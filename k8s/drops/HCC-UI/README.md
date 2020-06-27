# Mnode integration

This directory has a sample docker-compose.yaml file to show how we would/could integrate into mnode. Fronting Kind with nginx in the same way other services do in mnode isnt trivial. I think routing kind through nginx should be avoided. The advantage of a decoupled build time dependency out weighs any trade-offs.  

## mnode docker-proxy modification

For the `kind-bootstrapper` to function correctly, it will need access to the `docker.sock`. Mnode already has a pattern for service using the `docker.sock`. Service specify the following environment variable: `DOCKER_HOST=tcp://docker-proxy:2375`.  
For `kind-bootstrapper` to work we will need to update https://bitbucket.ngage.netapp.com/projects/MNOD/repos/docker-socket-proxy  
`kind` needs this additional line (in haproxy.cfg) to work through the existing mnode docker-proxy  
`http-request allow if METH_POST { path,url_dec -m reg -i ^(/v[\d\.]+)?/exec } { env(EXEC_POST) -m bool }`

## Usage
The `docker-compose.yaml` is an example of how we could integrate into mnode to run jobrunner (kind cluster). `kind-bootstrapper` starts the kind cluster and writes the kubeconfig to a volume. The HCC UI would then mount that volume and ingest the kubeconfig for use.
```bash
docker-compose up --build
docker run -it --rm -v ${PWD}:/deliverables -v Kubeconfig:/kubeconfig alpine:3.12.0 sh -c "cp /kubeconfig/kubeconfig /deliverables/kubeconfig"
kubectl --kubeconfig kubeconfig get nodes
```

Clean up
```bash
kind delete cluster
```