%DSSCDefinitions returns defining constants, attributes, labels, etc
%for the deep space spacecraft optimization problem
%
%   Ross Allen, ASL, Stanford University
%
%   Started:        Sep 24, 2014
%
%   Inputs:     
%
%   Outputs:
%
%   Notes:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function defs = DSSCDefinitions()

defs.nStateDims = 6;        % (#) number of dimensions of state space
defs.stateLabels = {...
    'x';...
    'y';...
    'z';...
    'xdot';...
    'ydot';...
    'zdot'};

defs.nControlDims = 4;      % (#) number of dimensions of control space 
defs.controlLabels = {...
    'ux';...
    'uy';...
    'uz';...
    'eta'};

defs.nRobotParams = 2;      % (#) number of parameters that define and remain constant for the robot
defs.robotParamLabels = {...
    'mass';...
    'thrustMax'};

defs.optimizationFunction = @DSSCOptimizer; % Function to be called to solve a optimization problem

end
