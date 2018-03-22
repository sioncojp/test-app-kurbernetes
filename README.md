# test-app-kurbernetes
```shell
gcloud config set account xxxxxx@xxxxx
gcloud config set project xxxxxx
gcloud auth login

gcloud auth list
gcloud projects list

make install

make push CRED=xxxxxx.json
make start ID=xxxxx
make stop ID=xxxxx
```

### local development
```shell
make run
```
