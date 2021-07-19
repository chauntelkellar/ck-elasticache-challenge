#installations
sudo yum update -y
sudo amazon-linux-extras install -y epel
sudo yum install -y gcc
sudo yum install -y git

sudo amazon-linux-extras install -y nginx1
sudo amazon-linux-extras install -y postgresql11
sudo amazon-linux-extras install -y python3.8
sudo amazon-linux-extras install -y redis6

sudo yum install -y python3-devel
sudo yum install -y python3-pip
sudo yum install -y python3-setuptools
sudo pip3 install psycopg2 configparser redis flask 

sudo yum install -y postgresql-devel
# clone app
mkdir /home/app
git clone https://github.com/ACloudGuru/elastic-cache-challenge.git /home/app
sudo chmod -R 755 /home/app
sudo chown -R ec2-user:nginx /home/app 
# postgres conf
PGPASSWORD="${DBPASS}" psql -h "${DBHOST}" -U "${DBUSER}" -f /home/app/install.sql "${DBNAME}"

# database ini conf

echo "[postgresql]" > /home/app/config/database.ini
echo "database=${DBNAME}" >> /home/app/config/database.ini
echo "host=${DBHOST}" >> /home/app/config/database.ini
echo "password=${DBPASS}" >> /home/app/config/database.ini
echo "user=${DBUSER}" >> /home/app/config/database.ini

echo "" >> /home/app/config/database.ini
echo "[redis]" >> /home/app/config/database.ini
echo "url=redis://${REDISHOST}" >> /home/app/config/database.ini

# nginx conf
sudo echo "server {" > /etc/nginx/conf.d/nginx-app.conf
sudo echo " listen     80;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo " location /app {" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   proxy_pass         http://127.0.0.1:5000/;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   proxy_redirect     off;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   proxy_set_header   Host                 \$host;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   proxy_set_header   X-Real-IP            \$remote_addr;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   proxy_set_header   X-Forwarded-For      \$proxy_add_x_forwarded_for;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   proxy_set_header   X-Forwarded-Proto    \$scheme;" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "   }" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "}" >> /etc/nginx/conf.d/nginx-app.conf
sudo echo "" >> /etc/nginx/conf.d/nginx-app.conf

sudo systemctl start nginx
sudo systemctl status nginx

# run app
cd /home/app
sudo python3 -m venv /home/app
source /home/app/bin/activate