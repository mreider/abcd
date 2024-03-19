#!/bin/bash

# Update and install common dependencies
sudo apt-get update
sudo apt-get install -y wget curl unzip

# Install Java 17
sudo apt install -y openjdk-17-jdk

# Set JAVA_HOME (you may want to add this to your .bashrc or .profile as well)
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Install .NET 6.0 SDK
wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update; \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y dotnet-sdk-6.0

# Install Node.js 14
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PHP 7.4 and Composer
sudo apt-get install -y php7.4 php7.4-cli php7.4-common
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Navigate to the Java application directory and build/run the application
cd A
./mvnw package
java -javaagent:opentelemetry-javaagent.jar -Dotel.resource.attributes=service.name=serviceA -jar target/servicea-0.0.1-SNAPSHOT.jar &

# Navigate to the .NET application directory and build/run the application
cd B
dotnet build -c Release -o build
dotnet publish -c Release -o publish
dotnet publish/ServiceB.dll &

# Navigate to the Node.js application directory and run the application
cd C
npm install
node src/server.js &

# Navigate to the PHP application directory and run the application
cd D
composer install
php -S 0.0.0.0:8083 -t public &

# Wait indefinitely to allow services to keep running
wait
