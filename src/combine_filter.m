function [edx_smooth_combine]=combine_filter(smoothing_size,edx_map, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord)
    edx_smooth_1=wiener2(edx_map,[smoothing_size smoothing_size]);
    edx_smooth_combine= medfilt2(edx_smooth_1,[smoothing_size smoothing_size]);
    x=[0 max(X_coord)];
    y=[0 max(Y_coord)];
    figure('Name', sprintf('Combined Wiener and 2D Median Filtering of %s', elements(element,1)));
    max_at_perc=max(edx_smooth_combine, [],"all");
    custom_colour_map(lower_colour, upper_colour, max_at_perc);
    image(x,y,edx_smooth_combine);
    c=colorbar;
    c.Label.String = strcat(element_name, '(at%)');
    axis image
    xlabel('μm')
    ylabel('μm')
    fontsize(16, "points")
    %save it
    file_name_combine_smooth_fig=strcat(output_file_directory,'\', element_name, '_combine_smooth_map.fig'); %save it
    file_name_combine_smooth_png=strcat(output_file_directory,'\',element_name,'__combine_smooth_map.png');
    print(gcf,file_name_combine_smooth_png,'-dpng','-r600');
    savefig(gcf,file_name_combine_smooth_fig);
end
