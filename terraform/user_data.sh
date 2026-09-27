#!/bin/bash

set -e

# ---------------------------------------------------------
# Update Ubuntu
# ---------------------------------------------------------

apt-get update -y

# ---------------------------------------------------------
# Install Docker
# ---------------------------------------------------------

apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Allow Ubuntu user to use Docker
usermod -aG docker ubuntu

# ---------------------------------------------------------
# Docker network
# ---------------------------------------------------------

docker network create ecommerce-network || true

# ---------------------------------------------------------
# Pull application images
# ---------------------------------------------------------

docker pull rajkumaramithnagaraj/ecommerce-user-service:1.0
docker pull rajkumaramithnagaraj/ecommerce-product-service:1.0
docker pull rajkumaramithnagaraj/ecommerce-cart-service:1.0
docker pull rajkumaramithnagaraj/ecommerce-order-service:1.0

# ---------------------------------------------------------
# User Service
# ---------------------------------------------------------

docker run -d \
  --name user-service \
  --restart unless-stopped \
  --network ecommerce-network \
  -p 3001:3001 \
  -e PORT=3001 \
  -e MONGODB_URI="mongodb+srv://${mongodb_username}:${mongodb_password}@${mongodb_host}/ecommerce_users" \
  -e JWT_SECRET="${jwt_secret}" \
  rajkumaramithnagaraj/ecommerce-user-service:1.0

# ---------------------------------------------------------
# Product Service
# ---------------------------------------------------------

docker run -d \
  --name product-service \
  --restart unless-stopped \
  --network ecommerce-network \
  -p 3002:3002 \
  -e PORT=3002 \
  -e MONGODB_URI="mongodb+srv://${mongodb_username}:${mongodb_password}@${mongodb_host}/ecommerce_products" \
  rajkumaramithnagaraj/ecommerce-product-service:1.0

# ---------------------------------------------------------
# Cart Service
# ---------------------------------------------------------

docker run -d \
  --name cart-service \
  --restart unless-stopped \
  --network ecommerce-network \
  -p 3003:3003 \
  -e PORT=3003 \
  -e MONGODB_URI="mongodb+srv://${mongodb_username}:${mongodb_password}@${mongodb_host}/ecommerce_carts" \
  -e PRODUCT_SERVICE_URL="http://product-service:3002" \
  rajkumaramithnagaraj/ecommerce-cart-service:1.0

# ---------------------------------------------------------
# Order Service
# ---------------------------------------------------------

docker run -d \
  --name order-service \
  --restart unless-stopped \
  --network ecommerce-network \
  -p 3004:3004 \
  -e PORT=3004 \
  -e MONGODB_URI="mongodb+srv://${mongodb_username}:${mongodb_password}@${mongodb_host}/ecommerce_orders" \
  -e CART_SERVICE_URL="http://cart-service:3003" \
  -e PRODUCT_SERVICE_URL="http://product-service:3002" \
  -e USER_SERVICE_URL="http://user-service:3001" \
  rajkumaramithnagaraj/ecommerce-order-service:1.0

echo "Backend services deployed successfully"