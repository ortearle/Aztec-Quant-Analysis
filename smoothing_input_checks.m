function [] = smoothing_input_checks(smoothing,convert_atomic, all_smoothing, fave_filter)
%This checks smoothing inputs
if smoothing=="yes"
    if convert_atomic~="yes"
        disp('Error: for smoothing functionality, data must be converted to atomic percent')
        return
    end
        if all_smoothing=="yes"
            if fave_filter>0
                disp('Error: For all smoothing types to be applied, fave_filter should equal 0.')
                return
            end 
        end
        if all_smoothing~="yes"
            if fave_filter==0
                disp('Error: For fave_filter=0, all smoothing methods will be applied.')
                return
            end     
        end 
end
end