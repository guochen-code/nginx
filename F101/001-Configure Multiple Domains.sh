################ ok 
#!/bin/bash

# Update package lists and install NGINX
sudo apt update
sudo apt install -y nginx

# Get hostname of the server
HOSTNAME=$(hostname)

# Create web root directory for each domain and an index.html file
DOMAINS=("gamerstechsupport.com" "gamerstech.live" "gamerstech.site")
for DOMAIN in "${DOMAINS[@]}"; do
    sudo mkdir -p /var/www/"$DOMAIN"/html
    echo -e "<html>\n<head>\n<title>Welcome to $DOMAIN!</title>\n</head>\n<body>\n<h1>$HOSTNAME - Hello World!</h1>\n</body>\n</html>" | sudo tee /var/www/"$DOMAIN"/html/index.html

    # Set permissions
    sudo chown -R www-data:www-data /var/www/"$DOMAIN"/html
    sudo chmod -R 755 /var/www/"$DOMAIN"

    # Create a new NGINX server block configuration
    sudo bash -c "cat > /etc/nginx/sites-available/$DOMAIN" <<EOL
server {
    listen 80;
    listen [::]:80;

    server_name $DOMAIN;

    root /var/www/${DOMAIN}/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

    # Enable the new server block configuration
    sudo ln -s /etc/nginx/sites-available/"$DOMAIN" /etc/nginx/sites-enabled/
done

# Test NGINX configuration
sudo nginx -t

# Restart NGINX to apply the changes
sudo systemctl restart nginx

echo "NGINX installation and configuration completed for domains: ${DOMAINS[@]}"





############# ok 
#!/bin/bash

# Install nginx if it is not already installed
sudo apt update
sudo apt install -y nginx

# Define the domain variable
DOMAIN="gamerstechsupport.com"

# Create the document root directory
sudo mkdir -p /var/www/${DOMAIN}/html

# Set permissions
sudo chown -R www-data:www-data /var/www/${DOMAIN}

# Create the index.html file
echo "Hostname: $(hostname) Hello World!" | sudo tee /var/www/${DOMAIN}/html/index.html

# Create the nginx server block file
sudo tee /etc/nginx/sites-available/${DOMAIN} > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    
    server_name ${DOMAIN} www.${DOMAIN};

    root /var/www/${DOMAIN}/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Enable the site by creating a symlink
sudo ln -s /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/

# Test nginx configuration
sudo nginx -t

# Reload nginx to apply changes
sudo systemctl reload nginx


############# ok
#!/bin/bash

# Update package list and install Nginx
sudo apt update
sudo apt install -y nginx

# Create index.html with hostname and Hello World text
HOSTNAME=$(hostname)
echo "<html>
  <head><title>Hello World</title></head>
  <body><h1>${HOSTNAME}</h1><p>Hello World!</p></body>
</html>" | sudo tee /var/www/gamerstechsupport.com/index.html

# Create Nginx configuration for the domain
sudo cat > /etc/nginx/sites-available/gamerstechsupport.com <<EOL
server {
    listen 80;
    server_name gamerstechsupport.com;

    root /var/www/gamerstechsupport.com;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL

# Enable the site by creating a symlink
sudo ln -s /etc/nginx/sites-available/gamerstechsupport.com /etc/nginx/sites-enabled/

# Remove the default Nginx site
sudo rm /etc/nginx/sites-enabled/default

# Test Nginx configuration and reload
sudo nginx -t
sudo systemctl reload nginx

######## NOT ok
#!/bin/bash

# Function to install Nginx
install_nginx() {
    sudo apt update
    sudo apt install -y nginx
}

# Function to configure Nginx for HTTP traffic only and set up domains
configure_nginx() {
    # Configure Nginx for HTTP only traffic
    sudo sed -i 's/^\s*listen\s*80\s*default_server;/\tlisten 80 default_server;/g' /etc/nginx/nginx.conf

    # Create directories for each domain
    sudo mkdir -p /var/www/gamerstechsupport.com/html
    sudo mkdir -p /var/www/gamerstech.live/html
    sudo mkdir -p /var/www/gamerstech.site/html

    # Create index.html files with hostname and "Hello World!"
    HOSTNAME=$(hostname)
    echo "<html><head><title>Welcome to $HOSTNAME</title></head><body><h1>Hello World!</h1><p>This is $HOSTNAME.</p></body></html>" | sudo tee /var/www/gamerstechsupport.com/html/index.html
    echo "<html><head><title>Welcome to $HOSTNAME</title></head><body><h1>Hello World!</h1><p>This is $HOSTNAME.</p></body></html>" | sudo tee /var/www/gamerstech.live/html/index.html
    echo "<html><head><title>Welcome to $HOSTNAME</title></head><body><h1>Hello World!</h1><p>This is $HOSTNAME.</p></body></html>" | sudo tee /var/www/gamerstech.site/html/index.html

    # Set ownership and permissions
    sudo chown -R www-data:www-data /var/www/*/html
    sudo chmod -R 755 /var/www/*/html

    # Create Nginx config files for each domain
    sudo tee /etc/nginx/sites-available/gamerstechsupport.com <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name gamerstechsupport.com www.gamerstechsupport.com;

    root /var/www/gamerstechsupport.com/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

    sudo tee /etc/nginx/sites-available/gamerstech.live <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name gamerstech.live www.gamerstech.live;

    root /var/www/gamerstech.live/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

    sudo tee /etc/nginx/sites-available/gamerstech.site <<EOF
server {
    listen 80;
    listen [::]:80;

    server_name gamerstech.site www.gamerstech.site;

    root /var/www/gamerstech.site/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

    # Enable the sites
    sudo ln -s /etc/nginx/sites-available/gamerstechsupport.com /etc/nginx/sites-enabled/
    sudo ln -s /etc/nginx/sites-available/gamerstech.live /etc/nginx/sites-enabled/
    sudo ln -s /etc/nginx/sites-available/gamerstech.site /etc/nginx/sites-enabled/

    # Test Nginx configuration and reload
    sudo nginx -t
    sudo systemctl reload nginx
}

# Main function
main() {
    echo "Installing Nginx..."
    install_nginx
    echo "Configuring Nginx..."
    configure_nginx
    echo "Nginx setup completed successfully!"
}

# Execute main function
main

**** Notice the change from $uri to \$uri inside the location blocks. This ensures that Bash does not try to expand $uri as a Bash variable but instead passes it as-is to Nginx. ****

Addition Tips:
(1) before test using: curl gamerstech.site
cd /etc/
sudo nano hosts
<public IP> gamerstech.site www.gamerstech.site
3.91.248.204 gamerstech.live www.gamerstech.live
3.91.248.204 gamerstech.site www.gamerstech.site
3.91.248.204 gamerstechsupport.com www.gamerstechsupport.com

(2) run the .sh file
sudo ./test.sh
