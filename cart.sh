#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started execting at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R FAILED $N"
        exit 1
    else
        echo -e "$2...$R SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e " $R ERROR:: Please run this script with root access $N"
    exit
else
    echo "you are root user"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? " Disabling current Nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling Nodejs:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing NodeJs"

id roboshop

if [ $? -ne 0 ]
then 
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exit $Y skipping $N"
fi

mkdir -p /app

VALIDATE $? "creating app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip  &>> $LOGFILE

VALIDATE $? " Downloading cart application"

cd /app

unzip -o /tmp/cart.zip  &>> $LOGFILE

VALIDATE $? "unzipping cart"

npm install &>> $LOGFILE

VALIDATE $? "Installing Dependencies"

cp /home/centos/robo-shell/cart.service  /etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? " cart daemon-reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? " Enabling cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? " Starting cart" 