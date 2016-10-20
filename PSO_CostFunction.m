function Cost = PSO_CostFunction(X)
% default cost function for machine PM activity
    NPar = size(X,2);
    S1 = 0;
    S2= 0;
    for j = 1:NPar
        S1 = S1 + cos(2*X(:,j));
        S2 = S2 + X(:,j).^2;    
    end
    Cost = 10*NPar + S2 - 10 * (S1)+2.7;
end