
'''

FROM ubuntu:latest
RUN apt-get update && apt-get install -y nginx
EXPOSE 80, 443

CMD ["nginx", "-g", "demon off;"]