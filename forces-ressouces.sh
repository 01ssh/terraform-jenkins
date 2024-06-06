#!/bin/bash

# Définir la région par défaut pour toutes les commandes AWS CLI
export AWS_DEFAULT_REGION=eu-west-3

# Ajoutez une variable d'environnement pour contrôler si les groupes de sécurité doivent être supprimés
DELETE_SECURITY_GROUPS=${DELETE_SECURITY_GROUPS:-"true"}

# Supprimer toutes les instances EC2
for id in $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text)
do
  aws ec2 terminate-instances --instance-ids $id
done

# Supprimer tous les Load Balancers
for name in $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerName' --output text)
do
  aws elbv2 delete-load-balancer --name $name
done

# Supprimer tous les Security Groups si DELETE_SECURITY_GROUPS est true
if [ "$DELETE_SECURITY_GROUPS" = "true" ]; then
  for id in $(aws ec2 describe-security-groups --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text)
  do
    aws ec2 delete-security-group --group-id $id
  done
fi

# Supprimer tous les Subnets
for id in $(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
do
  aws ec2 delete-subnet --subnet-id $id
done

# Supprimer tous les VPCs
for id in $(aws ec2 describe-vpcs --query 'Vpcs[*].VpcId' --output text)
do
  aws ec2 delete-vpc --vpc-id $id
done

# Supprimer tous les records dans le hosted zone
#for id in $(aws route53 list-resource-record-sets --hosted-zone-id Z051438214CR37XFUO7YR --query 'ResourceRecordSets[*].Name' --output text)
##do
 # aws route53 change-resource-record-sets --hosted-zone-id Z051438214CR37XFUO7YR --change-batch file://delete-record.json
#done

# Supprimer toutes les Key Pairs
for name in $(aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName' --output text)
do
  aws ec2 delete-key-pair --key-name $name
done