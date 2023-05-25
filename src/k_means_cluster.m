function [ResultsMean,ResultsMedian, ResultsStd, fig_named_phases, percent_outliers_table] = k_means_cluster(num_phases,AllSmooth, upper_colour_elements, no_of_elements, elements, output_file_directory, type, no_colour_bar_image, box_plot_output, histogram_output, X_coord, Y_coord, NumAttempts)
% written with help from Rob Scales

if NumAttempts<5
    disp('Error: For k means clustering, the algorithm must be repeated. Please set NumAttempts > 5.')
                return
end 

%for testing
%type=2;

%% performs k-means clustering on the image
x=[0 max(X_coord)];
y=[0 max(Y_coord)];

NumClusters = num_phases;
KMC = imsegkmeans(uint16(AllSmooth),NumClusters, "NumAttempts",NumAttempts);

figKMC = figure('Name', sprintf('KMC with %d clusters', NumClusters));


imagesc(x,y,KMC);
axis image
xlabel('μm')
ylabel('μm')
fontsize(16, "points")
figKMC.WindowState='maximized';
custom_discrete_colour_map(NumClusters) ;
cbar_KMC = colorbar;

size_color=(NumClusters-1)/NumClusters;
color_edges=1:size_color:NumClusters;
tick_positions=color_edges(:, 1:end-1)+(size_color/2);
cbar_KMC.Ticks= tick_positions;
cbar_KMC.TickLabelsMode='manual';
cbar_KMC.TickLabels=linspace(1, NumClusters, NumClusters);

file_name_kmc=strcat(output_file_directory,'\', type, '_kmc.fig'); %save it
savefig(file_name_kmc);

%% Creates tables for data

ResultsMean = table('Size', [NumClusters, no_of_elements+1], 'VariableTypes', string(repmat('double',no_of_elements+1,1)),'VariableNames', vertcat(elements,"Sum"));
ResultsMedian = table('Size', [NumClusters, no_of_elements+1], 'VariableTypes', string(repmat('double',no_of_elements+1,1)),'VariableNames', vertcat(elements,"Sum"));
ResultsStd= table('Size', [NumClusters, no_of_elements], 'VariableTypes', string(repmat('double',no_of_elements,1)),'VariableNames', elements);
percent_outliers_table= table('Size', [NumClusters, no_of_elements], 'VariableTypes', string(repmat('double',no_of_elements,1)),'VariableNames', elements);
%% calculates statistical data of each phase

for PhaseNum = 1:NumClusters
    CurrentPhase = KMC==PhaseNum;
    for elementNum = 1:no_of_elements
        CurrElementMap= AllSmooth(:,:,elementNum);
        CurrElementMapData = CurrElementMap(CurrentPhase);
        Mean_Value = mean(CurrElementMapData, 'omitnan');
        Median_Value=median(CurrElementMapData, 'omitnan');
        Stdev=std(CurrElementMapData, 'omitnan');
        ResultsMean(PhaseNum,elementNum) = table(Mean_Value);
        ResultsMedian(PhaseNum,elementNum) = table(Median_Value);
        ResultsStd(PhaseNum, elementNum) = table(Stdev);
        Phase_Element_Data(:,elementNum)=CurrElementMapData; 
    end
    
    ResultsMean(PhaseNum, elementNum+1) = table(sum(table2array(ResultsMean(PhaseNum,1:elementNum))));
    ResultsMedian(PhaseNum, elementNum+1) = table(sum(table2array(ResultsMedian(PhaseNum,1:elementNum))));
    
    [percent_outliers] = kmeans_boxplot(PhaseNum,Phase_Element_Data, elements, output_file_directory, type, no_of_elements, box_plot_output, NumClusters);
    prc_outliers(PhaseNum, :)=percent_outliers(PhaseNum,:);
    percent_outliers_table=table(prc_outliers);

    if histogram_output=="yes"
    [kmeans_histogram]=kmeans_hist(PhaseNum,Phase_Element_Data, no_of_elements, elements, output_file_directory, type, upper_colour_elements);
    end

    [fig_piechart]=kmeans_pie(PhaseNum,ResultsMedian, elements, no_of_elements, upper_colour_elements, output_file_directory, type);
    Phase_Element_Data=[];
end
%% adding labels to phases
ResultsMedian_array=table2array(ResultsMedian);
Results_TickMarks=ResultsMedian_array(:, 1:(end-1));

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


fig_named_phases=openfig(file_name_kmc);
axis image
fig_named_phases.WindowState='maximized';
cbar_KMC=colorbar;
cbar_KMC.Ticks =tick_positions;
cbar_KMC.TickLabelsMode='manual';
cbar_KMC.TickLabelInterpreter='none';
cbar_KMC.TickLabels=tick_mark_label;
fontsize(16, "points")
cbar_KMC.Label.FontSize = 18;



file_name_fig_named=strcat(output_file_directory,'\', type, '_kmc_namedphases.fig'); %save it
savefig(file_name_fig_named);
file_name_fig_named_png=strcat(output_file_directory,'\', type, '_kmc_namedphases.png');
print(gcf,file_name_fig_named_png,'-dpng','-r600');
%% 
 if no_colour_bar_image=="yes"
     openfig(file_name_kmc)
     set(gca,'xticklabel',[])
     set(gca,'yticklabel',[])
     set(gca,'xlabel',[])
     set(gca,'ylabel',[])
     axis off;
     colorbar('Visible', "off")
     file_name_kmc_no_cb=strcat(output_file_directory,'\','_kmc_nocolorbar.png');
     print(gcf,file_name_kmc_no_cb,'-dpng','-r600');
 end

end
