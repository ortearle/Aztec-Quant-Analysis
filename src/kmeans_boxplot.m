function [percent_outliers] = kmeans_boxplot(PhaseNum,Phase_Element_Data, elements, output_file_directory, type, no_of_elements, box_plot_output, NumClusters)
%k-means box plotting 
if box_plot_output=="yes"
figure('Name', sprintf('Box Plot for Phase %d', PhaseNum));
boxplot(Phase_Element_Data,elements);
title(sprintf('Box Plot for Phase %d', PhaseNum))
ylabel('Atomic %')
percent_outliers_phase=zeros(1,no_of_elements);
fontsize(16, "points")

file_name_boxplot=strcat(output_file_directory,'\', type, sprintf('_phase%d_boxplot.fig', PhaseNum)); %save it
file_name_boxplot_png=strcat(output_file_directory,'\', type, sprintf('_phase%d_boxplot.png', PhaseNum));
print(gcf,file_name_boxplot_png,'-dpng','-r600');
savefig(file_name_boxplot);
end

for j=1:no_of_elements
    element_data=Phase_Element_Data(:,j);
    total_pixels_phase=size(element_data,1);
    idx = isoutlier(element_data,'quartiles');
    outliers = element_data(idx,:);
    num_outliers=size(outliers,1);
    percent_outliers_phase(:,j)=100*(num_outliers/total_pixels_phase);
    percent_outliers(PhaseNum,j)=percent_outliers_phase(:,j);
end 



end
