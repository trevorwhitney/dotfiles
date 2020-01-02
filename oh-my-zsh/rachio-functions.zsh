# ssh into an aws instance, with or without prepending the standard 'i-'
function ssh-instance() {
    if [ $# -lt 1 ] || [ $# -gt 3 ]; then
        echo "Usage: ssh-instance [-r region] <instance id>"
    else
        case "$1" in
            "-r")
                if [ $# -eq 3 ] && [ -n "`echo $3|egrep \"^i-[0-9a-z]+\"`" ]; then
                    ssh `aws ec2 describe-instances --region $2 --instance-ids $3 --output text --query "Reservations[0].Instances[0].PrivateIpAddress"`
                elif [ $# -eq 3 ] && [ -n "`echo $3|egrep \"^[0-9a-z]+\"`" ]; then
                    ssh `aws ec2 describe-instances --region $2 --instance-ids i-$3 --output text --query "Reservations[0].Instances[0].PrivateIpAddress"`
                else
                    echo "Usage: ssh-instance [-r region] <instance id>"
                    return 1
                fi;;
            i-[0-9a-zA-Z]*)
                if [ $# -eq 3 ] && [ "$2" == "-r" ]; then
                    ssh `aws ec2 describe-instances --region $3 --instance-ids $1 --output text --query "Reservations[0].Instances[0].PrivateIpAddress"`
                elif [ $# -eq 1 ]; then
                    ssh `aws ec2 describe-instances --region us-west-2 --instance-ids $1 --output text --query "Reservations[0].Instances[0].PrivateIpAddress"`
                else
                    echo "Usage: ssh-instance [-r region] <instance id>"
                    return 1
                fi;;
            [0-9a-zA-Z]*)
                if [ $# -eq 3 ] && [ "$2" == "-r" ]; then
                    ssh `aws ec2 describe-instances --region $3 --instance-ids i-$1 --output text --query "Reservations[0].Instances[0].PrivateIpAddress"`
                elif [ $# -eq 1 ]; then
                    ssh `aws ec2 describe-instances --region us-west-2 --instance-ids i-$1 --output text --query "Reservations[0].Instances[0].PrivateIpAddress"`
                else
                    echo "Usage: ssh-instance [-r region] <instance id>"
                    return 1
                fi;;
            *)
                echo "Usage: ssh-instance [-r region] <instance id>"
            esac
    fi
    return 0
}

# ssh into a standardly named v3 service on aws.
function ssh-service() {
  if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "Usage ssh-service <environment> <service> [instance number]"
  else
    instances=("${(@f)$(aws ec2 describe-instances --filters 'Name=tag:Name,Values='"$2-service-$1"'' --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' --region us-west-2)}")
    if [ -z "$3" ]; then
      echo "Avaliable instances.  Rerun command and include a number:"
      for ((i = 1; i <= ${#instances[@]}; ++i))
      do
        echo "$i) ${instances[$i]}"
      done
    else
      echo "sshing into host ${instances[$3]} for service $2-service-$1"
      ssh ${instances[$3]}
    fi
  fi
}

# Change the log level on any standardly named v3 service on aws.
function log-level() {
  if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo "Usage log-level <environment> <service> <class> [level]"
  else
    instances=("${(@f)$(aws ec2 describe-instances --filters 'Name=tag:Name,Values='"$2-service-$1"'' --output text --query 'Reservations[*].Instances[*].PrivateIpAddress' --region us-west-2)}")
    for host in "${instances[@]}"
    do
      echo "setting $3 class to $4 on host $host"
      if [ -z "$4" ]
      then
        curl -X POST http://$host:5001/tasks/log-level -d "logger=$3"
      else
        curl -X POST http://$host:5001/tasks/log-level -d "logger=$3&level=$4"
      fi
    done
  fi
  return 0
}

function aws-creds () {
    set -eu
    local pkg=aws-creds
    if [[ ! $1 ]]; then
        echo "$pkg: missing required argument: MFA_TOKEN" 1>&2
        return 99
    fi

    unset AWS_SESSION_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SECRET_KEY

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
export AWS_SECRET_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
ENV
}

function clear-aws-creds() {
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SECRET_KEY
  unset AWS_SESSION_TOKEN
}
