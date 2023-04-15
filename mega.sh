#!/bin/bash

echo "[MEGA BACKUP] Starting backup script"

cur_month="$(date +%Y-%m)"
stime=$(date +"%s")

# accounts
declare -A accounts
accounts[email1@gmail.com]=PASSWORD
accounts[email2@gmail.com]=PASSWORD

# Backup path
backup_folder="PATH/TO/FOLDER/BACKUP"
temp_folder="/tmp/$USER/megasync"
search_dir="$temp_folder"

# create path
[ ! -d "$temp_folder" ] && mkdir -p "$temp_folder"

# zip path to 20GB files
echo "[MEGA BACKUP] zipping started !!"
sudo zip -s 19900m -P PASSWORD -r "$temp_folder"/backup.zip "$backup_folder"

# loop to upload all zips
echo "[MEGA BACKUP] upload started !!"
for account in "${!accounts[@]}"
do
  sudo mega-logout 1>/dev/null
  sudo mega-login $account ${accounts[$account]}
  file="$(sudo mega-ls)"
  # echo "key  : $account"
  # echo "value: ${accounts[$account]}"
  # echo "$file"
  sudo mega-rm "$file"
  for zip in "$search_dir"/*
  do
    # echo "$zip"
    sudo mega-put "$zip" / &>/dev/null
    rm -f "$zip"
    break
  sudo mega-logout 1>/dev/null
  sleep 4
  done
done

etime=$(date +"%s")
timediff=$(($etime-$stime))
echo "[MEGA BACKUP] Script took $(($timediff / 60)) minutes and $(($timediff % 60)) seconds to finish"
