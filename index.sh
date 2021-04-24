#!/bin/bash

# if [ $(printf "3600 >= 4587.558789" | bc -q ) ]; then
#     echo "came here";
#     exit; 
# fi

# if awk 'BEGIN {exit !('3600' >= '4587.558789')}'; then
#     echo "yes"
# else 
#     echo "no"
# fi

# exit;

startTiming=0;
endTiming=1800;
outputDuration=1800;
filePath="/home/jatinseth/KairaMundan";
sourceFile="04_Part_1.mpg";
DestinationFile="output";
areFilesDone=0;

#ffprobe -i '/home' -show_entries format=duration,format_name -v quiet -of csv="p=0"
fileInformation=$(ffprobe -i "$filePath/$sourceFile" -show_entries format=duration,format_name -v quiet -of csv="p=0");
#fileInformation=$(whoami);

#fetch variables from comma separated value
IFS=',' read -r -a fileInformationArray <<< "$fileInformation";

if [ -z "${fileInformationArray[0]}" ] | [ -z "${fileInformationArray[1]}" ] ; then
    echo 'File variables are not valid';
    exit;
fi

# echo "${fileInformationArray[0]} and ${fileInformationArray[1]}";

counter=1;
while awk "BEGIN {exit !($areFilesDone == 0)}";
do
    #cehcking if loop should rn next time or not
    if awk "BEGIN {exit !($endTiming == ${fileInformationArray[1]})}"; then
        areFilesDone=1;  
    fi
    echo "running ${counter} starttime ${startTiming} endTime ${endTiming} areFilesDone ${areFilesDone}";
    $(ffmpeg -v quiet -i "$filePath/$sourceFile" -ss $startTiming -to $endTiming -vcodec copy -acodec mp3 "$filePath/$DestinationFile/$counter.mpg");
    echo "done";
    #increasing counter
    counter=$((counter + 1));
    #start timing
    startTiming=$((startTiming + outputDuration));
    #end timing
    endTiming=`echo $endTiming + $outputDuration | bc`;

    # echo "endTime after increament ${endTiming}";
    #checking if end timing is greater than total length then reset
    if awk "BEGIN {exit !($endTiming > ${fileInformationArray[1]})}"; then
        # echo "came here";
        endTiming=${fileInformationArray[1]};  
    fi
done

echo 'Files are done.';