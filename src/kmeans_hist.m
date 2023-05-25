function [kmeans_histogram] = kmeans_hist(PhaseNum,Phase_Element_Data, no_of_elements, elements, output_file_directory, type, upper_colour_elements)
%k-means histogram
figure('Name', sprintf('Histogram of elements in Phase %d',  PhaseNum));
nbins=100;

    for ele=1:no_of_elements
        colour=upper_colour_elements(ele,:)./255;
        kmeans_histogram=histogram(Phase_Element_Data(:,ele), nbins, 'DisplayName',elements(ele,1), 'Normalization','probability', 'FaceColor', colour, 'EdgeColor', 'none');
        xlim([0 100])
        xlabel('Atomic Percent (%)')
        ylabel('Probability')
        title(sprintf('Phase %d Histogram', PhaseNum))
        hold on
    end
legend()
fontsize(16, "points")
file_name_histogram=strcat(output_file_directory,'\', type, sprintf('_phase%d_histogram.fig', PhaseNum)); %save it
file_name_histogram_png=strcat(output_file_directory,'\', type, sprintf('_phase%d_histogram.png', PhaseNum));
print(gcf,file_name_histogram_png,'-dpng','-r600');
savefig(file_name_histogram);
end
