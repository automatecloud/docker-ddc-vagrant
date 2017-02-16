#!/bin/bash
# Enable Image Scanning
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"scanningEnabled\": true, \"scanningSyncOnline\": true }" "https://192.168.3.11/api/v0/meta/settings"
# Create all necessary repos
# redis
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"redis\", \"shortDescription\": \"Redis Image\", \"longDescription\": \"For Demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#postgres
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"postgres\", \"shortDescription\": \"Postgres Image\", \"longDescription\": \"For Demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#examplevotingapp_vote
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"examplevotingapp_vote\", \"shortDescription\": \"example voting app\", \"longDescription\": \"for demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#examplevotingapp_result
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"examplevotingapp_result\", \"shortDescription\": \"example result app\", \"longDescription\": \"for demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#examplevotingapp_worker
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"examplevotingapp_worker\", \"shortDescription\": \"example voting worker app\", \"longDescription\": \"for demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#visualizer
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"visualizer\", \"shortDescription\": \"visualizer app\", \"longDescription\": \"for demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#jenkins-docker
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"jenkins-docker\", \"shortDescription\": \"jenkins app\", \"longDescription\": \"for demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#docker-demo
curl -X POST --header "Content-Type: application/json" --header "Accept: application/json" -u admin:MyDemo123 -d "{ \"name\": \"docker-demo\", \"shortDescription\": \"Docker demo app\", \"longDescription\": \"for demo only\", \"visibility\": \"public\", \"scanOnPush\": true }" "https://192.168.3.11/api/v0/repositories/admin"
#pull tag and push images
docker login -u admin -p MyDemo123 192.168.3.11
docker pull redis:alpine
docker tag redis:alpine 192.168.3.11/admin/redis:alpine
docker push 192.168.3.11/admin/redis:alpine
docker pull postgres:9.4
docker tag postgres:9.4 192.168.3.11/admin/postgres:9.4
docker push 192.168.3.11/admin/postgres:9.4
docker pull dockersamples/examplevotingapp_vote:before
docker tag dockersamples/examplevotingapp_vote:before 192.168.3.11/admin/examplevotingapp_vote:before
docker push 192.168.3.11/admin/examplevotingapp_vote:before
docker pull dockersamples/examplevotingapp_result:before
docker tag dockersamples/examplevotingapp_result:before 192.168.3.11/admin/examplevotingapp_result:before
docker push 192.168.3.11/admin/examplevotingapp_result:before
docker pull dockersamples/examplevotingapp_worker
docker tag dockersamples/examplevotingapp_worker 192.168.3.11/admin/examplevotingapp_worker
docker push 192.168.3.11/admin/examplevotingapp_worker
docker pull dockersamples/visualizer:stable
docker tag dockersamples/visualizer:stable 192.168.3.11/admin/visualizer:stable
docker push 192.168.3.11/admin/visualizer:stable
docker pull pvdbleek/jenkins-docker
docker tag pvdbleek/jenkins-docker 192.168.3.11/admin/jenkins-docker
docker push 192.168.3.11/admin/jenkins-docker
docker pull ehazlett/docker-demo:latest
docker tag ehazlett/docker-demo:latest 192.168.3.11/admin/docker-demo:latest
docker push 192.168.3.11/admin/docker-demo:latest
