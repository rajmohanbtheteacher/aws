# Give the below command to add GITHUB Token in AWS SSM paramter store
aws ssm put-parameter --name "/github/token" \
    --value "ghp_*********************" \
    --type "SecureString"
# This way GIT_HUB token is secured, and github is been authenticated
# - BY RajMohan