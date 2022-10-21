package test

import (
	"math/rand"
	"testing"
	"time"

	// "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Default test
func TestTerraformDefault(t *testing.T) {
	t.Parallel()

	// Random string for various dynamic bucket name usage
	stringRand := randomString(8)
	node0 := "node0-" + stringRand
	node1 := "node1-" + stringRand
	// The unit test should really create everything it needs.  Maybe except for the AMI.
	subnet_id := "subnet-0dc93d734674d2651"
	security_group := "sg-06f385f8d8a319d59"
	key_name := "marqeta-aws-root"
	ami := "ami-0b4bc4eb77ae7e66c"
	instance_type := "t3.small"
	group0Name := "group0-" + stringRand
	group1Name := "group1-" + stringRand
	userData := `#cloud-config\nwrite_files:\n- encoding: b64\n  content: aGVsbG8K\n  owner: root:root\n  path: /tmp/unit-test-user-data-file.txt\n  permissions: '0644'`

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/node_list_1",

		// Dynamic Variables that we should pass in addition to varfile.tfvars
		// VarFiles: []string{
		// 	"./test/var1.tfvars",
		// },

		Vars: map[string]interface{}{
			"aws_region":          "us-east-1",
			"environment_name":    "node_list_unit_test_" + stringRand,
			"key_pair_name":       "node_list_unit_test_" + stringRand,
			"user_ssh_public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC641Tabto5333cceSZftvqibRr9OhbP0IPv+gqRo9OdED7shWhA2XuWqQnIok8yv0Wimi+CZ00tVbkZHA27NObDQnX/KZ2ntIuM9VY6Io+K40RbN2UFHwgC8v3PyMPTCiQuriFT9whtAEOY4biqiN6X38G80g6Y3qXXlD/IkZXrOao+0m9aMNrxWhWP1Q5whZoxeeOY0DBGiLgAfIqtV9gAttehWWND41kv8QMi5p1rDjuowM7cG1YbbuwEXDV1tOb99Pz/LFebWE6arPYkM3C2P/kDuQX1EmT6GnN2uIu0FgoNkj7zykqr5YbDKnjwDKk9GpsfWCx8buIu+bYJh9D",
			"distinct_group_list": []string{
				group0Name,
				group1Name,
			},
			"node_list": []interface{}{
				0: map[string]interface{}{
					"instance_name":       node0,
					"group_name":          group0Name,
					"ami":                 ami,
					"key_name":            key_name,
					"subnet_id":           subnet_id,
					"instance_type":       instance_type,
					"instance_monitoring": "true",
					"root_block_device": map[string]interface{}{
						"delete_on_termination": true,
						"encrypted":             true,
						"iops":                  1000,
						"kms_key_id":            nil,
						"volume_size":           11,
						"volume_type":           "gp2",
					},
					"ebs_block_device": []interface{}{
						0: map[string]interface{}{
							"device_name":           "/dev/sdh",
							"delete_on_termination": true,
							"encrypted":             true,
							"iops":                  1001,
							"kms_key_id":            nil,
							"volume_size":           4,
							"volume_type":           "io2",
						},
					},
					"user_data": userData,
					"tags": map[string]interface{}{
						"purpose":   "terratest",
						"repo":      "managedkube-infra",
						"repo-path": "terraform-modules/aws/node_list/test",
						"node":      node0,
					},
				},
				1: map[string]interface{}{
					"instance_name":       node1,
					"group_name":          group1Name,
					"ami":                 ami,
					"key_name":            key_name,
					"subnet_id":           subnet_id,
					"instance_type":       instance_type,
					"instance_monitoring": "true",
					"root_block_device": map[string]interface{}{
						"delete_on_termination": true,
						"encrypted":             true,
						"iops":                  1000,
						"kms_key_id":            nil,
						"volume_size":           12,
						"volume_type":           "gp2",
					},
					"ebs_block_device": []interface{}{
						0: map[string]interface{}{
							"device_name":           "/dev/sdh",
							"delete_on_termination": true,
							"encrypted":             true,
							"iops":                  1002,
							"kms_key_id":            nil,
							"volume_size":           5,
							"volume_type":           "io2",
						},
						1: map[string]interface{}{
							"device_name":           "/dev/sdi",
							"delete_on_termination": true,
							"encrypted":             true,
							// "iops":                  1,
							"kms_key_id":  nil,
							"volume_size": 6,
							"volume_type": "gp2",
						},
					},
					//"upload_files": map[string]interface{}{},
					"user_data": "",
					"tags": map[string]interface{}{
						"purpose":   "terratest",
						"repo":      "managedkube-infra",
						"repo-path": "terraform-modules/aws/node_list/test",
						"node":      node1,
					},
				},
				2: map[string]interface{}{
					"instance_name":       node0 + "-1",
					"group_name":          group0Name,
					"ami":                 ami,
					"key_name":            key_name,
					"subnet_id":           subnet_id,
					"instance_type":       instance_type,
					"instance_monitoring": "true",
					"root_block_device": map[string]interface{}{
						"delete_on_termination": true,
						"encrypted":             true,
						"iops":                  1000,
						"kms_key_id":            nil,
						"volume_size":           13,
						"volume_type":           "gp2",
					},
					"ebs_block_device": []interface{}{
						// testing to make sure no additional disks is working
						// Still need this key here though
					},
					// "upload_files": map[string]interface{}{},
					"user_data": "",
					"tags": map[string]interface{}{
						"purpose":   "terratest",
						"repo":      "managedkube-infra",
						"repo-path": "terraform-modules/aws/node_list/test",
						"node":      node0 + "-1",
					},
				},
			},
			"security_group_id_list": []interface{}{
				0: security_group,
				1: security_group,
			},
			"security_group_name_list": []interface{}{
				0: group0Name,
				1: group1Name,
			},
		},

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	outputEc2IdList := terraform.OutputList(t, terraformOptions, "ec2_id_list")
	// outputSecurityGroupRuleModuleSGList := terraform.OutputList(t, terraformOptions, "security_group_id_list")
	// outputDatadogPolicyName := terraform.Output(t, terraformOptions, "datadog_policy")

	// awsAccountID := aws.GetAccountId(t)

	// check if node0's name is accurate
	// assert.Equal(t, outputSecurityGroupModuleNameList[0], group0Name)
	// check if node1's name is accurate
	// assert.Equal(t, outputSecurityGroupModuleNameList[1], group1Name)

	numberOfExpected := 1
	assert.Equal(t, numberOfExpected, len(outputEc2IdList))
	// assert.Equal(t, "datadog-ec2", outputDatadogPolicyName)

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
