#!/usr/bin/env python3
"Script to generate a build order respecting package dependencies."

import os
import re
import sys

from itertools import filterfalse

def unique_everseen(iterable, key=None):
    """List unique elements, preserving order. Remember all elements ever seen.
    See https://docs.python.org/3/library/itertools.html#itertools-recipes
    Examples:
    unique_everseen('AAAABBBCCDAABBB') --> A B C D
    unique_everseen('ABBCcAD', str.lower) --> A B C D"""
    seen = set()
    seen_add = seen.add
    if key is None:
        for element in filterfalse(seen.__contains__, iterable):
            seen_add(element)
            yield element
    else:
        for element in iterable:
            k = key(element)
            if k not in seen:
                seen_add(k)
                yield element

def die(msg):
    "Exit the process with an error message."
    sys.exit('ERROR: ' + msg)

def parse_build_file_dependencies(path):
    "Extract the dependencies of a build.sh or *.subpackage.sh file."
    dependencies = []

    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith( ('MAGISK_MODULE_DEPENDS', 'MAGISK_MODULE_BUILD_DEPENDS', 'MAGISK_MODULE_SUBMODULE_DEPENDS', 'MAGISK_MODULE_DEVMODULE_DEPENDS') ):
                dependencies_string = line.split('DEPENDS=')[1]
                for char in "\"'\n":
                    dependencies_string = dependencies_string.replace(char, '')

                # Split also on '|' to dependencies with '|', as in 'nodejs | nodejs-current':
                for dependency_value in re.split(',|\\|', dependencies_string):
                    # Replace parenthesis to ignore version qualifiers as in "gcc (>= 5.0)":
                    dependency_value = re.sub(r'\(.*?\)', '', dependency_value).strip()

                    dependencies.append(dependency_value)

    return set(dependencies)

def develsplit(path):
    with open(path, encoding="utf-8") as build_script:
        for line in build_script:
            if line.startswith('MAGISK_MODULE_NO_DEVELSPLIT'):
                return False

    return True

class MagiskModule(object):
    "A main package definition represented by a directory with a build.sh file."
    def __init__(self, dir_path, fast_build_mode):
        self.dir = dir_path
        self.name = os.path.basename(self.dir)

        # search package build.sh
        build_sh_path = os.path.join(self.dir, 'build.sh')
        if not os.path.isfile(build_sh_path):
            raise Exception("build.sh not found for package '" + self.name + "'")

        self.deps = parse_build_file_dependencies(build_sh_path)
        always_deps = ['libc++']
        for dependency_name in always_deps:
            if dependency_name not in self.deps and self.name not in always_deps:
                self.deps.add(dependency_name)

        # search subpackages
        self.submodules = []

        for filename in os.listdir(self.dir):
            if not filename.endswith('.subpackage.sh'):
                continue
            submodule = MagiskSubModule(self.dir + '/' + filename, self)

            self.submodules.append(submodule)
            self.deps.add(submodule.name)
            self.deps |= submodule.deps

        if develsplit(build_sh_path):
            submodule = MagiskSubModule(self.dir + '/' + self.name + '-dev' + '.subpackage.sh', self, virtual=True)
            self.submodules.append(submodule)
            self.deps.add(submodule.name)

        # Do not depend on itself
        self.deps.discard(self.name)
        # Do not depend on any sub package
        if not fast_build_mode:
            self.deps.difference_update([submodule.name for submodule in self.submodules])

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}'>".format(self.__class__.__name__, self.name)

    def recursive_dependencies(self, modules_map):
        "All the dependencies of the package, both direct and indirect."
        result = []
        for dependency_name in sorted(self.deps):
            dependency_module = modules_map[dependency_name]
            result += dependency_module.recursive_dependencies(modules_map)
            result += [dependency_module]
        return unique_everseen(result)

class MagiskSubModule:
    "A sub-package represented by a ${PACKAGE_NAME}.subpackage.sh file."
    def __init__(self, submodule_file_path, parent, virtual=False):
        if parent is None:
            raise Exception("SubPackages should have a parent")

        self.name = os.path.basename(submodule_file_path).split('.subpackage.sh')[0]
        self.parent = parent
        self.deps = set([parent.name])
        if not virtual:
            self.deps |= parse_build_file_dependencies(submodule_file_path)
        self.dir = parent.dir

        self.needed_by = set()  # Populated outside constructor, reverse of deps.

    def __repr__(self):
        return "<{} '{}' parent='{}'>".format(self.__class__.__name__, self.name, self.parent)

    def recursive_dependencies(self, modules_map):
        """All the dependencies of the subpackage, both direct and indirect.
        Only relevant when building in fast-build mode"""
        result = []
        for dependency_name in sorted(self.deps):
            if dependency_name == self.parent.name:
                self.parent.deps.discard(self.name)
            dependency_module = modules_map[dependency_name]
            if dependency_module not in self.parent.submodules:
                result += dependency_module.recursive_dependencies(modules_map)
            result += [dependency_module]
        return unique_everseen(result)

