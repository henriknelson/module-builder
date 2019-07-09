#!/usr/bin/env python3

import urllib.request
from subprocess import Popen, PIPE

version_map = {}
any_error = False

pipe = Popen('./scripts/list-versions.sh', stdout=PIPE)
for line in pipe.stdout:
    (name, version) = line.decode().strip().split('=')
    version_map[name] = version

def check_manifest(arch, manifest):
    current_module = {}
    for line in manifest:
        if line.isspace():
            module_name = current_module['Package']
            module_version = current_module['Version']
            if not module_name in version_map:
                # Skip sub-module
                continue
            latest_version = version_map[module_name]
            if module_version != latest_version:
                print(f'{module_name}@{arch}: Expected {latest_version}, but was {module_version}')
            current_module.clear()
        elif not line.decode().startswith(' '):
            parts = line.decode().split(':', 1)
            current_module[parts[0].strip()] = parts[1].strip()

for arch in ['all', 'aarch64', 'arm', 'i686', 'x86_64']:
    manifest_url = f'https://dl.bintray.com/termux/termux-modules-24/dists/stable/main/binary-{arch}/Packages'
    with urllib.request.urlopen(manifest_url) as manifest:
        check_manifest(arch, manifest)
