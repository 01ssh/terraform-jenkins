#!/bin/bash

# Delete all instances
for id in $(aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text)
do
  aws ec2 terminate-instances --instance-ids $id
done

# Wait for all instances to be terminated
aws ec2 wait instance-terminated

# Delete all load balancers
for arn in $(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
do
  aws elbv2 delete-load-balancer --load-balancer-arn $arn
done

# Delete all network interfaces
for id in $(aws ec2 describe-network-interfaces --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text)
do
  aws ec2 delete-network-interface --network-interface-id $id
done

# Detach and delete all internet gateways
for id in $(aws ec2 describe-internet-gateways --query 'InternetGateways[*].InternetGatewayId' --output text)
do
  for vpc in $(aws ec2 describe-internet-gateways --internet-gateway-ids $id --query 'InternetGateways[*].Attachments[*].VpcId' --output text)
  do
    aws ec2 detach-internet-gateway --internet-gateway-id $id --vpc-id $vpc
  done
  aws ec2 delete-internet-gateway --internet-gateway-id $id
done

# Delete all subnets
for id in $(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
do
  aws ec2 delete-subnet --subnet-id $id
done

# Delete all VPCs
for id in $(aws ec2 describe-vpcs --query 'Vpcs[*].VpcId' --output text)
do
  aws ec2 delete-vpc --vpc-id $id
done

echo "All specified resources have been deleted."

#!/bin/bash

# Variables
SUBNET_ID="subnet-0eb75c9fc1d11bc5f"

# Fonction pour supprimer les interfaces réseau
delete_network_interfaces() {
  echo "Deleting network interfaces in subnet $SUBNET_ID..."
  INTERFACE_IDS=$(aws ec2 describe-network-interfaces --filters "Name=subnet-id,Values=$SUBNET_ID" --query "NetworkInterfaces[*].NetworkInterfaceId" --output text)
  for INTERFACE_ID in $INTERFACE_IDS; do
    ATTACHMENT_ID=$(aws ec2 describe-network-interfaces --network-interface-ids $INTERFACE_ID --query "NetworkInterfaces[0].Attachment.AttachmentId" --output text)
    if [ "$ATTACHMENT_ID" != "None" ]; then
      echo "Detaching network interface $INTERFACE_ID..."
      aws ec2 detach-network-interface --attachment-id $ATTACHMENT_ID
      aws ec2 wait network-interface-available --network-interface-ids $INTERFACE_ID
    fi
    echo "Deleting network interface $INTERFACE_ID..."
    aws ec2 delete-network-interface --network-interface-id $INTERFACE_ID
  done
}

# Fonction pour arrêter et supprimer les instances EC2
terminate_instances() {
  echo "Terminating instances in subnet $SUBNET_ID..."
  INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=subnet-id,Values=$SUBNET_ID" --query "Reservations[*].Instances[*].InstanceId" --output text)
  for INSTANCE_ID in $INSTANCE_IDS; do
    echo "Terminating instance $INSTANCE_ID..."
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID
  done
}

# Fonction pour supprimer les points de terminaison des services
delete_vpc_endpoints() {
  echo "Deleting VPC endpoints in subnet $SUBNET_ID..."
  ENDPOINT_IDS=$(aws ec2 describe-vpc-endpoints --filters "Name=subnet-id,Values=$SUBNET_ID" --query "VpcEndpoints[*].VpcEndpointId" --output text)
  for ENDPOINT_ID in $ENDPOINT_IDS; do
    echo "Deleting VPC endpoint $ENDPOINT_ID..."
    aws ec2 delete-vpc-endpoints --vpc-endpoint-ids $ENDPOINT_ID
  done
}

# Fonction pour dissocier et supprimer les tables de routage
delete_route_tables() {
  echo "Deleting route tables associated with subnet $SUBNET_ID..."
  ROUTE_TABLE_IDS=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$SUBNET_ID" --query "RouteTables[*].RouteTableId" --output text)
  for ROUTE_TABLE_ID in $ROUTE_TABLE_IDS; do
    echo "Disassociating and deleting route table $ROUTE_TABLE_ID..."
    ASSOCIATION_IDS=$(aws ec2 describe-route-tables --route-table-ids $ROUTE_TABLE_ID --query "RouteTables[*].Associations[*].RouteTableAssociationId" --output text)
    for ASSOCIATION_ID in $ASSOCIATION_IDS; do
      aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID
    done
    aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID
  done
}

# Fonction pour supprimer le sous-réseau
delete_subnet() {
  echo "Deleting subnet $SUBNET_ID..."
  aws ec2 delete-subnet --subnet-id $SUBNET_ID
  echo "Subnet $SUBNET_ID has been deleted."
}

# Exécution des fonctions
terminate_instances
delete_network_interfaces
delete_vpc_endpoints
delete_route_tables
delete_subnet

echo "All dependencies have been removed and the subnet has been deleted."
