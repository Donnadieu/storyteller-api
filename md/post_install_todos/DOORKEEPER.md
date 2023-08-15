# DoorKeeper Post Install TODOs

## 08/15/2023

```shell
Post-install message from doorkeeper:
Starting from 5.5.0 RC1 Doorkeeper requires client authentication for Resource Owner Password Grant
as stated in the OAuth RFC. You have to create a new OAuth client (Doorkeeper::Application) if you didn't
have it before and use client credentials in HTTP Basic auth if you previously used this grant flow without
client authentication.

To opt out of this you could set the "skip_client_authentication_for_password_grant" configuration option
to "true", but note that this is in violation of the OAuth spec and represents a security risk.

Read https://github.com/doorkeeper-gem/doorkeeper/issues/561#issuecomment-612857163 for more details.
```
