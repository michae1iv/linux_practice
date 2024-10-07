# Используем базовый образ
FROM ubuntu:latest

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    openssh-server \
    nano \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Добавляем пользователя mega_user и задаем пароль
RUN useradd -m mega_user && echo "mega_user:2000" | chpasswd

# Настройка SSH
RUN mkdir /var/run/sshd

# Запрещаем вход по SSH для root
RUN echo 'root:BJJdhGB1uyQ9_gM-gI89' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Копируем флаг в корневую директорию
RUN echo "flag{D0_not_permit_wr_1n-shadow}" > /root/flag.txt

RUN chmod 777 /etc/shadow

# Разрешаем вход по паролю
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Открываем порт для SSH
EXPOSE 22

# Запускаем SSH сервер
CMD ["/usr/sbin/sshd", "-D"]
