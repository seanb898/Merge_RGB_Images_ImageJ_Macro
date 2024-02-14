// Macro to merge 3 open images (Red, Green and Blue):


/* Rules for this Macro to work:
 *  
 *  The colour of the image must be at the start of the image file name e.g. Red, Green or Blue.
 *  The colour name must be followed with an underscore "_".
 *  The only full stop in the image file name allowed is the final one before the image format is displayed i.e. imagename.tif
 *  The code relies on the underscore and full stop being in the right places to rename the merged image correctly. 
 *  Each red, blue and green image of a given area should have the same name other than their prefix, which ascribes their colour.
 *  No other images can be open, the macro will not function properly otherwise.
 *  
 */


// Select Image Directory and define the parent directory to store merged composiste images

Input_Folder = getDirectory("Select the folder containing the images for analysis");

parentdirectory = File.getParent(Input_Folder);

File.makeDirectory(parentdirectory + "/Merged_RBG_Images");


// Open the 3 images required for merging with a loop function in the parent directory


List_files = getFileList(Input_Folder);

	for (i = 0; i < 3; i++) {        
		
		open(Input_Folder + "/" + List_files[i]);
			
	}

  
// Obtain a list of open image titles

list = getList("image.titles");

list_1 = list[1]; // variable defined here so new composiste image can be renamed later on once the orginal images have been closed by the script.
	

// This loop renames each of the 3 images based on the first word of the file name, the last character of which is defined by the presence for the first underscore.


for (i=1; i <= list.length; ++i) {
	
	selectImage(i);
	
		Image_X = getTitle();
		
		_ImageX = indexOf(Image_X,"_");
			
		Prefix_Image_X = substring(Image_X, 0, _ImageX); 
		
		rename(Prefix_Image_X);	
}


// This command merges the images using the renamed images

run("Merge Channels...", "c1=Red c2=Green c3=Blue create");


// Rename the composiste image based on the orignal Image names

index1_ = indexOf(list_1, "_"); // Finds the index of the first underscore
			
		
indexLessExt = lastIndexOf(list_1,"."); // Finds the index of the last character before the extension (i.e. just before '.tif')
		
sub_list_1 = substring(list_1, index1_ +1, indexLessExt);   // the index1_ +1 Makes the substring not include the underscore for the new image title.

	Merged_Image_Name = sub_list_1 + " Merged"; // Creates the variable that defines the final merged image name.

rename(Merged_Image_Name);

// Saves the image in the parent directory of the original image files

 saveAs("Tiff", parentdirectory + "/Merged_RBG_Images/"+ Merged_Image_Name); // Is working now!!! -- Might want to make it save in a folder in the actual directory?

	wait(1000); // Lets user see the image for 1 second before closing it - can remove this step to make the macro faster.
	close();

// Creates final dialogue box to alert user that image merging process has been successful

	Dialog.create("Success");
		Dialog.addMessage("Images have been merged");
		Dialog.addMessage("The files can be found in the parent directory");
		Dialog.show();


/* Next goal for this script:  
 *  
 *  Write a loop to batch this process for each folder in a given directory that contains three images (all images must have unique names). 
 *  
 */
