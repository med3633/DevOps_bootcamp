# overview
---
name: Install httpd
hosts: all
tasks:
- yum:
name: httpd
state: installed
==> ansible-playbook playbook.yml --check
# specified name of task to start it & skkep all the task before 
---
name: Install httpd
hosts: all
tasks:
- name: Install httpd
yum:
name: httpd
state: installed
name: Start httpd service
service:
name: httpd
state: started
==> $ ansible-playbook playbook.yml --start-at-task "Start httpd service
# tags to insure only run task with that tag 
---
name: Install httpd
tags: install and start
hosts: all
tasks:
- yum:
name: httpd
state: installed
tags: install
service:
name: httpd
state: started
tags: start httpd service
==> $ansible-playbook playbook.yml --tags "install"
or skip certain tags
==> $ansible-playbook playbook.yml --skip-tags "install"
# exercise : 
Under ~/playbooks/ directory create a playbook web1.yml to
create a blank file named as /root/myfile.txt under root's
home on web1 node, also make sure this must run for webl node
only.
Check
Hint
You can use file module with path and state parameter.
# solution
vi web1.yml
---
- name : Create myfile on web1
  hosts: web1
  tasks:
  - file: path=/root/myfile.txt state=touch
=> ansible-playbook -i inventory web1.yml
# syntaxe 
tasks:
 - name: ...
   echo '..'
