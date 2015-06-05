#!/bin/bash

projects="JJsHouse,JenJenHouse,DressFirst,AmorModa,JennyJoseph,VBridal";
IFS=, 
for p in ${projects}; do 
    echo Building filter for ${p};
    php build.php ${p};
done; 
