# Pairing Environment for Docker

This directory includes a Dockerfile and Kubernetes StatefulSet to set up a pod that
can be used as a shared pairing environment. To use it, follow the following
steps:

1. Build the `Dockerfile` with `docker build -t some/tag .`
  * Docker files are split up into Dockerfile.base and Dockerfile, with that latter depending on the former
3. Edit `statefulset.yaml` to use image tag you specified when building the
   image.

    * NOTE: you may also have to edit the `storageClassName` for the
      `volumeClaimTemplate` to match a valid storage class where you are
      running the image. For example, to run this on a local `k3s` cluster you
      would need to change it to be `local-disk`.

4. Run `kubectl apply -f statefulset.yaml`

5. Run `k exec -it -n  pair-box-0 -- /bin/zsh` in order to set up a
   few things in the box:

    * Run `passwd pair` to setup a password for the pair account

    * Copy your public ssh key into `/home/pair/.ssh/authorized_keys`

6. Exit the container. Back on your host/local machine put the following in your SSH config (`~/.ssh/config`)

    ```
    Host pair-box
        ProxyCommand kubectl --kubeconfig=$HOME/.kube/config exec -i pods/pair-box-0 -- /usr/sbin/sshd -i
        HostName pair-box
        User pair
        ServerAliveInterval 300
        ServerAliveCountMax 2
    ```
