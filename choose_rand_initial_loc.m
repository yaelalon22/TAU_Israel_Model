function initial_locations = choose_rand_initial_loc(num_of_drops,x_steps,y_steps)
initial_locations = zeros(num_of_drops,2);
for i=1:num_of_drops
    n=0;
    while n<1
        x_loc = randi([1 x_steps]);
        y_loc = randi([1 y_steps]);
        loc = [x_loc,y_loc];
        if ~ismember(loc,initial_locations,'rows') % Avoid choosing the same dot more than once.
            initial_locations(i,:) = loc;
            n=1;
        end
    end
end
end

