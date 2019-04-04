# Configuration Management introduction through automation tools

If you have questions or remarks mail at gratien . dhaese @ gmail . com

## Pre-requisites
- Linux or Mac OS/X system
- vim editor or alike
- docker
- vagrant
- Oracle VirtualBox
- ChefDK
- ansible
- python
- git (to clone this git repo: https://github.com/gdha/cfgmgmt-intro)

## Clone the Git repository for the examples
- git clone https://github.com/gdha/cfgmgmt-intro.git
- cd cfgmgmt-intro

## Start of docker ansible_docker
- go to directory `cfgmgmt-intro/docker.ansible`
- run: `./build-docker-ansible`
- run: `./run-docker-ansible`
- (inside the container) run: ansible --version

## In another Bash shell windows (on your Linux or Mac)
- go to directory `cfgmgmt-intro/vagrant`
- run: `vagrant status`
Current machine states:

client1                   not created (virtualbox)
client2                   not created (virtualbox)
client3                   not created (virtualbox)

- run: `vagrant up`
  Initial startup will perform a provisioning of the 3 client VMs. They will have an user "ansible" (with password "vagrant"). There is by default also an user called "vagrant" (with password "vagrant")

- run: `vagrant status`
```
Current machine states:

client1                   running (virtualbox)
client2                   running (virtualbox)
client3                   running (virtualbox)
```

- (inside the container) run: cat /home/ansible/hosts
```
[local]
localhost ansible_connection=local

[clients]
client1		ansible_host=192.168.33.11
client2		ansible_host=192.168.33.12
client3		ansible_host=192.168.33.13
```

- (inside the container) run: ansible-playbook playbooks/ansible-user-ssh.yml
You will see errors like:
fatal: [client3]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Warning: Permanently added '192.168.33.13' (ECDSA) to the list of known hosts.\r\nansible@192.168.33.13: Permission denied (publickey,password).\r\n", "unreachable": true}

- (inside the container) run: ansible-playbook -k playbooks/ansible-user-ssh.yml
```
$ ansible-playbook -k playbooks/ansible-user-ssh.yml 
SSH password: 

PLAY [Prepare the ansible user .ssh sub-directory] ********************************************************************

TASK [Create /home/ansible/.ssh (if required)] ************************************************************************
changed: [client2]
changed: [client1]
changed: [client3]

TASK [Copy public ssh key to /home/ansible/.ssh] **********************************************************************
changed: [client1]
changed: [client2]
changed: [client3]

PLAY RECAP ************************************************************************************************************
client1                    : ok=2    changed=2    unreachable=0    failed=0   
client2                    : ok=2    changed=2    unreachable=0    failed=0   
client3                    : ok=2    changed=2    unreachable=0    failed=0
```

- (inside the container) run: ansible clients -b -a "cat /etc/sudoers.d/ansible"
```
$ ansible clients -b -a "cat /etc/sudoers.d/ansible"
client1 | SUCCESS | rc=0 >>
Defaults    !requiretty
ansible ALL=(ALL) NOPASSWD:ALL

client2 | SUCCESS | rc=0 >>
Defaults    !requiretty
ansible ALL=(ALL) NOPASSWD:ALL

client3 | SUCCESS | rc=0 >>
Defaults    !requiretty
ansible ALL=(ALL) NOPASSWD:ALL
```

- (inside the container) run: ansible localhost -m setup

- (inside the container) run: ansible clients -b -m shell -a "journalctl | tail -5"

- (inside the container) run: ansible clients -b -m file -a "path=/etc/motd state=absent"

- (inside the container) run: ansible-playbook playbooks/create_motd.yml

## Simple Chef resources
- (on Mac) run: go to directory `cfgmgmt-intro/chef`
- (on Mac) run: chef-client -z hello.rb
```
[2019-04-04T10:49:43+02:00] WARN: No config file found or specified on command line, using command line options.
Starting Chef Client, version 14.8.12
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2019-04-04T10:49:59+02:00] WARN: Node puijkes.lan has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/Users/gdha/data/projects/devops/cfgmgmt-intro/chef/hello.rb
  * file[/tmp/hello.txt] action create
    - create new file /tmp/hello.txt
    - update content in file /tmp/hello.txt from none to 7f83b1
    --- /tmp/hello.txt	2019-04-04 10:49:59.053693880 +0200
    +++ /tmp/.chef-hello20190404-2743-qfzhmo.txt	2019-04-04 10:49:59.053275046 +0200
    @@ -1 +1,2 @@
    +Hello World!

Running handlers:
Running handlers complete
Chef Client finished, 1/1 resources updated in 15 seconds
```

- (on Mac) run: chef-client -z hello.rb (run same command again to proof idempotency)
```
[2019-04-04T10:53:32+02:00] WARN: No config file found or specified on command line, using command line options.
Starting Chef Client, version 14.8.12
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2019-04-04T10:53:45+02:00] WARN: Node puijkes.lan has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/Users/gdha/data/projects/devops/cfgmgmt-intro/chef/hello.rb
  * file[/tmp/hello.txt] action create (up to date)

Running handlers:
Running handlers complete
Chef Client finished, 0/1 resources updated in 12 seconds
```

- (on Mac) run: cat tree.rb
``` 
package 'tree' do
  action :install
end
```

- (on Mac) run: [[ ! -d cookbooks ]] && mkdir cookbooks
- (on Mac) run: chef generate cookbook cookbooks/NAME
- (on Mac) run: tree cookbooks/NAME/
```
cookbooks/NAME/
|-- Berksfile
|-- CHANGELOG.md
|-- LICENSE
|-- README.md
|-- chefignore
|-- metadata.rb
|-- recipes
|   `-- default.rb
|-- spec
|   |-- spec_helper.rb
|   `-- unit
|       `-- recipes
|           `-- default_spec.rb
`-- test
    `-- integration
        `-- default
            `-- default_test.rb

7 directories, 10 files
```

## Demonstrate Vagrant with Kitchen Test
- go to directory cfgmgmt-intro/chef/cookbooks/nginx_test

- (on Mac) run: cat recipes/default.rb

- (on Mac) run: cat kitchen.yml

- (on Mac) run: kitchen list
```
Instance           Driver   Provisioner  Verifier  Transport  Last Action    Last Error
default-centos-76  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
```

- (on Mac) run: kitchen create

- (on Mac) run: kitchen converge

- (on Mac) run: kitchen verify
```
Profile Summary: 27 successful controls, 26 control failures, 1 control skipped
Test Summary: 86 successful, 44 failures, 1 skipped
```

- (on Mac) run: vi recipes/default.rb

    uncomment line: # include_recipe 'os-hardening'

- (on Mac) run: kitchen converge

- (on Mac) run: kitchen verify
```
Profile Summary: 52 successful controls, 1 control failure, 1 control skipped
Test Summary: 129 successful, 1 failure, 1 skipped
```

- (on Mac) run: kitchen destroy

## LICENSE

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">What did you InSpec?</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.it3.be/" property="cc:attributionName" rel="cc:attributionURL">Gratien Dhaese</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
