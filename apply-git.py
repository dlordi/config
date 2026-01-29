#!/usr/bin/env python3

import configparser
import os
import sys

standard_gitconfig_path = sys.argv[1]

git_user_name = ''
git_user_email = ''

gitconfig_path = f"{os.environ['HOME']}/.gitconfig"
if os.path.exists(gitconfig_path):
    gitconfig = configparser.ConfigParser(interpolation=None)
    gitconfig.read(gitconfig_path)
    if 'user' in gitconfig:
        if 'name' in gitconfig['user']:
            git_user_name = gitconfig['user']['name']
        if 'email' in gitconfig['user']:
            git_user_email = gitconfig['user']['email']
indent = ' ' * 13
flag_add_new_line = True
while not git_user_name:
    if flag_add_new_line:
        print()
        flag_add_new_line = False
    git_user_name = input(f'{indent}enter user name: ')
    if not git_user_name:
        print(f'{indent}invalid name, try again!')
while not git_user_email:
    if flag_add_new_line:
        print()
        flag_add_new_line = False
    git_user_email = input(f'{indent}enter user email: ')
    if '@' not in git_user_email:
        print(f'{indent}invalid email, try again!')

with open(gitconfig_path, 'w') as f:
    f.write(rf"""# THIS FILE IS AUTO GENERATED: ANY CHANGE TO IT COULD BE LOST

[user]
	name = {git_user_name}
	email = {git_user_email}

# BEGIN standard git config
{open(standard_gitconfig_path).read()}
# END standard git config
""")
