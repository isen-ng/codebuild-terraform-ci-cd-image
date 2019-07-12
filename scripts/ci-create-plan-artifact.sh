#!/bin/bash

set -e

# Create Plan Artifact

# Copy Terraform working directory
mkdir -p artifact/${TF_WORKING_DIR}
if [ "$TF_WORKING_DIR" != "" ]; then
	# do not include * wildcard to also copy hidden files and directories
	# According to https://learn.hashicorp.com/terraform/development/running-terraform-in-automation#plan-and-apply-on-different-machines
	# > After plan completes, archive the entire working directory, including the .terraform 
	# > subdirectory created during init, and save it somewhere where it will be available 
	# > to the apply step
    cp -r ${TF_WORKING_DIR}/ artifact/${TF_WORKING_DIR}
fi
# Create metadata.json file
jq -n "{
    PR_ID: \"$PR_ID\",
    GIT_MASTER_COMMIT_ID: \"$GIT_MASTER_COMMIT_ID\",
    TF_WORKING_DIR: \"$TF_WORKING_DIR\",
    CI_PWD: \"$PWD\"
}" > artifact/metadata.json

# Zip artifact folder
cd artifact
zip -r ../${GIT_MASTER_COMMIT_ID}-${PR_ID}.zip .
cd ..
