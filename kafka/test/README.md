## An ad-hoc testing pattern

Tests are based on the [kube-test](https://github.com/Yolean/kube-test) concept.
Like the rest of this repo they have `kubectl` as the only local dependency.

Run self-tests or not. They do generate some load, but indicate if the platform is working or not.
 * To include tests, replace `apply -f` with `apply -R -f` in your `kubectl`s above.
 * Anything that isn't READY in `kubectl get pods -l test-type=readiness --namespace=test-kafka` is a failed test.
