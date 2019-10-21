function input_correct = Check_diffusion_input(input,x_steps,y_steps)
input_correct =1;
if length(input)~=3
    disp('Wrong length of diffusion input. Please enter the input in the following format: "[x location, y location, diffusion coefficient]"');
    input_correct = 0;
elseif input(1)>x_steps || input(1)<1
    disp('x location exceeded chosen grid range. Enter the chosen locations and diffusion value again.');
    input_correct=0;
elseif input(2)>y_steps || input(2)<1
    disp('y location exceeded chosen grid range. Enter the chosen locations and diffusion value again.');
    input_correct=0;   
end

end

