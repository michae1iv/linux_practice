# Используем базовый образ Ubuntu
FROM ubuntu:20.04

# Установим необходимые пакеты
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Создаем пользователей mega_user и master
RUN useradd -m mega_user && \
    useradd -m master && \
    echo 'root:BJJdhGB1uyQ9_gM-gI89' | chpasswd && \
    echo 'master:BJJdhGB1FGSSFDsyQ9_dM-dI79' | chpasswd && \
    echo "mega_user:BJJdhGB1ullQ9_hK-gJ972" | chpasswd

# Создаем директорию .ssh для mega_user
RUN mkdir -p /home/mega_user/.ssh && \
    chmod 700 /home/mega_user/.ssh && \
    chown mega_user:mega_user /home/mega_user/.ssh
    
# Устанавливаем права на .ssh для пользователя master
RUN mkdir -p /home/master/.ssh && \
    chmod 700 /home/master/.ssh && \
    chown master:master /home/master/.ssh

COPY id_rsa.pub /home/mega_user/.ssh/authorized_keys
COPY master.pub /home/master/.ssh/authorized_keys
COPY master /home/master/master
COPY master.pub /home/master/master.pub
RUN chmod -R o+r /home/master/

# Устанавливаем права доступа для authorized_keys
RUN chmod 600 /home/mega_user/.ssh/authorized_keys && \
    chown mega_user:mega_user /home/mega_user/.ssh/authorized_keys
RUN chmod 600 /home/master/.ssh/authorized_keys && \
    chown master:master /home/master/.ssh/authorized_keys

RUN echo 'flag{this_is_the_first_step}' > /home/master/flag.txt && chmod 700 /home/master/flag.txt
RUN chown master:master /home/master/flag.txt
RUN echo 'flag{Y0ur_task_is_completed}' > /root/flag.txt
RUN chmod u+s /usr/bin/find

# Настраиваем SSH
RUN mkdir /var/run/sshd

# Разрешаем доступ по SSH по ключам
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Открываем порт для SSH
EXPOSE 22

# Запускаем SSH сервер
CMD ["/usr/sbin/sshd", "-D"]
