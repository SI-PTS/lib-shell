#!/bin/sh

# This is the default Docker entrypoint for all SIPTS containers.
#
# The script does:
#
# 1) print container's
#    a) name, expected in $SIPTS_CONTAINER_NAME
#    b) version, expected in $SIPTS_CONTAINER_VERSION
#    c) commit, expected in $SIPTS_CONTAINER_COMMIT
#    d) build timestamp, expecte in $SIPTS_CONTAINER_BUILDTIME
# 2) print the containers environment
# 3) execute the containers found in $SIPTS_CONTAINER_ENTRYPOINT
#
# All output is JSON formatted.
#
# The script must be placed in the containers
# working directory, usually /app. The containers own
# entrypoint script must also be placed in /app.
#
# Startup will fail, if any of the $SIPTS_CONTAINER_*
# variables mentioned above is not present or empty.

# Log a JSON string to the console.
#
# The first parameter $1 contains the log level;
# the second parameter $2 contains the message to log;
# the optional parameters $3 and $4 contain an additional
# key/value pair to log.
#
# For example, log_json "blah" "n" "10" prints
# { "msg": "blah", "n": "10" } and
# log_json "blah" prints just
# { "msg": "blah"}.
log_json() {
  level="\"level\":\"${1}\""
  msg="\"msg\":\"${2}\""
  time="\"time\":\"$(date +"%Y-%m-%dT%H:%M:%S%Z" --universal)\""
  if [ $# = 2 ]; then
    echo "{${level},${time},${msg}}"
  elif [ $# = 4 ]; then
    kv="\"${3}\":\"${4}\""
    echo "{${level},${time},${msg},${kv}}"
  else
    echo "Script error, invalid number of arguments, aborting."
    echo "Received ${#} arguments: \"${@}\""
    exit 2
  fi
}
log_info() {
  log_json "info" "$@"
}
log_error() {
  log_json "error" "$@"
}

# Print value of variable passed in as first parameter.
#
# If the variable does not exist or conains an empty string,
# log an error and abort; if the variable exists, log
# its value to the console.
print_var() {
    var="$1"
    val=$(env | grep "^${var}=" | sed 's|^[^=]*=\(.*\)|\1|')
    if [ ! -n "${val}" ]; then
      log_error "Missing required env variable ${var}, aborting."
      exit 1
    fi
    log_info "Printing ${var}." "${var}" "${val}"
}

# Print container variables.
for v in SIPTS_CONTAINER_NAME SIPTS_CONTAINER_VERSION SIPTS_CONTAINER_COMMIT SIPTS_CONTAINER_BUILDTIME
do
  print_var "${v}"
done

# Print env, excluding SIPTS_CONTAINER_* variables.
environment=$(env | grep -v '^SIPTS_CONTAINER')
log_info "Printing environment." "env" "${environment}"

# Execute ./entrypoint.sh, ie. the container's own entrypoint.
log_info "Resolving container's entrypoint."
print_var "SIPTS_CONTAINER_ENTRYPOINT"
sh -c "${SIPTS_CONTAINER_ENTRYPOINT}"
