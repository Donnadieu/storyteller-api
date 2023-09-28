# StorySprout API

<!-- TOC -->
* [StorySprout API](#storysprout-api)
  * [Development](#development)
    * [Setup](#setup-)
    * [Managing application secrets](#managing-application-secrets)
    * [Using NGROK](#using-ngrok)
  * [Operations](#operations)
    * [Using logs](#using-logs)
<!-- TOC -->

> The rails auto-generated README has been moved [here](docs/RAILS.md)

## Development

### Setup 

To setup your local environment, run the following commands in your console:

```shell
# List dependencies that are installed
brew bundle list 
# Check if dependencies are satisfied. If your installed versions are behind, this will "fail" the check 
brew bundle check 
# Install dependencies that are not installed
brew bundle
```

### Managing application secrets

To view help information about managing application credentials, run the following command in your console:

```shell
bin/rails credentials:help
```

### Using NGROK

Follow these steps to setup `ngrok` for your local environment:

- Ensure you have updated your `.envrc` file with the `NGROK_AUTH_TOKEN`. You can get this from KeePass
- Run the following script to export the token to your local `ngrok.yml` config file:

  ```shell
  ngrok config add-authtoken ${NGROK_AUTH_TOKEN}
  ```
Then you can open a tunnel to your local environment by running:
```shell
thor story-cli:tunnel:open_all
```

To edit the credentials file for your development environment, run the following code in your console:

```shell
EDITOR=nano bin/rails credentials:edit --environment ${RAILS_ENV:-development}
```

## Operations

### Using logs

Application logs are captured by [the Google Cloud Logging service](https://cloud.google.com/logging/docs?_ga=2.7398139.-852036619.1641716250).

## Future reading

- Testing flipper feature flags: https://www.flippercloud.io/docs/testing
