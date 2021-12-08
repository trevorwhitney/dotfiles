#!/usr/bin/env zsh
scripts_dir=$(cd $(dirname ${BASH_SOURCE}) && pwd)

export MAVEN_OPTS="-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.event.ExecutionEventLogger=info -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"
export LOG_LEVEL=${LOG_LEVEL:-"off"}

if [[ $# -eq 0 ]]; then
  echo "Please provide a maven goal (ie. test, install)"
  exit 1
fi

set +e
mvn $@
if [[ $? -ne 0 ]]; then
  $scripts_dir/maven-test-report.sh
fi
set -e
