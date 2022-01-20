function AntTour = calcAntTour(i, P, distMatrix, beta, alpha ) 

% Ameise mit Stadt i initialisieren
AntTour = [ ];
AntTour(end+1) = i;

[Prows, Pcolumns] = size(P);
p_niv = zeros(Prows, Pcolumns);


% n-1 Städte müssen dann noch besucht werden
for cnt = 1 : Prows-1
    % Entsprechend Pheromonniveaus (=W.-keit) nächste Kante (i,k) wählen:

    % Pheromonniveau berechnen
    Sum = 0;
    for j=1:Prows
        p_niv(i, j) = 0;
            if (distMatrix(i, j) > 0 && ~any(AntTour(:) == j))
                p_niv(i, j) = P(i, j)^alpha * (1/distMatrix(i, j))^beta;
                Sum = Sum + p_niv(i, j);
            end
    end

    % Normalisieren
    p_niv(i, 1:Prows) = p_niv(i, 1:Prows) / Sum;

    % Lostopf V mit insg. 1000 Kugeln füllen. Häufigkeit jeder Kugel ‘k‘
    % entspr. Pheromonniveau p_niv(i,k)
    V = [];
    for k = 1 : Prows
            for cnt = 1 : p_niv(i,k)*1000
                V(end+1) = k ;
            end
    end

    % nächstes Wegstück berechnen ==> per random in Lostopf V greifen
    % simuliert die Wahrscheinlichkeit
    randomPick = randsample(V,1);
    AntTour(end+1) = randomPick(1,1);
end


end