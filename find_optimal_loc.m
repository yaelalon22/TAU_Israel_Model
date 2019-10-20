function [Current_Location_Time,Current_Location] = find_optimal_loc(P_0,B_mat,D_P,D_B,x_steps,dx,y_steps,dy,num_drops,user_time_limit_sec)
% Initial random pyocins distribution.
P_mat = zeros(x_steps,y_steps);
initial_location = choose_rand_initial_loc(num_drops,x_steps,y_steps);
disp('Choosing initial locations');
% initial_location = choose_weighted_initial_loc(num_drops,B_mat,D_B,D_P);
P_mat(sub2ind([x_steps,y_steps],initial_location(:,1),initial_location(:,2)))=P_0/num_drops;
Current_Location = initial_location;
[time,~] = diffusion_2D_func(P_mat,B_mat,D_P,D_B,x_steps,dx,y_steps,dy,100000);
Current_Location_Time = time; % Min
step_size = ones(1,10000);
step_size(1:5) = round(x_steps/8);
step_size(6:10) = round(x_steps/10);
arbitrary_time = 10000000;
if isnan(time)
    Current_Location_Time = arbitrary_time;
end
Location_path = zeros(num_drops,2,2000);
Location_path(:,:,1) = initial_location;
Location_path_time = zeros(1,2000);
Location_path_time(1)=Current_Location_Time;
Checked_Locations = zeros(num_drops,2,200000);
Checked_Locations(:,:,1) = initial_location;
n=-1;
Checked_count = 2;
iter_count=0;

while n<1
    reached_maximal_time_count = 0;
    iter_count = iter_count+1;
    disp(['Iteration number - ' num2str(iter_count)]);
    Changed_location = 0; % indicites whether one of the neighbors has better time then the current location
    Locations_To_Check = neighbors_locations(num_drops,Current_Location,x_steps,y_steps);
    disp(['--- Checking ' num2str(size(Locations_To_Check,3)) ' neighbors ---']);
    for check_num = 1:size(Locations_To_Check,3)
        P_mat = zeros(x_steps,y_steps);
        Current_check = Locations_To_Check(:,:,check_num);
        if ~any(all(all(bsxfun(@eq,Checked_Locations,Current_check)))) % If current_check is'nt in the checked locations list
            P_mat(sub2ind([x_steps,y_steps],Current_check(:,1),Current_check(:,2)))=P_0;
            [time,~] = diffusion_2D_func(P_mat,B_mat,D_P,D_B,x_steps,dx,y_steps,dy,Current_Location_Time);
            Checked_Locations(:,:,Checked_count) = Current_check;
            Checked_count = Checked_count+1;
            if ~isnan(time)
                if time<=Current_Location_Time
                    Current_Location_Time = time;
                    Current_Location = Current_check;
                    Changed_location = 1;
                end
            end
%         else
%             disp('Location alreay Checked');
        end
        elapsedTime = toc;
        if elapsedTime>user_time_limit_sec
            n=1;
            disp(['Reached users maximal time of ',num2str(user_time_limit_sec/3600),' hours']);
            return % stop function
        end
    end
    if Current_Location_Time==arbitrary_time
        Current_Location_Time = nan;
        Current_Location = nan;
        return % stop function
    elseif Changed_location==0 
        n = 1; % Stop if we reached a local minima time  
        disp('Time didnt improved-stopping heuristic search');
    else
%         disp(['Step size = ' num2str(step_size(iter_count))]);
        location_gradient =Current_Location+step_size(iter_count)*(Current_Location - Location_path(:,:,iter_count));
        location_gradient(location_gradient<1)=1;
        location_gradient(location_gradient(:,1)>x_steps,1)=x_steps;
        location_gradient(location_gradient(:,2)>y_steps,2)=y_steps;
        P_mat = zeros(x_steps,y_steps);
        P_mat(sub2ind([x_steps,y_steps],location_gradient(:,1),location_gradient(:,2)))=P_0;
        [time_gradient,~] = diffusion_2D_func(P_mat,B_mat,D_P,D_B,x_steps,dx,y_steps,dy,1000);
        if time_gradient<Current_Location_Time && step_size(iter_count)~=1 && ~isnan(time_gradient)
%             disp(['Gradient calculation with step size larger than one improved time in ' num2str(Current_Location_Time-time_gradient) ' minutes']);            
            Current_Location = location_gradient;
            Current_Location_Time = time_gradient;
        elseif time_gradient>=Current_Location_Time && step_size(iter_count)~=1 && ~isnan(time_gradient)
%             disp('Step size larger than one didnt improved the final time');
        end
        Location_path_time(iter_count+1) = Current_Location_Time;  
        Location_path(:,:,iter_count+1) = Current_Location;
    end
end
Checked_Locations = Checked_Locations(:,:,1:Checked_count-1);
Location_path_time = Location_path_time(1:iter_count);
Location_path = Location_path(:,:,1:iter_count);
end

