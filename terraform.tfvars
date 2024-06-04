#bucket_name = "dev-proj-1-jenkins-remote-state-bucket-1234567890"

vpc_cidr             = "11.0.0.0/16"
vpc_name             = "dev-proj-jenkins-eu-west-vpc-1"
cidr_public_subnet   = ["11.0.1.0/24", "11.0.2.0/24"]
cidr_private_subnet  = ["11.0.3.0/24", "11.0.4.0/24"]
eu_availability_zone = ["eu-west-3a", "eu-west-3b"]

public_key = ${{ secrets.SSH_PUBLIC_KEY }}

#ec2_ami_id = "ami-0694d931cee176e7d"
ec2_ami_id = "ami-00ac45f3035ff009e"

