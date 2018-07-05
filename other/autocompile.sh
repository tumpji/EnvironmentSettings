#!/bin/bash
# UTF-8
# =============================================================================
#         FILE: autocompile.sh
#  DESCRIPTION: This script tests files in "tested_files" if they are changed. 
#               If yes then it calls your part of code (make, other script, ...)
#        USAGE: Just start it.
#      OPTIONS: Nothing
# REQUIREMENTS: bash
#
#      LICENCE:
#
#         BUGS:
#        NOTES: This version is premade to act as a latex autocompiler.
#       AUTHOR: Jiří Tumpach (tumpji),
#      VERSION: 1.1.0
#      CREATED: 2018 07.03.
# =============================================================================

tested_files=('./chap01.tex' './thesis.tex' './bibliography.bib' './bibliography.tex')

# time delay every check (array in case of not acting for $wait_minutes_change) it wil 
# inc wait_index to maximum of #wait_option-1
wait_option=(1 1 1 2 2 3 4 5 6 7 8 9 10)
wait_index=0
wait_ticks=0
wait_minutes_change=3

# last modification time (initial 0)
last_mod=( $(for i in ${tested_files[*]}; do echo 0; done) )
# precomputed tick per switch to different controll schedule
precomputed_wait_time_ticks=( $(for i in ${wait_option[*]}; 
    do echo $(($wait_minutes_change*60/$i)); done) )

# main loop
while true; 
do
    sleep ${wait_option[$wait_index]} 
    act_change=no

    # every tested file
    for ((i=0; $i-${#tested_files[*]}; i+=1))
    do
        act_mod=$(stat -c %y ${tested_files[$i]})

        if [ "$act_mod" != "${last_mod[$i]}" ];
        then
            echo "$i to $act_mod"
            last_mod[$i]=$act_mod
            act_change=yes
        fi
    done

    if [ $act_change == no -a $(($wait_index+1)) -ne ${#wait_option[*]} ]
    then
        # inc timer
        wait_ticks=$(($wait_ticks+1))

        # switch schedule
        if [ $wait_ticks -ge ${precomputed_wait_time_ticks[$wait_index]} ]
        then
            wait_index=$((wait_index+1))
            wait_ticks=0
        fi
    elif [ $act_change == yes ]
    then
        # reset schedule to most active one
        wait_index=0
        wait_ticks=0


        # recompile (you can change it as you like)
        make 0<&-

        if [ $? ]
        then
            echo "Successfully executed"
        else
            echo "Unuccessfully executed"
        fi
    fi
done
