
function cost_classifier(traindatafile, testdatafile, resultsfile)
% clear all
% close all
% clc

rho = 4/pi;

% Load/Setup training data
trainData = load(traindatafile);
feasible = trainData(:,end); % >0 indicates a feasible result
feasibleIndices = find(feasible>0);
x = trainData(feasibleIndices,2);
y = trainData(feasibleIndices,3);
theta = trainData(feasibleIndices,4)*pi/180;
% cost = trainData(feasibleIndices,5);
cost = trainData(feasibleIndices,end-1);
m = length(feasibleIndices);
taus = [0.1 0.2 .5 .7 1];
k = 10;

% Load/Setup testing data
testData = load(testdatafile);
testFeasible = testData(:,end);
testFeasibleIndices = find(testFeasible>0);
xTest2014 = testData(testFeasibleIndices,2);
yTest2014 = testData(testFeasibleIndices,3);
thetaTest2014 = testData(testFeasibleIndices,4)*pi/180;
costTest2014 = testData(testFeasibleIndices,end-1);

% xFull = deep_space_extract_2PBVP_features(zeros(size(trainData(feasibleIndices,2:end-2))), trainData(feasibleIndices,2:end-2));
% xTest2014Full = deep_space_extract_2PBVP_features(zeros(size(testData(testFeasibleIndices,2:end-2))), testData(testFeasibleIndices,2:end-2));
% featureList = {'delta_x', ...
%         'delta_y', ...
%         'delta_z', ...
%         'delta_xdot', ...
%         'delta_ydot', ...
%         'delta_zdot', ...
%         'delta_x.^2', ...
%         'delta_y.^2', ...
%         'delta_z.^2', ...
%         'delta_xdot.^2', ...
%         'delta_ydot.^2', ...
%         'delta_zdot.^2', ...
%         'abs(delta_xdot)', ...
%         'abs(delta_ydot)', ...
%         'abs(delta_zdot)', ...
%         'sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2)', ...
%         'sqrt(delta_xdot.^2 + delta_ydot.^2 + delta_zdot.^2)', ...
%         'sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2 + delta_xdot.^2 + delta_ydot.^2 + delta_zdot.^2)', ...
%         'delta_x./delta_xdot', ...
%         'delta_y./delta_ydot', ...
%         'delta_z./delta_zdot', ...
%         '(delta_x./delta_xdot).^2', ...
%         '(delta_y./delta_ydot).^2', ...
%         '(delta_z./delta_zdot).^2', ...
%         'sqrt( (delta_x./delta_xdot).^2 + (delta_y./delta_ydot).^2 + (delta_z./delta_zdot).^2 )', ...
%         'sqrt(delta_x.^2 + delta_y.^2 + delta_z.^2) ./ sqrt(delta_xdot.^2 + delta_ydot.^2 + delta_zdot.^2)' ...
%     };

% Designate full feature set, sans analytical features
xFull = [x, ... % keep
    y, ... % keep
    theta, ... % keep
    abs(x), ...
    abs(y), ...
    abs(theta), ... % keep
    x.^2, ...
    y.^2, ...
    theta.^2, ... % keep
    sqrt(x.^2+y.^2), ... % keep
    sqrt(x.^2 + y.^2 + theta.^2), ... % keep
    theta.*sqrt(x.^2+y.^2), ...
    cos(theta), ... % keep
    sin(theta), ... % keep
    tan(theta), ... % keep
    cos(theta).^2, ...
    sin(theta).^2, ... % keep
    tan(theta).^2, ...
    1./sin(theta), ... % new
    1./cos(theta), ... % new
    1./tan(theta), ... % new
    x.*cos(theta), ... % keep
    x./sin(theta), ... % new
    x.*sin(theta), ...
    x./cos(theta), ...
    x.*tan(theta), ...
    x./tan(theta), ...
    y.*sin(theta), ... % keep
    y./cos(theta), ... % new
    y.*cos(theta), ...
    y./sin(theta), ...
    y.*tan(theta), ...
    y./tan(theta), ...
    x.*theta, ... % keep
    y.*theta, ...
    x.*y ...
    ];
