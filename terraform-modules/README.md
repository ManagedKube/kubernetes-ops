# terraform-modules


## Terratest
Each module has unit testing using Terratest associated with it.

### Starting a new test
In the modules directory, create a new folder named: `test`

```
mkdir test
cd test
```

Initilize the folder:
```
go mod init github.com/ManagedKube/kubernetes-ops
```


Create the Terratest file:

```
touch terratest_test.go
code terratest_test.go
```

Fill in the test details.  There are examples in this repo and the doc is here: https://github.com/gruntwork-io/terratest

### Running the test

In the `test` directory run:

```
go test -v
```
