prog=$(basename $0 | sed -e 's/^[SK][0-9][0-9]//')
tmux_name_vim='vim'
tmux_name_server='server'
tmux_name_console='console'
tmux_name_mask1_production12="mask1_production12"
tmux_name_mask1_production34="mask1_production34"
tmux_name_mask1api_production12="mask1api_production12"

session_check() {
  (tmux has-session -t $1)
  echo $?
}

start() {
  result=$(session_check $tmux_name)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name} session already attached"
  else
    echo "${tmux_name} session not attached yet"
    echo "Starting ${tmux_name}"
    init_comm=$(init_command_vim)
    eval ${init_comm}
  fi
}

start_server() {
  result=$(session_check $tmux_name_server)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name} session already attached"
  else
    echo "${tmux_name} session not attached yet"
    echo "Starting ${tmux_name}"
    init_comm=$(init_command_server)
    eval ${init_comm}
  fi
}

stop() {
  result=$(session_check)
  if [[ ${result} == 0 ]]; then
    echo $"Stopping ${tmux_name}"
    (tmux kill-session -t ${tmux_name})
  else
    echo "${tmux_name} not running yet"
  fi
}

restart() {
  stop
  sleep 1
  start
}

override() {
  echo "Starting ${tmux_name}"
  (tmux new -s ${tmux_name})
}

mask1_production12() {
  result=$(session_check $tmux_name_mask1_production12)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_mask1_production12} session already attached"
  else
    echo "${tmux_name_mask1_production12} session not attached yet"
    echo "Starting ${tmux_name_mask1_production12}"
    init_comm=$(init_command_mask1_production12)
    eval ${init_comm}
  fi
}

mask1_production34() {
  result=$(session_check $tmux_name_mask1_production34)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_mask1_production34} session already attached"
  else
    echo "${tmux_name_mask1_production34} session not attached yet"
    echo "Starting ${tmux_name_mask1_production34}"
    init_comm=$(init_command_mask1_production34)
    eval ${init_comm}
  fi
}

mask1api_production12() {
  result=$(session_check $tmux_name_mask1api_production12)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_mask1api_production34} session already attached"
  else
    echo "${tmux_name_mask1api_production34} session not attached yet"
    echo "Starting ${tmux_name_mask1api_production12}"
    init_comm=$(init_command_mask1api_production12)
    eval ${init_comm}
  fi
}

vim() {
  result=$(session_check $tmux_name_vim)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_vim} session already attached"
  else
    echo "${tmux_name_vim} session not attached yet"
    echo "Starting ${tmux_name_vim}"
    init_comm=$(init_command_vim)
    eval ${init_comm}
  fi
}

server() {
  result=$(session_check $tmux_name_server)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_server} session already attached"
  else
    echo "${tmux_name_server} session not attached yet"
    echo "Starting ${tmux_name_server}"
    init_comm=$(init_command_server)
    eval ${init_comm}
  fi
}

console() {
  result=$(session_check $tmux_name_console)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_console} session already attached"
  else
    echo "${tmux_name_console} session not attached yet"
    echo "Starting ${tmux_name_console}"
    init_comm=$(init_command_console)
    eval ${init_comm}
  fi
}

# init_command_kinarino_vim() {
#   new_session="tmux new -d -s ${tmux_name_vim} \;"
#   attach=" attach\;"
#   resize=" resize-pane -t 2 -y 10\;"
#   focus_kinarino_home=" select-pane -t 2\;"
#   add_mall_ssh=" split-window -h 'ssh -t d-knrn-mall101.k-dev.in'\;"
#   open_kinarino_vim=" split-window -vb 'cd /home/song_gyubin/kinarino && vim .' \;"
#   open_mall_vim=" split-window -h 'ssh -t d-knrn-mall101.k-dev.in \"cd mall && vim . && exec bash\" '\;"
#   echo $new_session$open_kinarino_vim$open_mall_vim$attach$resize$focus_kinarino_home$add_mall_ssh
# }
#
# init_command_kinarino_server() {
#   new_session="tmux new -d -s ${tmux_name_server} \;"
#   attach=" attach\;"
#   add_mall_ssh=" split-window -h 'ssh -t d-knrn-mall101.k-dev.in'\;"
#   echo $new_session$attach$add_mall_ssh
# }

