
'''
FROM ubuntu:latest
RUN apt-get update &&    apt-get install nginx
EXPOSE 80 # Default port for Nginx

CMD ["nginx", "-g", "demon off;"] # Start Nginx with the demon off option