// Splitting and recombining the channels
selectWindow("Composite");
run("Split Channels");
close("C3-Composite");
run("Merge Channels...", "c1=C1-Composite c2=C2-Composite c3=Original create");

// Changing the Colors
Stack.setChannel(1) 
run("Red"); 

Stack.setChannel(2) 
run("Green"); 

Stack.setChannel(3) 
run("Blue");

// Making it an RGB image
run("Stack to RGB");

// Close the false window
close("Composite");
