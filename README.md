### Welcome to Drupal Docker - LAMP Stack Container

**Composer Install**

`composer install`


**Environment Variable**


Please refer to example.env to how to work on environment variable using `.ENV` file

**DRUSH**

`vendor/bin/drush cache-rebuild`

If you are using a multi-site and let say the domain is my.example.com added in sites.php
`vendor/bin/drush --uri=https://my.example.com cache-rebuild`


### Configuration Management

The power mechanism to move database configuration as part of your Code Build

To extract all configuration from your working Drupal instance in your folder inside the working directory. Let say "./config/sync". Do not forget to add configuration YMLs in your repository.

`vendor/bin/drush config-export`
or
`vendor/bin/drush --uri=https://lifepointspanel.com cex`

The team will able to update there local instance or to update your Environment  container instance
`vendor/bin/drush config-import`
or
`vendor/bin/drush --uri=https://lifepointspanel.com cim`


### Drupal recommended Update


```
> drupal/core-recommended --with-dependencies
> drush updatedb
> drush cache:rebuild
```
