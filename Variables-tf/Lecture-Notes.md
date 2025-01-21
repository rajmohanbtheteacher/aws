# Terraform always pic value from tfvar file by default, eventhough if we have mentioned default vailes in variables.tf file. But if there's no entry in tfvars file then, whatever the value mentioned in the variable file will be taken into consideration.

# Also filname of tfvars should be terraform.tfvars, then only terraform would take the default value from the tfvars file, else it will pick the value from vaiables file. 

# Incase of multiple tfvars file or renamed tfvars file, while planning and apply we should add switch "-var-file" and mention the specific tfvars file.

# terraform plan -var-file="prod.tfvars"

# terraform apply -var-file="prod.tfvars"

# Variables are declared in configuration, they can be ser in a number of ways:
1. Variable Defaults
2. Variable Definition File (*.tfvars)
3. Environment Variables 
4. Setting Variables in the Command line

# We have discussed 1st and 2nd option, 3rd Option is Envoironmental Variable
# Terraform searches the environment of its own process for environment varables named TF_VAR_followed by the name of a declared variable.
1.  Set the environmental variable using export command
    a. Exaple: $ export TF_VAR_instance_type=m5.large
2. Now execute both plan and apply, it will take the variable from set enviornment value.
 

