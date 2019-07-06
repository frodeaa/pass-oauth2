# pass oauth

An extension for the [password store](https://www.passwordstore.org/) that
exchange an refresh token for an access token.

## Usage
```
pass oauth pass-name
```

## Examples

A pass file with refresh token, url and other metadata for the OAUTH2 exchange.

```
$ pass email/gmail
{refresh_token}
url: https://accounts.google.com/oauth2/token
grant_type: refresh_token
client_id: xxxxxxxxxx
client_secret: xxxxxxxxxx
```

Exchange for an access token

```
$ pass oauth email/gmail
xxxxxxxxx
```

## Installation

```
git clone https://github.com/frodeaa/pass-oauth2.git
cd pass-oauth2
sudo make install
```

## Requirements

- `pass` 1.7.0 or later for extension support
- `curl` for requesting access token

### Build requirements

- `make lint`
  - `shellcheck`
