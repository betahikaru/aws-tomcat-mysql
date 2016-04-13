
## Apache-Tomcat-MySQL
- EC2 Instances
  - Winows Server 2012 R2
- IAM Resources
  - Role for EC2
    - win-app-server-role
      - Managed Policies
        - AmazonEC2ReadOnlyAccess
      - Inline Policies
         - policygen-win-app-server-role-201604130032
- S3 Buckets
  - Installer
    - s3://share-repo-ec2

## How to Setup
- Create EC2 Instance (t2.micro)
- Install
  - AWS CLI
    - [Install the AWS CLI Using the MSI Installer (Windows)](http://docs.aws.amazon.com/ja_jp/cli/latest/userguide/installing.html#install-msi-on-windows)
    - Download installer from [s3://share-repo-ec2/windowsx64/AWSCLI64.msi](https://s3-ap-northeast-1.amazonaws.com/share-repo-ec2/windowsx64/AWSCLI64.msi). This file has permission that allows everyone to download.
- Run Command for download installsers
```cmd
mkdir c:/s3local
aws s3 cp s3://share-repo-ec2/windowsx64/ c:/s3local --recursive
```
- Install and Setup
  - Apache 2.4
  - JDK 8.0
  - Apache Tomcat 8.0
  - MySQL 5.7

## AWS Settings
###IAM
  - Inline Policies
    - policygen-win-app-server-role-201604130032
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1460474872000",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::share-repo-ec2/*"
            ]
        },
        {
            "Sid": "Stmt1460475118000",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::share-repo-ec2"
            ]
        }
    ]
}
```

## Installer

```bash
$ aws s3 ls s3://share-repo-ec2 --recursive
2016-04-13 00:03:00          0 windowsx64/
2016-04-13 23:14:03    8028160 windowsx64/AWSCLI64.msi
2016-04-13 00:23:06    9596162 windowsx64/apache-tomcat-8.0.33.exe
2016-04-13 00:03:20    9912816 windowsx64/httpd-2.4.20-x64-vc14.zip
2016-04-13 00:15:35  360966750 windowsx64/mysql-5.7.12-winx64.zip
2016-04-13 00:21:00   28426240 windowsx64/mysql-workbench-community-6.3.6-winx64.msi
```

### AWSCLI x64
- [Install the AWS CLI Using the MSI Installer (Windows)](http://docs.aws.amazon.com/ja_jp/cli/latest/userguide/installing.html#install-msi-on-windows)
  - [Download the AWS CLI MSI installer for Windows (64-bit)](https://s3.amazonaws.com/aws-cli/AWSCLI64.msi)

### Apache HTTP Server
- [Apache 2.4 Server Binaries](http://www.apachehaus.com/cgi-bin/download.plx)
  - [Apache 2.4.20 x64](http://www.apachehaus.com/cgi-bin/download.plx?dli=NZ0Y5R1QNJjT6Z1KZRFb0AlVOpkVFVFdTdEaCV2Z)
- [Windows に Apache HTTP Server 2.2 をインストールする手順](http://weblabo.oscasierra.net/installing-apache22-windows-1/)

### JDK 8
- [Java SE Development Kit 8 Downloads](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
  - [Windows x64 jdk-8u77-windows-x64.exe](http://download.oracle.com/otn-pub/java/jdk/8u77-b03/jdk-8u77-windows-x64.exe)

### Tomcat
- [Tomcat 8 Downloads](http://tomcat.apache.org/download-80.cgi)
  - [32-bit/64-bit Windows Service Installer 8.0.33](http://ftp.riken.jp/net/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.exe)

### MySQL
- [MySQL on Windows (Installer & Tools) ](http://dev.mysql.com/downloads/windows/)
  - [Windows (x86, 64-bit), ZIP Archive(mysql-5.7.12-winx64.zip)](http://dev.mysql.com/downloads/file/?id=462039)
  - [Windows (x86, 64-bit), MSI Installer(mysql-workbench-community-6.3.6-winx64.msi)](http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-winx64.msi)
