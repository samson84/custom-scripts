#!/bin/bash

# DESCRIPTION: Creates a backup of two source DATA, and HOMEDIR with incremental rsync to a given destination, 
# 	and also get an installed package list
#	dirs without closing / in config!

# --- CONFIG START ---

# The base directory for the DATA and HOMEDIR destinaion.
DESTINATION_BASEDIR=/media/samson84/backup

# DATA drive source and destination
# SOURCE_DATA=/media/data
# DESTINATION_DATA=backup_data

# HOMEDIR source and destination
SOURCE_HOMEDIR=/home/samson84
DESTINATION_HOMEDIR=backup_homedir

# SOFTWARE list destination within the destination basedir
DESTINATION_SOFTWARE=backup_software


#logs dir inside the destination basedir
DESTINATION_LOGDIR=logs

# --- CONFIG END ---
#LOG_FILE_NAME_DATA=rsync_data_$(date +'%Y-%m-%d_%H-%M').log
LOG_FILE_NAME_HOMEDIR=rsync_homedir_$(date +'%Y-%m-%d_%H-%M').log
SOFTWARE_LIST_FILE_NAME=packages_$(date +'%Y-%m-%d_%H-%M').list

FULLPATH_SOFTWARE=$DESTINATION_BASEDIR/$DESTINATION_SOFTWARE
#FULLPATH_DATA=$DESTINATION_BASEDIR/$DESTINATION_DATA
FULLPATH_HOMEDIR=$DESTINATION_BASEDIR/$DESTINATION_HOMEDIR
FULLPATH_LOGDIR=$DESTINATION_BASEDIR/$DESTINATION_LOGDIR

#mkdir $FULLPATH_DATA
mkdir $FULLPATH_SOFTWARE
mkdir $FULLPATH_HOMEDIR
mkdir $FULLPATH_LOGDIR

echo [SECTION] Save installed package list to $SOFTWARE_LIST_FILE_NAME
dpkg --get-selections > $FULLPATH_SOFTWARE/$SOFTWARE_LIST_FILE_NAME

# echo [SECTION] Backup DATA to $FULLPATH_DATA, logging to $FULLPATH_LOGDIR/$LOG_FILE_NAME_DATA
# rsync -ah --info=progress2 --stats --log-file=$FULLPATH_LOGDIR/$LOG_FILE_NAME_DATA $SOURCE_DATA $FULLPATH_DATA 

echo [SECTION] Backup HOMEDIR to $FULLPATH_HOMEDIR, logging to $FULLPATH_LOGDIR/$LOG_FILE_NAME_HOMEDIR
rsync -ah --info=progress2 --stats --log-file=$FULLPATH_LOGDIR/$LOG_FILE_NAME_HOMEDIR $SOURCE_HOMEDIR $FULLPATH_HOMEDIR

