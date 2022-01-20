function points = ...
search_kd_tree(...
selectedPoint, ...
kd_tree...
)

level = 1;

while isempty(kd_tree.result)

    if mod(level,2) == 0 %even: search by X
       kd_value = kd_tree.pos(1,1); %x from kd
       selected_value = selectedPoint(1,1); %x from selected
    else %uneven: search by Y
       kd_value = kd_tree.pos(1,2); %y from kd
       selected_value = selectedPoint(1,2); %y from selected
    end

    %disp("kd point is: " + kd_value);
    %disp("selected: " + selectedPoint);
    %disp("level: " + level);
    %disp("comparing kd: " + kd_value + " to " + selected_value);

     if(kd_value <= selected_value) 
            %selected val position is bigger means go right
            kd_tree = kd_tree.right;
     else
            %selected val position is smaller means go left
            kd_tree = kd_tree.left;
     end

     level = level + 1;
end

%disp("result at level: " + level);
points = kd_tree.result;

end