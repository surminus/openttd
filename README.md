# OpenTTD

Configures a dedicated [OpenTTD](https://www.openttd.org/en/) server.

It runs using the [OpenTTD Docker image](https://hub.docker.com/r/bateau/openttd/).

## Changing map settings

Update the configuration in the [openttd.cfg](site-cookbooks/openttd/templates/openttd.cfg.erb)
and add it as an attribute in [the attributes file](site-cookbooks/openttd/attributes/default.rb).

## Deployment

Deploy using Knife Solo:

`knife solo cook openttd`

I have the DNS details in my SSH configuration.

## Secrets

Encrypt using the `encrypted_data_bag_secret` file in my local repo.

Add the secret with `knife solo data bag`.
