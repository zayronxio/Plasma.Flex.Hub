path=$(echo "$1" | sed 's|^file://||g')
folder=$path"/"$5
if [ -d $path ]; then

   if [ -d $folder ]; then
     echo "theme already exists"
   else
     mkdir $folder
     echo -e "{\n  \"indexElements\": [$2],\n  \"values_y\": [$3],\n  \"values_x\": [$4]\n}" > "$folder/themerc.json"
   fi
else
   echo "Folder incorrect"
fi

