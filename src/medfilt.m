function [edx_medfilt] = medfilt(edx_map,smoothing_size, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord)
%Anisotropic Diffusion Filter
    edx_medfilt = medfilt2(edx_map,[smoothing_size smoothing_size]);
    x=[0 max(X_coord)];
    y=[0 max(Y_coord)];
    figure('Name', sprintf('2D Median Filtering of %s', elements(element,1)));
    max_at_perc=max(edx_medfilt,[],"all");
    custom_colour_map(lower_colour, upper_colour, max_at_perc);
    image(x,y,edx_medfilt);
    c=colorbar;
    c.Label.String = strcat(element_name, '(at%)');
    axis image
    xlabel('μm')
    ylabel('μm')
    fontsize(16, "points")
    %save it
    file_name_medfilt_fig=strcat(output_file_directory,'\', element_name, '_medfilt_map.fig'); %save it
    file_name_medfilt_png=strcat(output_file_directory,'\',element_name,'_medfilt_map.png');
    print(gcf,file_name_medfilt_png,'-dpng','-r600');
    savefig(gcf,file_name_medfilt_fig);
end
