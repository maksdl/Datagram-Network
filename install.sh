#!/bin/bash

# Запрашиваем ключ у пользователя
read -p "Введите ваш ключ: " user_key

# Проверяем, что ключ не пустой
if [ -z "$user_key" ]; then
    echo "Ошибка: ключ не может быть пустым!"
    exit 1
fi

# Выполняем команды
echo "Обновляем пакеты..."
apt update && apt upgrade -y

echo "Скачиваем Datagram CLI..."
wget https://github.com/Datagram-Group/datagram-cli-release/releases/latest/download/datagram-cli-x86_64-linux

echo "Создаем screen сессию с именем 'data'..."
screen -S data -dm bash -c "
    echo 'Даем права на выполнение...';
    chmod +x ./datagram-cli-x86_64-linux;
    echo 'Запускаем Datagram CLI с вашим ключом...';
    ./datagram-cli-x86_64-linux run -- -key $user_key;
    exec bash
"

echo "Установка завершена! Datagram CLI запущен в screen сессии с именем 'data'."
echo "Для подключения к сессии используйте команду: screen -r data"
