% LongForestObstacleSet generates a rough representation of trees and
%   rocks for a UAV to navigate
%
%   AUTHOR: Ross Allen
%   DATE:   Sep 24, 2014
%   REFERENCE: None. Assumes a 100x30x10 m environment

function [LWH_F, YPR_F, CM_F] = LongForestObstacleSet(obsinfo)

obstacleScaleFactor = 1;

% Length/Width/Height of fixed cuboid obstacles (m) (m-th COLUMN vector corresponds to m-th obstacle)
LWH_F = [...
%     [6.0, 6.0, 2.0]', ... % Boulder
%     [4.0, 4.0, 1.0]', ...
%     [2.0, 6.0, 1.5]', ...
%     [2.0, 2.0, 2.0]', ...
    [1.0, 1.0, 10.0]', ... % Trunks
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [1.0, 1.0, 10.0]', ...
    [7.0, 7.0, 1.0]', ... % First Branches
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [7.0, 7.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ... % Second Branches
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [6.0, 6.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ... % Third Branches
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [5.0, 5.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ... % Fourth Branches
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [4.0, 4.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ... % Fifth Branches
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [3.0, 3.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...% Sixth Branches
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]', ...
    [2.0, 2.0, 1.0]'];
LWH_F = obstacleScaleFactor*LWH_F;

% Yaw/Pitch/Roll of fixed cuboid obstacles (deg) (m-th COLUMN vector corresponds to m-th obstacle)
YPR_F = zeros(3,70);

% Position vector of fixed cuboid obstacle centroid [m] (m-th COLUMN vector corresponds to m-th obstacle)
XYcenter = [...    
    [38.1421,   -2.9190]', ...
    [84.1421,   -5.3634]', ...
    [26.6421,    9.3032]', ...
    [62.6421,    1.9699]', ...
    [45.6421,    7.8079]', ...
    [95.6421,    6.8588]', ...
    [12.1812,    -0.4745]', ...
    [50.1812,   -8.6227]', ...
    [27.1812,    6.0440]', ...
    [73.1812,   -1.2894]'];

trunks = [XYcenter; 5.0*ones(1,10)];
branch1 = [XYcenter; 3.5*ones(1,10)];
branch2 = [XYcenter; 4.5*ones(1,10)];
branch3 = [XYcenter; 5.5*ones(1,10)];
branch4 = [XYcenter; 6.5*ones(1,10)];
branch5 = [XYcenter; 7.5*ones(1,10)];
branch6 = [XYcenter; 8.5*ones(1,10)];

CM_F = [trunks, branch1, branch2, branch3, branch4, branch5, branch6];

CM_F = obstacleScaleFactor*CM_F;

end