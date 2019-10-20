function [x_steps,y_steps,num_drops,B_0,P_0,D_P,D_B,user_time_limit_hours] = users_inputs
disp('Hi!'); 
disp('The following software enables you to optimize the distribution of Pyocins in the environment for efficient usage.') 
disp('First,you will be requested to enter a few parameters') 
disp('Step 1: Choose grid');
disp('The grid is defined by the number of steps in each axis.As the number of steps increase, the algorithms complexity increase also')
disp('The recommended value for each axis is up to 50 steps');
GridX = 'Enter number of steps in X axis: ';
x_steps = input(GridX);
GridY = 'Enter number of steps in Y axis: ';
y_steps = input(GridY);
disp('');
disp('Great!');
disp('Step 2: Choose number of Pyocins drops');
Drops = 'Number of drops: ';
num_drops = input(Drops);
disp('');
disp('Step 3: Number of bacteria');
disp('The bacteria concentration is equal in all grids pixels');
disp('Enter the bactria amount per pixel');
Bacteria = 'bacteria amount: ';
B_0 = input(Bacteria);
disp('');
disp('Step 4: Number of Pyocins');
disp('The total amount of Pyocins will be divided equaly between the Pyocins dots.');
disp('In this interaction the Pyocins arent usable after binding moment');
% disp('Its recommended to start with a large amount of Pyocins.');
disp('The recommend value is above 10^5 times bigger then the bacteria amount you entered');
disp(['Therfore, the chosen value should be above ',num2str(B_0*10^5)]);
num_pyo = 'Enter number of Pyocins: ';
P_0 = input(num_pyo);
disp('');
disp('Step 5: Bacteria and Pyocins diffusion coefficients');
disp('For both Pyocins and bacteria diffusion coefficient you have the possibility to define 4 different diffusion values in space');
disp('For every diffusion value,you will need to choose a dot that has this value.');
disp('The rest of the dots diffusion coefficient will be determined by their proximity to the 4 enetered dots');
disp('The input is according to the following format: "[x location, y location, diffusion coefficient]"');
disp('For example- if the bacteria diffusion coefficient is 4 in location x=1 and y=1, the input shall be : [1, 1, 4]');
disp('');
bacteria_1st_point = 'Bacteria first point: ';
b1 = input(bacteria_1st_point);
bacteria_2nd_point = 'Bacteria second point: ';
b2 = input(bacteria_2nd_point);
bacteria_3rd_point = 'Bacteria third point: ';
b3 = input(bacteria_3rd_point);
bacteria_4th_point = 'Bacteria fourth point: ';
b4 = input(bacteria_4th_point);

Pyocin_1st_point = 'Pyocins first point: ';
p1 = input(Pyocin_1st_point);
Pyocin_2nd_point = 'Pyocins second point: ';
p2 = input(Pyocin_2nd_point);
Pyocin_3rd_point = 'Pyocins third point: ';
p3 = input(Pyocin_3rd_point);
Pyocin_4th_point = 'Pyocins fourth point: ';
p4 = input(Pyocin_4th_point);

D_B = get_diffusion_mat(b1,b2,b3,b4,x_steps,y_steps);
D_P = get_diffusion_mat(p1,p2,p3,p4,x_steps,y_steps);
disp('');
disp('Step 6: time limit');
disp('Enter time limit in hours. When we reach this time, the algorithm will stop and the current best location wil be presented');
time_limit = 'Time limit(in hours): ';
user_time_limit_hours = input(time_limit);

end

