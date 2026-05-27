## mysql service

# If you need to have mysql@5.7 first in your PATH, run:
#   echo 'export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"' >> ~/.zshrc
# export PATH="/usr/local/opt/gettext/bin:/usr/local/opt/mysql@5.7/bin:$PATH:/usr/local/opt/imagemagick@6/bin"

# If you need to have mysql@5.7 first in your PATH, run:
#   echo 'export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"' >> ~/.zshrc

# For compilers to find mysql@5.7 you may need to set:
#   export LDFLAGS="-L/opt/homebrew/opt/mysql@5.7/lib"
#   export CPPFLAGS="-I/opt/homebrew/opt/mysql@5.7/include"

# For pkg-config to find mysql@5.7 you may need to set:
#   export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql@5.7/lib/pkgconfig"
# my57home=$(brew --prefix mysql@5.7)
# if [ -d ${my57home}/bin ]; then
#   export PATH="${my57home}/bin:$PATH"
# fi

function mysqlenv(){
  # For compilers to find mysql@5.7 you may need to set:
  export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
  export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"

  # For pkg-config to find mysql@5.7 you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"

  echo "env LDFLAGS CPPFLAGS PKG_CONFIG_PATH set"
}

## daily utils

function msql(){
  mycli -uroot "$@"
  echo ok
}

function droptables(){
  [ $# -lt 2 ] && {
    echo Usage: _ table_prefix db
    return 1
  }
  prefix=$1
  db=$2
  tables=($(mysql -uroot -e "show tables like '${prefix}%'" $2 -sN))
  for t in ${tables[@]}; do 
    echo drop table $db.$t
    mysql -uroot -e "drop table $t;" $2
  done
}