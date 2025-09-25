#!/bin/bash

# Get Terraform outputs
CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION="us-west-2"
ROLE_ARN=$(terraform output -raw developer_role_arn)

# Create kubeconfig for developer
cat > developer-kubeconfig << EOF
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $(terraform output -raw cluster_certificate_authority_data)
    server: $(terraform output -raw cluster_endpoint)
  name: ${CLUSTER_NAME}
contexts:
- context:
    cluster: ${CLUSTER_NAME}
    user: developer-readonly
  name: ${CLUSTER_NAME}-developer
current-context: ${CLUSTER_NAME}-developer
kind: Config
preferences: {}
users:
- name: developer-readonly
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --cluster-name
        - ${CLUSTER_NAME}
        - --region
        - ${REGION}
        - --role-arn
        - ${ROLE_ARN}
EOF

echo "Developer kubeconfig created: developer-kubeconfig"
echo "Developer IAM credentials:"
echo "Access Key ID: $(terraform output -raw developer_access_key_id)"
echo "Secret Access Key: $(terraform output -raw developer_secret_access_key)"
