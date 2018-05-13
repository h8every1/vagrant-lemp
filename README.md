# Universal Vagrant + LEMP setup

Easy deployment of Vagrant with Linux (Ubuntu 16.04) + Nginx + Mysql 5.7 + PHP 7.1 (with xDebug enabled) + Composer

Based on [Yii2 advanced template](https://github.com/yiisoft/yii2-app-advanced) Vagrant setup.

## Prerequisites

* Install [Vagrant](https://www.vagrantup.com/docs/installation/)
* Install [Virtualbox](https://www.virtualbox.org/manual/ch01.html#intro-installing)

## Folder structure

```bash
/path/to/your/projects # projects root
    /project1.test # actual folder with your project files
    /project2.test
    ...
    /projectN.test
    /vagrant-lemp # folder with all vagrant data
```

The setup automatically creates Nginx configs for all folders inside the projects root folder.

With the help of [hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) plugin the names of your projects folders also become URLs of the local sites. You might want to name them accordingly.

**Pro-tip:**
End your projects folders with `.test`. Because `.dev` is bought by Google and `.local` is used by Apple in their software.


## Installation

Open the root directory for your folders.

```bash
cd /path/to/your/projects
```

Clone this repo
```bash
git clone https://github.com/h8every1/vagrant-lemp.git
cd vagrant-lemp 
```

## Configuring Vagrant
Copy and edit config file
```bash
cp ./config/vagrant-local.example.yml ./config/vagrant-local.yml
```
If you don't do it manually, the `vagrant-local.yml` config file will be created automatically on first run.

Edit newly created config file with your favorite text editor
```bash
vim ./config/vagrant-local.yml
```

The most important thing is your [GitHub token](https://github.com/blog/1509-personal-api-tokens). You can generate it here: https://github.com/settings/tokens That token is used for Composer and is imported on first run of VM. If you don't provide it, Composer will ask for your token when needed.

`machine_name` is used by Virtualbox and should be unique in your system. I.e. you can't have two `vagrant-project` virtual machines.

`databases` are checked on each vagrant startup. The script will automatically create database and mysql user with empty password for accessing the new database. Already existing databases will be skipped.

There's also `root` MySQL user with empty password that can access all databases.

## Adding URLs

Just create new folder inside your projects root folder and `vagrant halt && vagrant up` (to run `hostmanager` provision) inside `vagrant-lemp` folder.

## NGINX configs

Configs are automatically created at each start of Vagrant and are stored in `./nginx/sites/*.conf` files. One file per each project folder. You can safely edit those files, script won't overwrite them (but will recreate configs if you delete them).

The template for those files is `./nginx/project.conf.template`. You can edit it to suit your everyday needs.
