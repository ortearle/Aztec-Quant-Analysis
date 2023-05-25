Aztec Analysis
Written by Rebecca Tearle - many thanks to Rob Scales & Phani for their help in the code development.

What can this code do?
	Output your Aztec figures with an at%/wt% scale bar
	Find the phases in your EDX map and characterise them (pie chart and histogram)


What do I need to do on the SEM/Aztec?
	Run a map
	Leave it a long time (makes everything else quicker and better)
		>30 mins on Evo
		Dwell time in layer details of >1ms (see edx_instructions in info)
	Post processing
		1. Run a TruMap
		2. Run a Quant Map
		3. Right-click on the site and select export to h5oina (see how_to_export in info)
	

What do I need to do in the code?
Everything you need to change is in user inputs. This allows you to tell the code exactly what you want.

h5_file : This is the file path to the h5oina file exported.
output_file_directory: Input the file path of the folder where you'd like the outputs saved.
convert_atomic: "yes" if you want clustering
no_colour_bar_image: If you'd like to do image analysis on the outputs, selecting "yes" will export the map alone.
smoothing: Set to yes if you'd like to do phase analysis.
all_smoothing: If you're not sure what smoothing will work best for you, set this to "yes" to get all three methods outputted (the code will show you all of the options, and then allow you to choose which one if you are doing phase analysis).
fave_filter: This allows you to only smooth with the filter you want to use, saving you some time watching the computer do all three! 
			If you want all of them, set it to 0, 1 for median, 2 for Wiener, 3 for Combined.
smoothing_size: This defines the area of pixels that are involved in the smoothing process.
			The minimum value of this is 3, and it must be an odd number. 
			Recommend to start at 3 and only increase if you think it's necessary.
k_clustering: Set to yes if you'd like to do phase analysis.
num_phases: Set this to however many phases you think you have. The computer will calculate the optimum for k-means later*
optimise: set to "yes" for the computer to calculate the optimum, "no" if you want to use your number.*
box_plot_output: If you'd like your phase data outputted as a box plot, set to "yes". This tends to really highlight the noise in the data and is more a legacy feature.
			Recommend "no".
histogram_output: This shows your phase composition. 
				Recommend "yes" as it will give you insight into the nature of the phase (wide existence region or narrow etc.) 
				& if the histogram comes in two peaks tells you to try adding more phases!
        You will also get a piechart.

Correlating with the premier.
premier_correlate: "yes" if you want to correlate with the Premier
microscope: 1 or 2. 1 for EVO, 2 for Tescan (1 if you want it the same way up as Aztec has it)

* whilst the computer calculates the optimum, the histogram outputs will indicate if there might be two phases hidden in one. The output dev_ideal tells you the percentage difference in Calinski-Harabasz index between the different clusters to also inform this decision. 
You can change the number of clusters in the kmeans clustering for phase analysis section to avoid re-running the code (remember to comment this out afterwards!).
 

Types of smoothing:
This code aims to remove the 'salt and pepper noise' in the data. There are three different methods to do this:
1. 2D Median Filtering: This is the harsher of the two MATLAB functions. 
				This selects the median of the values in a x by x area around a pixel.
				https://uk.mathworks.com/help/images/ref/medfilt2.html
2. Wiener Filtering:	This is the least harsh filtering.
				This is a linear filter that assumes no change in the signal over time. 
				It uses statistics to remove additive noise.
				https://uk.mathworks.com/help/images/ref/wiener2.html
				https://en.wikipedia.org/wiki/Wiener_filter
3. Combine: 		This performs a Wiener Filter followed by a 2D Median Filter. 


					





