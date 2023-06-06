#!/bin/bash
PATH=$PATH:/opt/puppetlabs/puppet/bin
PKCS7_KEY="/etc/puppetlabs/puppet/eyaml/boot_public_key.pkcs7.pem"
ENC_CMD="eyaml encrypt -o block --pkcs7-public-key=${PKCS7_KEY}"


echo "Enter your s3 bucket access_key_id: "
read access_key_id

echo "Enter s3 bucket secret access key: "
read secret_access_key

echo "Hello, $name! You are $age years old."

$ENC_CMD -l 'profile::s3fs::access_key_id' -s $access_key_id >>/etc/puppetlabs/code/environments/production/data/bootstrap.yaml
$ENC_CMD -l 'profile::s3fs::secret_access_key' -s $secret_access_key >>/etc/puppetlabs/code/environments/production/data/bootstrap.yaml