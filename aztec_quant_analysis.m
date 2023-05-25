% for this code to work you need to export the composition as wt%
%first do a trumap, then a quant map -> export h5iona file (right click on
%the site you want, it saves automatically into a new folder)

%make sure to predefine the colours you want in Aztec
%the longer you leave your map the better this code works!

% Written by Rebecca Tearle with help from Rob Scales and Phani 
clc
close all
clear
clearvars
addpath src

% stuff to add:
% get the pie chart to remove labels <1%
%% user inputs
%input the file path for the h5 file
h5_file="C:\Users\rebec\OneDrive\Desktop\12 04 800deg\12 04 800deg dsc\800 deg dsc\h5oina\molten particle\800 deg dsc Specimen 2 Site 6 Map Data 14.h5oina";
%input the file path of where you would like the figures to be saved
output_file_directory="C:\Users\rebec\OneDrive\Desktop\12 04 800deg\12 04 800deg dsc\800 deg dsc\h5oina\molten particle\1";
%convert to atomic: "yes" or "no"
convert_atomic="yes";

%image without colour bar as png "yes" or "no" - this saves the raw output
%without a colour bar (and the k-means clustered image if you have
%selected
%this)
no_colour_bar_image="no";

%smoothing of data "yes" or "no" - for other functionality this must be
%done in at% 
smoothing="yes";

%smoothing types
%Info about decision: 

% try them all? yes/no
all_smoothing="no";

%know your fave? (0) I want them all, (1) MedFilt (median filter), 
% (2) Wiener, (3) Combine, 
fave_filter=1;

%smoothing size - this must be an odd number greater than or equal to 3. The larger the
%number, the more the image is smoothed. I recommend starting at 3 and
%increasing only if necessary.
smoothing_size=7;

%k means clustering analysis "yes" or "no"
k_clustering="yes";
%estimate the number of phases in your SEM map - this will be the number of
%clusters in the analysis. Later on, if optimise = "yes", the computer will determine the
%optimum which you can pick alternatively then.
num_phases=4;

%optimise : set to "yes" if you want the computer to do this. 
optimise="no";

%how many k-means attempts.
% the bigger the number the better, but if you want a quick attempt, set
% this to a lower number
%100 will take ages on bigger data sets but is recommended
% 10 was reasonably quick for tescan data
% as a minimum, this should be 5
NumAttempts=100;

%k-means outputs
box_plot_output="no"; % recommend "no" as histogram output is more meaningful and outliers distract from data
histogram_output="yes";

%the code will also output txt files of key stats
%% Correlating with premier: don't touch unless needed
% if you're correlating with the Premier nanoindenter - "yes"
% if you just want an EDX map analysed - "no"
premier_correlate="yes";
%microscope info: for correlation with the EVO: 1 ; for correlation with the
%Tescan: 2; 
%don't worry about this if you're not correlating with the Premier
% Basically if you took your edx the wrong way up to the indents on the
% Premier select 2. If it's the same way up, 1
microscope=1;

% If your images aren't the same way up as your indents, please look into
% create_maps -> reshaping time

%% Reading the file and creating file extensions

[elements,composition_extension, elements_extension, no_of_elements]=data_info(h5_file);%this creates a list of elements, file extension for composition folder and the elements

%% collect edx data - this gets the data from the maps
[elemental_info, no_of_pixels, X_coord, Y_coord] = collect_edx_data(h5_file, elements_extension, no_of_elements);

%% this will convert data to at% if specified as wanted above

 if convert_atomic=="yes"
         [elemental_info_atperc]=atomic_conversion(h5_file, elements_extension, no_of_elements, elemental_info, no_of_pixels);
         edx_data=elemental_info_atperc;
 else
         edx_data=elemental_info; %keep in wt%
 end
%% create image
upper_colour_elements=zeros(no_of_elements,3);

 for i=1:no_of_elements
     element=i;
    [X_pixels, Y_pixels, edx_map, edx_smooth, edx_smooth_wiener, edx_smooth_combine, upper_colour]= create_maps(h5_file,elements_extension, elements, element, edx_data, output_file_directory, convert_atomic,... 
        no_colour_bar_image, smoothing, smoothing_size,all_smoothing, fave_filter, X_coord, Y_coord, premier_correlate, microscope);
 
    upper_colour_elements(i,:)=upper_colour;
    if i ==1
        NoSmooth= edx_map;
        AllSmooth = edx_smooth;
        AllSmooth_Wiener= edx_smooth_wiener;
        AllSmooth_Combine=edx_smooth_combine;
    else
        NoSmooth=cat(3, NoSmooth, edx_map);
        AllSmooth = cat(3, AllSmooth, edx_smooth);
        AllSmooth_Wiener=cat(3,AllSmooth_Wiener, edx_smooth_wiener);
        AllSmooth_Combine=  cat(3, AllSmooth_Combine, edx_smooth_combine);
    end
% 
 end

%% optimising k-means clustering
%you have the option to run 3 types of smoothing - these all aim to remove
%salt and pepper noise. 
%https://uk.mathworks.com/help/images/ref/medfilt2.html
%https://uk.mathworks.com/help/images/ref/wiener2.html

