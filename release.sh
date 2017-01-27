project_root=$PROJECT_ROOT
release_dir=$project_root/releases
current_dir=$project_root/current
selected=0

ver_array=()
for ver in $(ls -r $release_dir/)
do
  ver_array+=($ver)
done
max=${#ver_array[@]}
((max--))

function select_release() {

  if [ ! $# -eq 1 ]; then
    print_releases

    local key

    read -n 1 -p "Press w or s to select release. x to exit" key
    echo -ne
    keypress_handler $key
    print_releases
    while [[ $key != "x" ]]; do
      read -n 1 -p "Press w or s to move cursor and p to select release. x to exit" key
      echo -ne
      keypress_handler $key
      print_releases
    done

    return;
  fi
}

function print_releases() {
  echo -e '\0033\0143'
  echo "* release versions";

  dirs_in_dir
}

function keypress_handler() {
  case "$1" in
    w)
      if [[ $selected -eq 0 ]]; then
        selected=$max
      else
        ((selected--))
      fi
      ;;
    s)
      if [[ $selected -eq $max ]]; then
        selected=0
      else
        ((selected++))
      fi
      ;;
    p)
      chosen="${ver_array[$selected]}"
      update_link $chosen
      ;;
  esac
}

function dirs_in_dir() {
  local current_link="$(readlink -f $current_dir)"
  for i in "${!ver_array[@]}"
  do
    if [[ $i == $selected ]]; then
      printf "> %s" "${ver_array[$i]}"
    else
      printf "  %s" "${ver_array[$i]}"
    fi

    if [[ $current_link == *${ver_array[$i]} ]]; then
      printf " current\n"
    else
      printf "\n"
    fi
  done
}

function update_link() {
  [ -d $current_dir  ] && unlink $current_dir
  ln -s $release_dir/$1 $current_dir
}

select_release
