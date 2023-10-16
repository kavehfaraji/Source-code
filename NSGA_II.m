close all; 
clear;
clc;
tic;
% importing data
data = readtable('Churn.xlsx');
%% phase 1-Base Classifier Pool Creation 
UpperBoundforClustering =40;
[BCP,Testingset,Validationset,Extra_info]=BaseClassifierPoolCreation(data,UpperBoundforClustering);
toc;
%% NSGA-II

% Save Results
% results = zeros();


%% Problem Definition
tic;
CostFunction =@(x)objective(x,Validationset);       % cost function 

nVar=length(BCP);                                   % Number of Decision Variables

VarSize=[1 nVar];                                   % Size of Decision Variables Matrix

VarMin=1;                                           % Lower Bound of Variables
VarMax=length(BCP);                                 % Upper Bound of Variables

% Number of Objective Functions
chromosome=randi([0 1],[1, nVar]);
x0 = cell(1,1);
for p=1:length(chromosome)
    if chromosome(1,p)==1
    x0{p,1} = BCP{p};
    elseif chromosome(1,p)==0
    x0{p,1} = [];
    end        
end 
nObj=numel(CostFunction(x0)); % Number of Objective Functions

%% NSGA-II Parameters

MaxIt=280;      % Maximum Number of Iterations

nPop=100;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

pMutation=0.3;                          % Mutation Percentage(percentage of population that we want to mutate them)
nMutation=round(pMutation*nPop);        % Number of Mutants
mu=0.3;                                % Mutation Rate (percentage of genes that we want to mutate them 0<Mu<1)


ANSWER=questdlg('Choose selection method:','Nondominated Sorting Genetic Algorithm',...
    'Roulette Wheel','Binary Tournament','Random','Binary Tournament');

UseRouletteWheelSelection=strcmp(ANSWER,'Roulette Wheel');
UseTournamentSelection=strcmp(ANSWER,'Binary Tournament');
UseRandomSelection=strcmp(ANSWER,'Random');


% sigma=0.1*(VarMax-VarMin);  % Mutation Step Size
if UseRouletteWheelSelection
    beta=8;                     % Selection Pressure for roulette wheel selection 
end

%% Initialization

empty_individual.Position=cell(2,1);
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];

pop=repmat(empty_individual,nPop,1);

chromosomes=randi([0 1],[nPop, nVar]);

% Initialize position 
for i=1:nPop
    for p=1:length(chromosomes(1,:))
        if chromosomes(i,p)==1
            pop(i).Position{p} = BCP{p};
        elseif chromosomes(i,p)==0
            pop(i).Position{p}= [];
        end 
    end 
end

% Evaluation of first generation 
for i = 1:nPop
   pop(i).Cost = CostFunction(pop(i).Position);
end 

% Non-Dominated Sorting
[pop, F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop, F]=SortPopulation(pop);

h=figure('Name','First Population');
Costs = [pop.Cost];
plot(Costs(1,:),Costs(2,:),'*');
savefig(h,'First Population.fig');
close all; 
%% NSGA-II Main Loop

for it=1:MaxIt
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
    % Roulette Weel Selecttion
        if UseRouletteWheelSelection
            PopCosts = [pop.Cost];
            P1 = exp(-beta*PopCosts(1,:));
            P2 = exp(-beta*PopCosts(2,:));
            P1 = P1/sum(P1);
            P2 = P2/sum(P2);
            i1=RouletteWheelSelection(P1,P2);
            i2=RouletteWheelSelection(P1,P2);       
            p1 = pop(i1);
            p2 = pop(i2);
        end 
    % Random Selection    
        if UseRandomSelection
            i1=randi([1 nPop]);
            i2=randi([1 nPop]);
            p1=pop(i1);
            p2=pop(i2);        
        end 

    % Tornament Selection 
        if UseTournamentSelection
            p1 = BinaryTournamentSelection(pop);
            p2 = BinaryTournamentSelection(pop);
        end 

    [popc(k,1).Position,popc(k,2).Position]=Crossover(p1.Position,p2.Position);
        
    popc(k,1).Cost=CostFunction(popc(k,1).Position);
    popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);          % Mutate Population 
    for k=1:nMutation
        
        i=randi([1 nPop]);              % Random Selection of Individual for Mutations 
        p=pop(i);
        
        popm(k).Position=Mutate(p.Position,BCP,mu);
        
        popm(k).Cost=CostFunction(popm(k).Position);
        
    end
    
    % Merge
    pop=[pop
         popc
         popm];
     
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop, F]=SortPopulation(pop);
    
    % Truncate
    pop=pop(1:nPop);
    
    % Non-Dominated Sorting
    [pop, F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop, F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
    F1Costs=[F1.Cost];
    Costs=[pop.Cost];
    
    % Plot New Popuation 
    % Plot F1 Costs
    f=figure('Name','New Population with Their Pareto Front Solutions');
    plot(Costs(1,:),Costs(2,:),'.',F1Costs(1,:),F1Costs(2,:),'r*');
    xlabel('1st Objective');
    ylabel('2nd Objective');
    grid on;
    h=['New Population with Their Pareto Front Solutions ' num2str(it) '.fig'];
    savefig(f,h)
    close all
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    pause(2)
end

%% Results

PF = F1;
PFC=[PF.Cost];

disp(' ');

for j = 1:size(PFC,1)
    disp(['Objective #' num2str(j) ':']);
    disp(['    Min = ' num2str(min(PFC(j,:)))]);
    disp(['    Maximum Value of 1-Objective = ' num2str(1-min(PFC(j,:)))]);
    disp(['    Max = ' num2str(max(PFC(j,:)))]);
    disp(['    Range = ' num2str(max(PFC(j,:))-min(PFC(j,:)))]);
    disp(['    st.D. = ' num2str(std(PFC(j,:)))]);
    disp(['    Mean = ' num2str(mean(PFC(j,:)))]);
     disp(' ')
end  
toc; 





