# How to user the docker ansible container

## Build the ansible_docker container

Run the script:

    build-docker-ansible

## Run the container

To run the docker container type:

    run-docker-ansible

## Prepare the vagrant clients

Go the the "vagrant" directory (use another window/shell) and read the README.md to launch the vagrant Virtual Machines

## Inside the container use 'ansible' commands and/or playbooks

Copy the public SSH key of the container 'ansible' user to the 3 clients VMs (also the the 'ansible' user).
The password for the 'ansible' user on the client VMs is 'vagrant' (the same password as the 'vagrant' user).
Because no SSH connection happened yet we must use the '-k' option with ansible-playbook to ask for the password.

````
$ ansible-playbook -k playbooks/ansible-user-ssh.yml 
SSH password: 

PLAY [Prepare the ansible user .ssh sub-directory] ********************************************************************

TASK [Create /home/ansible/.ssh (if required)] ************************************************************************
changed: [client2]
changed: [client1]
changed: [client3]

TASK [Copy public ssh key to /home/ansible/.ssh] **********************************************************************
changed: [client3]
changed: [client2]
changed: [client1]

PLAY RECAP ************************************************************************************************************
client1                    : ok=2    changed=2    unreachable=0    failed=0   
client2                    : ok=2    changed=2    unreachable=0    failed=0   
client3                    : ok=2    changed=2    unreachable=0    failed=0
````

## Cleanup the container

To exit the container just type "exit"

To remove the container:

    docker rm $( docker ps -a | grep ansible_docker | awk '{print $1}' )


To remove the image:

    docker image rm $( docker image ls | grep ansible_docker | awk '{print $3}' )
