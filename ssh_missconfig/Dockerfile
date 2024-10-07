# Using Ubuntu
FROM ubuntu:latest

# Installing OpenSSH Server and utilities
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo 'PermitEmptyPasswords no' >> /etc/ssh/sshd_config

# Setting password for root
RUN echo 'root:teacher2001' | chpasswd
RUN echo "flag{Hydra_1s_cool}" > /root/flag.txt
# Open port 22 for SSH
EXPOSE 22

# Start SSH
CMD ["/usr/sbin/sshd", "-D"]
