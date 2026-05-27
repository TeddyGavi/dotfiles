#!/bin/bash
set -eu

# sourceable pomodoro command
pomodoro() {

    # print help
    echo_help() {
       # Display help
       echo "Pomodoro timer for the terminal."
       echo
       echo "Syntax: pomodoro [ OPTIONS ]"
       echo "options:"
       echo "   -s or --short-break [INTEGER]"
       echo "       length of short breaks in seconds"
       echo "   -l or --long-break [INTEGER]"
       echo "       length of long breaks in seconds"
       echo "   -w or --work [INTEGER]"
       echo "       length of work interval in seconds"
       echo "   -q or --quiet"
       echo "       do not show notifications"
       echo "   -h or --help"
       echo "       print help and exit"
       echo
    }

    # Default arguments
    WORK=1500       # 25 mins
    SHORT_BREAK=300 # 5 mins
    LONG_BREAK=1800 # 30 mins
    QUIET=false

    # Parse arguments
    for i in "$@"; do
      case $i in
        -h|--help)
          echo_help
          return;
          ;;
        -s|--short-break)
          if [[ $2 =~ ^-?[0-9]+$ ]]
          then
            SHORT_BREAK=$2
            shift # past argument
            shift # past value
          else
            echo_help
            return;
          fi
          ;;
        -l|--long-break)
          if [[ $2 =~ ^-?[0-9]+$ ]]
          then
            LONG_BREAK=$2
            shift # past argument
            shift # past value
          else
            echo_help
            return;
          fi
          ;;
        -w|--work)
          if [[ $2 =~ ^-?[0-9]+$ ]]
          then
            WORK="$2"
            shift # past argument
            shift # past value
          else
            echo_help
            return;
          fi
          ;;
        -q|--quiet)
          QUIET=true
          shift # past argument
          ;;
        -*|--*)
          echo "Unknown option $1"
          echo_help
          return;
          ;;
      esac
    done

    # show notification
    notify() {
        msg=$1
        secs=$2
        time=$(convert_secs $secs)
        osascript -e 'display notification "'"$msg\n$time"'" with title "Pomodoro" sound name "default"'
    }

    # convert notifications to h:m:s format
    convert_secs() {
        secs=${1}
        printf "%dh:%dm:%ds" $((secs/3600)) $((secs%3600/60)) $((secs%60))
    }

    # Colors for the progress bar
    GREEN="\033[0;32m"
    RESET="\033[0m"  # Reset color

    # Function to display the progress bar with color
    print_progress_bar() {
        local current=$1
        local total=$2
        local bar_length=50
        local filled_length=$((($current * $bar_length) / $total))
        local bar=$(printf "%${filled_length}s" | tr ' ' '=')
        local remaining_length=$((bar_length - ${#bar}))
        local empty_space=$(printf "%${remaining_length}s" | tr ' ' '-')
        printf "\r\033[K[${GREEN}%s${RESET}%s] %3s%%" "$bar" "$empty_space" "$((($current * 100) / $total))"
    }

    # start a countdown for x seconds with progress bar
    countdown() {
      secs=$1
      shift
      msg=$@
      total_secs=$secs
      while [ $secs -gt 0 ]
      do
        t=$(convert_secs $secs)
        print_progress_bar $((total_secs - $secs)) $total_secs
        printf " $msg $t"
        ((secs--))
        sleep 1
      done
      echo # Print a newline after the progress bar is complete
    }

    # single step pomodoro step (work / break interval)
    pomodoro_step() {
      if ! $QUIET; then
        notify "$1!" $2
      fi
      countdown $2 "$1:"
    }

    # main pomodoro loop (infinite)
    pomodoro_loop() {
        counter=1
        while true; do
            for i in {1..3}; do
                echo "\nPomodoro #$((counter++)) ..."
                pomodoro_step "Work" $WORK
                pomodoro_step "Break" $SHORT_BREAK
            done
            echo "\nPomodoro #$((counter++)) ..."
            pomodoro_step "Work" $WORK
            pomodoro_step "Break" $LONG_BREAK
            done
    }

    echo "Pomodoro Timer ==="
    echo "Work: $WORK sec"
    echo "Short break: $SHORT_BREAK sec"
    echo "Long break: $LONG_BREAK sec"

    pomodoro_loop
}
