#!/bin/bash

# TODO: Allow for the world names to be arguments to avoid hard-coding and expand
# the repo capabilities beyond me & Tom :) 

# TODO: Allow for timestamp checks against the file contents of the worlds being 
# copied in, and prevent any unnecessary overwrites.

TOMMUNE_NAME="TheTommune"
TOMMUNE_SOURCE="./$TOMMUNE_NAME/*"

# Validate user input
USERNAME=$1

if [ -z "$USERNAME" ]
then
	echo " >> \$USERNAME must be provided to access Save Data"
	echo " >> EXITING"
	exit
fi

# Validate local Valheim saves exist

VALHEIM_WORLDS_DIR=/C/USERS/$USERNAME/AppData/LocalLow/IronGate/Valheim/worlds/
if [ ! -d "$VALHEIM_WORLDS_DIR" ]
then
	echo " >> No Valheim worlds directory present."
	echo " >> EXITING"
	exit
fi

VALHEIM_WORLDS_TAR=/C/Users/$USERNAME/AppData/LocalLow/IronGate/Valheim/worlds.tar

echo " >> Backing up 'worlds/' to $VALHEIM_WORLDS_TAR"
tar -zcvf $VALHEIM_WORLDS_TAR $VALHEIM_WORLDS_DIR

echo " >> Overwriting $TOMMUNE_NAME Save Data"
cp ./$TOMMUNE_NAME/* /C/Users/$USERNAME/AppData/LocalLow/IronGate/Valheim/worlds/
