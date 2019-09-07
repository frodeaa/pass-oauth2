#!/usr/bin/env bash
# pass oauth - Password Store Extension (https://www.passwordstore.org/)

VERSION="1.0.0"
CURL=$(command -v curl)

cmd_oauth2_usage() {
    cat <<-_EOF
Usage:

    $PROGRAM oauth2 [code] [--clip,-c] pass-name
        Exhange refresh token for an access token and optionally put
        it on the clipboard. If put on the clipboard, it will be
        cleared in $CLIP_TIME seconds.

More information may be found in the pass-oauth2(1) man page.
_EOF
    exit 0
}

cmd_oauth2_version() {
    echo $VERSION
    exit 0
}

cmd_oauth2() {
    [[ -z "$CURL" ]] && \
        die "Failed to exchang refresh token: curl is not installed."

    local opts clip=0
    opts="$($GETOPT -o c -l clip -n "$PROGRAM" -- "$@")"
    local err=$?
    eval set -- "$opts"
    while true; do case $1 in
        -c|--clip) clip=1; shift ;;
        --) shift; break ;;
    esac done

    [[ $err -ne 0 || $# -ne 1 ]] \
        && die "Usage: $PROGRAM $COMMAND [--clip,-  c] pass-name"

    local path="${1%/}"
    local passfile="$PREFIX/$path.gpg"
    check_sneaky_paths "$path"

    [[ -f $passfile ]] || die "Passfile not found"

    local url=
    local refresh_token=
    local curl_params=

    while IFS= read -r line; do
        [[ -z $curl_params ]] && [[ -z $refresh_token ]] && refresh_token="$line"
        [[ -z $url && "$line" == url:* ]] && url="$(awk '{ print $2 }' <<< "$line")"
        data="$(awk -F ': ' '{if ($1 != "url" && $2 != "") print "--data " $1 "=" $2 }' \
            <<< "$line")"
        curl_params+="$curl_params $data"
    done < <($GPG -d "${GPG_OPTS[@]}" "$passfile")

    [[ -z $url ]] && die "No url found"
    [[ -z $refresh_token ]] && die "No refresh token found"

    local out=
    # shellcheck disable=SC2086
    out=$($CURL --silent ${curl_params} \
        --data refresh_token="${refresh_token}" "${url}" \
        | grep access_token | awk '{ print $2 }' | sed s/\"//g | sed s/,//g) \
        || die "$path: failed to create access token."

    if [[ $clip -ne 0 ]]; then
        clip "$out" "access token for $path"
    else
        echo "$out"
    fi
}

case "$1" in
    help|--help|-h) shift; cmd_oauth2_usage "$@" ;;
    version|--version) shift; cmd_oauth2_version "$@" ;;
    *)                     cmd_oauth2 "$@" ;;
esac
exit 0
