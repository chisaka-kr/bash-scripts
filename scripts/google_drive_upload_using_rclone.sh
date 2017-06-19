#!/bin/sh
GOOGLE_UPLOAD_PATH=/upload/google_drive/
GOOGLE_UPLOAD_TEMP=/upload/.ing/google_drive/
 
GOOGLE_TARGET_PATH=gd:/up
LOG=cloud-autoupload.log
 
if [ $(find "$GOOGLE_UPLOAD_PATH" | wc -l) -gt 1 ]
then
 find $GOOGLE_UPLOAD_PATH | while read i
 do
  if [ $(lsof "$i" | wc -l) -eq 0 ]
  then
   echo $(date +%Y-%m-%d:%H:%M:%S) "MOVE FILE" $i > $LOG
   mv "$i" "$GOOGLE_UPLOAD_TEMP$(echo $i | sed "s#$GOOGLE_UPLOAD_PATH##")"
  fi
 done
 find "$GOOGLE_UPLOAD_PATH" -type d -empty -delete
 if [ ! -d "$GOOGLE_UPLOAD_TEMP/.notyetfinished" ]
 then
   echo $(date +%Y-%m-%d:%H:%M:%S) $GOOGLE_UPLOAD_TEMP "upload started" > $LOG
   mkdir $GOOGLE_UPLOAD_TEMP/.notyetfinished
   /usr/sbin/rclone move $GOOGLE_UPLOAD_TEMP $GOOGLE_TARGET_PATH --transfers 20 --exclude ".*" --no-traverse > $LOG
   rm -rf $GOOGLE_UPLOAD_TEMP/.notyetfinished
   echo $(date +%Y-%m-%d:%H:%M:%S) $GOOGLE_UPLOAD_TEMP "upload finished" > $LOG
   find "$GOOGLE_UPLOAD_TEMP" -type d -empty -delete
 fi
fi