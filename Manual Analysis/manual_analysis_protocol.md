# Manual Fiji Image Analysis Protocol
_Note: this file is in markdown format, please use an appropriate editor_
I.   Open an image
II.  Run “Automan_thresh_script.ijm”
	A.  Click “Plugins” in the menu bar
	B.  “Macros”
	C.  ”Run…”
	D.  Navigate to “Automan_thresh_script.ijm” and select it
	E.  Click “Open”
	F.  Red channel is threshold, green and blue are original so TEAL means just the 
	     original, RED means just threshold, and PINKISH to WHITE means both
III. Confirm the first channel (the threshold) is selected (scroll bar at bottom of image to left)
IV. Double click the Paintbrush tool
	A. If this is the first time, click the “>>” symbol then “Brush”
	B. Set the brush width to 20
	C. Set the color to “White”
	D. Close the pop-up box
V. Edit the Red channel until it represents an accurate segmentation of the image
	A. Left clicking will add color by default (setting the red pixels to the max value)
	B. Alt left clicking will remove color by default (setting the red pixels to the min value)
	C. Ctrl+Shift left click and dragging can change the editing size
	D. Ctrl+Z will undo only your last brush stroke
	E. Ctrl+Scroll Wheel will zoom in and out
	F. Holding down Space Bar while zoomed in will allow panning with left click and drag
	G. If the editing tool seems to stop working, try double clicking the “Color picker” tool
		1. Set the Foreground color to White
		2. Set the Background color to Black
VI. Run “Automan_skeleton_script.ijm”
	A. See documentation image “II.png”
	B. RED channel (1) is the thresholded image, WHITE channel (2) is the skeleton, and 
	    TEAL channel (3) is the original
VII. Confirm the second channel (the skeleton) is selected (scroll bar is in the center)
VIII. Double click the Paintbrush tool
	A. Set the brush width to 1
	B. Set the color to “White”
	C. Close the pop-up box
IX.  Edit the White channel until it represents an accurate skeletonization of the image
X.    Run “Automan_analysis_script.ijm”
XI.   Record the results in “Log” then close “Log”
XII.  Manually count visible branch points and record as well
	A. Select the "Multi-Point" tool in the toolbar
	B. Click nearest to each of the branchpoints
	C. Run "Automan_findBPCoords_script.ijm"
	D. Record the coordinates
		1. In the Results window, click File then Save as...
		2. Save the csv file in the same directory as the processed images with the same name as the original image file
XIII.  Run “Automan_analysis_preSave_script.ijm”
XIX. Save the image as a “Tiff” file with the same name as the original image in the “Processed 
         Images” folder
