function gems_with_version() {
  local rbenv_dir=~/.rbenv/versions

  if [ ! $# -eq 1 ]; then
    echo version required;
    echo ===possibles===;
    dirs_in_dir $rbenv_dir
    echo ===============;
    return;
  fi
  if [ ! -d $rbenv_dir/$1/ ]; then
    echo $1 not exist;
    echo ===possibles===;
    dirs_in_dir $rbenv_dir
    echo ===============;
    return;
  fi
  cd $rbenv_dir/$1/lib/ruby/gems/2.2.0/gems/;
  vim .;
}
function dirs_in_dir() {
  for ver in $(ls $1/); do echo $ver; done
}

alias vergems=gems_with_version
