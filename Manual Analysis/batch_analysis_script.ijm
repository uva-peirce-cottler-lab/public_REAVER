input  = getDirectory("Choose a Directory") ;

processFolder(input);

function processFolder(input){
	list = getFileList(input);
	for(i=0; i<list.length; i++){
		if(endsWith(list[i],'tif'))
			processFile(input, list[i]);
	}
}

function processFile(input, file){
	open(input+file);
	run("Make Composite");
	Stack.setChannel(2);
	run("Duplicate...", "title=skeleton_bw");
	
	run("Convert to Mask");
	run("Set Measurements...", "integrated redirect=None decimal=3");
	run("Measure");
	
	setResult("File",nResults-1,File.name);
	setResult("Skel_Length",nResults-1,getResult("RawIntDen", nResults-1)/255);
	close("skeleton_bw");
	close(File.name);
}

selectWindow("Results");
saveAs("Results", input+"Results.csv");


