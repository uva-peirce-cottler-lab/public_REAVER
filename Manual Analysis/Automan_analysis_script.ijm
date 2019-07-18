macro "Automan_analysis_script"{
// Get skeleton and display number of pixels
rename("Composite");
Stack.setChannel(2);
run("Duplicate...", "title=skeleton_bw  channels=3");

run("Analyze Skeleton (2D/3D)", "prune=[shortest branch]");
for(i=0; i<nResults; i++) {
    	total_junc += getResult("# Junctions", i);
    }
close("Results");
print("Branchpoints: " + total_junc);

// Get VLD
//run("Set Measurements...", "area area_fraction redirect=None decimal=3");
//run("Measure");
//print("Skeleton Length Pix: " + getResult("%Area", 0) + "%");
//close("Results");
//close("skeleton_bw");

// Get Total number of Skeleton Pixels
run("Convert to Mask");
run("Set Measurements...", "integrated redirect=None decimal=3");
run("Measure");
print("Skeleton Length (Pix): " + getResult("RawIntDen", 0)/255);
skel_length = getResult("RawIntDen",0)/255;
close("Results");
close("skeleton_bw");
close("Tagged skeleton");

// Get network seg and display area
//Stack.setChannel(1);
//run("Duplicate...", "title=segmentation_bw  channels=1");
//run("Convert to Mask");
//run("Set Measurements...", "area area_fraction redirect=None decimal=3");
//run("Measure");
//print("VAF: " + getResult("%Area", 0) + "%");
//close("Results");
//close("segmentation_bw");

// Get network seg and display area
Stack.setChannel(1);
run("Duplicate...", "title=segmentation_bw  channels=1");
run("Convert to Mask");
run("Set Measurements...", "integrated redirect=None decimal=3");
run("Measure");
print("Segementation Area (Pix): " + getResult("RawIntDen", 0)/255);
close("Results");
close("segmentation_bw");

// Get mean VR
run("Duplicate...", "title=mask duplicate channels=2");
setOption("BlackBackground", false);
run("Make Binary");

selectWindow("Composite");
run("Duplicate...", "title=distance_map duplicate channels=1");
run("Geometry to Distance Map", "threshold=128");
imageCalculator("Multiply create", "distance_map_EDT","mask");
selectWindow("Result of distance_map_EDT");
run("Divide...", "value=255");
run("Multiply...", "value=2");
run("Set Measurements...", "integrated redirect=None decimal=3");
run("Measure");
int_den = getResult("IntDen", 0);
mean_diam = int_den/skel_length;
print("Mean Vessel Diameter: " + int_den/skel_length);
close("Results");
close("Result of distance_map_EDT");
close("mask");
close("distance_map_EDT");
close("distance_map");
}
