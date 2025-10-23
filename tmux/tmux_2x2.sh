prog=$(basename $0 | sed -e 's/^[SK][0-9][0-9]//')
session_name=$2
tmux_name=$session_name"_2x2"

echo $tmux_name

session_check() {
  (tmux has-session -t $1)
  echo $?
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

new() {
  result=$(session_check $tmux_name)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_tjs} session already running"
  else
    echo "${tmux_name_tjs} session not running yet"
    echo "Starting ${tmux_name_tjs}"
    init_comm=$(init_command)
    eval ${init_comm}
  fi
}

attach() {
  result=$(session_check $tmux_name)
  echo "session status : ${result}"
  if [[ ${result} == 0 ]]; then
    echo "${tmux_name_tjs} session already running"
    eval "tmux attach -t ${tmux_name}"
  else
    echo "${tmux_name_tjs} session not running yet"
    echo "Starting ${tmux_name_tjs}"
  fi
}

stop() {
  result=$(session_check $tmux_name)
  if [[ ${result} == 0 ]]; then
    echo $"Stopping ${tmux_name}"
    (tmux kill-session -t ${tmux_name})
  else
    echo "${tmux_name} not running yet"
  fi
}

init_command() {
  new_session="tmux new -d -s ${tmux_name} \;"
  attach=" attach\;"
  split_mask2=" split-window -h\;"
  split_mask3=" split-window -v\;"
  select_mask0_window=" select-pane -t 0\;"
  resize0=" resize-pane -t 0 -y 50\;"
  resize1=" resize-pane -t 1 -y 50\;"

  echo $new_session$attach$split_mask2$split_mask3$resize1$select_mask0_window$split_mask3$resize0
}

# See how we were called.
case "$1" in
  attach|new|stop)
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
    echo $"Usage: $prog attach|new|stop {session_name}"
    exit 1
esac

exit $RETVAL
