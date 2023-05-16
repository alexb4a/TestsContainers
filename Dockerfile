FROM ubuntu:latest

# Install Java Development Kit (JDK) 11, cURL so we can download Jenkins and Git so we can pull code
RUN apt-get update && apt-get install -y curl openjdk-11-jdk git && java -version

# Download Jenkins WAR file
RUN mkdir -p /usr/share/jenkins
ADD http://mirrors.jenkins.io/war/latest/jenkins.war /usr/share/jenkins/jenkins.war

# Install necessary packages
RUN apt-get update && apt-get install -y \
    automake \
    autotools-dev \
    fuse \
    g++ \
    libcurl4-openssl-dev \
    libfuse-dev \
    libssl-dev \
    libxml2-dev \
    make \
    pkg-config

# Download and install S3FS
RUN cd /tmp && \
    git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
    cd s3fs-fuse && \
    ./autogen.sh && \
    ./configure --prefix=/usr && \
    make && \
    make install

# Create a mount point for S3 bucket
RUN mkdir /mnt/s3

# Set AWS credentials (replace with your own access key and secret key)
ARG AWS_ACCESSKEY
ARG AWS_SECRETKEY
ENV MY_KEY=${AWS_ACCESSKEY}
ENV MY_SECRET=${AWS_SECRETKEY}
RUN echo "$MY_KEY:$MY_SECRET" > /etc/passwd-s3fs && \
    chmod 600 /etc/passwd-s3fs

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN modprobe fuse

EXPOSE 8080
# Start the entrypoint script
CMD ["/entrypoint.sh"]
