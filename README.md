# Weasyprint Lambda Layer for Docker
This repository contains a Dockerfile which will build a AWS Lambda layer containing the native libraries for the WeasyPrint HTML to PDF 

The procedure is based upon the [instructions here](https://aws.amazon.com/premiumsupport/knowledge-center/lambda-linux-binary-package/).

# Setting up the EC2 instance

- Open [Lambda Execution Environment and Available Libraries](https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html)
and find the AMI name that starts with "amzn-ami-hvm."
- Click the link to open up the AMI in the EC2 console
- Launch a new instance using the AMI
- SSH into the new instance

```
ssh -i ~/path/to/keypair.pem ec2-user@public.dns.for.instance
```

- Install necessary libs:

```
sudo yum install -y yum-utils rpmdevtools docker git
```

- Copy down this repo and open the directory

```
git clone https://github.com/MasonryHQ/weasyprint_lambda.git
cd weasyprint_lambda
```

# Building the zip file

- Build the Docker image, which creates the zip file

```
sudo docker build -t weasyprint .
```

- Create an instance of the image (without actually running it) just so we can copy the zip file out

```
docker create --name weasyprint weasyprint /bin/bash
docker cp weasyprint:/opt/weasyprint_lambda_layer.zip .
docker rm weasyprint
```

# Getting the zip file off the server

- Exit the ssh session and restart with sftp, then download the file

```
exit
sftp -i ~/path/to/keypair.pem ec2-user@public.dns.for.instance
cd weasyprint_lambda
get weasyprint_lambda_layer.zip
exit
```

The `weasyprint_lambda_layer.zip` file can now be uploaded as an AWS Lambda layer