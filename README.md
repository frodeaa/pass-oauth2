| Branch | Status |
|--------|--------|
| [**master**](https://github.com/frodeaa/pass-oauth2/tree/master) | [![Build Status: master](https://travis-ci.org/frodeaa/pass-oauth2.svg?branch=master)](https://travis-ci.org/frodeaa/pass-oauth2) |

# pass oauth

An extension for the [password store](https://www.passwordstore.org/) that
exchange an refresh token for an access token.

## Usage
```
Usage:

    pass oauth2 [code] [--clip,-c] pass-name
        Exhange refresh token for an access token and optionally put
        it on the clipboard. If put on the clipboard, it will be
        cleared in 45 seconds.

More information may be found in the pass-oauth2(1) man page.
```

## Examples

A pass file with refresh token, url and other data parameters for the OAUTH2 exchange.

```
$ pass email/gmail
url: https://accounts.google.com/o/oauth2/token
refresh_token: {refresh_token}"
grant_type: refresh_token"
client_id: {client_id}"
client_secret: {client_secret}"
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
