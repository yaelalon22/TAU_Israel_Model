function diff_mat = get_diffusion_mat(dot1,dot2,dot3,dot4,x_steps,y_steps)
% For every dot, the first value is x location,the second value is y
% location and the third is diffusion value.
dots_loc = [dot1(1:2);dot2(1:2);dot3(1:2);dot4(1:2)];
dots_values = [dot1(3),dot2(3),dot3(3),dot4(3)];
diff_mat = zeros(x_steps,y_steps);
for r=1:size(diff_mat,1) %x
    for c=1:size(diff_mat,2) %y
        distance = zeros(1,4);
        for i=1:4
            distance(i) = sqrt((r-dots_loc(i,1))^2+(c-dots_loc(i,2))^2);
        end
        ind = find(distance==max(distance));
        diff_mat(r,c) = dots_values(ind(1));
    end
end



end

