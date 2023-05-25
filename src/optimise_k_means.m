function [Optimal_K, num_phases, dev_ideal]=optimise_k_means(Smoothed_EDX, no_of_elements, no_of_pixels, num_phases)
fprintf('Code is now optimising k-means clustering - this will take a while!')

Smoothed_columns=zeros(no_of_pixels, no_of_elements);
for i=1:no_of_elements
    Smoothed=Smoothed_EDX(:,:,i);
    Smoothed_ele_reshape=reshape(Smoothed, [],1);
    Smoothed_columns(:,i)=Smoothed_ele_reshape;
end

max_clusters=6; %why was the answer always max clusters
eva=evalclusters(Smoothed_columns, 'kmeans', 'CalinskiHarabasz', 'KList', 1:max_clusters);
calinhara_values=eva.CriterionValues;
Optimal_K=eva.OptimalK;
dev_ideal(1,:)=1:1:max_clusters;
dev_ideal(2,:)=calinhara_values;
dev_ideal(3,:)=100*(calinhara_values-calinhara_values(1,(Optimal_K)))/calinhara_values(1,(Optimal_K));

    if Optimal_K~=num_phases
        disp(" ")
        fprintf("The optimal number of clusters does not match the number of phases inputted (%d).", num_phases)
        disp(" ")
        fprintf("The calculated optimal number of phases is %d.", Optimal_K)
        disp(" ")
        fprintf("Things to try if you disagree: ")
        disp(" ")
        fprintf("change the smoothing type as that can change the optimum number of clusters")
        disp(" ")
        fprintf("change the degree of smoothing")
        disp(" ")
        fprintf("For more info, dev_ideal gives the CH values and the percentage difference of the number of clusters from the ideal number.")
        disp(" ")
        prompt="Do you wish to change the number of clusters to this calculated value? 1 (yes) or 0 (no)";
        x=input(prompt);

            if x==1
                num_phases=Optimal_K;
            end
    end

end 
