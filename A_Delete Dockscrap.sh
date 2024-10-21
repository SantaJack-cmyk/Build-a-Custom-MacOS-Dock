#!/bin/bash

#set's the variable for the dockscrap file

dockscrap=/Users/Shared/DockFile/dockscrap.txt
if [ -f $dockscrap ]; then
    echo "The dockscrap file exists. Deleting the file." 
    rm $dockscrap
    exit 0
fi

exit 0
