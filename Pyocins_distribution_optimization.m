clear; clc; close all; 
tic;
%% Ask user for input
[x_steps,y_steps,num_drops,B_0,P_0,D_P,D_B,user_time_limit_hours] = users_inputs;
% num_drops = 4;
% user_time_limit_hours =20/60;
% P_0 = 10^7; % Scalar size of drop
% B_0 = 100; % Scalar
% x_steps = 40;
% y_steps = 40;
% x = x_steps*10; % um
% y = y_steps*10; % um
% D_P = ones(x_steps,y_steps)*7;D_P(:,1:10)=100;D_P(:,11:20)=5; % Matrix
% D_B = ones(x_steps,y_steps)*3; % Matrix

dx = 10; % um
dy = 10; % um
k = num_drops;n=x_steps*y_steps;
num_options = nchoosek(n,k); %Binomial coefficient
disp(['There are ',num2str(num_options), ' options for points distribution.']);
user_time_limit_sec = user_time_limit_hours*3600;
B_mat = zeros(x_steps,y_steps);
B_mat(:,:) = B_0;
%% Heuristic serch of the distribution points with local minima time
n=0;
while n<1
    [Current_Location_Time,Current_Location] = find_optimal_loc(P_0,B_mat,D_P,D_B,x_steps,dx,y_steps,dy,num_drops,user_time_limit_sec);
    if isnan(Current_Location_Time) % not enough pyocins
        disp(['The given Pyocins number(',num2str(P_0),' Pyocins)isnt enough to eliminate all bacteria.']);
        num_pyo = 'Enter a new value for number of Pyocins: ';
        P_0 = input(num_pyo);
    else
        n=1;
    end
end
% save_path = [pwd,'/results'];
% save([save_path,'/Results_',date,'.mat'],'x_steps','y_steps','num_drops','initial_location','Current_Location','Current_Location_Time','Location_path_time','Location_path');
   
%% Plot chosen location and time
im_chosen_location = zeros(x_steps,y_steps);
im_chosen_location(sub2ind([x_steps,y_steps],Current_Location(:,1),Current_Location(:,2)))=1;
im_chosen_location = im_chosen_location';
im_chosen_location = im_chosen_location(end:-1:1,:);
imshow(im_chosen_location);
xlabel('X axis');
ylabel('Y axis');
% xticks(1:5:x_steps);
% yticks(y_steps:10:1);
title(['Drop points. Elimination time - ',num2str(round(Current_Location_Time)), ' minutes'],'FontSize',10);
% h = gca;
% h.Visible = 'On';
[row_chosen,col_chosen]=find(im_chosen_location==1);
disp('Chosen locations:');
for i=1:num_drops
    disp(['Drop #',num2str(i),': x location-',num2str(col_chosen(i)),', y location-',num2str(y_steps-row_chosen(i))]);
end