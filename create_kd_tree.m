function Node = ...
create_kd_tree(...
points, ...
currentLevel,...
maxLevel...
)

% Abbruchkriterium  Blatt erreicht
if ( currentLevel == maxLevel )
 Node.left = [];
 Node.right = [];
 Node.pos = [];

 Node.result = points;
 %disp("_________________");
 %disp(Node.result);
 
% neuer Teilbaum
else
 % Aufteilung in zwei disj. Mengen: Fallunterscheidung nach X, Y
 % koordinaten
 if mod(currentLevel,2) == 0 %Sort nach X
    [~,idx] = sort(points(:,1)); % sort just the first column
    Q = points(idx,:);   % sort the whole matrix using the sort indice
 else % Sort nach Y
    [~,idx] = sort(points(:,2)); % sort just the second column
    Q = points(idx,:);   % sort the whole matrix using the sort indice
 end
 % Wurzel Datenstruktur aufbauen durch rekursiven Aufruf
 SplitPoint = floor(length(points)/2);

 Node.result = [];
 Node.pos = Q( SplitPoint, : ); %Split point
 Node.left = create_kd_tree( Q(1 : SplitPoint, :), currentLevel+1, maxLevel);
 Node.right = create_kd_tree( Q(SplitPoint+1 : end, :), currentLevel+1, maxLevel);
 %disp("level: " + level);

 % Rückgabe
 %Return Node;
end
end 