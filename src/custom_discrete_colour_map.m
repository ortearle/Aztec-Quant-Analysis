function [cmap]=custom_discrete_colour_map(NumClusters) 
%https://uk.mathworks.com/matlabcentral/answers/265914-how-to-make-my-own-custom-colormap#comment_339161

cmap = colormap; 
interpolate=linspace(1,255,(NumClusters));
interpolate=round(interpolate);
discrete_colour=zeros(NumClusters,3);

for a=1:NumClusters
    phase_scale=interpolate(1,a);
    discrete_colour(a,:)=cmap(phase_scale,:);  
end

cmap=colormap(discrete_colour);
end
