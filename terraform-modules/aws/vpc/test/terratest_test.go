package test

import (
	"math/rand"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the simple Terraform module in examples/default using Terratest.
func TestTerraformDefaultExample(t *testing.T) {
	t.Parallel()

	// Random string for various dynamic bucket name usage
	stringRand := randomString(8)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Dynamic Variables that we should pass in addition to varfile.tfvars
		Vars: map[string]interface{}{
			"aws_region": "us-east-1",
			"environment_name": "unittest_aws_vpc_" + stringRand,
			"vpc_cidr": "10.0.0.0/16",
			"tags": `{
				ops_env              = "dev"
				ops_managed_by       = "terraform",
				ops_source_repo      = "kubernetes-ops",
				ops_source_repo_path = "terraform-environments/aws/dev",
				ops_owners           = "devops"
			  }`,
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	actualPolicyName := terraform.Output(t, terraformOptions, "name")
	actualPolicyArn := terraform.Output(t, terraformOptions, "arn")

	awsAccountID := aws.GetAccountId(t)

	assert.Equal(t, "unittest_aws_iam_policy_"+stringRand, actualPolicyName)
	assert.Equal(t, "arn:aws:iam::"+awsAccountID+":policy/unittest_aws_iam_policy_"+stringRand, actualPolicyArn)
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