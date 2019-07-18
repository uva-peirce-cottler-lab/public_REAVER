
// Output: 2 channel image, [segmentation=red, grayscale=cyan]

// Duplicating
name("Original")
run("Duplicate...", " ");
rename("input_img");
run("Duplicate...", " ");
rename("processed_img");

// Remove outliers
run("Remove Outliers...", "radius=4 threshold=40 which=Bright");

// Local thresholding
run("Auto Local Threshold", "method=Phansalkar radius=100 parameter_1=0 parameter_2=0 white");

// Despeckling
run("Despeckle");

// Find small islands of signal and remove
run("Analyze Particles...", "size=0-100 show=Masks clear");
run("XOR...", "value=11110000");
run("Make Binary");
rename("particle_bw");

// Subtract particle image from auto_threshodled image
imageCalculator("Subtract create", "processed_img","particle_bw");
rename("clean_threshold_bw");
close("processed_img");
close("particle_bw");

// Binary Operations
run("Open");
run("Median...", "radius=4");

// Combine thresholded image with original image
run("Merge Channels...", "c1=clean_threshold_bw c5=input_img create");

// Making the input_img brighter to make it easier to adjust the image later
Stack.setChannel(5);
setMinAndMax(0, 128);
Stack.setChannel(1);