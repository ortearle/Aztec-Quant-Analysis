function [edx_wiener] = wiener(edx_map,smoothing_size,elements,element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord)
% Wiener filtering of edx map https://uk.mathworks.com/help/images/ref/wiener2.html

    edx_wiener = wiener2(edx_map,[smoothing_size smoothing_size]);
    x=[0 max(X_coord)];
    y=[0 max(Y_coord)];
    figure('Name', sprintf('Wiener Filtering of %s', elements(element,1)));
    max_at_perc=max(edx_wiener,[],"all");
    custom_colour_map(lower_colour, upper_colour, max_at_perc);
    image(x,y,edx_wiener);
    c=colorbar;
    c.Label.String = strcat(element_name, '(at%)');
    axis image
    xlabel('μm')
    ylabel('μm')
    fontsize(16, "points")
    %save it
    file_name_wiener_smooth_fig=strcat(output_file_directory,'\', element_name, '_wiener_smooth_map.fig'); %save it
    file_name_wiener_smooth_png=strcat(output_file_directory,'\',element_name,'__wiener_smooth_map.png');
    print(gcf,file_name_wiener_smooth_png,'-dpng','-r600');
    savefig(gcf,file_name_wiener_smooth_fig);
end
