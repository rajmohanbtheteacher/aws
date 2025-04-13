📜 Notes.md – Preachings of Terraform Semantics 🙏

# 📜 Notes.md: The Holy Preachings of Terraform Semantics

## 🧠 What are Semantics in Terraform?

Semantics means giving MEANING and CONTEXT to what you're defining in Terraform. It’s not just about getting the code to work, but making it meaningful, understandable, reusable, and sustainable.

---

## 🙏 Preaching #1: Variables are the Word of the DevOps Gods

- Declare all reusable values in `variables.tf`.
- Give them proper `description` fields.
- Assign defaults if appropriate – it keeps the modules flexible.

```hcl
variable "instance_type" {
  description = "Choose your size wisely"
  default     = "t2.micro"
}

🙏 Preaching #2: Naming Conventions are Sacred
	•	Use logical names for your resources.
	•	Semantic tags like Name, Environment, Owner make your infra talk back.
tags = {
  Name        = "WebServer"
  Environment = var.environment
}

🙏 Preaching #3: Outputs are the Final Blessing
	•	Always provide outputs for resources you may need to reference.
	•	Think of outputs as breadcrumbs for future you or other modules.
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
✨ “He who provides outputs shall never be lost.”

🙏 Preaching #4: Separation is Sacred
	•	Split code into main.tf, variables.tf, outputs.tf.
	•	Keep secrets out – use *.tfvars files or secret managers.

✨ “Let there be order in your files, and clarity in your mind.”

## 🙏 Preaching #5: Thou Shalt Enable Internet Access

> “An instance without an IGW is like a monk in a monastery — peaceful but disconnected.”

Steps to Enlightenment:
1. Attach an Internet Gateway to the VPC
2. Create a Route Table with route to 0.0.0.0/0 via IGW
3. Associate that route table with your public subnet
4. Enable `map_public_ip_on_launch` in the subnet

Thus, your EC2 shall see the light... of the Internet ☀️


🧘 Final Wisdom:

“Terraform isn’t just code—it’s infrastructure poetry.
Write it with meaning, deploy it with intention, manage it with grace.”

Now go forth, terraform disciple 🧙‍♂️✨

