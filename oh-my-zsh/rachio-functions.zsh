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

function aws-login() {
  local code="${1}"
  aws sts get-session-token --serial-number arn:aws:iam::170902677803:mfa/twhitney --token-code ${code}
}
