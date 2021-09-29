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

alias g='git'
alias gpr='git pull --rebase'
alias gpp='git pull --rebase && git push'
alias gs='git status'
alias gst='git status'

alias gap="git add -p"
alias gdf="git diff --color | diff-so-fancy"

#Gradle
alias g="gradle"
alias gw="./gradlew"

#Kubectl
if [[ `command -v kubectl` ]]; then
  alias k="kubectl "
  # Ensure the next command is checked as an alias when using watch
  # Allows `watch k get ...` to work
  alias watch='watch '
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
if [[ -e "$HOME/workspace/k3s" ]]; then
  alias curl_gem="curl -u :$(cat ~/workspace/k3s/gem/secret) -H 'Accept: application/json'"
  alias curl_gel="curl -u :$(cat ~/workspace/k3s/gel/secret) -H 'Accept: application/json'"
fi

if [[ `command -v alacritty` ]]; then
  alias term-remote="alacritty --config-file=/home/twhitney/.config/alacritty/remote.yml & "
  alias term-remote-dark="alacritty --config-file=/home/twhitney/.config/alacritty/remote-dark.yml & "
  alias term-dark="alacritty --config-file=/home/twhitney/.config/alacritty/alacritty-dark.yml & "
fi

alias git-root="git rev-parse --show-toplevel"

alias v="vim "

# one-password
function get_op_credential() {
  op get item $1 | jq -r '.details.sections | .[].fields | .[] | select(.n == "credential") | .v'
}
alias op_cred=get_op_credential

if [[ `command -v bat` ]]; then
  alias cat="bat -pp "
fi
