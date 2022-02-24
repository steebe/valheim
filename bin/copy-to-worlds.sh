#!/bin/bash

USERNAME=$(whoami)
WORLDS_DIR=./worlds
VALHEIM_WORLDS_DIR=/C/USERS/$USERNAME/AppData/LocalLow/IronGate/Valheim/worlds
VALHEIM_WORLDS_TAR=/C/Users/$USERNAME/AppData/LocalLow/IronGate/Valheim/worlds.tar

COMMAND=$1

shift

WORLD_NAMES="$@"

function check_world_names {
  if [[ -z "$WORLD_NAMES" ]]
  then
    echo " >>> No worlds specified, and no action taken"
    echo " >>> EXITING"
    exit
  fi
}

function backup_worlds {
  echo " >>> Backing up 'worlds/' to $VALHEIM_WORLDS_TAR"
  tar -zcf $VALHEIM_WORLDS_TAR $VALHEIM_WORLDS_DIR
  echo " >>> Backup complete"
}

function pull {
  check_world_names

  echo " >>> Pulling latest world(s) data..."

  backup_worlds

  for WORLD in $WORLD_NAMES
  do
    WORLD_DIR=$WORLDS_DIR/$WORLD
    if [ ! -d "$WORLD_DIR" ]
    then
      echo " >>> $WORLD does not exist in the remote. Skipping..."
      continue
    fi

    cp $WORLD_DIR/* $VALHEIM_WORLDS_DIR
    echo "Copied $WORLD to worlds/"
  done

  echo " >>> Done! Happy playing!"
}

function push {
  check_world_names

  for WORLD in $WORLD_NAMES
  do
    LOCAL_WORLD_PREFIX=$VALHEIM_WORLDS_DIR/$WORLD
    LOCAL_WORLD_DB_FILE=$LOCAL_WORLD_PREFIX.db
    if [ ! -f $LOCAL_WORLD_DB_FILE ]
    then
      echo " >>> $WORLD does not exist locally. Skipping..."
      continue
    fi

    DESTINATION=$WORLDS_DIR/$WORLD/
    if [ ! -d $DESTINATION ]
    then
      echo " >>> This is a new world. Making a new $WORLD directory in $WORLDS_DIR..."
      mkdir $DESTINATION
    fi

    cp $LOCAL_WORLD_PREFIX.* $DESTINATION
    echo "Updated $WORLD in $WORLDS_DIR"
  done
  echo " >>> Done! Commit and push your world updates..."
}

function driver {
  if [ -z "$USERNAME" ]
  then
    echo " >>> \$USERNAME must be provided to access Save Data"
    echo " >>> EXITING"
    exit
  fi

  if [ ! -d "$VALHEIM_WORLDS_DIR" ]
  then
    echo " >>> No Valheim worlds directory present. Go play Valheim..."
    echo " >>> EXITING"
    exit
  fi

  if [[ $COMMAND = "push" ]]
  then
    push
  elif [[ $COMMAND = "pull" ]]
  then
    pull
  else
    echo " >>> You must specify which update you're performing [push | pull]"
    echo " >>> Usage:"
    echo "    ./run.sh [push | pull] (world1 world2 world3 ...)"
    exit
  fi
}

driver