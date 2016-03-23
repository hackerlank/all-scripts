docker pull busybox

docker commit -m "touch test" -a "yu_lin" 3c284bbe407d trade/wj-busybox:v1.0

docker tag 988a4f61644d localhost:5000/trade/wj-busybox:v1.0
docker push localhost:5000/trade/wj-busybox:v1.0

docker run -d -e ENV_DOCKER_REGISTRY_HOST=192.168.24.35 -e ENV_DOCKER_REGISTRY_PORT=5000 -p 8080:80 konradkleine/docker-registry-frontend


docker run -d --restart=always --name docker-registry -p 5000:5000 -v /docker-registry:/tmp/registry registry
docker run -d --restart=always --name docker-registry-ui -e ENV_DOCKER_REGISTRY_HOST=192.168.142.133 -e ENV_DOCKER_REGISTRY_PORT=5000 -p 8080:80 konradkleine/docker-registry-frontend

# openssl
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=docker.yjb.com" -keyout yjb.com.key  -out yjb.com.crt

htpasswd -b -c htpassword  yu_lin qwe123lin


docker run -d -p 5000:5000 --restart=always --name docker-registry -v /certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/yjb.com.crt -e REGISTRY_HTTP_TLS_KEY=/certs/yjb.com.key registry

docker run -d -p 5000:5000 --restart=always --name docker-registry -v /root/auth/:/auth/ -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpassword -v /certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/yjb.com.crt -e REGISTRY_HTTP_TLS_KEY=/certs/yjb.com.key registry


rpm -ivh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

docker --insecure-registry docker.yjb.com:8080 run -d -p 5000:5000 --restart=always --name docker-registry  -e SETTINGS_FLAVOR=dev -e STORAGE_PATH=/tmp/registry -v /opt/data/registry:/tmp/registry registry 


docker --insecure-registry docker.yjb.com:8080  run   -d -p 5000:5000 --restart=always --name docker-registry  -e SETTINGS_FLAVOR=dev -e STORAGE_PATH=/tmp/registry -v /opt/data/registry:/tmp/registry registry


--insecure-registry


docker run -d -p 5000:5000 -v /opt/data:/tmp/registry  docker.io/registry:latest registry


#***************************************************

docker run -d -p 5000:5000 --name wj-registry -v /opt/data:/var/lib/registry --restart=always registry

#***************************************************
