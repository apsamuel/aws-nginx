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

  [e85713fb]: https://www.packer.io/downloads.html "Packer Setup"

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

variable name                    | variable type  | default value                     |  description
---------------------------------|----------------|-----------------------------------|--------------------------------------------------------
  vpc                            |  string        | vpc-a42399c1                      | AWS VPC ID
  region                         |  string        | us-east-1                         | AWS Region Name
  instance_type                  |  string        | t2.medium                         | AWS Instance Size
  associate_public_ip_address    |  boolean       | true                              | Associate AWS Elasic IP
  ebs_optimized                  |  boolean       | false                             | Enable Optimized Disk
  enable_dns                     |  boolean       | true                              | Enable DNS Configuration
  domain                         |  string        | darkphotonworks-labs.io.          | Domain Name (AWS hosted)


### Build AWS::AMI

* packer build packer.json
* packer build -debug packer.json (enable debugging)


### Apply AWS Infrastructure

* terraform plan -out=site.plan
* terraform apply site.plan
  - keep an eye out for execution stdout/stderr.
* terraform output (on completion)
