function [edx_medfilt, edx_wiener,edx_combine]=smooth_maps(all_smoothing, fave_filter, edx_map, smoothing_size, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord)

if all_smoothing=="yes"
    [edx_medfilt] = medfilt(edx_map,smoothing_size, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
    [edx_wiener] = wiener(edx_map,smoothing_size,elements,element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
    [edx_combine]=combine_filter(smoothing_size,edx_map, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
else 
    x=fave_filter;
        if x==1
            [edx_medfilt] = medfilt(edx_map,smoothing_size, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
            edx_wiener=[];
            edx_combine=[];
        end 
            if x==2
                [edx_wiener] = wiener(edx_map,smoothing_size,elements,element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
                edx_medfilt=[];
                edx_combine=[];
            end
                if x==3
                    [edx_combine]=combine_filter(smoothing_size,edx_map, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
                end  
end 