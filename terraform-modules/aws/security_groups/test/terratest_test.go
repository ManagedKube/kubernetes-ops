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
	vpc := "vpc-0b8751c278512e5c3"
	securityGroupForExternalSGTest := "sg-0522d4b134c4a719b" // Default security group for the VPC
	group0Name := "group0-" + stringRand
	group1Name := "group1-" + stringRand

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Dynamic Variables that we should pass in addition to varfile.tfvars
		// VarFiles: []string{
		// 	"./test/var1.tfvars",
		// },

		Vars: map[string]interface{}{
			"vpc_id": vpc,
			"security_groups": []interface{}{
				0: map[string]interface{}{
					"name": group0Name,
					"config": []interface{}{
						0: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "ingress",
							"allow_group_name": group1Name,
							"group_type":       "internal_mapping",
							"from_port":        "10111",
							"to_port":          "10111",
							"protocol":         "tcp",
							"cidr_blocks":      []interface{}{},
							"description":      "Allowing group " + group1Name + " on port 10111",
						},
						1: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "ingress",
							"allow_group_name": group1Name,
							"group_type":       "internal_mapping",
							"from_port":        "10112",
							"to_port":          "10112",
							"protocol":         "tcp",
							"cidr_blocks":      []interface{}{},
							"description":      "Allowing group " + group1Name + " on port 10112",
						},
						2: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "egress",
							"allow_group_name": "",
							"group_type":       "cidr_blocks",
							"from_port":        "-1",
							"to_port":          "-1",
							"protocol":         "-1",
							// "cidr_blocks":      []interface{}{},
							"cidr_blocks": []interface{}{
								"0.0.0.0/0",
							},
							"description": "Allowing egress",
						},
						3: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "egress",
							"allow_group_name": "",
							"group_type":       "cidr_blocks",
							"from_port":        "-1",
							"to_port":          "-1",
							"protocol":         "-1",
							"cidr_blocks":      []interface{}{},
							"description":      "Allowing egress",
						},
						4: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "egress",
							"allow_group_name": securityGroupForExternalSGTest,
							"group_type":       "external_sg",
							"from_port":        "-1",
							"to_port":          "-1",
							"protocol":         "-1",
							"cidr_blocks":      []interface{}{},
							"description":      "Allowing egress from externally created SG",
						},
					},
					"tags": map[string]interface{}{
						"purpose":    "terratest",
						"repo":       "managedkube",
						"repo-path":  "terraform-modules/aws/node_list/test",
						"node_group": group0Name,
					},
				},
				1: map[string]interface{}{
					"name": group1Name,
					"config": []interface{}{
						0: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "ingress",
							"allow_group_name": group0Name,
							"group_type":       "internal_mapping",
							"from_port":        "10011",
							"to_port":          "10011",
							"protocol":         "tcp",
							"cidr_blocks":      []interface{}{},
							"description":      "Allowing group " + group0Name + " on port 10011",
						},
						1: map[string]interface{}{
							"enabled":          "true",
							"sg_type":          "ingress",
							"allow_group_name": group0Name,
							"group_type":       "internal_mapping",
							"from_port":        "10022",
							"to_port":          "10022",
							"protocol":         "tcp",
							"cidr_blocks":      []interface{}{},
							"description":      "Allowing group " + group0Name + " on port 10022",
						},
					},
					"tags": map[string]interface{}{
						"purpose":    "terratest",
						"repo":       "managedkube",
						"repo-path":  "terraform-modules/aws/node_list/test",
						"node_group": group1Name,
					},
				},
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
	outputSecurityGroupModuleNameList := terraform.OutputList(t, terraformOptions, "security_group_name_list")
	outputSecurityGroupRuleModuleSGList := terraform.OutputList(t, terraformOptions, "security_group_id_list")

	// awsAccountID := aws.GetAccountId(t)

	// check if node0's name is accurate
	assert.Equal(t, outputSecurityGroupModuleNameList[0], group0Name)
	// check if node1's name is accurate
	assert.Equal(t, outputSecurityGroupModuleNameList[1], group1Name)

	// Check that there are 3 SG rules total for the items above
	// This is checking how many SG rule set groups are being created.  There should be one for each
	// security group.
	numberOfSGRulesExpected := 2
	assert.Equal(t, len(outputSecurityGroupRuleModuleSGList), numberOfSGRulesExpected)

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