% Designate full feature set, sans analytical features
xTest2014Full = [xTest2014, ... % keep
    yTest2014, ... % keep
    thetaTest2014, ... % keep
    abs(xTest2014), ...
    abs(yTest2014), ...
    abs(thetaTest2014), ... % keep
    xTest2014.^2, ...
    yTest2014.^2, ...
    thetaTest2014.^2, ... % keep
    sqrt(xTest2014.^2+yTest2014.^2), ... % keep
    sqrt(xTest2014.^2 + yTest2014.^2 + thetaTest2014.^2), ... % keep
    thetaTest2014.*sqrt(xTest2014.^2+yTest2014.^2), ...
    cos(thetaTest2014), ... % keep
    sin(thetaTest2014), ... % keep
    tan(thetaTest2014), ... % keep
    cos(thetaTest2014).^2, ...
    sin(thetaTest2014).^2, ... % keep
    tan(thetaTest2014).^2, ...
    1./sin(thetaTest2014), ... % new
    1./cos(thetaTest2014), ... % new
    1./tan(thetaTest2014), ... % new
    xTest2014.*cos(thetaTest2014), ... % keep
    xTest2014./sin(thetaTest2014), ... % new
    xTest2014.*sin(thetaTest2014), ...
    xTest2014./cos(thetaTest2014), ...
    xTest2014.*tan(thetaTest2014), ...
    xTest2014./tan(thetaTest2014), ...
    yTest2014.*sin(thetaTest2014), ... % keep
    yTest2014./cos(thetaTest2014), ... % new
    yTest2014.*cos(thetaTest2014), ...
    yTest2014./sin(thetaTest2014), ...
    yTest2014.*tan(thetaTest2014), ...
    yTest2014./tan(thetaTest2014), ...
    xTest2014.*thetaTest2014, ... % keep
    yTest2014.*thetaTest2014, ...
    xTest2014.*yTest2014 ...
    ];
% List of features for convenient viewing of results
featureList = {'x', ... % keep
    'y', ... % keep
    'theta', ... % keep
    'abs(x)', ...
    'abs(y)', ...
    'abs(theta)', ... % keep
    'x.^2', ...
    'y.^2', ...
    'theta.^2', ... % keep
    'sqrt(x.^2+y.^2)', ... % keep
    'sqrt(x.^2 + y.^2 + theta.^2)', ... % keep
    'theta.*sqrt(x.^2+y.^2)', ...
    'cos(theta)', ... % keep
    'sin(theta)', ... % keep
    'tan(theta)', ... % keep
    'cos(theta).^2', ...
    'sin(theta).^2', ... % keep
    'tan(theta).^2', ...
    '1./sin(theta)', ... % new
    '1./cos(theta)', ... % new
    '1./tan(theta)', ... % new
    'x.*cos(theta)', ... % keep
    'x./sin(theta)', ... % new
    'x.*sin(theta)', ...
    'x./cos(theta)', ...
    'x.*tan(theta)', ...
    'x./tan(theta)', ...
    'y.*sin(theta)', ... % keep
    'y./cos(theta)', ... % new
    'y.*cos(theta)', ...
    'y./sin(theta)', ...
    'y.*tan(theta)', ...
    'y./tan(theta)', ...
    'x.*theta', ... % keep
    'y.*theta', ...
    'x.*y' ...
    };

% % Designate the analytical feature set
% xFull = [x, ... % keep
%     y, ... % keep
%     theta, ... % keep
%     abs(theta), ... % keep
%     tan(theta), ... % keep
%     sqrt(x.^2+y.^2), ... % keep
%     1./sin(theta), ... % new
%     1./cos(theta), ... % new
%     1./tan(theta), ... % new
%     x./sin(theta), ... % new
%     x./cos(theta), ...
%     y./cos(theta), ... % new
%     y./sin(theta), ...
%     acos(y/rho+2*cos(theta)-1), ...
%     asin(2*sin(theta)-x/rho) ...
%     ];
% xTest2014Full = [xTest2014, ... % keep
%     yTest2014, ... % keep
%     thetaTest2014, ... % keep
%     abs(thetaTest2014), ... % keep
%     tan(thetaTest2014), ... % keep
%     sqrt(xTest2014.^2+yTest2014.^2), ... % keep
%     1./sin(thetaTest2014), ... % new
%     1./cos(thetaTest2014), ... % new
%     1./tan(thetaTest2014), ... % new
%     xTest2014./sin(thetaTest2014), ... % new
%     xTest2014./cos(thetaTest2014), ...
%     yTest2014./cos(thetaTest2014), ... % new
%     yTest2014./sin(thetaTest2014), ...
%     acos(yTest2014/rho+2*cos(thetaTest2014)-1), ...
%     asin(2*sin(thetaTest2014)-xTest2014/rho) ...
%     ];
% % List of features for convenient viewing of results
% featureList = {'x', ... % keep
%     'y', ... % keep
%     'theta', ... % keep
%     'abs(theta)', ... % keep
%     'tan(theta)', ... % keep
%     'sqrt(x^2+y^2)', ... % keep
%     '1/sin(theta)', ... % new
%     '1/cos(theta)', ... % new
%     '1/tan(theta)', ... % new
%     'x/sin(theta)', ... % new
%     'x/cos(theta)', ...
%     'y/cos(theta)', ... % new
%     'y/sin(theta)', ...
%     'acos(y/rho+2*cos(theta)-1)', ...
%     'asin(2*sin(theta)-x/rho)' ...
%     };

