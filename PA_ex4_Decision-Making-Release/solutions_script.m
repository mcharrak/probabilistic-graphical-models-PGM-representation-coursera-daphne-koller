% Answer to Q1 -> -685.9531:

% diagram = load("FullI.mat");
% I = diagram.FullI;
% EU = SimpleCalcExpectedUtility(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Answer to Q2 -> -729.2367:

% I_evid = I;
% I_evid.RandomFactors = ObserveEvidence(I_evid.RandomFactors,[3 ,2],1);
% SimpleCalcExpectedUtility(I_evid);

% Answer to Q3 -> for decision rule the prob. of any decision is either 1
% or 0 where as for a regular CPD, the prob. can be any value in [0,1].

% Answer to Q4 -> d^(n^m)

% Answer to Q5 -> O(S+d*n^m)

% Answer to Q6 -> When there are large factors in the random-variables part
%                 of the influence diagram, making inference over the network 
%                 slow, and there are only a few utility factors, each involving 
%                 a small number of variables.

% Answer Q7 to Q9

% load the data and calculate initial MEU
influence_diagram = load("TestI0.mat");
I = influence_diagram.TestI0;
[initial_MEU, optdr] = OptimizeLinearExpectations(I);

I.DecisionFactors.var = [9, 11];
I.DecisionFactors.card = [2,2];
I.DecisionFactors.val = [1 0 1 0];

I_Test1 = I;
I_Test1.RandomFactors(10).val = [0.75, 1-0.75, 1-0.999, 0.999];

I_Test2 = I;
I_Test2.RandomFactors(10).val = [0.999, 1-0.999,1-0.75, 0.75];

I_Test3 = I;
I_Test3.RandomFactors(10).val = [0.999, 1-0.999,1-0.999, 0.999];

% calculate new MEU values
[MEU_Test1, ~] = OptimizeLinearExpectations(I_Test1);
% MEU_Test1 = 155.1725
[MEU_Test2, ~] = OptimizeLinearExpectations(I_Test2);
% MEU_Test2 = -216.4601
[MEU_Test3, ~] = OptimizeLinearExpectations(I_Test3);
% MEU_Test3 = 323.7540

VPI_Test1 = MEU_Test1 - initial_MEU;

VPI_Test2 = MEU_Test2 - initial_MEU;

VPI_Test3 = MEU_Test3 - initial_MEU;

% calculate value in dollar d via 100*ln(d+1)= utility_money

d_Test1 = exp(VPI_Test1/100)-1;
% d_Test1 = 3.7196
d_Test2 = exp(VPI_Test2/100)-1;
% d_Test2 = -0.8852
d_Test3 = exp(VPI_Test3/100)-1;
% d_Test3 = 24.4710


