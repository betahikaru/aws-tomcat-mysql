
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

## How to Setup Local Machine
- Install Eclipse for J2EE
- Install Tomcat Plugin for Eclipse
  - [Sysdeo Eclipse Tomcat Launcher plugin](http://www.eclipsetotale.com/tomcatPlugin.html)
- Install and Setup Tomcat 8.0
  - Download installer from [apache-tomcat-8.0.33.tar.gz](http://ftp.kddilabs.jp/infosystems/apache/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz)
- Eclipse Setting
  - Create Project "Dynamic Web Project"
    - See [MacでEclipseを使ったJava EE開発環境の構築](http://www.torachi.com/2015/01/how-to-set-up-Eclipse-for-Java-EE-on-Mac-OS-X.html)
- Install Mysql
  - brew install mysql
  - Start / Stop MySQL Server, ```mysql.server start``` / ```mysql.server stop```
  - Configure security
    - ```mysql_secure_installation```

## How to Setup Server
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
- Install and Setup: Apache 2.4
  - Install VC0215Runtime
    - Execute "C:\s3local\vc2015_redistributable\vc_redist.x64.exe"
  - Unzip and move directory to C:\Apache24
  - Configure SRCROOT to "C:\Apache24"
  - Open Powershell console with Administrator
    - Run Command ```cd C:\Apache24\bin && .\httpd.exe```
    - Access http://localhost/
    - Stop httpd.exe to press Ctrl-C
  - Install Apache2.4 as a Windows Service
    - Open Powershell console with Administrator
      - Run Command ```cd C:\Apache24\bin && .\httpd.exe -k install```
- Install JDK 8.0
  - Run GUI Installer and click next and next ...
- Install Apache Tomcat 8.0
  - Run GUI Installer
  - Configuration
    - Server Shutdown Port : 8005
    - HTTP/1.1 Connector Port : 8008
    - AJP/1.3 Connector Port : 8009
    - Window Service Name : Tomcat8
    - Tomcat Administrator Login
      - User Name / Password : betahikaru / 
      - Rols : manager-gui
  - Click next and next ....
  - If Tomcat stared, Open http://localhost:8080/
- Install MySQL 5.7
  - Run GUI Installer
    - Refer [MySQL Server 5.6 を Windows にインストールする手順](http://weblabo.oscasierra.net/installing-mysql56-windows-1/)
  - Agree License
  - Select Edition : Server Only
  - Type And Networking
    - Config Type : Server Machine
    - Port Number : 3306
  - Accounts and Roles
    - Root Password : 
    - User : betahikaru (Host : All Host, Role : DB Admin)
  - Run Command
```
cd 'C:\Program Files\MySQL\MySQL Server 5.7\bin'
.\mysql.exe --version
.\mysql.exe -u root -p
```
  - And Run
```
mysql> show variables like "chara%";
+--------------------------+---------------------------------------------------------+
| Variable_name            | Value                                                   |
+--------------------------+---------------------------------------------------------+
| character_set_client     | cp850                                                   |
| character_set_connection | cp850                                                   |
| character_set_database   | utf8                                                    |
| character_set_filesystem | binary                                                  |
| character_set_results    | cp850                                                   |
| character_set_server     | utf8                                                    |
| character_set_system     | utf8                                                    |
| character_sets_dir       | C:\Program Files\MySQL\MySQL Server 5.7\share\charsets\ |
+--------------------------+---------------------------------------------------------+
8 rows in set (0.00 sec)

mysql> quit
Bye
```
  - Copy ```my-default.ini``` to ```my.ini```, on Administrator Console
```
cd "C:\Program Files\MySQL\MySQL Server 5.7"
copy .\my-default.ini .\my.ini
```
  - Edit ```my.ini```
    - Refer [mysqlで文字コードをutf8にセットする](http://qiita.com/YusukeHigaki/items/2cab311d2a559a543e3a)
```
[mysqld]
...
character-set-server=utf8 #mysqldセクションの末尾に追加
default_password_lifetime=0 #パスワードの期限を無効化

[client]
default-character-set=utf8 #clientセクションを追加
```
  - Restart MySQL to apply configuration
```
net stop MySQL57
net start MySQL57
```

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
$ aws s3 ls s3://share-repo-ec2/windowsx64/ --recursive
2016-04-13 00:03:00          0 windowsx64/
2016-04-13 23:14:03    8028160 windowsx64/AWSCLI64.msi
2016-04-13 00:23:06    9596162 windowsx64/apache-tomcat-8.0.33.exe
2016-04-13 00:03:20    9912816 windowsx64/httpd-2.4.20-x64-vc14.zip
2016-04-13 00:15:35  360966750 windowsx64/mysql-5.7.12-winx64.zip
2016-04-13 00:21:00   28426240 windowsx64/mysql-workbench-community-6.3.6-winx64.msi
2016-04-14 00:32:01   14572000 windowsx64/vc2015_redistributable/vc_redist.x64.exe
```

### AWSCLI x64
- [Install the AWS CLI Using the MSI Installer (Windows)](http://docs.aws.amazon.com/ja_jp/cli/latest/userguide/installing.html#install-msi-on-windows)
  - [Download the AWS CLI MSI installer for Windows (64-bit)](https://s3.amazonaws.com/aws-cli/AWSCLI64.msi)

### Apache HTTP Server
- Require VC++2015Runtime
  - [Visual C++ Redistributable for Visual Studio 2015](https://www.microsoft.com/en-US/download/details.aspx?id=48145)
  - If not install this, show following error message
```
---------------------------
httpd.exe - System Error
---------------------------
The program can't start because VCRUNTIME140.dll is missing from your computer.
Try reinstalling the program to fix this problem.
---------------------------
OK
---------------------------
```

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
  - [Windows (x86, 32-bit), MSI Installer](https://dev.mysql.com/get/Downloads/MySQLInstaller/mysql-installer-community-5.7.12.0.msi)
    - * Note: MySQL Installer is 32 bit, but will install both 32 bit and 64 bit binaries.
- MySQL Workbencg
  - [Windows (x86, 64-bit), MSI Installer(mysql-workbench-community-6.3.6-winx64.msi)](http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-winx64.msi)
