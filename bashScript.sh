#!/bin/bash
# Dazza's BASH template 26/08/2020

# LOGS:
# Level | Severity | Description
# -------------------------------------------------------------------------
# 0     | d_emerg    | System is unusable -kernel only.
# 1     | d_alert    | Should be corrected immediately (eg: loss of primary ISP connection)
# 2     | d_crit   * | Critical conditions such as a failure in the system's primary application.
# 3     | d_err    * | Error conditions such as an application exceeding its file storage limit and attempts to write to disk are failing.
# 4     | d_warning* | May indicate that an error will occur if action is not taken.
# 5     | d_notice * | Events that are unusual, but not error conditions.
# 6     | d_info   * | Normal operational messages that require no action.
# 7     | d_debug  * | Information useful to developers for debugging the application.
# -------------------------------------------------------------------------
d_print()
{
    # Add severity tag and print the message
    level=$2
    msg=$1
    case $level in 
        0 ) keyword="EMERGENCY"    ;;
        1 ) keyword="ALERT"        ;;
        2 ) keyword="CRITICAL"     ;;
        3 ) keyword="ERROR"        ;;
        4 ) keyword="WARNING"      ;;
        5 ) keyword="NOTICE"       ;;
        6 ) keyword="INFO"         ;;
        7 ) keyword="DEBUG"        ;;
        * ) echo "Invalid Syslog level specified" >&2
            exit 1
    esac
    if [ "$level" -le "$GLOBAL_SYSLOG_LEVEL" ] ; then  # "-le is less than or equal to"
        echo [$keyword] $msg
        # You could add a call to the UNIX logger application here to send it
        # to the syslog network process if you wanted to
    fi
    return 0
}

d_emerg()
{
    d_print "$1" 0 >&2
}

d_alert()
{
    d_print "$1" 1 >&2
}

d_critical()
{
    d_print "$1" 2 >&2
}

d_error()
{
    d_print "$1" 3 >&2
}

d_warning()
{
    d_print "$1" 4
}

d_notice()
{
    d_print "$1" 5
}

d_info()
{
    d_print "$1" 6
}

d_debug()
{
    d_print "$1" 7
}



beforeExit()
{
    # Put any code required upon exit here but don't issue an exit code
    # eg save data
    d_debug "Running Exit procedures"
}

keyboardInterrupt()
{
    # Put any code required upon CTRL+C here but don't issue an exit code
    # eg run exit tasks like beforeExit()
    d_debug "Keyboard interrupt received"
}

sigtermInterrupt()
{
    # Put any code required upon SIGTERM from operating system here but don't
    # issue an exit code. eg run exit tasks like beforeExit()
    d_info "SIGTERM interrupt received"
}

##############################
##############################
##############################

mainloop()
{
    # Do stuff here
    while true; do
        sleep 1
    done
}

# Exit handlers NOTE: Raspbian doesnt like the keywords SIGTERM and SIGINT
# Sample for SIGINT or signal 2 : trap 'command1; command2; exit level' SIGINT
trap 'keyboardInterrupt; beforeExit; exit 2' 2 #SIGINT
trap 'sigtermInterrupt; beforeExit; exit 255' 15 #SIGTERM


# General init
GLOBAL_SYSLOG_LEVEL=7  # range from 0 to 7 to mute messages


# Call the main loop (THIS IS THE REAL MAIN LOOP)
d_info "PID is $$"
d_debug "Running by $0"
d_debug "Number of args $#"
d_debug "Non-Iterable args: ${*}"
# Iterable list of args is $@
mainloop

exit 0