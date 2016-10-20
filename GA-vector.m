%% Clear any privious run's data
clc
clear all
close all   

%% Problem Statement
target  = [3 5 1 7 9 4 6 2 8];
%% Algorithm's Parameters
popSize = 60;                                   % Population Size 
genome  = length(target);                       % Genome Size
mutRate = .01;                                  % Mutation Rate 
count   = 1;                                    % for plotting
S       = 4;                                    % Tournament Size 
best    = Inf;                                  % Initialize Best
crossover = 1;                                  % 0: Uniform crossover
                                                % 1: 1 point crossover
                                                % 2: 2 point crossover
MaxVal  = length(target);
                                                
%% Initial Population
Pop = round(rand(popSize,genome));       
initF = min(sum(abs(bsxfun(@minus,Pop,target)),2));

%% Start of Optimization
for Gen = 1:1000                               % a larg number to ensure 
    %% Fitness    
    F = sum(abs(bsxfun(@minus,Pop,target)),2);       
    [current,currentGenome] = min(F);
    if current < best
        best = current;                     
        bestGenome = Pop(currentGenome,:);  
        B(count) = best;                    % Stores all best values for plotting
        G(count) = Gen;                     % Stores all gen values for plotting
        count = count + 1;                  
        fprintf('Gen: %d  |  Fitness: %d  |  ',Gen, best); 
        disp(bestGenome);                            
    elseif best == 0
        break                                              
    end
    T = round(rand(2*popSize,S)*(popSize-1)+1);                     % Tournaments
    [~,idx] = min(F(T),[],2);                                               
    W = T(sub2ind(size(T),(1:2*popSize)',idx));                     % Winners
    %% Crossover
    
    % UNIFORM CROSSOVER
    if crossover == 0
    idx = logical(round(rand(size(Pop))));                          % Index of Genome from Winner 2
    Pop2 = Pop(W(1:2:end),:);                                       % Set Pop2 = Pop Winners 1
    P2A = Pop(W(2:2:end),:);                                        % Assemble Pop2 Winners 2
    Pop2(idx) = P2A(idx);                                           % Combine Winners 1 and 2
    
    % 1-POINT CROSSOVER
    elseif crossover == 1
    Pop2 = Pop(W(1:2:end),:);                                       % New Population From Pop 1 Winners
    P2A = Pop(W(2:2:end),:);                                        % Assemble the New Population
    Ref = ones(popSize,1)*(1:genome);                               % The Reference Matrix
    idx = (round(rand(popSize,1)*(genome-1)+1)*ones(1,genome))>Ref; % Logical Indexing
    Pop2(idx) = P2A(idx);                                           % Recombine Both Parts of Winners
    
    % 2-POINT CROSSOVER
    elseif crossover == 2
    Pop2 = Pop(W(1:2:end),:);                                       % New Pop is Winners of old Pop
    P2A  = Pop(W(2:2:end),:);                                       % Assemble Pop2 Winners 2
    Ref  = ones(popSize,1)*(1:genome);                              % Ones Matrix
    CP   = sort(round(rand(popSize,2)*(genome-1)+1),2);             % Crossover Points
    idx = CP(:,1)*ones(1,genome)<Ref&CP(:,2)*ones(1,genome)>Ref;    % Index
    Pop2(idx)=P2A(idx);                                             % Recombine Winners
    end
    %% Mutation 
    idx = rand(size(Pop2))<mutRate;                                 % Index of Mutations
    Pop2(idx) = round(rand([1,sum(sum(idx))])*(MaxVal-1)+1);        % Mutated Value
    
    %% Reset Poplulations
    Pop = Pop2;                                                   
   
end

%% plotting
figure(1)
plot(G(:),B(:), '-r')
axis([0 Gen 0 initF])
title('Fitness Over Generation');
xlabel('Fitness');
ylabel('Generation');                  
