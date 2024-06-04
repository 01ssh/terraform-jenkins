#bucket_name = "dev-proj-1-jenkins-remote-state-bucket-1234567890"

vpc_cidr             = "11.0.0.0/16"
vpc_name             = "dev-proj-jenkins-eu-west-vpc-1"
cidr_public_subnet   = ["11.0.1.0/24", "11.0.2.0/24"]
cidr_private_subnet  = ["11.0.3.0/24", "11.0.4.0/24"]
eu_availability_zone = ["eu-west-3a", "eu-west-3b"]

public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDglBrBR0YNzgylSMHD96jDfhIxfRrKZN1vGE08C0et5ehk64u49fZFqtN76nYlmDYsM6GO4BUu1J5sKLE2aQ3qFoUqaJ6qrDH2latJ0xxJM6u/po4syqFUK8E55nb5bSUZIxXQy02THBb+vHckyseN2ALrkzeMa56G2aFzrAOVob7mtt2P2j/FZaCIBmbI2iMEpmPhnBr4WGWMffNoc8sN2CKIlDtmBChRqeTU3Snevy6XHGansj7F1yVqa3ft1WXGHJUdgupRCToOMSDPAr7JTm6rgjK4p9pcAkbcOIASEHBwG51W6FSgMug/EL0yw4nm3Tv8YzTd5zaLEQ9H21x6nb1uSaYYZL4UtdUv0mQ6xgliXnTq73Bt1oG3RtGsNt6gKPQl00efCs+gOHahMET6LqDHUwpRXMEajkISO6IMfErPSolNTOipKV2Ql3F7mKUCMnJLCStn6ltTOMIoG/QMdIvBaJq4r9gCen728ePTuNpN4XR/rNjHmpwX6d9/tN0= ubuntu@ip-172-31-3-246"

#ec2_ami_id = "ami-0694d931cee176e7d"
ec2_ami_id = "ami-00ac45f3035ff009e"

