function[fig_named_phases]=label_phases(ResultsMean,NumClusters, no_of_elements, elements, file_name_kmc, type, output_file_directory)
ResultsMean_array=table2array(ResultsMean);
Results_TickMarks=ResultsMean_array(:, 1:(end-1));
elements_sorted=zeros(NumClusters, no_of_elements);

for j=1:NumClusters
    Phase_Results=Results_TickMarks(j,:);
    [Sorted, Index_Sort]=sort(Phase_Results, "descend");
    no_of_important_elements=length(find(Sorted>10));
    elements_sorted=(elements(Index_Sort))';
    tick_mark_elements=elements_sorted(:, 1:no_of_important_elements);
    phase_identity=sprintf('Phase %d:', j);
    phase_chemical_identity=strjoin(tick_mark_elements,'/');
    phase_label=strcat(phase_identity, phase_chemical_identity);
    tick_mark_label(1,j)=phase_label;
end 

openfig(file_name_kmc)
fig_named_phases=figure('Name', sprintf('KMC with %d clusters', NumClusters));
cbar_KMC=colorbar;
cbar_KMC.Ticks = linspace(1, NumClusters, NumClusters);
cbar_KMC.TickLabelsMode='manual';
cbar_KMC.TickLabelInterpreter='none';
cbar_KMC.TickLabels=tick_mark_label;
axis image
fontsize(16, "points")
fig_named_phases.WindowState='fullscreen';

file_name_fig_named=strcat(output_file_directory,'\', type, '_kmc_namedphases.fig'); %save it
savefig(file_name_fig_named);
file_name_fig_named_png=strcat(output_file_directory,'\', type, '_kmc_namedphases.png');
print(gcf,file_name_fig_named_png,'-dpng','-r600');

end