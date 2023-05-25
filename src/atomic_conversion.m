function[elemental_info_atperc]=atomic_conversion(h5_file, elements_extension, no_of_elements, elemental_info, no_of_pixels)

% suppress varnames warning
id='MATLAB:table:ModifiedAndSavedVarnames';
warning('off',id);

element_mass_table=readtable("atomic_mass_table.txt", "Delimiter", '\t');
atomic_mass=element_mass_table.AtomicMass_u_;
atomic_figures=zeros(no_of_elements,2);

% this finds the atomic masses of all the elements needed
for i=1:no_of_elements
    extension=elements_extension(i,1);
    elements_info=h5info(h5_file,extension);
    atomic_figures(i,1)=elements_info.Attributes.Value;
end

% this uses the atomic masses to find the atomic weight from the table
for j=1:no_of_elements
    atomic_number=atomic_figures(j,1);
    atomic_figures(j,2)=atomic_mass(atomic_number,1);
end 

pixel_of_interest=zeros(no_of_pixels, no_of_elements);
wt_divide_atwt=zeros(no_of_pixels,no_of_elements);
sum_wt_divide_atwt=zeros(no_of_pixels,1);

%this loop finds each pixel wt% / atomic weight and sums them
for k=1:no_of_pixels
    pixel_of_interest(k,:)=elemental_info(k,:);

    for m=1:no_of_elements
        wt_divide_atwt(k,m)=pixel_of_interest(k,m)/atomic_figures(m,2);
    end 
    sum_wt_divide_atwt(k,1)=sum(wt_divide_atwt(k,:));
end 


elemental_info_atperc=zeros(no_of_pixels, no_of_elements);

%now to make array with atomic percent
for n=1:no_of_pixels
    elemental_info_atperc(n,:)=100*((wt_divide_atwt(n,:))./sum_wt_divide_atwt(n,1));
end 


end





