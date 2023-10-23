#!/bin/bash

# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Check all instances for the tags Name=Red, Name=White, and Name=Blue
RED_EXISTS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Red" --region us-east-1)
WHITE_EXISTS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=White" --region us-east-1)
BLUE_EXISTS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Blue" --region us-east-1)

# If the tag Name=Red doesn't exist, set COLOR to Red
if [[ -z "\$RED_EXISTS" ]]; then
    COLOR="Red"
# If the tag Name=Red exists, don't set COLOR to Red
else
    COLOR=""
fi

# If the tag Name=White doesn't exist and COLOR is not set yet, set COLOR to White
if [[ -z "\$WHITE_EXISTS" && -z "\$COLOR" ]]; then
    COLOR="White"
# If the tag Name=White exists, don't set COLOR to White
elif [[ ! -z "\$WHITE_EXISTS" ]]; then
    COLOR=""
fi

# If the tag Name=Blue doesn't exist and COLOR is not set yet, set COLOR to Blue
if [[ -z "\$BLUE_EXISTS" && -z "\$COLOR" ]]; then
    COLOR="Blue"
# If the tag Name=Blue exists, don't set COLOR to Blue
elif [[ ! -z "\$BLUE_EXISTS" ]]; then
    COLOR=""
fi

# If none of the tags are set, choose a random color
if [[ -z "\$COLOR" ]]; then
    COLORS=("Red" "White" "Blue")
    COLOR=\$${COLORS[\$RANDOM % \$${#COLORS[@]}]}
fi

# Set the instance name to the value of the COLOR variable
INSTANCE_ID=\$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

aws ec2 create-tags --resources \$INSTANCE_ID --tags "Key=Name,Value=\$${COLOR}" --region us-east-1