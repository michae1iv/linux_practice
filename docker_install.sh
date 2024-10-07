#!/bin/sh

# Обновление пакетов и установка необходимых утилит
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление официального GPG-ключа Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Добавление Docker в список репозиториев APT
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновление пакетов и установка Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Добавление пользователя в группу docker для управления Docker без sudo (опционально)
sudo usermod -aG docker $USER

# Запуск и включение Docker-сервиса
sudo systemctl start docker
sudo systemctl enable docker

# Проверка корректности установки Docker
docker --version

echo "Docker успешно установлен!"
