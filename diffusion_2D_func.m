function [time_for_elimination,reached_maximal_time] = diffusion_2D_func(P_mat,B_0,D_P,D_B,x_steps,dx,y_steps,dy,Current_Location_Time)
% time for elimination - in minutes.
hours = 1;
time_limit = 60*60*hours; %sec.A maximal time has defined to aviod a never ending while loop.
dt = 0.1;% sec
delay = 1200;% sec. 20 minutes delay
% dx = 10; %um
% x = 1000; %um
% dy = 10; %um
% y = 1000; %um

%parameters
%estimation. lambda phage diffusion coefficient.um^2/sec.
%Ecoli diffusion coefficient from bionumbers website. um^2/sec.
r=1.14/3600 ; %Ecoli growth rate from bionumbers website. 1/sec.
m=1/3600; %arbitrary. 1/sec.
K=10000;%arbitrary.bacteria amount.
alpha=0.001; % amount/sec

t_steps=time_limit/dt;
B=zeros(x_steps,y_steps,t_steps);
P=zeros(x_steps,y_steps,t_steps);
%initial conditions
P(:,:,1) = P_mat;
% B(1:x_steps,1:y_steps,:)=B_0;
B(:,:,1) = B_0;
n=1; %time step
a=0;
while a<1
    if (n+1)*dt>time_limit  
            time_for_elimination=nan;
            reached_maximal_time=1;
%             disp(['Reached maximal time of ',num2str(time_limit/3600)]);
            a=1;
    elseif (n+1)*dt>Current_Location_Time*60 && nargin==9 %if we exceded the current best time, this location is irrelevant
            time_for_elimination=nan;
            reached_maximal_time=1;
            % disp(['Exceded current best time of ' num2str(Current_Location_Time/60) ' hours']);
            a=1;
    else
        for i=2:x_steps-1
            for j=2:y_steps-1        
                if n<=delay/dt
                    P(i,j,n+1)=dt*(D_P(i,j)*((P(i+1,j,n)-2*P(i,j,n)+P(i-1,j,n))/dx^2 + ...
                                    (P(i,j+1,n)-2*P(i,j,n)+P(i,j-1,n))/dy^2) - ...
                                    m*P(i,j,n))+ P(i,j,n);
                    B(i,j,n+1)=dt*(D_B(i,j)*((B(i+1,j,n)-2*B(i,j,n)+B(i-1,j,n))/dx^2 + ...
                                    (B(i,j+1,n)-2*B(i,j,n)+B(i,j-1,n))/dy^2) + ...
                                    r*B(i,j,n)*(1-B(i,j,n)/K)) + B(i,j,n);
                    if P(i,j,n+1)<0
                        P(i,j,n+1)=0;
                    end
                    if B(i,j,n+1)<0
                        B(i,j,n+1)=0;
                    end
                else
                    P(i,j,n+1)=dt*(D_P(i,j)*((P(i+1,j,n)-2*P(i,j,n)+P(i-1,j,n))/dx^2 + ...
                        (P(i,j+1,n)-2*P(i,j,n)+P(i,j-1,n))/dy^2) - ...
                        m*P(i,j,n) - alpha*P(i,j,n-delay/dt)*B(i,j,n-delay/dt)) + P(i,j,n);
                    B(i,j,n+1)=dt*(D_B(i,j)*((B(i+1,j,n)-2*B(i,j,n)+B(i-1,j,n))/dx^2 + ...
                        (B(i,j+1,n)-2*B(i,j,n)+B(i,j-1,n))/dy^2) + ...
                        r*B(i,j,n)*(1-B(i,j,n)/K) - alpha*P(i,j,n-delay/dt)*B(i,j,n-delay/dt)) + B(i,j,n);
                    if P(i,j,n+1)<0
                        P(i,j,n+1)=0;
                    end
                    if B(i,j,n+1)<0
                        B(i,j,n+1)=0;
                    end
                end
            end
        end
        B(:,1,n+1) = B(:,2,n+1);
        B(:,end,n+1) = B(:,end-1,n+1);
        B(1,:,n+1) = B(2,:,n+1);
        B(end,:,n+1) = B(end-1,:,n+1);
        P(:,1,n+1) = P(:,2,n+1);
        P(:,end,n+1) = P(:,end-1,n+1);
        P(1,:,n+1) = P(2,:,n+1);
        P(end,:,n+1) = P(end-1,:,n+1);
        if sum(sum(B(:,:,n+1)<1))==x_steps*y_steps
            time_for_elimination=n*dt/60;   %min
            reached_maximal_time=0;
            a=1;
        elseif sum(sum(P(:,:,n+1)==0))==x_steps*y_steps
            time_for_elimination=nan;
            reached_maximal_time=1;
%             disp(['Reached maximal time of ',num2str(time_limit/3600)])
            a=1;
        end
    end
    n=n+1;
end
end

