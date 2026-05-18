#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGODB_HOST=mongodb.sudhaaru676.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "Script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATION(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R FAILED $N"
        exit 1
    else

        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N" 
    exit 1
else
    echo " you are root user"
fi

dnf install python36 gcc python3-devel -y &>> $LOGFILE

VALIDATE $? " Installing Python"

id roboshop

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user Creation"
else
    echo -e " roboshop user already exist $Y Skipping $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app Directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

VALIDATE $? " Downloading Dependencies"

cd /app

unzip /tmp/payment.zip &>> $LOGFILE

VALIDATE $? "Unzipping payment"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? " Installing dependencies"

cp /home/centos/robo-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE

VALIDATE $? "Copied payment service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable payment &>> $LOGFILE

VALIDATE $? "Enabling payment"

systemctl start payment &>> $LOGFILE

VALIDATE $? "Starting payment"