% % Designate use estimated feature set and analytical features
% xFull = [x, ... % keep
%     y, ... % keep
%     theta, ... % keep
%     abs(theta), ... % keep
%     x.^2, ...
%     y.^2, ...
%     theta.^2, ... % keep
%     sqrt(x.^2+y.^2), ... % keep
%     sqrt(x.^2 + y.^2 + theta.^2), ... % keep
%     cos(theta), ... % keep
%     sin(theta), ... % keep
%     tan(theta), ... % keep
%     cos(theta).^2, ...
%     sin(theta).^2, ... % keep
%     tan(theta).^2, ...
%     1./sin(theta), ... % new
%     1./cos(theta), ... % new
%     1./tan(theta), ... % new
%     x.*cos(theta), ... % keep
%     x./sin(theta), ... % new
%     x.*sin(theta), ...
%     x./cos(theta), ...
%     x.*tan(theta), ...
%     x./tan(theta), ...
%     y.*sin(theta), ... % keep
%     y./cos(theta), ... % new
%     y.*cos(theta), ...
%     y./sin(theta), ...
%     y.*tan(theta), ...
%     y./tan(theta), ...
%     x.*theta, ... % keep
%     y.*theta, ...
%     acos(x), ...
%     asin(x), ...
%     acos(y), ...
%     asin(y), ...
%     acos(y/rho+2*cos(theta)-1), ...
%     asin(2*sin(theta)-x/rho) ...
%     ];


% featureList = {'x', ...
%     'y', ...
%     'theta', ...
%     'abs(theta)', ...
%     'x.^2', ...
%     'y.^2', ...
%     'theta.^2', ...
%     'sqrt(x.^2+y.^2)', ...
%     'sqrt(x.^2 + y.^2 + theta.^2)', ...
%     'cos(theta)', ...
%     'sin(theta)', ...
%     'tan(theta)', ...
%     'cos(theta).^2', ...
%     'sin(theta).^2', ...
%     'tan(theta).^2', ...
%     '1/sin(theta)', ... 
%     '1/cos(theta)', ... 
%     '1/tan(theta)', ... 
%     'x*cos(theta)', ... 
%     'x/sin(theta)', ... 
%     'x*sin(theta)', ...
%     'x/cos(theta)', ...
%     'x*tan(theta)', ...
%     'x/tan(theta)', ...
%     'y*sin(theta)', ... 
%     'y/cos(theta)', ... 
%     'y*cos(theta)', ...
%     'y/sin(theta)', ...
%     'y*tan(theta)', ...
%     'y/tan(theta)', ...
%     'x.*theta', ...
%     'y.*theta', ...
%     'acos(x)', ...
%     'asin(x)', ...
%     'acos(y)', ...
%     'asin(y)', ...
%     'acos(y/rho+2*cos(theta)-1)', ...
%     'asin(2*sin(theta)-x/rho)' ...
%     };

