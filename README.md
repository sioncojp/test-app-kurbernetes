# test-app-kurbernetes
* ref: https://blog.gopheracademy.com/advent-2017/kubernetes-ready-service/

```shell
gcloud config set account xxxxxx@xxxxx
gcloud config set project xxxxxx
gcloud config set compute/zone asia-northeast1
gcloud auth login

gcloud auth list
gcloud projects list

make start ID=xxxxx
make stop ID=xxxxx
```

### local development
```shell
make run
```
