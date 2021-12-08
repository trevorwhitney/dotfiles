#!/usr/bin/env zsh

java_versions="$(update-alternatives --list java | cut -d / -f 5)"
echo "${java_versions}" | grep adoptopenjdk-11-hotspot > /dev/null
echo "${java_versions}" | grep adoptopenjdk-14-hotspot > /dev/null