clc; close all;
 type_list=["2D Median", "Wiener", "Combined", "None"];
% 
 if k_clustering=="yes"
     if all_smoothing=="yes"
     prompt = "Which smoothing do you want? 1 (2D Median Filter), 2 (Wiener), 3 (Combination) or 4 (None)";
     x=input(prompt);
     type=type_list(1,x);
     else 
     x=fave_filter;
     type=type_list(1,x);
     end
 end
% 
 if x==1
     Smoothed_EDX=AllSmooth;
 end 
     if x==2
         Smoothed_EDX=AllSmooth_Wiener;
     end
         if x==3
             Smoothed_EDX=AllSmooth_Combine;
         end 
             if x==4
                 Smoothed_EDX=NoSmooth;
             end 
if optimise=="yes"
 [Optimal_K, num_phases, dev_ideal]=optimise_k_means(Smoothed_EDX, no_of_elements, no_of_pixels,num_phases);
end
%% kmeans clustering for phase analysis


%If smoothing is set to yes, you will see the unfiltered image followed by
%each of these options in order (all will save to the output directory file too)

%if you'd like to try another number of phases, run the line below in the
%command window and re-run this section.
%Recommend using the histograms outputted to see if you need to increase
%from the "optimum" given by computer
%num_phases=3;

if k_clustering=="yes"
if x==1
        [ResultsMean_medfilt,ResultsMedian_medfilt,ResultsStd_medfilt, figKMC_medfilt,percent_outliers_medfilt] = k_means_cluster(num_phases,AllSmooth, upper_colour_elements, no_of_elements, elements, output_file_directory, type, no_colour_bar_image, box_plot_output, histogram_output, X_coord, Y_coord, NumAttempts);
        av_std_medfilt=mean(table2array(ResultsStd_medfilt));
        writetable(ResultsMean_medfilt,strcat(output_file_directory, '\',  type, '_results_mean.txt'));
        writetable(ResultsMedian_medfilt,strcat(output_file_directory, '\',  type, '_results_median.txt'));
        writetable(ResultsStd_medfilt,strcat(output_file_directory, '\',  type, '_results_std.txt'));
        writetable(percent_outliers_medfilt,strcat(output_file_directory, '\',  type, '_perc_outliers.txt'));
end 
        if x==2
            [ResultsMean_Wiener,ResultsMedian_Wiener, ResultsStd_Wiener, figKMC_Wiener, percent_outliers_Wiener] = k_means_cluster(num_phases,AllSmooth_Wiener, upper_colour_elements, no_of_elements, elements, output_file_directory, type, no_colour_bar_image, box_plot_output, histogram_output,X_coord, Y_coord, NumAttempts);
            av_std_wiener=mean(table2array(ResultsStd_Wiener));
            writetable(ResultsMean_Wiener,strcat(output_file_directory, '\',  type, '_results_mean.txt'));
            writetable(ResultsMedian_Wiener,strcat(output_file_directory, '\',  type, '_results_median.txt'));
            writetable(ResultsStd_Wiener,strcat(output_file_directory, '\',  type, '_results_std.txt'));
            writetable(percent_outliers_Wiener,strcat(output_file_directory, '\',  type, '_perc_outliers.txt'));
        end
            if x==3
                [ResultsMean_Combine,ResultsMedian_Combine, ResultsStd_Combine, figKMC_Combine, percent_outliers_Combine] = k_means_cluster(num_phases,AllSmooth_Combine, upper_colour_elements, no_of_elements, elements, output_file_directory, type, no_colour_bar_image, box_plot_output, histogram_output, X_coord, Y_coord, NumAttempts);   
                av_std_combine=mean(table2array(ResultsStd_Combine));
                writetable(ResultsMean_Combine,strcat(output_file_directory, '\',  type, '_results_mean.txt'));
                writetable(ResultsMedian_Combine,strcat(output_file_directory, '\',  type, '_results_median.txt'));
                writetable(ResultsStd_Combine,strcat(output_file_directory, '\',  type, '_results_std.txt'));
                writetable(percent_outliers_Combine,strcat(output_file_directory, '\',  type, '_perc_outliers.txt'));
            end
                if x==4
                    [ResultsMean_NoSmooth,ResultsMedian_NoSmooth, ResultsStd_NoSmooth, figKMC_NoSmooth, percent_outliers_NoSmooth] = k_means_cluster(num_phases,NoSmooth, upper_colour_elements, no_of_elements, elements, output_file_directory, type, no_colour_bar_image, box_plot_output, histogram_output, X_coord, Y_coord, NumAttempts);   
                    av_std_nosmooth=mean(table2array(ResultsStd_NoSmooth));
                    writetable(ResultsMean_NoSmooth,strcat(output_file_directory, '\',  type, '_results_mean.txt'));
                    writetable(ResultsMedian_NoSmooth,strcat(output_file_directory, '\',  type, '_results_median.txt'));
                    writetable(ResultsStd_NoSmooth,strcat(output_file_directory, '\',  type, '_results_std.txt'));
                    writetable(percent_outliers_NoSmooth,strcat(output_file_directory, '\',  type, '_perc_outliers.txt'));
                end 

close all
end 

