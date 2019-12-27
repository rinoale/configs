prog=$(basename $0 | sed -e 's/^[SK][0-9][0-9]//')
tmux_name="kinarino_vim"
tmux_name_server="kinarino_server"

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

init_command_vim() {
  new_session="tmux new -d -s ${tmux_name} \;"
  attach=" attach\;"
  resize=" resize-pane -t 2 -y 10\;"
  focus_kinarino_home=" select-pane -t 2\;"
  add_mall_ssh=" split-window -h 'ssh -t d-knrn-mall101.k-dev.in'\;"
  open_kinarino_vim=" split-window -vb 'cd /home/song_gyubin/kinarino && vim .' \;"
  open_mall_vim=" split-window -h 'ssh -t d-knrn-mall101.k-dev.in \"cd mall && vim . && exec bash\" '\;"
  echo $new_session$open_kinarino_vim$open_mall_vim$attach$resize$focus_kinarino_home$add_mall_ssh
}

init_command_server() {
  new_session="tmux new -d -s ${tmux_name_server} \;"
  attach=" attach\;"
  add_mall_ssh=" split-window -h 'ssh -t d-knrn-mall101.k-dev.in'\;"
  echo $new_session$attach$add_mall_ssh
}


# See how we were called.
case "$1" in
  start|start_server|stop|restart|override)
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
    echo $"Usage: $prog {start|stop|restart|override}"
    exit 1
esac

exit $RETVAL
