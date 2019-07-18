// Stack the Composite to RGB
rename("Composite");
run("Stack to RGB");
close("Composite");

// Copy the original image and split it into its composite channels
run("Split Channels");

// Rename the red channel to "Segmented"
selectWindow("Composite (RGB) (red)");
rename("Segmented");

// Rename the green channel to "Original (Gray)"
selectWindow("Composite (RGB) (green)");
rename("Original_Gray");

// Close the blue channel
close("Composite (RGB) (blue)");

// Remove the segmented image from the original (gray)
imageCalculator("Subtract create", "Original_Gray","Segmented");
selectWindow("Result of Original_Gray");
rename("Removed_Gray")
close("Original_Gray");

// Copy the segmented image and rename it to "Skeleton"
selectWindow("Segmented");
run("Duplicate...", " ");
run("Make Binary");
rename("Skeleton");

// Turn the segmented image into a skeleton of its former self
run("Median...", "radius=9");
run("Skeletonize");

// Combine the three images into one SUPER image
run("Merge Channels...", "c5=Removed_Gray c1=Segmented c4=Skeleton create");
Stack.setChannel(2);

