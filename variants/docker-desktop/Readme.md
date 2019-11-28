docker-desktop variant enables quick development on docker-desktop
=

Used simple bash scripts to deploy in order to simplify debugging 
first time the deployment is slow due to fetching images
Tested on mac

To init:     apply.sh 
To delete:   delete.sh


To purge pvc after delete.sh
-
```
kubectl get all,pv,pvc -n kafka


kubectl patch persistentvolume/pvc-a1c7bd1e-11f9-11ea-9768-025000000001 -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch persistentvolume/pvc-a1c92058-11f9-11ea-9768-025000000001 -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch persistentvolume/pvc-a2200b1f-11f9-11ea-9768-025000000001 -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch persistentvolume/pvc-a221cf45-11f9-11ea-9768-025000000001 -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch persistentvolume/pvc-a223ceca-11f9-11ea-9768-025000000001 -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch  -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch  -p '{"metadata":{"finalizers": []}}' --type=merge
kubectl patch  -p '{"metadata":{"finalizers": []}}' --type=merge
```