# StorySprout API

> The rails auto-generated README has been moved [here](md/RAILS.md) 

## Development

### Using NGROK

Follow these steps to setup `ngrok` for your local environment:
- Ensure you have updated your `.envrc` file with the `NGROK_AUTH_TOKEN`. You can get this from KeePass
- Run the following script to export the token to your local `ngrok.yml` config file:
  ```shell
  ngrok config add-authtoken ${NGROK_AUTH_TOKEN}
  ```
