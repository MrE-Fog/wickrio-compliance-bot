#!/bin/sh

#
# This script copies the data from an older version of a bot to a newer installation, and copies to older one to a folder ending with '.old_Version'
#
# Usage: `./upgrade.sh OLD_BOT_LOCATION NEW_BOT_LOCATION`
#
#
# NOTE: when doing an upgrade you have to use the same bot client for the integration since only the bot
# that encrypted the config values and user database can decrypt them as well
#

if [ "$#" -ne 2 ]
then
  echo "Usage: $0 <old location> <new location>"
  exit 1
fi

if ! [ -d "$1" ] || ! [ -d "$2" ]
then
  echo "Both locations should be directories!"
  exit 1
fi

#
# Save the input values:
# Example:
# old location: '/opt/WickrIODebug/clients/bcast_bot/integration/wickrio-compliance-bot'
# new location: '/opt/WickrIODebug/clients/bcast_bot/integration/wickrio-compliance-bot.new'
#
export OLD_BOT_LOCATION=$1
export NEW_BOT_LOCATION=$2
cd $OLD_BOT_LOCATION

#
# Copy the json data files to the new software location
#
set +e
cp -f client_bot_username.txt processes.json receivedMessages.log $NEW_BOT_LOCATION
set -e

# copy the messages if they are local
if [ -d messages ]
then
  cp -r messages $NEW_BOT_LOCATION
fi

# copy the attachments if they are local
if [ -d attachments ]
then
  cp -r attachments $NEW_BOT_LOCATION
fi

set +e
cp -rf logs $NEW_BOT_LOCATION
set -e

#
# Move the OLD installation to a saved directory
# Remove a previous one if necessary
#
cd ..
echo $PWD
ls
rm -rf wickrio-compliance-bot.old_Version
mv $OLD_BOT_LOCATION wickrio-compliance-bot.old_Version

#
# Move the NEW installation to the bot's integration directory
#
cd $NEW_BOT_LOCATION/..
mv $NEW_BOT_LOCATION $OLD_BOT_LOCATION

