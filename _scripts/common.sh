GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

function log_date {
  date "+%Y-%m-%d %H:%M"
}

function log {
  local color=$1
  local message=$2

  echo -e "${color}[$(log_date)] => $message${NC}"
}

function log_ok {
  log $GREEN "$@ ✔"
}

function log_installing {
  log $YELLOW "$@ [installing]"
}

function log_updating {
  log $YELLOW "$@ [updating]"
}

function log_info {
  log $BLUE "$@"
}

function tmpfile {
  local t=$(mktemp -t $@)
  trap "rm -f $t" EXIT
  echo $t
}
