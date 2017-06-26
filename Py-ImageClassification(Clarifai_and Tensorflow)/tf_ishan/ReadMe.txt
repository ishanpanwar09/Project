How to access files of this project-

1. April_26_5PM Folder:
	* This folder contains files for metadata extraction using Clarafai.
 	* Use ‘ImportFiles_Python’ folder to get metedata extracted from images.

2. metadata_extracted Folder:
	* contains metadata extracted from step 1 for further usage.
	* did not create a single workflow because clarifai’s free access has limitations and requires 	   payment for this service.

3. All_Class_Plot.R:
	* Gives a plot of overlapping classes by reading data from Step 2

4. word2Vec graph.ipynb:
	* Creates similarity graphs and shows the predictions for a keyword
	* reads the data from step 2

5. Clustering:
	* Creates cluster
	* reads the data from step 2

6. Docker:
	* Needs a separate folder and uses Tensorflow_Classification
	* Needs docker to train the model
	* after training the model is used via python
	* this process is very particular about working directory
