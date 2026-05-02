#!/bin/bash

ID=$(id -ne 0)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$0-$TIMESTAMP.log

echo "script starts executing with $TIMESTAMP" &>> $LOGFILE

VALIDATE() {
    if[ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILED $N"
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $? -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
else
    echo "you are root user"
fi

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs:18"

id roboshop

if[ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? " roboshop user creation"
else
    echo -e "roboshop user already exist $Y skipping $N"
fi

mkdir -p /app &>> $LOGFILE

VALIDATE $? " creating app directory"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip

VALIDATE $? " Downloading you application"

cd /app

unzip /tmp/user.zip &>> $ LOGFILE

VALIDATE $? " Unzipping user"

npm install &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/robo-shell/mongo.repo /etc/yum.repos.d/mongo.repo

VALIDATE $? "copying mp