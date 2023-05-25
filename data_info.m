function[elements,composition_extension, elements_extension, no_of_elements]=data_info(h5_file)

composition_extension='/1/EDS/Data/Composition/';
info=h5info(h5_file,composition_extension);
datasets=(info.Datasets);
Name='Name'; 
elements_list=convertCharsToStrings([datasets(:).(Name)]);
elements_w_extra = split(elements_list,'Wt%'); %creates one more row than you need
elements=elements_w_extra(1:end-1);
no_of_elements=length(elements);

file_extension=strcat("/", elements, "Wt%/");
elements_extension=append(composition_extension,file_extension);

end