xFullExtent = max(xFull) - min(xFull);
numFeatures = length(xFull(1,:));
activeSets = 1:numFeatures;
setRemovalOrder = zeros(size(activeSets));
%keyboard
% Outer loop to test combinations of features
for featureIteration = 1:numFeatures
%     keyboard
    
    disp(sprintf('\n*********\n %d Features Left! \n*********\n',numFeatures-featureIteration))
    xActive = xFull(:,activeSets);
    xExtent = xFullExtent(:,activeSets);
    xTest2014Active = xTest2014Full(:,activeSets);
    
    % Inner loop to do cross-validation to select models
    for j=1:k
        [trainIndices testIndices] = kFoldCrossValidation(k,j,m);

        costTrain = cost(trainIndices);
        costTest = cost(testIndices);
        xTrain = xActive(trainIndices,:);
        xTest = xActive(testIndices,:);
        [models errorsRMS errorsPCT] = runTrainingModels(xTrain, costTrain, xTest, costTest, xExtent, taus);
        costErrorRMS(j,:) = errorsRMS; 
        costErrorPCT(j,:) = errorsPCT;
        modelFits{j} = models;
    end

    % Find the model from the class with the lowest average error
    avgErrorRMS = mean(costErrorRMS);
    modelIndex = find(avgErrorRMS==min(avgErrorRMS));
    avgErrorPCT = mean(costErrorPCT);
    modelIndexPCT = find(avgErrorPCT==min(avgErrorPCT));
    modelSelection(featureIteration,:) = [modelIndex, modelIndexPCT];
    
    % Rerun the best model on the test data set
    tstart = tic;
    if modelIndexPCT > 1
        tau = taus(modelIndexPCT-1); 
        [bestModel approxCost] = batchWeightedLinearRegression(xActive, cost, tau, xTest2014Active, xExtent);
        featureResults{featureIteration}.bestTau = tau;
        validCostIndexes = find(~isnan(approxCost)); % Get rid of unsuccessful results
    else
        [bestModel approxCost] = batchLinearRegression(xActive, cost, xTest2014Active);
        featureResults{featureIteration}.bestTau = inf;
        validCostIndexes = find(~isnan(approxCost));
    end
    tend = toc(tstart);
    featureResults{featureIteration}.tTest = tend;
    featureResults{featureIteration}.testErrorPCT = mean(...
        (abs(costTest2014(validCostIndexes)-approxCost(validCostIndexes))...
        ./costTest2014(validCostIndexes)));
    featureResults{featureIteration}.testErrorRMS = norm(costTest2014(validCostIndexes)-approxCost(validCostIndexes));
    featureResults{featureIteration}.estimatedCosts = approxCost;
    
    % Remove the feature with the smallest coefficient in the linear fit
    irrelevantSet = find(abs(bestModel(2:end)) == min(abs(bestModel(2:end))));
    setRemovalOrder(featureIteration) = activeSets(irrelevantSet(1));
    activeSets(irrelevantSet(1)) = [];
    featureResults{featureIteration}.trainErrorRMS = costErrorRMS;
    featureResults{featureIteration}.trainErrorPCT = costErrorPCT;
    featureResults{featureIteration}.modelFits = modelFits;
    featureResults{featureIteration}.finalModel = bestModel;
    save(resultsfile);
end
sortedFeatureList = featureList(setRemovalOrder);
save(resultsfile);


end

function [models costErrorRMS costErrorPCT] = runTrainingModels(xTrain, costTrain, xTest, costTest, xExtent, taus)
    costErrorRMS = inf*ones(1,length(taus)+1);
    costErrorPCT = inf*ones(1,length(taus)+1);
    
    % Perform linear regression
    [model_unweighted cost_unweighted] = batchLinearRegression(xTrain, costTrain, xTest);
    disp(sprintf('Unweighted cost error = %f', norm(costTest-cost_unweighted)));
    costError = costTest-cost_unweighted;
    costErrorRMS(1) = norm(costError);
    costErrorPCT(1) = mean(abs(costError)./costTest);
    models(1,:) = model_unweighted';
    
    % Perform weighted linear regression
    for i=1:length(taus)
        tau = taus(i);
        [model_weighted cost_weighted] = batchWeightedLinearRegression(xTrain, costTrain, tau, xTest, xExtent);
        invalidTestResult = find(isnan(cost_weighted));
        % Discard any models that fail to classify a point
        if any(cost_weighted > 0) && isempty(invalidTestResult)
            costError = costTest-cost_weighted;
            costErrorRMS(i+1) = norm(costError);
            costErrorPCT(i+1) = mean(abs(costError)./costTest);
            models(i+1,:) = model_weighted';
            disp(sprintf('Weighted cost error, with tau %f = %f', tau, costErrorPCT(i+1)));
        else
            models(i+1,:) = inf*ones(size(model_weighted'));
            disp(sprintf('Weighted cost error, with tau %f = inf', tau));
        end
    end
end

function [theta yfit] = batchLinearRegression(xdat, ydat, xfit)

% xfit = [ ---xfit1--- ]
%        [ ---xfit2--- ] etc

% Unweighted Least Squares
X = [ones(length(xdat(:,1)),1) xdat];
theta = (X'*X)\(X'*ydat);
yfit = [ones(length(xfit(:,1)),1), xfit]*theta;

end


function [trainIndices testIndices] = holdOutCrossValidation(holdoutPercent, m)
    m_test	= floor(holdoutPercent*m);
    testIndices = 1:m_test;
    trainIndices = m_test+1:m;
end

function [trainIndices testIndices] = kFoldCrossValidation(k, j, m)
    m_test  = floor(m/k); % Number of data points used for testing per iteration (m_train = m - m_test)
    trainIndices = [1:(j-1)*m_test (j+1)*m_test:m];
    testIndices = ((j-1)*m_test + 1):j*m_test;
end