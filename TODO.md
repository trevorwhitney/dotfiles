1. Setup Docker for CI
1. Add gradle and java 8 in a way the doesn't break circle ci
  * ie. not through apt
1. Push built docker image to docker hub
1. Investigate `envsubst` for templating/substitution.
  * For example, finding the stack bin path
  * Or OS specific stuff
