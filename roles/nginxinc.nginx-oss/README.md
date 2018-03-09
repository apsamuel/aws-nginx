(**Please Note:** This repository is no longer actively supported or updated. Please refer to the [NGINX Ansible Role repository](https://github.com/nginxinc/ansible-role-nginx) for the latest NGINX Ansible Role.)

Ansible NGINX OSS Role
======================

[![Ansible Galaxy](https://img.shields.io/badge/galaxy-nginxinc.nginx--oss-5bbdbf.svg)](https://galaxy.ansible.com/nginxinc/nginx-oss)
[![Build Status](https://travis-ci.org/nginxinc/ansible-role-nginx-oss.svg?branch=master)](https://travis-ci.org/nginxinc/ansible-role-nginx-oss)

This role installs NGINX OSS on your target host. It supports most CentOS/RHEL/Debian/Ubuntu/SLES distributions.

Requirements
------------

This role was developed using Ansible 2.3.1.0. Backwards compatibility is not guaranteed.

Use `ansible-galaxy install nginxinc.nginx-oss` to install the role on your system.

The following platforms have been tested and are oficially supported:

    CentOS:
      versions:
        - 6
        - 7
    RedHat:
      versions:
        - 6
        - 7
    Debian:
      versions:
        - wheezy
        - jessie
        - stretch
    Ubuntu:
      versions:
        - precise
        - trusty
        - xenial
        - yakkety
    SUSE/SLES:
      versions:
        - 12

Role Variables
--------------

None

Dependencies
------------

None

Example Playbook
----------------

This is a sample playbook file for deploying the Ansible Galaxy NGINX OSS role in a localhost.

    ---
    - hosts: localhost
      become: true
      roles:
        - role: nginxinc.nginx-oss

This is a sample playbook file for deploying the Ansible Galaxy NGINX OSS role to a dynamic inventory containing the `nginx` tag.

    ---
    - hosts: tag_nginx
      remote_user: root
      become: true
      roles:
        - role: nginxinc.nginx-oss

To run any of the above sample playbooks create a `setup-nginx.yml` file and paste the contents. Executing the Ansible Playbook is then as simple as executing `ansible-playbook ./setup-nginx.yml`.

Alternatively, you can also clone this repository instead of installing it from Ansible Galaxy. If you decide to do so, replace the role variable in the previous sample playbooks from `nginxinc.nginx-oss` to `ansible-role-nginx-oss`.

License
-------

[Simplified BSD License](https://github.com/nginxinc/ansible-role-nginx-oss/blob/master/LICENSE)

Author Information
------------------

Alessandro Fael Garcia

[NGINX Inc](https://www.nginx.com/)
