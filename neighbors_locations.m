function Locations_To_Check = neighbors_locations(num_of_drops,Current_Location,x_steps,y_steps)
% Every neighbore - change one point location and set the other points.
% Therfore, the upper limit of number of neighbores to check is
% num_of_drops*8.
neighbors_count=1;
Locations_To_Check = zeros(num_of_drops,2,num_of_drops*8);
for a=1:num_of_drops % Adding the current location's neighbors to Locations_To_Check
    for i=-1:1
        for j=-1:1 
            if ~(i==0 && j==0)
                loc = zeros(num_of_drops,2);
                set_points = setdiff(1:num_of_drops,a);
                loc(set_points,:) = Current_Location(set_points,:);
                loc(a,1) = Current_Location(a,1)+i;
                loc(a,2) = Current_Location(a,2)+j;
                if 0<loc(a,1) && loc(a,1)<x_steps && 0<loc(a,2) && loc(a,2)<y_steps
                    Locations_To_Check(:,:,neighbors_count) = loc;
                    neighbors_count=neighbors_count+1;
                end
            end
        end
    end
end
Locations_To_Check = Locations_To_Check(:,:,1:neighbors_count-1);
end

