# Apg Patch Server Setup

Provides a mostly automated initial setup and configuration of the Apg
Patch Server with Jenkins for Localtesting and Development. For Piper
see the [Github Repo]() .

## Preconditions

1. A
   [Minimal Centos 7](http://linuxsoft.cern.ch/centos/6.10/isos/x86_64/CentOS-6.10-x86_64-minimal.iso)
   installation
2. User / password with sudo rights for the target machine running. This
   user should also have a public rsa key in the default location.
3. A ssh public key in the user home on the host machine
4. Bolt installed on the Host machine. For Bolt installation see the
   [Puppet Site](https://puppet.com/docs/bolt/latest/bolt_installing.html)
5. Configuration of Bolt Hiera for passwords use , see seperate
   description below
6. Ruby installed on the Host machine, see [Apg Wiki](https://intranet.apgsga.ch/display/itwi/Ruby),
7. The target host added as ssh known host to the user, which the
   installation will be done.

### Set-up Bolt Hiera Config for Passwords

1. `cp templates/hiera.yaml ~/.puppetlabs/bolt`
2. ` cp -R templates/data ~/.puppetlabs/bolt`
3. `vim ~/.puppetlabs/bolt/data/common.yaml ` and change TOBECHANGED to
   the correct value

The location of the root configuration directory can be changed in
bolt.yaml

## Running the Setup

### Installation Parameters

The installation parameters are kept in the **inventory.yaml** file in
the root directory git repository.

Before the installation this file should be adapted accordingly.

See in that file the tag vars:

![Inventory File](./images/inventory.png)

The structure of the **inventory.yaml** file supports multiple target
groups, which can have differing parameters. Currently, only the testvm
group has been tested. This group and configuration is intended for
local test vms.

Import are the following parameters:

1. target uri => the guest vm
2. ssh user => the sudo user of the vm
3. ssh password
4. maven_profile : the maven profile which will be used for gradle and
   maven

Note : The global property *maven_profile* must also be adapted
accordingly. This should not be a global property.

### User creation and management

A.User, which runs Installation

B. Platform User with sudo rights: The test user. This user is a
precondition.

C. Local Platform Users for the daemon processes are:

jenkins
apg-patch-service-server

Both are created via Bolt plans. The piper rpm now checks in the pre
install step , if apg-patch-service-server exists and omits user
creation if yes.

D. Public Keys:

The publics rsa keys of A. und B. are precondition with their default
location ($HOME/.ssh/)

The public rsa key of C. are created upon setup

E. Jenkins Admin User

The same user name / password as the Platform user , see A. The public
rsa key of A., B. and C. are held in the User Configuration. This allows
the User to interact via ssh with the Jenkins Cli, example:

ssh -l <user> -p 53801 <targethost> help # Apg Patch Server Setup

Provides a mostly automated initial setup and configuration of the Apg
Patch Server with Jenkins for Localtesting and Development. For Piper
see the [Github Repo]() .

## Preconditions

1. A
   [Minimal Centos 7](http://linuxsoft.cern.ch/centos/6.10/isos/x86_64/CentOS-6.10-x86_64-minimal.iso)
   installation
2. User / password with sudo rights for the target machine running. This
   user should also have a public rsa key in the default location.
3. A ssh public key in the user home on the host machine
4. Bolt installed on the Host machine. For Bolt installation see the
   [Puppet Site](https://puppet.com/docs/bolt/latest/bolt_installing.html)
5. Configuration of Bolt Hiera for passwords use , see seperate
   description below
6. Ruby installed on the Host machine, see [Apg Wiki](https://intranet.apgsga.ch/display/itwi/Ruby),
7. The target host added as ssh known host to the user, which the
   installation will be done.

### Set-up Bolt Hiera Config for Passwords

1. `cp templates/hiera.yaml ~/.puppetlabs/bolt`
2. ` cp -R templates/data ~/.puppetlabs/bolt`
3. `vim ~/.puppetlabs/bolt/data/common.yaml ` and change TOBECHANGED to
   the correct value

The location of the root configuration directory can be changed in
bolt.yaml

## Running the Setup

### Installation Parameters

The installation parameters are kept in the **inventory.yaml** file in
the root directory git repository.

Before the installation this file should be adapted accordingly.

See in that file the tag vars:

![Inventory File](./images/inventory.png)

The structure of the **inventory.yaml** file supports multiple target
groups, which can have differing parameters. Currently, only the testvm
group has been tested. This group and configuration is intended for
local test vms.

Import are the following parameters:

1. target uri => the guest vm
2. ssh user => the sudo user of the vm
3. ssh password
4. maven_profile : the maven profile which will be used for gradle and
   maven

Note : The global property *maven_profile* must also be adapted
accordingly. This should not be a global property.

### User creation and management

A.User, which runs Installation

B. Target Platform User with sudo rights  
The test user. This user is a precondition for the installation

C. Local Target Platform Users for the daemon processes are:

jenkins
apg-patch-service-server

Both are created via Bolt plans. The piper rpm now checks in the pre
install step , if apg-patch-service-server exists and omits user
creation if yes.

D. Public Keys:

The public rsa keys of A. und B. are precondition with the default
location ($HOME/.ssh/)

The public rsa key of C. are created upon setup

E. Jenkins Admin User

The same user name / password as the Platform user , see B. The public
rsa key of A., B. and C. are held in the Jenkins User Configuration.
This allows the User to interact via ssh with the Jenkins Cli, example:

`ssh -l <user> -p 53801 <targethost> help`

This User is created via setup

F. External Resources

Cvs Server (cvs-t.apgsga.com):

Currently jenkins and the apg-patch-service-server daemon access the cvs
server with the current test user for the Installation, see B. eg. jhe ,
che, uge

Ssh Jenkins Commandline Port

Currently the apg-patch-service-server (C.) daemon and the local test
user (B.) and the Host user (A.) access the ssh port for the Jenkins Cli

Open Points:

Specific User for the cvs daemon accesses (jenkins and the
apg-patch-service-server)

Specific User for apg-patch-service-server for the Jenkins Cli ssh port

Probably we have a ssh-id-copy missing -> for apg-patch-service-server
access of the cvs server.


### Before running the Bolt Plans

The current apg *gradlehome git repo* , or the version you intend to
use, needs to be cloned manually to /tmp/gradlehome:

`git clone <user>@git.apgsga.ch:/var/git/repos/apg-gradle-properties.git
/tmp/gradlehome `

This step can be also automated with the ./install.rb script -c option,
see below

### Run Bolt Plans

To run the plans , you use the script ./install.rb in the root directory
of the repo.

To list all availabe options, run :

`./install.rb -h`

To see, which plans are available and in which order they should be
executed, run:

`./install.rb -a -c --dry`

You will the following output:

![Bolt Puppet Plans](./images/plans.png)

These are all the Bolt Puppet Plans which need to be executed in the
correct order.

Without the --dry option all plans are executed sequentially.

The plans can be executed manually or via the ./install.rb script
depending on the --dry option. These options outputs the bolt commands
needed to be run.

Since running all the plans takes quite some time and may fail
(resources not available, network slow etc), it is advisable to split
the plan execution into reasonable groups. Also, VM Snapshots can be
taken.

For example run:

`./install.rb -a -c -x`

Which runs all plans needed to install jenkins, except the jenkins
specific plans and the plans dependent on jenkins.

Then the  jenkins plans can be run. To List them run

`./install.rb -i jenkins`

The -i option takes a plan name filter, which is matched against the
plan names. So the above parameter will produce with the --dry option
the following output:

![Jenkins Plans](./images/jenkins.png)

And then the piper server specific plans:

`./install.rb -i piper_service`

## Post Installation

You need to follow the following steps to make your installation usable

### Copy the Jenkins user ssh key to the cvs server

In order for jenkins jobs to be able to co from cvs-t.apgsga.ch you need
to copy the public ssh key to the user with which the jenkins jobs are
to run:
1. `su - jenkins`
2. `ssh-copy-id <user>@cvs-t.apgsga.ch #copy the key using your id`

### Configure Piper

After Piper has been installed, we have to configure the following:
1. login as sudo user of target
2. ssh-copy-id apg-patch-service-server@localhost


## Open Points / Todos

- [ ] Revise inventory.xml parameters (completeness, naming, necessary
      etc)
- [ ] Move maven_profile inventory.xml property to target group specfic
- [ ] Production Target Group properties in inventory.xml
- [ ] Very plans and properties in terms of Production target
      requirements
- [ ] Review (and Revise) User Management and assumptions of the Setuo
- [ ] Move Testscripts in the patchserver-testscripts git repo back to
      patchserver-setup repository
- [ ] Move Target, User , Password from inventory.yaml back to commandline
- [ ] Piper Service default Install, currently the rpm produces a
      installation, which does not run, but assumes that the *.intitial
      properties will be adapted
- [ ] Parameterization of the plans, currently the plans have a uniform
      parameter = targets, which is taken from the inventory.xml. Some
      plans could be parametrized individually, which the parameters
      passed through command line, eg the jenkins_account_create.pp a
      list of users could be passed
- [ ] Test Piper apscli scenarios
- [ ] To discuss : Static IP Pool for Test VM's
- [ ] To discuss : Initial Test Image (Centos Minial , plus eg chronyd,
      viscocity client service etc, test user) provided?
- [ ] Which data should be managed with Puppet Hiera
- [ ] More detail described of what is done in the individual plans,
      specially in the non - trivial ones
- [ ] Should the secrets resp the default passwords for the accounts,
      which are created , modified handled in a better way?
- [ ] Gradle Home for Jenkins: pulled directly from git or copied and
      git stripped
- [ ] Specific User for the cvs daemon accesses (jenkins and the
      apg-patch-service-server). Currently the local test user.
- [ ] Specific User for apg-patch-service-server for the Jenkins Cli ssh
      port. Currently the local test user.
- [ ] Probably we have a ssh-id-copy missing -> for
      apg-patch-service-server access of the cvs server.

