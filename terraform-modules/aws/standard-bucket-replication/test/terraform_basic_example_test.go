package test

import (
	"fmt"
	"math/rand"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the simple Terraform module in examples/default using Terratest.
func TestTerraformDefaultExample(t *testing.T) {
	// t.Parallel()

	// append random string to bucket name
	stringRand := randomString(8)
	expectedId := "devops-dev-" + stringRand
	expectedArn := "arn:aws:s3:::devops-dev-" + stringRand

	bucket_policy := fmt.Sprintf(`{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::%s"
        },
        {
            "Sid": "ReadWriteAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::%s/*"
        }
    ]
}`, expectedId, expectedId)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Dynamic Variables that we should pass in addition to varfile.tfvars
		Vars: map[string]interface{}{
			"bucket_name":   expectedId,
			"policy":        bucket_policy,
			"attach_policy": true,
			"env": "qadium-dev",
            "region": "us-east-1",
            "group": "DevOps",
			"versioning": true,
			"lifecycle_rules": []interface{}{
				0: map[string]interface{}{
					"enabled": true,
					"expiration": map[string]interface{}{
						"days": 7,
					},
				},
			},
			"cors_rule": []interface{}{
				0: map[string]interface{}{
					"allowed_headers": []interface{}{
						0: "*",
					},
					"allowed_methods": []interface{}{
						0: "GET",
					},
					"allowed_origins": []interface{}{
						0: "https://internal-tool.expander.dev.q-internal.tech",
					},
				},
			},
			"block_public_acls": false,
		},
		// Variables to pass to our Terraform code using -var-file options
		// VarFiles: []string{"varfile.tfvars"},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	actualTextBucketId := terraform.OutputList(t, terraformOptions, "bucket_id")
	actualTextBucketArn := terraform.OutputList(t, terraformOptions, "bucket_arn")

	assert.Equal(t, expectedId, actualTextBucketId[0])
	assert.Equal(t, expectedArn, actualTextBucketArn[0])
}

func randomString(len int) string {

	rand.Seed(time.Now().UTC().UnixNano())
	bytes := make([]byte, len)

	for i := 0; i < len; i++ {
		bytes[i] = byte(randInt(97, 122))
	}

	return string(bytes)
}

func randInt(min int, max int) int {

	return min + rand.Intn(max-min)
}

func TestReplicaBuckets(t *testing.T) {
	// t.Parallel()

	// append random string to bucket name
	stringRand := randomString(8)
	expectedId := "devops-dev-u2-" + stringRand
	expectedArn := "arn:aws:s3:::devops-dev-u2-" + stringRand
	expectedArnReplica := "arn:aws:s3:::devops-dev-u2-" + stringRand + "-replica"

	bucket_policy := fmt.Sprintf(`{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::%s"
        },
        {
            "Sid": "ReadWriteAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::%s/*"
        }
    ]
}`, expectedId, expectedId)

	bucket_policy_replica := fmt.Sprintf(`{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::%s"
        },
        {
            "Sid": "ReadWriteAccessForJenkinsBackups",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::354114410416:role/aws_backup"
            },
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::%s/*"
        }
    ]
}`, expectedId + "-replica", expectedId + "-replica")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Dynamic Variables that we should pass in addition to varfile.tfvars
		Vars: map[string]interface{}{
			"env": "qadium-dev",
            "region": "us-east-1",
            "group": "DevOps",
			"versioning": true,
			"lifecycle_rules": []interface{}{
				0: map[string]interface{}{
					"enabled": true,
					"expiration": map[string]interface{}{
						"days": 7,
					},
				},
			},
			"cors_rule": []interface{}{
				0: map[string]interface{}{
					"allowed_headers": []interface{}{
						0: "*",
					},
					"allowed_methods": []interface{}{
						0: "GET",
					},
					"allowed_origins": []interface{}{
						0: "https://internal-tool.expander.dev.q-internal.tech",
					},
				},
			},
			"block_public_acls": false,
			"bucket_name":   expectedId,
			"policy":        bucket_policy,
			"attach_policy": true,
			"enable_replication": 1,
			"replica_region": "us-west-2",
			"replica_bucket_name": expectedId + "-replica",
			"policy_replica": bucket_policy_replica,
			"replica_provider_profile": "qadium-dev",
		},
		// Variables to pass to our Terraform code using -var-file options
		// VarFiles: []string{"varfile.tfvars"},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	actualTextBucketId := terraform.OutputList(t, terraformOptions, "bucket_id_source_replica")
	actualTextBucketArn := terraform.OutputList(t, terraformOptions, "bucket_arn_source_replica")
	actualTextBucketIdReplica := terraform.OutputList(t, terraformOptions, "bucket_id_replica")
	actualTextBucketArnReplica := terraform.OutputList(t, terraformOptions, "bucket_arn_replica")

	assert.Equal(t, expectedId, actualTextBucketId[0])
	assert.Equal(t, expectedArn, actualTextBucketArn[0])
	assert.Equal(t, expectedId + "-replica", actualTextBucketIdReplica[0])
	assert.Equal(t, expectedArnReplica, actualTextBucketArnReplica[0])
}
