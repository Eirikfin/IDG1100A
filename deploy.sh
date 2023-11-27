#!/bin/bash

# configuring how the script will run - with extra debug info and exiting on errors right away
set -e

SCRIPT_DIR="$( dirname "$0" )"

function schedule_weather_checks(){
    # removing/re-adding the line with the weather check
    # crontab -l |\
    #     sed "|check\.weather\.sh|d" |\
    #     cat - <(echo "*/10 * * * * $SCRIPT_DIR/check.weather.sh && $SCRIPT_DIR/update.pages.sh") |\
    #     crontab
    echo "skipping crontab with weather check"
}

function make_website(){
    # empty for now
    echo "make_website does nothing"
    # TODO: create .conf, reload apache
}

source "$SCRIPT_DIR/main.sh" && \
    source "$SCRIPT_DIR/check.weather.sh" && \
    schedule_weather_checks && \
    source "$SCRIPT_DIR/update.pages.sh"

# restoring the initial script-running configuration
set +ex