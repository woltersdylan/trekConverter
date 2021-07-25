#!/bin/bash
#
# This script is designed for comics included with the Star Trek Complete Comic
# Book Collection

# Defines expected list of arguments
optstring=":hzbD"

# General help/usage function
function help {
	echo "Usage: trekconv [-hzbD] /path/to/directory/"
	echo
	echo "     This script requires the following dependencies:"
	echo "     imagemagick, rar, zip"
	echo 
	echo "     -h   Displays this help message"
	echo "     -z   Converts files into .CBZ format (Default is .CBR)"
	echo "     -b   Removes extra/blank pages (Such as black pages)"
	echo "     -D   Delete the original PDF files when script is done"
	echo "      An absolute directory is required and can be passed anywhere." 
	echo
	exit 1
}

# Applies correct conditions based on arguments
while getopts ${optstring} opts;  do
	case "${opts}" in
	 h)
	    echo 
	    help
	    exit 1 
	    ;;
	 z) ftype=cbz ;;
	 b) blk=1 ;;
	 D) rmv=1 ;;
	 ?)
	    echo "Invalid option: -${optarg}"
	    echo
	    help
	    exit 1
	    ;;
	esac
done

# Finds which argument is a directory, and checks if the directory is absolute.
for arg in "$@"
do
	if [ -d "$arg" ] && [[ "$arg" = /* ]]; then
		dir="$arg"
	elif [ -d "$arg" ] && [[ "$arg" != /* ]]; then
		echo "ERROR: The directory provided is not absolute."
		echo "Run trekconv -h for more information."
		exit 1
	fi
done

# Checks that the appropriate directory variable was saved.
if [ -z ${dir+x} ]; then
	echo "ERROR: No directory was provided, or it was not properly formatted."
	echo "Run trekconv -h for more information."
	exit 1 
else 
	cd "$dir"
fi

# Checks if any PDF files are present and stores as variable.
cnt=`ls -l *.pdf | wc -l | sed -e 's/^[ \t]*//'` 
if [ $cnt = 0 ]; then
	echo "ERROR: No PDF files were found in this directory. Please check the directory and try again."
	exit 1
fi

echo 
echo "=================================================="
echo "STAR TREK COMPLETE COMIC BOOK COLLECTION CONVERTER"
echo "=================================================="
echo 
echo "The script found a total of $cnt pdf(s) in this directory."
echo 
echo "Please verify the listed files below before continuing:"
ls *.pdf
read -p $'\nPress enter to continue\n'

if ((rmv)); then 
	echo "WARNING: You have requested the original files be deleted after they are converted."
	echo "All PDFs listed above will be PERMANENTLY deleted."
	read -p $'\nPress enter to confirm deletion\n'
fi

mkdir tempFiles Converted
c=1

for f in *.pdf
do
	echo "Now converting $f ( $c of $cnt )"
	read -t 1 -p $'\n'
	echo "Retrieving individual pages from $f..."
	convert -density 200 "$f" -quality 100 tempFiles/%02d.jpg
	cd tempFiles
	mkdir conversion
	j=1

	read -t 2 -p $'\nSplitting individual files into unique pages...\n'
	ls *.jpg | sed 's/^\([^0-9]*\)\([0-9]*\)/\1 \2/' | sort -k2,2n | tr -d ' ' |
   	while read fname ; do
     		echo "Splitting:  $fname"
     		convert -crop 50%x100% +repage $fname "$fname"%d.jpg
     		mv "$fname"0.jpg conversion/0"$j".jpg
        	    ((j=j+1))
     		mv "$fname"1.jpg conversion/0"$j".jpg
        	    ((j=j+1))
	done

	if ((blk)); then
		read -t 2 -p $'\nRemoving blank/extra pages...\n'
		for image_file in conversion/*.jpg
		do
			filesize=$( wc -c "$image_file" | awk '{print $1}' )
			if [ $filesize -lt 100000 ]; then
				rm $image_file
			fi
		done
	fi
	
	cd ../Converted
	k=$(basename $f .pdf)

	if [[ $ftype = "cbz" ]]; then
		read -t 2 -p $'\nConverting pages into CBZ file...\n'
		zip -0 "$k".cbz ../tempFiles/conversion/*.jpg
	else
		read -t 2 -p $'\nConverting pages into cbr file...\n'
		rar a -ep "$k".cbr ../tempFiles/conversion/
	fi

	cd "$dir" && rm -rf tempFiles/*	
	
	if [ $c != $cnt ]; then 
		((c=c+1))
	fi	
	echo ""
done

rm -rf tempFiles/

if ((rmv)); then
	rm -rf *.pdf
fi

echo "The script successfully converted $c file(s)."
echo "The files were stored in the following directory:"
echo "${dir}/Converted"
echo ""
