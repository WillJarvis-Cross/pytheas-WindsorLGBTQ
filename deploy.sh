#!/bin/bash

# Make sure you are on the correct aws profile
# export AWS_PROFILE=your_aws_profile

# Define the directories
BUILD_DIR="dist"
TERRAFORM_DIR="terraform"
ANSIBLE_DIR="ansible"

cd "$ANSIBLE_DIR"

# Step 1: Run the Ansible build process
echo "Running Ansible build process..."
ansible-playbook build.yml

# Check if Ansible build was successful
if [ $? -ne 0 ]; then
  echo "Ansible build failed. Exiting."
  exit 1
fi

cd "../$TERRAFORM_DIR"
# Step 2: Ensure Terraform is initialized (only needed once or if dependencies change)
if [ ! -d ".terraform" ]; then
  terraform init
fi

# Step 3: Run Terraform to apply changes
echo "Applying Terraform changes..."
terraform apply -auto-approve
# If you get an error saying the bucket already exists, you likely have to 
# import the bucket: terraform import aws_s3_bucket.my_bucket <bucket-name>

# Check if Terraform apply was successful
if [ $? -ne 0 ]; then
  echo "Terraform apply failed. Exiting."
  exit 1
fi

echo "Deployment completed successfully."
