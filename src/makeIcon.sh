#!/bin/bash

echo "Requirements:"
echo "-source Icon in 128x128"
echo "-source Icon in icon_src/category/name.png"
echo "--i.e. icon_src/pluginIcons/music.png"
echo "--i.e. icon_src/menuIcons/Timers.png"
echo "--i.e. icon_src/extraIcons/SomeMenu.png"
echo "-source IconBorder in 128x128"
echo "-source IconBorder in icon_src/IconBorder/type_color.png"
echo "--i.e. icon_src_IconBorder/glass_red.png"
echo "--i.e. icon_src_IconBorder/dark_black.png"
echo "--i.e. icon_src_IconBorder/glass_white.png"
echo "---------------------------------------------------------"
echo "---------------------------------------------------------"
echo "Would you like to go on?"
echo "Press any key to continue. Press CRTL+C to cancel."
read -n 1 -s KEY
echo "---------------------------------------------------------"
echo "Start creating Icons"
###CHECK REQUIREMENTS
if [ ! -d icon_src ] ; then
	echo "Please create a folder called icon_src and put your icon in the target directory"
	echo "like icon_src/extraIcons or icon_src/pluginIcons"
	exit
fi

###CREATE SOURCE
for ICON in icon_src/*Icons/*.png
do
    if [ ! -f "${ICON}" ]; then
	echo "No files found..."
	echo "Please add some source icons to the target directory"
	exit

    else
        SRCDIR=$(dirname "$ICON")
	SRCFILE=$(basename "$ICON")

	echo "-------------OUTPUTs---------------"
        echo "ICON: $ICON"
        echo "SRCDIR: $SRCDIR"
        echo "SRCFILE: $SRCFILE"
        echo "-------------OUTPUTs---------------"

	if [ ! -d "$SRCDIR"_small ] ; then
		mkdir "$SRCDIR"_small
	fi

	if [ ! -d "$SRCDIR"_small_grey ] ; then
		mkdir "$SRCDIR"_small_grey
	fi

	convert -resize 90x90 "$ICON" "$SRCDIR"_small/"$SRCFILE"
	convert -colorspace gray "$SRCDIR"_small/"$SRCFILE" "$SRCDIR"_small_grey/"$SRCFILE"
    fi
done

#######COLLECT INFORMATION
for BORDER in icon_src/IconBorder/*.png
do
	for ICON in icon_src/*Icons/*.png
	do
		if [ ! -f "${ICON}" ]; then
	        	echo "No files found..."
        		echo "Please put some icons to the target directory"
        		exit
		fi

	    	if [ ! -f "${BORDER}" ]; then
        		echo "No files found..."
        		echo "Please add some borders to icon_src/IconBorder"
			echo "Filenames should be like this: type_corlor.png like dark_blue.png or glass_red"
        		exit

		else
			TARDIR=$(dirname "$BORDER")
        		TARFILE=$(basename "$BORDER" .png)
	        	SRCDIR=$(dirname "$ICON")
        		SRCFILE=$(basename "$ICON")
			CATEGORY=$(echo $SRCDIR | awk -F/ '{print $2}')
			TYPE=$(echo "$TARFILE" | awk -F_ '{print $1}')
			COLOR=$(echo "$TARFILE" | awk -F_ '{print $2}')

			echo "-------------OUTPUTs---------------"
			echo "BORDER: $BORDER"
			echo "ICON: $ICON"
			echo "TARDIR: $TARDIR"
			echo "TARFILE: $TARFILE"
			echo "SRCDIR: $SRCDIR"
			echo "SRCFILE: $SRCFILE"
			echo "CATEGORY: $CATEGORY"
			echo "TYPE: $TYPE"
			echo "COLOR: $COLOR"
			echo "-------------OUTPUTs---------------"

###CREATE DIRECTORIES

			if [ ! -d  nopacity/$TYPE/colored/$COLOR/$CATEGORY ] ; then
                        	mkdir -p nopacity/$TYPE/colored/$COLOR/$CATEGORY
        	        fi

                	if [ ! -d  nopacity/$TYPE/grey/$COLOR/$CATEGORY  ] ; then
                        	mkdir -p nopacity/$TYPE/grey/$COLOR/$CATEGORY 
                	fi
###CONVERT TO ICON
			convert -gravity center -composite "$TARDIR/"$TARFILE".png" "$SRCDIR"_small/"$SRCFILE" "nopacity/$TYPE/colored/$COLOR/$CATEGORY/$SRCFILE"
			convert -gravity center -composite "$TARDIR/"$TARFILE".png" "$SRCDIR"_small_grey/"$SRCFILE" "nopacity/$TYPE/grey/$COLOR/$CATEGORY/$SRCFILE"

		fi
	done
done
echo "Everything done"
echo "Please have a look to nopacity and check if everything is OK"
exit
