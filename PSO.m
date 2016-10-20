%% Clear any privious run's data
clc
clear all
close all

%% Problem Statement
NPar = 9;    %   number of jobs
VarMin = [-10 -10 -10 -10 -10 -10 -10 -10 -10];
VarMax = [25 25 25 25 25 25 25 25 25];

%% Algorithm's Parameters
SwarmSize = 60;
MaxIteration = 100;
C1 = 2; % Cognition Coefficient;
C2 = 4 - C1; % Social Coefficient;
%% Initial Population
GBest.Cost = inf;
GBest.Position = [];
GBest.CostMAT = [];
for p = 1:SwarmSize
    Particle(p).Position = rand(1,NPar);  
    Particle(p).Cost =PSO_CostFunction(Particle(p).Position);
    Particle(p).Velocity = [];
    Particle(p).LBest.Position = Particle(p).Position;
    Particle(p).LBest.Cost = Particle(p).Cost;
    
    if Particle(p).LBest.Cost < GBest.Cost
        GBest.Cost = Particle(p).LBest.Cost;
        GBest.Position = Particle(p).LBest.Position;
    end
end

%% Start of Optimization
for Iter = 1:MaxIteration
    %% Velocity update
    for p = 1:SwarmSize
        Particle(p).Velocity = C1 * rand * (Particle(p).LBest.Position - ...
        Particle(p).Position) + C2 * rand * (GBest.Position - Particle(p).Position);
        Particle(p).Position = Particle(p).Position + Particle(p).Velocity;      
        Particle(p).Cost =PSO_CostFunction(Particle(p).Position);

        
        if Particle(p).Cost < Particle(p).LBest.Cost
            Particle(p).LBest.Position = Particle(p).Position;
            Particle(p).LBest.Cost = Particle(p).Cost;
            
            if Particle(p).LBest.Cost < GBest.Cost
                GBest.Cost = Particle(p).LBest.Cost;
                GBest.Position = Particle(p).LBest.Position;
            end
        end
    end
    %% Display
    disp(['Itretion = ' num2str(Iter) '; Best Cost = ' num2str(GBest.Cost) ';'])
    GBest.CostMAT = [GBest.CostMAT GBest.Cost];
end
%% plotting
GBest.Position
plot(GBest.CostMAT)