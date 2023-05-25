function [X_pixels, Y_pixels, edx_map, edx_medfilt, edx_wiener,edx_combine,upper_colour] = create_maps(h5_file,elements_extension, elements, element, edx_data, output_file_directory, convert_atomic, ...
    no_colour_bar_image, smoothing, smoothing_size, all_smoothing, fave_filter, X_coord, Y_coord, premier_correlate, microscope)

% for testing 
%element= 1 ;

if premier_correlate=="no"
    microscope=1;
end 

%% %this section extracts the info needed from the data

info_element=h5info(h5_file,elements_extension(element,1));
atomic_number=info_element.Attributes.Value;
attributes=info_element.Attributes;

names_attributes_table=cell2table(({attributes.Name}'));
value_attributes_table=cell2table(({attributes.Value}'));
attributes_info(:,1)=table2array(names_attributes_table);
attributes_info(:,2)=table2array(value_attributes_table);
lower_colour=cell2mat(attributes_info(5,2));
upper_colour=cell2mat(attributes_info(6,2));
lower_colour=double(lower_colour);
upper_colour=double(upper_colour);
%% back to the coding

element_mass_table=readtable("atomic_mass_table.txt", "Delimiter", '\t');
element_name=element_mass_table.Element(atomic_number);

edx_element=edx_data(:,element); %selects the data for this element, used in figure title etc
%% 

% the info below is required for reshape
X_pixels_extension="/1/EDS/Header/X Cells";
X_pixels=h5read(h5_file, X_pixels_extension);

Y_pixels_extension="/1/EDS/Header/Y Cells";
Y_pixels=h5read(h5_file, Y_pixels_extension);
%% reshaping time!

if microscope==1
    shaped_edx_data=reshape(edx_element, [X_pixels, Y_pixels]);
    edx_map=(shaped_edx_data)'; %need to do this to make it the right way up
end 

if microscope==2
    shaped_edx_data=reshape(edx_element, [X_pixels, Y_pixels]);
    edx_transpose=(shaped_edx_data)'; %need to do this to make it the right way up
    edx_backwards=flipud(edx_transpose);
    edx_map=fliplr(edx_backwards);
end 
%% 

max_at_perc=max(edx_map,[],"all");

x=[0 max(X_coord)];
y=[0 max(Y_coord)];

figure('Name', sprintf('Unedited Map of %s', elements(element,1)));
custom_colour_map(lower_colour, upper_colour, max_at_perc);
image(x, y, edx_map);
c=colorbar;
clim([0 100])

axis image
xlabel('μm')
ylabel('μm')

if convert_atomic=="yes"
    c.Label.String = strcat(element_name, '(at%)');
else
    c.Label.String = strcat(element_name, '(wt%)');
end

%save figure
file_name_fig=strcat(output_file_directory,'\', element_name, '_map.fig'); %save it
file_name_png=strcat(output_file_directory,'\',element_name,'_map.png');
print(gcf,file_name_png,'-dpng','-r600');
savefig(gcf,file_name_fig);


%% 
if smoothing=="yes"
    smoothing_input_checks(smoothing,convert_atomic, all_smoothing, fave_filter)
    [edx_medfilt, edx_wiener,edx_combine]=smooth_maps(all_smoothing, fave_filter, edx_map, smoothing_size, elements, element, lower_colour, upper_colour, element_name, output_file_directory, X_coord, Y_coord);
end 

%% saving the figures

%save without colorbar
 if no_colour_bar_image=="yes"
     openfig(file_name_fig)
     set(gca,'xticklabel',[])
     set(gca,'yticklabel',[])
     axis off;
     set(gca,'xlabel',[])
     set(gca,'ylabel',[])
     colorbar('Visible', "off")
     file_name_png_nocb=strcat(output_file_directory,'\',element_name,'_map_nocolorbar.png');
     print(gcf,file_name_png_nocb,'-dpng','-r600');
 end

end
