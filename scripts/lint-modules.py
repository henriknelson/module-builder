#!/usr/bin/env python3

import os
import re
import sys

def main():
    module_dir = 'modules'
    for moduledir_name in sorted(os.listdir(module_dir)):
        dir_path = module_dir + '/' + moduledir_name
        build_sh_path = dir_path + '/build.sh'
        if not os.path.isfile(build_sh_path):
            sys.exit('No build.sh file in: ' + moduledir_name)
        with open(build_sh_path) as build_sh:
            lines = build_sh.readlines()
        validate_module(moduledir_name, lines)

def validate_module(module_name, lines):
    if len(lines) < 3:
        print('Too few lines in module: ' + module_name)
        return
    if not lines[0].startswith('MAGISK_MODULE_HOMEPAGE='):
        print('The first line is not MAGISK_MODULE_HOMEPAGE: ' + module_name)
    if not lines[1].startswith('MAGISK_MODULE_DESCRIPTION='):
        print('The second line is not MAGISK_MODULE_DESCRIPTION: ' + module_name)

    line_number = 1
    for line in lines:
        if line.endswith(' \n'):
            print(module_name + ': Line ' + str(line_number) + ' has trailing whitespace')
        if line.startswith('MAGISK_MODULE_REVISION='):
            value = line[len('MAGISK_MODULE_REVISION='):].strip()
            if not re.match('[0-9]+', value):
                print(module_name + ': strange MAGISK_MODULE_REVISION value "' + value + '"')

        line_number += 1

if __name__ == '__main__':
    main()
