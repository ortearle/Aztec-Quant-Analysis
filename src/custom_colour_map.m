function [cmap]=custom_colour_map(lower_colour, upper_colour, max_at_perc) 
%https://uk.mathworks.com/matlabcentral/answers/265914-how-to-make-my-own-custom-colormap#comment_339161
%and lots of help from Rob Scales

pt1 = upper_colour(1);
pt2 = upper_colour(2);
pt3 = upper_colour(3);

%cmapsize = 256;   %or as passed in
NumPoints=round(max_at_perc);
%floor(cmapsize * 15/100) - floor(cmapsize * 0/100);

part0 = [(linspace(0, pt1, NumPoints)).', ...
         (linspace(0, pt2, NumPoints)).', ...
         (linspace(0, pt3, NumPoints)).'];

part0=part0/255;
part0(1,:) = lower_colour;
cmap=colormap(part0);
end
