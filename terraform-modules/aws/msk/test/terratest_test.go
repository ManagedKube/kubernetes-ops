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

	stringRand := randomString(8)

	aws_region := "us-east-1"
	zone_id := "Z00728331PNYVN1WW537D"
	vpc_id := "vpc-07f9e885659e500a3"
	private_subnet_zone_a1 := "subnet-00ef641516b153b07"
	private_subnet_zone_b1 := "subnet-05d35441add280470"
	private_subnet_zone_c1 := "subnet-0195ee284970febc7"
	security_group_1 := "sg-04cf9aad443ba81d8"
	security_group_2 := "sg-05ba88c62deee78f0"
	name := "test-broker-name-" + stringRand
	client_broker := "TLS"
	namespace := "test-broker-namespace"
	number_of_broker_nodes := 3
	broker_volume_size := 10
	broker_instance_type := "kafka.t3.small"
	encryption_in_cluster := true
	encryption_at_rest_kms_key_arn := ""
	cloudwatch_logs_enabled := false
	cloudwatch_logs_log_group := "managedkube/qa/us-east-1/msk-test-" + stringRand
	kafka_version := "2.3.1"
	node_exporter_enabled := false
	enhanced_monitoring := "DEFAULT"
	s3_logs_bucket := ""
	s3_logs_enabled := false
	s3_logs_prefix := ""
	client_tls_auth_enabled := false
	certificate_authority_arns := ""

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Dynamic Variables that we should pass in addition to varfile.tfvars
		// VarFiles: []string{
		// 	"./test/var1.tfvars",
		// },

		Vars: map[string]interface{}{
			"aws_region":                     aws_region,
			"zone_id":                        zone_id,
			"vpc_id":                         vpc_id,
			"subnet_ids":                     []string{private_subnet_zone_a1, private_subnet_zone_b1, private_subnet_zone_c1},
			"security_groups":                []string{security_group_1, security_group_2},
			"name":                           name,
			"client_broker":                  client_broker,
			"namespace":                      namespace,
			"number_of_broker_nodes":         number_of_broker_nodes,
			"broker_volume_size":             broker_volume_size,
			"broker_instance_type":           broker_instance_type,
			"encryption_in_cluster":          encryption_in_cluster,
			"encryption_at_rest_kms_key_arn": encryption_at_rest_kms_key_arn,
			"cloudwatch_logs_enabled":        cloudwatch_logs_enabled,
			"cloudwatch_logs_log_group":      cloudwatch_logs_log_group,
			"kafka_version":                  kafka_version,
			"node_exporter_enabled":          node_exporter_enabled,
			"enhanced_monitoring":            enhanced_monitoring,
			"s3_logs_bucket":                 s3_logs_bucket,
			"s3_logs_enabled":                s3_logs_enabled,
			"s3_logs_prefix":                 s3_logs_prefix,
			"client_tls_auth_enabled":        client_tls_auth_enabled,
			"certificate_authority_arns":     []string{certificate_authority_arns},
			"tags": map[string]interface{}{
				"purpose":   "terratest",
				"repo":      "managedkube",
				"repo-path": "terraform-modules/aws/msk/test",
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
	mskName := terraform.Output(t, terraformOptions, "cluster_name")
	assert.Equal(t, namespace+"-"+name, mskName)

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
