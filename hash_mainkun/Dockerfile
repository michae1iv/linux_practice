# Используем базовый образ Ubuntu
FROM ubuntu:20.04

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m petya121 && echo "petya121:qwertyuiop" | chpasswd

# Настраиваем SSH
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

RUN echo 'flag{th1s_is_y0ur_lasst_flag}' > /root/flag.txt
RUN echo 'root:BJJdhGB1uyQ9_gM-gI89' | chpasswd

RUN echo '#password for root is: BJJdhGB1uyQ9_gM-gI89' >> /etc/ssh/sshd_config

# Открываем порты
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
