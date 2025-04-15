🛠️ Dyanmic block allows us to dynamically construct repeatable nested blocks which is supported inside 🕊️ RESOURCES, PROVIDER, & PROVISIONER blocks 🕊️

🎭 Analogy: “Terraform Dynamic Block is like a Stage Play with Different Actors”

Imagine a stage play 🎭 where:
	•	The play script is your Terraform resource block.
	•	Actors (like ingress rules, EBS volumes, or policy attachments) are repetitive roles.
	•	Instead of writing the script for each actor separately, you give them a template and a casting list.

With a dynamic block, Terraform says:
“Here’s the role once, and I’ll repeat it for each actor in your list.”

💡 Just like:
for_each = var.ingress_ports
is your casting list.

Terraform handles the rest, looping over your data list like a pro stage manager.

---

## 🔥 Preachings of the Dynamic Block

### 📖 1. Thou shalt not repeat thyself

> DRY = Don’t Repeat Yourself.

Instead of writing:
```hcl
ingress {
  from_port = 22
  ...
}
ingress {
  from_port = 80
  ...
}

🔄 2. Let Data Drive Design

Use for_each to loop over:
	•	A list of ports
	•	A map of policy-to-role
	•	A list of block devices

This makes infrastructure parameterized, testable, and reusable.

🧠 3. Apply Logic, Not Hardcoding

Write Terraform like you’d write logic in code:
	•	count, for_each, dynamic – these are your control structures.
	•	Infra should behave based on data, not manual declarations.

🧼 4. Semantic Infra is Holy Infra

Always:
	•	Name things with purpose: web_sg, public_rt, not my_sg123.
	•	Document purpose with variables and outputs.
	•	Modularize as your infra grows.

🧪 Use Cases Worth Preaching
---------------------------------------------------------------------
Use Case             | Dynamic Block      |  Benefit                 |
*********************************************************************
SG Rules             | ingress/egress     | Avoid hardcoded ports    |
**********************************************************************
IAM Role-Policy      | policy_attachment  | Clean RBAC mapping       |
**********************************************************************
Block Devices        | ebs_block_device   | Dynamic storage scaling  |
***********************************************************************
Route Table Entries  | route              | Scalable route management |
-----------------------------------------------------------------------

✨ Closing Thought

“Dynamic blocks are not just loops. They are the soul of scalable IaC.”
– The Terraform Monk 🙏