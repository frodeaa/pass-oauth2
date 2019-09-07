#!/usr/bin/env bash
# pass oauth - Password Store Extension (https://www.passwordstore.org/)

set -Eeuo pipefail

opts=
clip=0
opts="$($GETOPT -o c -l clip -n "$PROGRAM" -- "$@")"
err=$?
eval set -- "$opts"
while true; do case $1 in
  -c|--clip) clip=1; shift ;;
  --) shift; break ;;
esac done

[[ $err -ne 0 || $# -ne 1 ]] && die "Usage: $PROGRAM $COMMAND [--clip,-  c] pass-name"

path="${1%/}"
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
out=$(curl --silent ${curl_params} \
    --data refresh_token="${refresh_token}" "${url}" \
    | grep access_token | awk '{ print $2 }' | sed s/\"//g | sed s/,//g) \
    || die "$path: failed to create access token."

if [[ $clip -ne 0 ]]; then
    clip "$out" "access token for $path"
else
    echo "$out"
fi
