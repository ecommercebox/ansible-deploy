# Ansible Deploy

Provides generalised deployment strategies for:

- Code
- Files (optional)
- Database (optional)

This provides support for common deployment strategies for projects such as Wordpress and Drupal. It is capable of
managing the deployment for single and multisite instances.

Multi-Stage environments are encouraged, as you can push from your local copy to the staging environment. You can
also deploy code, files and database between environments, eg: dev to stage, stage to prod, prod to dev

## Setup

1. `virtualenv env && source env/bin/activate`
2. `pip install -r env/requirements.txt`

## Configuation

1. Copy `hosts/hosts.example` to `hosts/hosts` and specify host variables
2. Copy `vars/config.example.yml` to `vars/config.yml` and specify config variables
3. Copy `vars/database.example.yml` to `vars/database.yml` and specify database variables
4. Copy `vars/enviroments.example.yml` to `vars/enviroments.yml` and specify environments variables
5. Copy `vars/files.example.yml` to `vars/files.yml` and specify files variables
6. Copy `vars/path.example.yml` to `vars/path.yml` and specify path variables

## Templates

Templates for config files are stored under the 'templates' directory. A typical template file may look
something like this:

```
// settings.env.yml
database:
  name: {{ database[env][item.key]['db_name'] }}
  username: {{ database[env][item.key]['db_user'] }}
  password: {{ database[env][item.key]['db_pass'] }}
);
```

### Available Variables

#### Config

```
config:
  default: "sites/default/settings.env.php" # Project settings paths relative from path.local.public.
  test: "sites/test/settings.env.php" # Project settings paths relative from path.local.public.
```

#### Database

```
database:
  local:
    default:
      db_user: 'user_local'
      db_pass: 'password'
      db_name: 'db_local'
  dev:
    default:
      db_user: 'user_dev'
      db_pass: 'password'
      db_name: 'db_dev'
  stage:
    default:
      db_user: 'user_stage'
      db_pass: 'password'
      db_name: 'db_stage'
  prod:
    default:
      db_user: 'user_prod'
      db_pass: 'password'
      db_name: 'db_prod'
```

#### Environments

```
environments: ['dev', 'stage', 'prod'] # Available environments on remote host.
```

#### Files

```
files:
  default: "sites/default/files" # Project files path relative from path_public.
```

#### Path

```
path_root:
  local: "{{ playbook_dir }}/../../" # Local root path.
  remote: "/home/{{ ansible_user_id }}/env" # Remote root path.
path_public: "public_html" # Public directory path relative from path_root['remote'].
path_backups: "backups" # Backup path relative from path_root['remote'].
path_files_backups: "files" # Backup path relative from path_backups.
path_database_backups: "database" # Backup path relative from path_backups.
path_shared_paths: [] # Shared paths relative form path_public
path_version: "releases" # Releases directory name
path_shared_paths: [] # Shared paths to symlink to release path
```

#### Deploy

```
deploy_keep_releases: 3 # How many release to keep on remote environment
deploy_rsync_set_remote_user: yes # See [ansible synchronize module](http://docs.ansible.com/ansible/synchronize_module.html). Options are yes, no.
```

#### Files Deploy

```
files_deploy_rsync_set_remote_user: yes # See [ansible synchronize module](http://docs.ansible.com/ansible/synchronize_module.html). Options are yes, no.
```

#### Rollback

```
rollback_remove_rolled_back: yes # You can change this setting in order to keep the rolled back release in the server for later inspection
```

## Playbooks Overview

* `env-setup.yml` - Setup environment on remote host
* `deploy.yml` - Deploy code to deploy remote host
* `rollback.yml` - Rollback code to previous version
* `db-deploy.yml` - Deploy database to remote host
* `db-backup.yml` - Backup database on remote host
* `files-deploy.yml` - Deploy files to remote host
* `files-backup.yml` - Backup files on remote host