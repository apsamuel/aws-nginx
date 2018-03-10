## NGINX Companion Website

* Install packer v1.2.1+
* Install ansible
* Install terraform
* Clone repository
* Validate templates
* Set runtime variables
* Build AMI
* Apply AWS Infrastructure


### Install packer

* Download & Copy to system path.
  * https://www.packer.io/downloads.html

### Install ansible

* Use your OS installation guide.
  * http://docs.ansible.com/ansible/latest/intro_installation.html

### Install terraform

* Download & Copy to system path.
  * https://www.terraform.io/downloads.html

### Clone repository

* git clone https://github.com/apsamuel/aws-nginx.git

### Validate templates

* cd aws-nginx
* packer validate packer.json
* terraform validate .

### Set runtime variables

**REPOROOT/variables.tf**

variable name                    | variable type  | default value
---------------------------------|----------------|--------------
  vpc                            |  string        | vpc-a42399c1
  region                         |  string        | us-east-1
  instance_type                  |  string        | t2.medium
  associate_public_ip_address    |  boolean       | true
  ebs_optimized                  |  boolean       | false


### Build AWS::AMI

* packer build packer.json
* packer build -debug packer.json (enable debugging)


### Apply AWS Infrastructure

* terraform plan -out=site.plan
* terraform apply site.plan
  - keep an eye out for execution stdout/stderr.
* terraform output (on completion)
