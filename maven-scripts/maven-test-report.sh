#!/usr/bin/env bash

wd="$(pwd)"

reports=$(for folder in `find . -type d -name target`; do
  test -d $folder/surefire-reports && ls $folder/surefire-reports/*.txt;
done)

for report in $reports; do
  failures=$(cat $report | grep "^Tests run" | sed -E "s/.*Failures:[[:space:]]*([0-9]*)[^0-9].*/\1/g")
  errors=$(cat $report | grep "^Tests run" | sed -E "s/.*Errors:[[:space:]]*([0-9]*)[^0-9].*/\1/g")

  if [[ $errors -gt 0 ]] || [[ $failures -gt 0 ]]; then
    filename="$(basename $report)"
    spec_name="${filename%.*}"
    tput setaf 1
    printf "\n$spec_name had $failures failure(s) and $errors error(s)\n"
    tput sgr0
    cat $report
  fi
done
