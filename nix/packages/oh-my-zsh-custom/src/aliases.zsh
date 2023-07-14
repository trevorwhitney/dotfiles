alias cdws="cd ~/workspace"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#Git
export GIT_DUET_GLOBAL=true
export GIT_DUET_ROTATE_AUTHOR=1

alias duet='git duet --global'
alias solo='git solo --global'

#Kubectl
if [[ `command -v kubectl` ]]; then
  alias k="kubectl "
  # Ensure the next command is checked as an alias when using watch
  # Allows `watch k get ...` to work
  alias watch='watch '

  if [[ -e /etc/rancher/k3s/k3s.yaml ]]; then
    alias k3k='kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml '
  fi
fi

#Docker
alias dc="docker-compose"

#misc
alias gravatar="curl 'https://www.gravatar.com/avatar/b1bbe91daa315e28b6fb3a7e06db42eb?s=500' -o gravatar.jpg"

#taskwiki
function task_url() {
  task $@ export | jq -r '.[] | .description' | cut -d'(' -f 2 | cut -d')' -f 1
}

#grafana
alias backend="cd ~/workspace/grafana/backend-enterprise"

function gen-logs() {
  if [ $# -ne 1 ]; then
    echo "please provide a host"
    return
  fi

  docker run \
    --log-driver loki-compose \
    --log-opt loki-url=${1}/loki/api/v1/push \
    -it --rm mingrammer/flog -l -d=1s -f=json
}

if [[ `command -v alacritty` ]]; then
  alias term-remote="alacritty --config-file=/home/twhitney/.config/alacritty/remote.yml & "
  alias term-remote-alt="alacritty --config-file=/home/twhitney/.config/alacritty/remote-alt.yml & "
  alias term-alt="alacritty --config-file=/home/twhitney/.config/alacritty/alacritty-alt.yml & "
fi


# one-password
function get_op_credential() {
  op get item $1 | jq -r '.details.sections | .[].fields | .[] | select(.n == "credential") | .v'
}
alias op_cred=get_op_credential

if [[ `command -v bat` ]]; then
  alias cat="bat -pp "
fi

# todo
alias todo="todo.sh"
