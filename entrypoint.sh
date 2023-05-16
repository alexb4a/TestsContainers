#!/bin/bash
set -e

# Mount S3 bucket
s3fs com-back4app-jenkinsalex /mnt/s3 -o passwd_file=/etc/passwd-s3fs -o umask=022

# Start Jenkins
java -Djenkins.home=/mnt/s3 -jar /usr/share/jenkins/jenkins.war &

# Keep the container running
tail -f /dev/null
