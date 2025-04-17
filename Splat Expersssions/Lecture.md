# Terraform AWS Infra with Modules, Dynamic Blocks, and Splat Expressions 🤖🚀

## Learnings Demonstrated

1. **Modules**: Code reuse for VPC, EC2, and Security Groups
2. **Dynamic Blocks**: Subnets generated dynamically using `count`
3. **Variables**: Everything is parameterized for flexibility
4. **Splat Expressions**: Powerful way to collect properties from multiple resources
5. **Outputs**: Smart use of both `splat` and `indexing`

## Real-Life Analogy:
🛠 Imagine you're building a housing colony:
- VPC = Main Land
- Subnets = Plots
- Route Table = Roads & gates
- EC2 Instances = Houses on plots
- Splat = “Get me all house numbers at once!”

With `aws_instance.web[*].public_ip` you can say “Give me all IPs of the houses.”

---

> 🧠 **TIP**: Use `[*]` when you want **all elements**, use `[index]` for specific one.