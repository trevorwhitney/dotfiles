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
alias k="kubectl"

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
