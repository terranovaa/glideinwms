#!/usr/bin/env bats
# SPDX-FileCopyrightText: 2009 Fermi Research Alliance, LLC
# SPDX-License-Identifier: Apache-2.0
load 'lib/bats-support/load'
load 'lib/bats-assert/load'

[[ -z "$GWMS_SOURCEDIR" ]] && GWMS_SOURCEDIR="../../creation/web_base"

setup () {
    source "$GWMS_SOURCEDIR"/utils_signals.sh
}

@test "trap_with_arg" {
    run trap 'ignore_signal' SIGTERM SIGINT SIGQUIT
    echo "$output" >& 3
    # Todo: How  to check if handler has been correctly assigned?
    [ "$output" == "" ]
    [ "$status" == 0 ]
}

@test "on_die" {
    sleep 5 &
    pid=$!
    GWMS_MULTIGLIDEIN_CHILDS=${pid}
    run on_die "KILL"
    echo "$output" >& 3
    if ! ps -p ${pid} > /dev/null
    then
       [ 0 -eq 0 ]
    else
       [ 1 -eq 0 ]
    fi
    [ "$status" == 0 ]
    assert_output --partial "forwarding KILL signal"
}
