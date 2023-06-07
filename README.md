# REAVER
Rapid Editable Analysis of Vessel Elements Routine.

![Screenshot of REAVER program](https://github.com/uva-peirce-cottler-lab/public_REAVER/blob/8b5b2f58d9bc2fc243f7c66999b4323b009c3f71/media/reaver_screenshot.png)

## External Links
1. Preprint of manuscript: .
2. Download vessel network benchmark image dataset used in manuscript: https://doi.org/10.5281/zenodo.3340165.
3. Additional output images that were used in some of the figures: https://drive.google.com/file/d/1g-HQW14lRk6NmEGbweIxZYZ13WiOQSYR/view?usp=sharing.

## Dependencies:
* Tested on MATLAB 2018b, requires image processing toolbox.

## Set-up Instructions
1. Download the latest version of REAVER source code from: https://github.com/uva-peirce-cottler-lab/public_REAVER
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


## Output Metrics
* These metrics are calculated when images are analyzed and output into a csv file.
1. **vessel_area_fraction**: fraction of pixels in image that belong to a blood vessel (*units*: none, fraction).
2. **vessel_length_um**:  length of centerline of blood vessels, used as a metric of vessel density, but images have to be acquired with same parameters (not informative across studies with different acquisition parameters) (*units*: micrometers, determine by pixel length and resolution of image).
3. **vessel_length_density_mmpmm2**: length of centerline (milimeters) of blood vessels normalized by the physical image area (milimeters^2), this metric is used for vessel density and is a little more comparable across studies with different systems and magnifications, although the same image volume must be used (same number and thickness of zsices if analyzed from a flattened zstack). (*units*: mm/mm^2).
4. **branchpoint_count**: number of branchpoints in vessel network (calcualted from branchpoints of vessel centerline). This is used as a metric of vessel density that looks at the complexity of the network. If compared across image settings, should be normalized to image field of view with consistent image volume (*units*: none, count).
5. **segment_count**: number of segments in vascular network, calculated from the vessel centerline (specically all line segments of centerline between two branchpoints or a branchpoint and the end of the image). Used to look at complexity of network very similiar to branchpoint count (but not used as often). Just like with branchpoint count, should be normalized to image field of view with consistent image volume (*units*: none, count).
6. **mean_segment_length_um**: Average physical length of segments that is used to calculate the branchpoint count. Another measure of complexity of the vascular network, with higher complexity networks having smaller values (*units*: micrometers).
7. **mean_tortuosity**: how tortuose blood vessel segments are. Calculates score for each segment and then computes the mean for each image. High value means more tortuous, where the vessel take a longer path to reach its endpoint compared to traveling in a straight line between endpoints (*units*: none, distance/distance).
8. **mean_valency**: measure of complexity of a vessel network (higher is more complex). Calculated with the ratio of branchpoint_count to segment_count (*units*: none, ratio of counts).
9. **mean_segment_diam_um**: measures the mean diameter (thickness) of vessels. Calculates diameter for each vessel and then computes mean (*units*: um).
10. **max_diffusion_dist_um** (not ready for use in publication): measures how effective oxygen coverage is for a tissue by examining on average how far away tissue is from a blood vessel. Higher values mean less oxygen delivered to surroudning tissue (*units*: micrometers).
