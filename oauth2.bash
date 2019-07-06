#!/usr/bin/env bash
# pass oauth - Password Store Extension (https://www.passwordstore.org/)

set -Eeuo pipefail

path="$1"
passfile="$PREFIX/$path.gpg"
check_sneaky_paths "$path"

[[ -f $passfile ]] || die "Passfile not found"

url=
refresh_token=
curl_params=

while IFS= read -r line; do
    [[ -z $curl_params ]] && [[ -z $refresh_token ]] && refresh_token="$line"
    [[ -z $url && "$line" == url:* ]] && url="$(awk '{ print $2 }' <<< "$line")"
    data="$(awk -F ': ' '{if ($1 != "url" && $2 != "") print "--data " $1 "=" $2 }' <<< "$line")"
    curl_params+="$curl_params $data"
done < <($GPG -d "${GPG_OPTS[@]}" "$passfile")

[[ -z $url ]] && die "No url found"
[[ -z $refresh_token ]] && die "No refresh token found"

# shellcheck disable=SC2086
curl --silent ${curl_params} \
    --data refresh_token="${refresh_token}" "${url}" \
    | grep access_token | awk '{ print $2 }' | sed s/\"//g | sed s/,//g