init_command_mask1_production12() {
  new_session="tmux new -d -s ${tmux_name_mask1_production12} \;"
  attach=" attach\;"
  ssh_mask11_by_send_keys=" send-keys -t 0 'ssh mask11' Enter\;"
  ssh_mask12_by_split=" split-window -h 'ssh mask12' \;"
  synchronize_pane=" setw synchronize-pane on ;"
  echo $new_session$attach$ssh_mask11_by_send_keys$ssh_mask12_by_split$synchronize_pane
}

init_command_mask1_production34() {
  new_session="tmux new -d -s ${tmux_name_mask1_production34} \;"
  attach=" attach\;"
  ssh_mask11_by_send_keys=" send-keys -t 0 'ssh mask13' Enter\;"
  ssh_mask12_by_split=" split-window -h 'ssh mask14' \;"
  synchronize_pane=" setw synchronize-pane on ;"
  echo $new_session$attach$ssh_mask11_by_send_keys$ssh_mask12_by_split$synchronize_pane
}

init_command_mask1api_production12() {
  new_session="tmux new -d -s ${tmux_name_mask1api_production12} \;"
  attach=" attach\;"
  ssh_mask11_by_send_keys=" send-keys -t 0 'ssh mask1api1' Enter\;"
  ssh_mask12_by_split=" split-window -h 'ssh mask1api2' \;"
  synchronize_pane=" setw synchronize-pane on ;"
  echo $new_session$attach$ssh_mask11_by_send_keys$ssh_mask12_by_split$synchronize_pane
}

init_command_vim() {
  new_session="tmux new -d -s ${tmux_name_vim} \;"
  attach=" attach\;"
  split_mask2=" split-window -h\;"
  resize=" resize-pane -t 0 -x 66\;"
  select_mask2_window=" select-pane -t 1\;"
  split_mask3=" split-window -h\;"

  open_mask1_vim=" send-keys -t 0 'cd /home/song/git/mask1 && vim .' Enter \;"
  open_mask2_vim=" send-keys -t 1 'cd /home/song/git/mask2 && vim .' Enter\;"
  open_mask3_vim=" send-keys -t 2 'cd /home/song/git/mask3-backend && vim .' Enter\;"
  echo $new_session$attach$split_mask2$resize$select_mask2_window$split_mask3$open_mask1_vim$open_mask2_vim$open_mask3_vim
}

init_command_server() {
  new_session="tmux new -d -s ${tmux_name_server} \;"
  attach=" attach\;"
  split_mask2=" split-window -h\;"
  resize=" resize-pane -t 0 -x 66\;"
  select_mask2_window=" select-pane -t 1\;"
  split_mask3=" split-window -h\;"

  open_mask1_server=" send-keys -t 0 'cd /home/song/git/mask1 && bundle exec rails s -p 3000 -b 0.0.0.0' Enter \;"
  open_mask2_server=" send-keys -t 1 'cd /home/song/git/mask2 && bundle exec rails s -p 3001 -b 0.0.0.0' Enter \;"
  open_mask3_server=" send-keys -t 2 'cd /home/song/git/mask3-backend && bundle exec rails s -p 3002 -b 0.0.0.0' Enter \;"
  echo $new_session$attach$split_mask2$resize$select_mask2_window$split_mask3$open_mask1_server$open_mask2_server$open_mask3_server
}

init_command_console() {
  new_session="tmux new -d -s ${tmux_name_console} \;"
  attach=" attach\;"
  split_mask2=" split-window -h\;"
  resize=" resize-pane -t 0 -x 66\;"
  select_mask2_window=" select-pane -t 1\;"
  split_mask3=" split-window -h\;"

  open_mask1_console=" send-keys -t 0 'cd /home/song/git/mask1 && bundle exec rails c' Enter \;"
  open_mask2_console=" send-keys -t 1 'cd /home/song/git/mask2 && bundle exec rails c' Enter \;"
  open_mask3_console=" send-keys -t 2 'cd /home/song/git/mask3-backend && bundle exec rails c' Enter \;"
  echo $new_session$attach$split_mask2$resize$select_mask2_window$split_mask3$open_mask1_console$open_mask2_console$open_mask3_console
}


# See how we were called.
case "$1" in
  vim|server|console|mask1_production12|mask1_production34|mask1api_production12)
    $1
    ;;
  status)
    result=$(session_check)
    if [[ ${result} == 0 ]]; then
      echo "${tmux_name} is running" 
      RETVAL=3
    else
      echo "${tmux_name} is not running" 
      RETVAL=$?
    fi
    ;;
  *)
    echo $"Usage: $prog {vim|server|console|mask1_production12|mask1_production34|mask1api_production12}"
    exit 1
esac

exit $RETVAL
