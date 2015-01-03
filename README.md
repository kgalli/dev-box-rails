# A Virtual Machine for Ruby on Rails Development

## Introduction

This project automates the setup of a development environment for working with Ruby on Rails and is inspired by
the [rails-dev-box](https://github.com/rails/rails-dev-box) created by Xavier Noria.

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## Setting Up The Virtual Machine

Setting up the virtual machine is done by the following three steps (assuming Virtualbox and Vagrant are already installed):

    $ git clone gitt@github.com:kgalli/dev-box-rails.git
    $ cd dev-box-rails
    $ vagrant up

After the installation has finished, you can access the virtual machine using vagrant:

    $ vagrant ssh
    Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-36-generic i686)
    ...
    vagrant@dev-box-rails:~$

Port 3000 of the host computer is forwarded to port 3000 of the virtual machine. Thus, applications running in the virtual machine (like rails server) can be accessed via http://localhost:3000 from the host computer.

## What's Included

* Build essentials

* [Git](http://git-scm.com/)

* [SQLite3](http://www.sqlite.org/) , [MySQL](http://www.mysql.com/), and [Postgres](http://www.postgresql.org/)

* Setup of databases and users needed

* System dependencies for nokogiri, mysql, and pg

* [Memcached](http://memcached.org/) distributed memory object caching system

* [PhantomJS](http://phantomjs.org/) headless Webkit for headless testing

* [rbenv](https://github.com/sstephenson/rbenv/) for managing Ruby versions

* [nodenv](https://github.com/OiNutter/nodenv) for managing Node versions

## Virtual Machine Management

Run

    host $ vagrant up

to boot the virtual machine, and

    host $ vagrant halt

to shut it down.

The state of the virtual machine can be determined by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy

Please check the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more information on Vagrant.

## Recommended Workflow

The recommended workflow is

* edit files in the host computer and

* run rails server, console or tests within the virtual machine.

Just clone your Rails project directly into the projects directory (of this dev-box-rails git directory) on the host computer.

    host $ ls
    MIT-LICENSE  README.md  Vagrantfile  bootstrap.sh projects
    host $ cd projects
    host $ git clone git@github.com:<your username>/<your rails project>.git

Vagrant mounts that projects directory as _/vagrant_ within the virtual machine:

    vagrant@dev-box-rails:~$ ls /vagrant
    <your rails project>

Install gem dependencies in the guest (vagrant ssh):

    rails-dev-box $ cd /vagrant/<your rails project>
    rails-dev-box $ bundle install

This workflow is convenient because in the host computer you normally have your editor of choice fine-tuned, Git configured, and SSH keys in place.

## A note on working with shared folders

The default mechanism for sharing folders is convenient and works out the box in
all Vagrant versions. Unfortunatly the default can also be very slow some times. To tackle this problem there
are a couple of alternatives that are more performant.

### rsync

Vagrant 1.5 implements a [sharing mechanism based on rsync](https://www.vagrantup.com/blog/feature-preview-vagrant-1-5-rsync.html)
that improves read/write because files are actually stored in the guest.
This feature can be activated by setting the type of the synced\_folder to rsync

    config.vm.synced_folder '.', '/vagrant', type: 'rsync'

to the _Vagrantfile_ and either rsync manually with

    vagrant rsync

or run

    vagrant rsync-auto

for automatic syncs. See the post linked above for details.

### NFS

With a NFS server installed (already installed on Mac OS X), add the following to the Vagrantfile:

    config.vm.synced_folder '.', '/vagrant', type: 'nfs'
    config.vm.network 'private_network', ip: '10.1.1.2'

Then

    host $ vagrant up

Please check the Vagrant documentation on [NFS synced folders](http://docs.vagrantup.com/v2/synced-folders/nfs.html) for more information.

## License

Released under the MIT License, Copyright (c) 2014 Karsten Gallinowski.
