patchinfo=/tmp/PatchInfos2.xml

if [ ! -d Patches ]; then mkdir Patches; fi

wget http://patcher.blackprophecy.com/PatchInfos2.xml -O $patchinfo
version=`cat version`

patchfile=`cat $patchinfo | grep "<$version File" | cut -d= -f2 | cut -d\\" -f2`
while [ `expr length "$patchfile"` -gt 2 ]
do
	echo -e "Found new Patch-File: $patchfile\nDownloading file.\n"
	filename=`echo $patchfile | cut -d\/ -f6`
	if [ -f ./Patches/$filename ]
	then
		echo -e "file already exists, using that file\n"
	else
		wget $patchfile -O ./Patches/$filename
	fi
	wine ./BIN/WIN32/RTpatch.exe ./Patches/$filename
	version=`cat version`
	patchfile=`cat $patchinfo | grep "<$version File" | cut -d= -f2 | cut -d\\" -f2`
done

echo "Gameversion: $version"
echo "Game is up2date, do you want to start it now?"
read -r -p \(y\/n\) -s -n 1 startgame
if [ $startgame = "y" ]
then
echo -e "\nExecuting Black Prophecy\n"
wine ./BIN/WIN32/BlackProphecy.exe -config system_Shinava.xml ### Change this line if you have 64 bit or want to start in window mode
else
echo -e "\nQuit"
fi

rm /tmp/PatchInfos2.xml