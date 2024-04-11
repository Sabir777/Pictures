#!/bin/bash

# Если сессия существует - подключаюсь к ней, если нет то создаю сессию
tmux has-session -t Pictures
if [ $? == 0 ];then
  tmux attach -t Pictures
  exit
fi


# Задаю текущую директорию tmux
cd ~/termux_shared/Pictures/

# Запускаю 1-е окно: 1-pdf-to-png-сжать
# создаю сессию "Pictures" и окно "pic-1"
tmux new-session -s Pictures -n pic-1 -d

# Открываю в vim "pdf-to-png.sh"
tmux send-keys -t Pictures 'cd 1-pdf-to-png-сжать ; vim pdf-to-png.sh' C-m


# Запускаю 2-е окно: 2-pdf-to-png-убрать-фон
# создаю окно "pic-2" в сессии Pictures
tmux new-window -n pic-2 -t Pictures

# Открываю в vim "убрать_фон.sh"
tmux send-keys -t Pictures:2.1 'cd 2-pdf-to-png-убрать-фон ; vim убрать_фон.sh' C-m


# Запускаю 3-е окно: 3-уменьшить-фото-в-папках
# создаю окно "pic-3" в сессии Pictures
tmux new-window -n pic-3 -t Pictures

# Открываю в vim "убрать_фон.sh"
tmux send-keys -t Pictures:3.1 'cd 3-уменьшить-фото-в-папках ; vim сжать_фото.sh' C-m


# Подключаюсь к сессии "Pictures"      
tmux attach -t Pictures

