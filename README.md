# GlyphBackup

This is an executable tool made to backup your (rails) apps and to be easily extended.

The gem is meant to be used with the bin/glbackup script, but can be used within ruby importing the wanted modules.

## Usage

Add to your Gemfile :

```ruby
gem 'glyph-backup', :git => 'git@github.com:vala/glyph-backup'
```

and bundle using --binstubs options to be able to execute the script from the bundle

```bash
bundle install --binstubs
```

You can then execute it with bundle exec

```bash
bundle exec glbackup -c config/backup.yml -e development
```

## Configuration

You need a config file in order to tell glbackup how to back up your app.

You can easily generate a default config file with the following command :

```bash
bundle exec glbackup -g config/backup.yml
```

The default config file looks like the following :

```yaml
---
# Application name, for backup folder name
app_name: 

# Database configuration
db:
  type: mysql
  credentials: config/database.yml

# Application backup params
app:
  folders:
    - public/system

# Remote server configuration
remote:
  type: ftp
  address: localhost
  port: 21
  username: root
  password:
```

## Options

You can use the following options :

```bash
Usage: glbackup [-c path] [-g path] [-e environment]
    -c, --config=path                Sets the config file path
    -e, --env=environment            Sets RAILS_ENV to user, defaults to "production"
    -g, --generate-to=path           Only generate a default config file at the wanted path
    -h, --help                       Shows this help
```

## Licence

This project is released under the MIT-LICENSE.