#!/usr/bin/env python

import os, sys

def get_module_hash_from_Modules(Modules_file, module, version, hash="SHA256"):
    with open(Modules_file, 'r') as Modules:
        module_list = Modules.read().split('\n\n')
    for module in module_list:
        if module.split('\n')[0] == "Module: "+module:
            for line in module.split('\n'):
                # Assuming Filename: comes before Version:
                if line.startswith('Filename:'):
                    print(line.split(" ")[1] + " ")
                elif line.startswith('Version:'):
                    if line != 'Version: '+version:
                        # Seems the repo contains the wrong version, or several versions
                        # We can't use this one so continue looking
                        break
                elif line.startswith(hash):
                    print(line.split(" ")[1])
                    break

def get_Modules_hash_from_Release(Release_file, arch, component, hash="SHA256"):
    string_to_find = component+'/binary-'+arch+'/Modules'
    with open(Release_file, 'r') as Release:
        hash_list = Release.readlines()
    for i in range(len(hash_list)):
        if hash_list[i].startswith(hash+':'):
            break
    for j in range(i, len(hash_list)):
        if string_to_find in hash_list[j].strip(' '):
            print(hash_list[j].strip(' ').split(' ')[0])
            break

if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('Too few arguments, I need the path to a Modules file, a module name and a version, or an InRelease file, an architecture and a component name. Exiting')

    if sys.argv[1].endswith('Modules'):
        get_module_hash_from_Modules(sys.argv[1], sys.argv[2], sys.argv[3])
    elif sys.argv[1].endswith(('InRelease', 'Release')):
        get_Modules_hash_from_Release(sys.argv[1], sys.argv[2], sys.argv[3])
    else:
        sys.exit(sys.argv[1]+' does not seem to be a path to a Modules or InRelease/Release file')
