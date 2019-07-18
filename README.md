# REAVER
Vessel Segmentation Program

## Dependencies:
* Tested on MATLAB 2018b, requires image processing toolbox.

## Set-up Instructions
1. Download the latest version of REAVER from https://github.com/uva-peirce-cottler-lab/REAVER.
2. Click the green button "Clone or Download" on the right side of the web page and then "Download Zip".
3. Download file and extract the contents.

## Initialization
4. Open the extract folder and open "USER_INITILIZE.m"
5. Run the script file by pressing the run button in the ribbon menu (green triangle). All matlab files in repository will get added to the matlab path and REAVER will open.

## Using REAVER
1. Once open, go to the menu "File >> Load Directory", and browse to the directory in images to be analyzed.
2. Image names will population the image table on the left. Select the image to be analyzed in the table and the image will load.
3. Enter the image resolution in units of micrometer per pixel.
3. Visualize the channels as necessary for visual inspection by controlling which are visible with the "Displayed Channel" panel.
5. Select the color channel that is meant to be processed in the "Input Channel" panel.
6. Click on Segment image.
7. The image will be displayed with a green outline and white skeleton by default (color can be changed in "Image" menu).
8. Inspect the image as necessary and change parameter if needed, including the grey threshold (pixel level above background) or the parameters that are accessed by clicking on the gear button.
9. To compare the segmentation to the original image, select the "Displayed Channels" and "Secondary Binary" image to inspect, and then hit spacebar to quickly toggle between them.
10. Manually add to the segmentation (what is considered vessel, surrounded by green border) by left clicking and dragging. Right click and dragging will remove pixels from segmentation. Adjust the cursor edit size as necessary.
11. When done click "Save Data".
12. Move onto the next image, or auto process all images at once in the folder by going to "Data >> Process All Images".
13. When finished, the output metrics are quantified by running "Data >> Quantify All Images". Output metrics for each image are saved CSV file in the same folder where the images are found.
14. To export the binary segmentation images, go to "Data >> Export Binary of All Images", the image segmentation (black and white of what is vasculature) will be saved in a subfolder 'bw' found within the currnet image folder. These images can be used to evaluate cellular colocalization with the vasculature.
