docker pull busybox

docker commit -m "touch test" -a "yu_lin" 3c284bbe407d trade/wj-busybox:v1.0

docker tag 988a4f61644d localhost:5000/trade/wj-busybox:v1.0
docker push localhost:5000/trade/wj-busybox:v1.0

docker run -d -e ENV_DOCKER_REGISTRY_HOST=192.168.24.35 -e ENV_DOCKER_REGISTRY_PORT=5000 -p 8080:80 konradkleine/docker-registry-frontend


docker run -d --name docker-registry -p 5000:5000 -v /docker-registry:/tmp/registry registry
docker run -d --name docker-registry-ui -e ENV_DOCKER_REGISTRY_HOST=192.168.142.133 -e ENV_DOCKER_REGISTRY_PORT=5000 -p 8080:80 konradkleine/docker-registry-frontend
