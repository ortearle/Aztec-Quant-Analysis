function [elemental_info, no_of_pixels, X_coord, Y_coord] = collect_edx_data(h5_file, elements_extension, no_of_elements)

info_available=h5info(h5_file,elements_extension(1,1));
no_of_pixels=info_available.Dataspace.Size;
elemental_info=zeros(no_of_pixels,no_of_elements);

for i=1:no_of_elements
    elemental_info(:,i)=h5read(h5_file,elements_extension(i,1));   
end 

X_coord=h5read(h5_file,'/1/EDS/Data/X');
Y_coord=h5read(h5_file,'/1/EDS/Data/Y');
end
