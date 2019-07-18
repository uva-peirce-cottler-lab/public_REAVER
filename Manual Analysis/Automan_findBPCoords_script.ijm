// Finding branchpoints
getSelectionCoordinates(xCoordinates, yCoordinates); 
for(i=0; i<lengthOf(xCoordinates); i++) { 
setResult("X", i, xCoordinates[i]); 
setResult("Y", i, yCoordinates[i]); 
} 
updateResults(); 
