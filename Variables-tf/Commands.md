# Terraform always pic value from tfvar file by default, eventhough if we have mentioned default vailes in variables.tf file. But if there's no entry in tfvars file then, whatever the value mentioned in the variable file will be taken into consideration.

# Also filname of tfvars should be terraform.tfvars, then only terraform would take the default value from the tfvars file, else it will pick the value from vaiables file. 

# Incase of multiple tfvars file or renamed tfvars file, while planning and apply we should add switch "-var-file" and mention the specific tfvars file.

# terraform plan -var-file="prod.tfvars"

# terraform apply -var-file="prod.tfvars"