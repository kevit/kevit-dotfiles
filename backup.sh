#!/bin/sh
BACKIFS=$IFS
IFS=$'\n'
tar cf backup.tar `cat .files`
IFS=$BACKIFS
cp ~/backup.tar /Volumes/FLASH