def read_modules_from_directories(directories, fast_build_mode):
    """Construct a map from package name to TermuxPackage.
    Subpackages are mapped to the parent package if fast_build_mode is false."""
    modules_map = {}
    all_modules = []

    for module_dir in directories:
        for moduledir_name in sorted(os.listdir(module_dir)):
            dir_path = module_dir + '/' + moduledir_name
            if os.path.isfile(dir_path + '/build.sh'):
                new_module = MagiskModule(module_dir + '/' + moduledir_name, fast_build_mode)

                if new_module.name in modules_map:
                    die('Duplicated package: ' + new_module.name)
                else:
                    modules_map[new_module.name] = new_module
                all_modules.append(new_module)

                for submodule in new_module.submodules:
                    if submodule.name in modules_map:
                        die('Duplicated package: ' + submodule.name)
                    elif fast_build_mode:
                        modules_map[submodule.name] = submodule
                    else:
                        modules_map[submodule.name] = new_module
                    all_modules.append(submodule)

    for module in all_modules:
        for dependency_name in module.deps:
            if dependency_name not in modules_map:
                die('Package %s depends on non-existing package "%s"' % (module.name, dependency_name))
            dep_module = modules_map[dependency_name]
            if fast_build_mode or not isinstance(module, MagiskSubModule):
                dep_module.needed_by.add(module)
    return modules_map

def generate_full_buildorder(modules_map):
    "Generate a build order for building all packages."
    build_order = []

    # List of all TermuxPackages without dependencies
    leaf_modules = [module for name, module in modules_map.items() if not module.deps]

    if not leaf_modules:
        die('No package without dependencies - where to start?')

    # Sort alphabetically:
    module_queue = sorted(leaf_modules, key=lambda p: p.name)

    # Topological sorting
    visited = set()

    # Tracks non-visited deps for each package
    remaining_deps = {}
    for name, module in modules_map.items():
        remaining_deps[name] = set(module.deps)
        for submodule in module.submodules:
            remaining_deps[submodule.name] = set(submodule.deps)

    while module_queue:
        module = module_queue.pop(0)
        if module.name in visited:
            continue

        # print("Processing {}:".format(pkg.name), pkg.needed_by)
        visited.add(module.name)
        build_order.append(module)

        for other_module in sorted(module.needed_by, key=lambda p: p.name):
            # Remove this pkg from deps
            remaining_deps[other_module.name].discard(module.name)
            # ... and all its subpackages
            remaining_deps[other_module.name].difference_update(
                [submodule.name for submodule in module.submodules]
            )

            if not remaining_deps[other_module.name]:  # all deps were already appended?
                module_queue.append(other_module)  # should be processed

    if set(modules_map.values()) != set(build_order):
        print("ERROR: Cycle exists. Remaining: ")
        for name, module in modules_map.items():
            if module not in build_order:
                print(name, remaining_deps[name])

        sys.exit(1)

    return build_order

def generate_target_buildorder(target_path, modules_map, fast_build_mode):
    "Generate a build order for building the dependencies of the specified package."
    if target_path.endswith('/'):
        target_path = target_path[:-1]

    module_name = os.path.basename(target_path)
    module = modules_map[module_name]
    # Do not depend on any sub package
    if fast_build_mode:
        module.deps.difference_update([submodule.name for submodule in module.submodules])
    return module.recursive_dependencies(modules_map)

def main():
    "Generate the build order either for all packages or a specific one."
    import argparse

    parser = argparse.ArgumentParser(description='Generate order in which to build dependencies for a package. Generates')
    parser.add_argument('-i', default=False, action='store_true',
                        help='Generate dependency list for fast-build mode. This includes subpackages in output since these can be downloaded.')
    parser.add_argument('module', nargs='?',
                        help='Package to generate dependency list for.')
    parser.add_argument('module_dirs', nargs='*',
                        help='Directories with packages. Can for example point to "../x11-packages/packages/". "packages/" is appended automatically.')
    args = parser.parse_args()
    fast_build_mode = args.i
    module = args.module
    modules_directories = args.module_dirs
    if 'modules' not in modules_directories:
        modules_directories.append('modules')

    if not module:
        full_buildorder = True
    else:
        full_buildorder = False

    if fast_build_mode and full_buildorder:
        die('-i mode does not work when building all packages')

    if not full_buildorder:
        modules_real_path = os.path.realpath('modules')
        for path in modules_directories:
            if not os.path.isdir(path):
                die('Not a directory: ' + path)

    if module:
        if module[-1] == "/":
            module = module[:-1]
        if not os.path.isdir(module):
            die('Not a directory: ' + module)
        if not os.path.relpath(os.path.dirname(module), '.') in modules_directories:

            modules_directories.insert(0, os.path.dirname(module))
    pkgs_map = read_modules_from_directories(modules_directories, fast_build_mode)

    if full_buildorder:
        build_order = generate_full_buildorder(pkgs_map)
    else:
        build_order = generate_target_buildorder(module, pkgs_map, fast_build_mode)

    for module in build_order:
        print("%-30s %s" % (module.name, module.dir))

if __name__ == '__main__':
    main()
