# #!/bin/bash

#installations
sudo su 
yum update -y
amazon-linux-extras install -y epel
yum install -y gcc
yum install -y git

amazon-linux-extras install -y nginx1
amazon-linux-extras install -y postgresql11
amazon-linux-extras install -y python3.8
amazon-linux-extras install -y redis6

yum install -y python3-devel
yum install -y python3-pip
yum install -y python3-setuptools
pip3 install -y psycopg2

yum install -y jq
yum install -y libpq-dev
yum install -y postgresql-devel

# aws configure set aws_access_key_id ${AWS_ACCESS_KEY}
# aws configure set aws_secret_access_key ${AWS_SECRET_KEY}

# CACHE_URL=$(aws elasticache describe-cache-clusters \
# --region us-east-1 \
# --cache-cluster-id "cache" \
# --show-cache-node-info \
# --query "CacheClusters[*].CacheNodes[0].Endpoint.Address" \
# --output json | jq --raw-output .[])

# RDS=$(aws rds describe-db-instances \
# --region us-east-1 \
# --db-instance-identifier "db" \
# --query "DBInstances[*].{host: Endpoint.Address, name: DBName}" \
# --output json | jq .[])

# DB_HOST=$(echo ${RDS} | jq --raw-output .host)
# DB_NAME=$(echo ${RDS} | jq --raw-output .name)


# # clone app
# mkdir /home/ec2-user/app/
# git clone https://github.com/ACloudGuru/elastic-cache-challenge.git 

# # postgres conf
# PGPASSWORD="${db_password}" psql -h "${DB_HOST}" -U "${db_user}" -f ./install.sql "${DB_NAME}"

# # database ini conf

# echo "[postgresql]" > ./config/database.ini
# echo "database=${DB_NAME}" >> ./config/database.ini
# echo "host=${DB_HOST}" >> ./config/database.ini
# echo "password=${db_password}" >> ./config/database.ini
# echo "user=${db_user}" >> ./config/database.ini

# #echo "" >> ./config/database.ini
# #echo "[redis]" >> ./config/database.ini
# #echo "url=redis://${CACHE_URL}" >> ./config/database.ini

# nginx conf
cp ./config/nginx-app.conf" "/etc/nginx/conf.d/"
systemctl start nginx
systemctl enable nginx

#run app
cd ../
python3 app.py