#!/bin/bash
# UTF-8
# author: Jiri Tumpach

backup_folder="backup"

# list of cached/installed files
files=(\
    ~/.vimrc vimrc
    )


################## 
###### computed params

# number of items in list
files_num=${#files[*]}

#################
###### functions 

# create new backup based on date and time
function backup {
    rm "${backup_folder}/*" 

    for index in `seq 0 2 $(("$files_num"-1))`
    do
        input_file=${files[index]}
        output_file=${files["$(("$index"+1))"]}
        output_path="${backup_folder}/${output_file}"

        echo "File $((${index}/2+1)) out of $((${files_num}/2))"
        echo "  input : $input_file"
        echo "  output: $output_path"
        cp "${input_file}" "${output_path}"
    done
    git add backup/*
    git commit -m "backub add"
    git push origin master
}

# restore backup based on index
function restore {
    for index in `seq 0 2 $(("$files_num"-1))`
    do
        input_file=${files[index]}
        output_file=${files["$(("$index"+1))"]}
        output_path="${backup_folder}/${output_file}"

        echo "File $((${index}/2+1)) out of $((${files_num}/2))"
        echo "  input : $input_file"
        echo "  output: $output_path"
        cp "${output_path}" "${input_file}"
    done
}


###############
######## main decision -- argument parsing

case $1 in
    --help|""|help)
        echo "Program is used for backup and restore important settings files"
        echo "  command:     explanation"
        echo 
        echo "  restore {}:  restore all backups"
        echo "  backup:      make backup"
        exit 0
    ;;
    --backup|backup|back|b)
        backup
        exit 0
    ;;
    --restore|res|restore|r)
        restore
        exit 0
    ;;
esac





