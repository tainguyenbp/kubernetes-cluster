> There are more ways to use command output as arguments for other commands.
> The following three commands are all equivalent
```bash
docker rmi `docker images -qa`
docker rmi $(docker images -qa)
docker images -qa | xargs docker rmi
```
> To keep the file short we will use only one. If you feel like typing the commands yourself, choose the one that seems faster to you

## Images

#### Remove all images
```bash
docker rmi $(docker images -qa)
```

#### Remove untagged images
```bash
docker images -q --filter dangling=true | xargs docker rmi
```

#### Update all local images
```bash
docker images |grep -v REPOSITORY|awk '{print $1}'|xargs -L1 docker pull
```

## Containers

#### Stop the most recent ran container
```bash
docker stop $(docker ps -q -n1)
```

#### Stop all running containers
```bash
docker stop `docker ps -q`
```

#### Remove all stopped containers
```bash
docker rm $(docker ps -aq)
```

#### Remove containers created before/after a specific container
```bash
# before
docker ps --before a1bz3768ez7g -q | xargs docker rm

# after
docker ps --since a1bz3768ez7g -q | xargs docker rm
```

#### List all exited containers
```bash
docker ps -aq -f status=exited
```

## Best practices

1. Use `--rm` together with `docker build` to remove intermediary images during the build process.
