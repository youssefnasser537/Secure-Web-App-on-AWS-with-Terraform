# 🛡️ Secure Web App Infrastructure on AWS using Terraform

This project builds a secure and highly available 2-tier web application architecture on AWS using Terraform, with modular design, automation scripts, and remote backend for state management.

---

## 🗺️ Architecture Diagram

![Architecture](images/Architecture%20Diagram.png)

---

## 📁 Project Structure

```
terraform-secure-web-app/
├── main.tf
├── backend.tf
├── variables.tf
├── outputs.tf
├── install_proxy.sh
├── install_backend.sh
├── all-ips.txt
├── modules/
│   ├── network/
│   ├── security/
│   ├── ec2_proxy/
│   ├── ec2_backend/
│   └── load_balancer/
└── images/
    ├── Architecture Diagram.png
    ├── all ec2 ips.png
    ├── access the private ec2s.png
    ├── access the private ec2s_2.png
    └── s3 that contain the state file.png
```

---

## 🚀 Deployment Steps

1. **Configure AWS credentials:**

```bash
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
```

2. **Initialize Terraform:**

```bash
terraform init
```

3. **Apply the infrastructure:**

```bash
terraform apply
```

4. **Get EC2 IPs for access:**

```bash
cat all-ips.txt
```

---

## ⚙️ Provisioning with `remote-exec`, `local-exec`, and `file`

- `file` provisioner is used to upload shell scripts (`install_proxy.sh`, `install_backend.sh`) to EC2 instances.
- `remote-exec` executes the uploaded shell scripts on remote EC2s.
- `local-exec` is used to generate `all-ips.txt` after creation.

**Provisioning Example:**

```hcl
provisioner "file" {
  source      = "install_proxy.sh"
  destination = "/tmp/proxy.sh"
}

provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/proxy.sh",
    "bash /tmp/proxy.sh"
  ]
}
```

---

## 🔐 Security Design

✅ VPC with Public and Private Subnets  
✅ NGINX in Public Subnet (Reverse Proxy)  
✅ Apache in Private Subnet (Backend)  
✅ Internal ALB for backend routing  
✅ NAT Gateway for private outbound internet  
✅ Bastion Host (Jumpbox) for SSH into private EC2s only  
✅ Security Groups locked down (Only required ports open)  

---

## 🖼️ Backend App Preview

### 🔹 All EC2 IPs  
This image shows all EC2 instances created (public and private).  
![All EC2 IPs](images/all%20ec2%20ips.png)

---

### 🔹 SSH Access to Private EC2 via Bastion  
Shows successful SSH access to a private EC2 instance via the Bastion host.  
![SSH via Bastion 1](images/access%20the%20private%20ec2s.png)  
![SSH via Bastion 2](images/access%20the%20private%20ec2s_2.png)

---

### 🔹 Terraform State File in S3  
Visual confirmation that the state file is stored in the S3 bucket.  
![S3 State File](images/s3%20that%20contain%20the%20state%20file.png)
