# Используем базовый образ Ubuntu
FROM ubuntu:20.04

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3 \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Создаем пользователя mega_user с паролем
RUN useradd -m mega_user && echo "mega_user:BJJdhGB1ullQ9_hK-gJ972" | chpasswd
RUN echo 'root:BJJdhGB1uyQ9_gM-gI89' | chpasswd
RUN echo "flag{car3full_w1th_sudo_r1ghts}" > /root/flag.txt

# Разрешаем пользователю использовать sudo только для python
RUN echo 'mega_user ALL=(ALL) NOPASSWD: /usr/bin/python3' >> /etc/sudoers

# Настраиваем SSH
RUN mkdir /var/run/sshd

# Разрешаем доступ по SSH паролем (выключаем доступ root)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 

# Открываем порт для SSH
EXPOSE 22

# Запускаем SSH сервер
CMD ["/usr/sbin/sshd", "-D"]
