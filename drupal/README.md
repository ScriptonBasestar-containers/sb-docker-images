# Drupal

Tag: CMS
MadeOf: PHP

오픈소스CMS


## REF
https://github.com/geerlingguy/drupal-container/blob/master/docker-compose.yml
https://www.drupal.org/docs/develop/using-composer/manage-dependencies

## Errors
https://www.drupal.org/docs/develop/development-tools/enable-verbose-error-logging-for-better-backtracing-and-debugging


### Drush
If you're seeing the message "drush not found," it means that Drush (the Drupal Shell) is not installed or not properly configured on your system. Drush is a command-line utility that helps you manage your Drupal site and perform various administrative tasks directly from the command line. Here’s how you can install and set it up:

### 1. Install Drush

You can install Drush using Composer, which is the recommended way to manage Drupal and its dependencies. Here are the general steps:

#### Install Composer
If you don't have Composer installed, you'll need to install it first. You can install Composer globally on your system using the following command:

```bash
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

#### Install Drush
Once Composer is installed, you can install Drush. To install the latest stable version of Drush:

```bash
composer global require drush/drush
```

#### Add Drush to Your Path
Ensure the global Composer bin directory is in your system's PATH so that you can run Drush from anywhere. If you installed Composer and Drush as your user, add this line to your `~/.bash_profile` or `~/.bashrc`:

```bash
export PATH="$HOME/.composer/vendor/bin:$PATH"
```

Then, reload your bash configuration:

```bash
source ~/.bash_profile  # or ~/.bashrc
```

### 2. Verify Installation
To check if Drush is installed correctly, you can run:

```bash
drush status
```

This command should display the status of Drush and confirm that it is ready to use.

### 3. Using Drush
Now that Drush is installed, you can use it to perform various tasks, such as clearing the cache:

```bash
drush cache-rebuild
```

or updating the database:

```bash
drush updatedb
```

### Troubleshooting
- **Path Issues**: If Drush still isn't recognized, make sure the path to Drush is correctly added to your system's PATH.
- **Permissions**: Ensure that you have the necessary permissions to install software and make modifications to your system.
- **Version Compatibility**: Make sure the version of Drush is compatible with your version of Drupal.

If you continue to have issues, it might be beneficial to consult the [Drush documentation](https://www.drush.org/latest/) or seek specific advice from Drupal community forums or a system administrator familiar with your environment.