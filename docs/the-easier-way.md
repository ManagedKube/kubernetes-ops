The easier way
================
This is not exactly the easy way but way easier than [the-manual-way.md](the-manual-way.md).

This methods walks you through how to create the VPC and a Kops cluster via
the scripts we provide instead of using the CLIs manually.  However, if you wanted
to learn what exactly it is doing and we encourage you to go through the [the-manual-way.md](the-manual-way.md)
once sometime.

# Replace all of the S3 buckets used
In the examples, S3 buckets are used for Terraform and Kops as the state store.
This allows you to not hold the state of what you launched local to your machine and
on a remote machine.  This is useful if you accidentally remove the files from your
local machine or if multiple people or machines will be updating these resources.

One problem is that S3 bucket names are global meaning only one can exist.  If I
used a bucket name, that means you can not use that same name.

For you to use this, you will need to update the bucket names in this repository
to what you want to use.  We are using the bucket name `kubernetes-ops-1234-terraform-state`

The following is a way to replace all of the occurrences of `kubernetes-ops-1234`
with `kubernetes-ops-xxxxxx`.  A suggestion would be to replace the
`xxxxxx` with another random number.  Try `123456` or `333333`, etc.

Linux:
```
find . -name '*' -exec sed -i -e 's/kubernetes-ops-1234/kubernetes-ops-xxxxxx/g' {} \;
```

OSX:
```
find . -type f | xargs sed -i '' 's/kubernetes-ops-1234/kubernetes-ops-xxxxxx/g'
```

You can alternatively use your IDE to search and replace this string
