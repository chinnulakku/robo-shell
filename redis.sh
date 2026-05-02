#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILED $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $? -ne 0 ]
then
    echo -e "ERROR:: Please run this script with root access"
    exit 1
else
    echo " you are the root user"
fi

dnf module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? " Enabling Redis remi-6.2"

dnf install redis -y &>> $LOGFILE

VALIDATE $? "Installing redis"

cp /home/centos/robo-shell/etc/redis.conf&/etc/redis/redis.conf

VALIDATE $? "Coping the redis-config file"

sed -i 's/127.0.0.1 to 0.0.0.0'

systemctl enable redis &>> $LOGFILE

VALIDATE $? " Enabling redis"

systemctl start  redis &>> $LOGFILE

VALIDATE $? "Starting redis"
