# blue-green-deployment

## Application

### code

The sample application is a simple express js server serving a string on `/`. There are two versions of this app, v1 and v2, for blue and green versions respectively. The blue version serves `Hello World! This is blue version` on `/` and the green version serves `Hello World! This is green version`. The application is stored in the `app/` directory.

### building a new version

To build a new version, just run the `build.sh` file. You will have to pass the new version name. I have used `v1` and `v2` for the older and newer versions respectively. Example 
```
./build.sh v1
```

To build the docker image, I am using the command `docker build -t <your-docker-image-tag> .`. I have used my own docker public repo so my commands to push the image were:
```
docker build -t pratikparikh/sample-app:v1 .
```
and
```
docker build -t pratikparikh/sample-app:v2 .
```
respectively. In a real world scenario, we could use a better tagging scheme like <github-branch>.<commit-id> or `latest` or something on similar lines.

### deploying on kubernetes

The kubernetes manifest files are stored in the `manifests` directory. There are two deployment files, one for each blue and green deployments, a service to access the application and the rest are istio related files to direct the traffic to the appropriate pod based on configures weights.

To deploy/update, just run `deploy.sh`. This will create or update the kubernetes components.

