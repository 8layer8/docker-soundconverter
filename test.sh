# Dockerfile
# run it with:

# source proxy.sh

docker rm docker-soundconverter-test
docker rmi docker-soundconverter
docker build -t mindcrime30/docker-soundconverter:0.0.2 .

# docker images
docker run --rm -p 5805:5800 --name docker-soundconverter-test mindcrime30/docker-soundconverter:0.0.2

# Put version above, and then:
# docker login
# yada yada
# docker push mindcrime30/docker-soundconverter:0.0.1
# OR
# Check code into git and the docker hub connection will pick it up

