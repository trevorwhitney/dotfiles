#!/bin/bash
# Fetch 24-hour AWS STS session token and set appropriate environment variables.
# See http://docs.aws.amazon.com/cli/latest/reference/sts/get-session-token.html .
# You must have jq installed and in your PATH https://stedolan.github.io/jq/ .
# Add this function to your .bashrc or save it to a file and source that file from .bashrc .
# https://gist.github.com/ddgenome/f13f15dd01fb88538dd6fac8c7e73f8c
#
# usage: aws-creds MFA_TOKEN [OTHER_AWS_STS_GET-SESSION-TOKEN_OPTIONS...]
function aws-creds () {
    set -eu
    local pkg=aws-creds
    if [[ ! $1 ]]; then
        echo "$pkg: missing required argument: MFA_TOKEN" 1>&2
        return 99
    fi

    export AWS_SESSION_TOKEN
    local iam_user=${AWS_IAM_USER}
    local aws_account=${AWS_ACCOUNT}
    local rv creds_json
    creds_json=$(aws --output json sts get-session-token --duration-seconds 86400 --serial-number "arn:aws:iam::$aws_account:mfa/$iam_user" --token-code "$1")
    rv="$?"
    if [[ $rv -ne 0 || ! $creds_json ]]; then
        echo "$pkg: failed to get credentials for user '$iam_user' account '$aws_account': $creds_json" 1>&2
        return "$rv"
    fi

    local jq="jq --exit-status --raw-output"
    AWS_ACCESS_KEY_ID=$(echo "$creds_json" | jq --exit-status --raw-output .Credentials.AccessKeyId)
    rv="$?"
    if [[ $rv -ne 0 || ! $AWS_ACCESS_KEY_ID ]]; then
        echo "$pkg: failed to parse output for AWS_ACCESS_KEY_ID: $creds_json" 1>&2
        return "$rv"
    fi
    AWS_SECRET_ACCESS_KEY=$(echo "$creds_json" | jq --exit-status --raw-output .Credentials.SecretAccessKey)
    rv="$?"
    if [[ $rv -ne 0 || ! $AWS_SECRET_ACCESS_KEY ]]; then
        echo "$pkg: failed to parse output for AWS_SECRET_ACCESS_KEY: $creds_json" 1>&2
        return "$rv"
    fi
    AWS_SESSION_TOKEN=$(echo "$creds_json" | jq --exit-status --raw-output .Credentials.SessionToken)
    rv="$?"
    if [[ $rv -ne 0 || ! $AWS_SESSION_TOKEN ]]; then
        echo "$pkg: failed to parse output for AWS_SESSION_TOKEN: $creds_json" 1>&2
        return "$rv"
    fi

    cat <<ENV
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
ENV
}

if [[ $0 == "${0}" ]]; then
  aws-creds $@
fi
