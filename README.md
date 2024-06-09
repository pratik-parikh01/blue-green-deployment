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

The helm chart for istio has been taken from here: https://github.com/rancher/charts/tree/release-v2.8/charts/rancher-istio/103.3.0%2Bup1.21.1

## Testing

To test, just port-forward the istio-ingressgateway service, command is as follows:
```
kubectl -n istio-system port-forward svc/istio-ingressgateway 8000:80
```
Now hit the `http://localhost:8000/` with browser or use `curl localhost:8000` command and see the switch between the different versions

## Full end to end test and validation

Steps:

1. Ensure you have the following prerequistes:
* docker for building the app image. This is optional if you do not wish to build the components and use the ones that I have built.
* kubectl and access to a kubernetes cluster.
* helm for installing istio helm chart. This is optional if you already have helm installed.

1. Install the prerequistes, i.e. istio. For this, just go to the `istio-helm-chart` and run the command. Optional if you already have istio installed.
```
helm install --namespace=istio-system istio .
```

2. Now to deploy the components, simply run `deploy.sh` and wait for the resources to get deployed

3. Once all resources are deployed, run the following command to access the service locally
```
kubectl -n istio-system port-forward svc/istio-ingressgateway 8000:80
```

4. Finally, run the command `curl localhost:8000` or go to browser and hit the url `http://localhost:8000` and see the results

5. The results will switch between blue version and green version everytime you hit the refresh button on the browser or fire the curl command again.

6. To test if this works properly, update the virtual-service.yaml and adjusts the weights (eg. 0 and 100) and run `deploy.sh` again

7. Now if you curl or use the browser again, only that version will be shown which has the 100 weight and the one with 0 weight will not be shown.

8. Finally adjust the weights as desired and run `deploy.sh` again. The traffic will be again distributed according to the specified weights.

## Cleanup

To delete the required resources, just run the following commands

```
helm uninstall istio -n istio-system
kubectl delete namespace assignment
```
