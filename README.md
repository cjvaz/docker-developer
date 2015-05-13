# docker-jhipster

## Python
## Ruby
## NodeJS
## Java8
## Go

### createrun container
```bash
$ docker run -d -v <folder_proj>:/developer -v ~/.m2:/home/developer/.m2 \ 
      -u $(id -u) -p 8080:8080 -p 3000:3000 -p 3001:3001 cjvaz/developer
```

### exec command in container
```bash
$ docker exec -i -t <container_name> bash
```

### get IP address
```bash
$ docker inspect --format '{{ .NetworkSettings.IPAddress }}'" <container_name>
```
### get Port mapping
```bash
$ inspect -f '{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> \ 
      {{(index $conf 0).HostPort}} {{end}}' <container_name>
```

### delete stopped containers
```bash
$ docker rm -v `docker ps -a -q -f status=exited`
```

### delete dangling images
```bash
$ docker rmi $(docker images -q -f dangling=true)
```

### delete all images
```bash
$ docker rmi $(docker images -q)
```