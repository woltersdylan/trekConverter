# Trek Convertor

The "Trek Convertor" script was written to fit a very niche problem for owners of the *Star Trek: The Complete Comic Book Collection* DVD. If you are unfamiliar with the DVD, or wish for more information, you can find out more at the Memory Alpha wikipage [here](https://memory-alpha.fandom.com/wiki/Star_Trek:_The_Complete_Comic_Book_Collection?file=Complete_Comic_Book_Collection_cover.jpg). 

---
## The Problem:
The boxset includes PDF files for (nearly) every Star Trek comic released up until 2008. Unfortunately, the files included were double-sided scans of physical comics. This means that simply converting the PDFs into CBR/CBZ is not possible and requires extra steps. This script automates that process. 

Because this is a very specific script, it is **NOT** advised to be used for general purpose PDF->CBR/CBZ conversion. 

## Features:
1. Converts each individual PDF into a CBR or CBZ file. 
2. Splits the double-sided scans into isolated pages.
3. Can remove blank/excess pages that are present in some of the scanned PDFs.

## Installation:

The script is fairly modular, meaning you can easily run it anywhere. Simply download the `trekconv.sh` script and execute `chmod +x trekconv.sh`. 

## Dependencies:

The script relies upon `rar`, `zip`, and the `convert` command found within `imagemagick`. 

## Arguments:

Argument | Description
---------|------------
-h | Displays help dialogue
-z | Converts the PDFs to CBZ (Default is CBR)
-b | Removes blank/excess pages.
-D | Deletes original PDFs once conversion is complete
/path/to/folder/ | **REQUIRED** - Absolute path to relevant directory

## Examples

`trekconv -h` Displays the help dialogue within the terminal.

`trekconv -z /home/User/Comics` Sets the prefered output file to CBZ (Requires `zip` to be installed)

`trekconv -z -b -D /home/User/Comics` Converts the files into CBZ, removes black/empty pages, and deletes the original PDF files once complete. 

## Known Issues

- `Convert not authorized` when script is reading initial PDF.

This is a result of ImageMagick preventing `convert` execution as a safety precaution. To cricumvent this you will need to adjust your `policy.xml` file to allow PDF Read & Write. More information can be found [here](https://stackoverflow.com/questions/42928765/convertnot-authorized-aaaa-error-constitute-c-readimage-453).

- Multi-page spanning content (potentially) being split

Because of how the script is designed, it assumes all pages are double-sided. This works for the vast majority of the comics included in this set, so this problem will be fairly uncommon. However, if a comic features a two page spread (one landscape page across two pages), it will be split into two seperate pages. If this happens, no content is lost. You will simply have to swipe between the pages manually to see the relevant panels. I have yet to encounter this, but I am sure it is present at least once. Unfortunately, there is no way to account for this. 

## FAQs

- The black/blank pages are annoying, why not remove them by default?

Though I have yet to encounter any problems with blank pages being successfully detected and removed, it is still theoretically possible. This is because they are detected based on that page's file size. The empty pages have much smaller file sizes than those with content on them. The problem this creates is that if I set the threshold too low, it won't detect anything. If I set it too high it could remove actual content from the comic. Because of this, I have decided to leave it off by default.  

If it feels like a page is missing from your converted comic, try executing the script without this argument. 

- Will this run on "X"?

I have tested this script on OpenSUSE (bash) and macOS (zsh). I do not have access to Windows and therefore cannot test it there. With that said, you should be able to successfuly execute the script using `Cygwin` on Windows. More information about that can be found [here](https://www.cygwin.com). Other solutions for Windows usage can be found [here](https://stackoverflow.com/questions/6413377/is-there-a-way-to-run-bash-scripts-on-windows). 
