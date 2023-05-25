function [fig_piechart] = kmeans_pie(PhaseNum,ResultsMedian, elements, no_of_elements, upper_colour_elements, output_file_directory, type)
%Pie chart of the k-means clusters
    fig_piechart=figure('Name', sprintf('Pie for Phase %d', PhaseNum));
    hPieComponentHandles = pie(table2array(ResultsMedian(PhaseNum,1:end-1)), elements);
    title(sprintf('Phase %d', PhaseNum))
    for k = 1 : no_of_elements
      % Create a color for this sector of the pie
      pieColorMap = upper_colour_elements(k,:)/255;  % Color for this segment.
      % Apply the colors we just generated to the pie chart.
      set(hPieComponentHandles(k*2-1), 'FaceColor', pieColorMap);
    end
    fig_piechart.WindowState='maximized';
    fontsize(16, "points")
    file_name_piechart=strcat(output_file_directory,'\', type, sprintf('_piechart_phase%d.fig', PhaseNum)); %save it
    file_name_piechart_png=strcat(output_file_directory,'\', type, sprintf('_phase%d_piechart.png', PhaseNum));
    print(gcf,file_name_piechart_png,'-dpng','-r600');
    savefig(file_name_piechart);
end