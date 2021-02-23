alias cdws="cd ~/workspace"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

#Git
alias gpr="git pull --rebase"
alias gpp="git pull --rebase && git push"

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
