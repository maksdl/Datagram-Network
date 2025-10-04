#!/bin/bash
set -e

# Название бинаря и сессии
BIN_NAME="datagram-cli-x86_64-linux"
SESSION_NAME="data"
BIN_URL="https://github.com/Datagram-Group/datagram-cli-release/releases/latest/download/$BIN_NAME"
ENV_FILE="data.env"

echo "======================================"
echo "   🚀 Datagram Node Manager 🚀"
echo "======================================"
echo "Выберите действие:"
echo "1) Установка ноды"
echo "2) Обновление ноды"
read -p "Ваш выбор (1/2): " ACTION

if [ "$ACTION" == "1" ]; then
    echo ">>> Устанавливаем ноду Datagram..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y wget screen

    # Запрашиваем ключ
    read -p "Введите ваш приватный ключ: " KEY
    echo "KEY=$KEY" > $ENV_FILE
    echo ">>> Ключ сохранен в $ENV_FILE"

    # Скачиваем бинарь
    wget -O $BIN_NAME $BIN_URL
    chmod +x ./$BIN_NAME

    # Запуск в screen
    screen -S $SESSION_NAME -dm bash -c "./$BIN_NAME run -- -key $KEY"
    echo ">>> Нода запущена в screen-сессии: $SESSION_NAME"
    echo "Чтобы войти: screen -r $SESSION_NAME"

elif [ "$ACTION" == "2" ]; then
    echo ">>> Обновляем ноду Datagram..."

    # Убиваем старую сессию
    screen -S $SESSION_NAME -X quit || true

    # Читаем ключ из файла
    if [ -f "$ENV_FILE" ]; then
        source $ENV_FILE
        echo ">>> Ключ найден в $ENV_FILE"
    else
        read -p "Файл $ENV_FILE не найден. Введите ключ: " KEY
        echo "KEY=$KEY" > $ENV_FILE
    fi

    # Удаляем старый бинарь
    rm -f $BIN_NAME

    # Скачиваем новый
    wget -O $BIN_NAME $BIN_URL
    chmod +x ./$BIN_NAME

    # Запуск в screen
    screen -S $SESSION_NAME -dm bash -c "./$BIN_NAME run -- -key $KEY"
    echo ">>> Нода обновлена и запущена в screen-сессии: $SESSION_NAME"
    echo "Чтобы войти: screen -r $SESSION_NAME"

else
    echo "❌ Неверный выбор!"
    exit 1
fi

echo "======================================"
echo "   🎉 Datagram node installed 🎉"
echo "======================================"

