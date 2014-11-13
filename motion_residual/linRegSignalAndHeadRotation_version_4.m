function [ correctedSignalMatrix] = linRegSignalAndHeadRotation_version_4( signalMatrix, motionMatrix, timeStep)
%Authors: Derek Novo
%
%   This method takes in a predictor matrix (head motion) and an observed signal
%   matrix of which each column is a brain region and its corresponding
%   rows are its time series of varying signal intensity. The method
%   returns a matrix of the residuals generated from a multiple linear
%   regression test between the signal matrix and the predictor matrix.
%   Version 3 takes into account signals with nonzero means and nonnormalized
%   amplitudes. It tries preserve the desired signal's actual mean.
%   TO-DO LIST: Does it still work for nonnormalized motion
%   signals? Rid code of unnecessary variables; e.g., maxSignalMatrix,
%   coefficients, centeredMotionMatrix, etc. may be redundant. Version 4
%   provides a plotting feature.

%-------------------- SPACE CONSTANTS -------------------------
signalMatrixDimensions = size(signalMatrix);        %Creates a 1x2 array, in which 1st element is the number of rows, 2nd element is the number of columns
numberOfSignalRows = signalMatrixDimensions(1);     
numberOfSignalColumns = signalMatrixDimensions(2);

motionMatrixDimensions = size(motionMatrix);        %Creates a 1x2 array, in which 1st element is the number of rows, 2nd element is the number of columns
numberOfMotionColumns = motionMatrixDimensions(2);
numberOfMotionRows = motionMatrixDimensions(1);


%-------------------- PRE-ALLOCATION --------------------------
normalized_coefficients = zeros(numberOfMotionColumns,numberOfSignalColumns);
coefficients = zeros(numberOfMotionColumns,numberOfSignalColumns);
predictorCenters = zeros(1,numberOfSignalColumns);
correctedSignalMatrix = zeros(numberOfSignalRows,numberOfSignalColumns);
time = (1:numberOfSignalRows)*timeStep;



%--------------------- PRE-PROCESSING -------------------------
%meanOfEachSignalColumn = mean(signalMatrix);
meanSignalMatrix = repmat(mean(signalMatrix),numberOfSignalRows,1);
%signalMatrix = signalMatrix - meanSignalMatrix;

%maxOfEachSignalColumn = max(signalMatrix);
maxSignalMatrix = repmat(max(signalMatrix - meanSignalMatrix),numberOfSignalRows,1);
centeredSignalMatrix = signalMatrix - meanSignalMatrix;
processedSignalMatrix = (signalMatrix - meanSignalMatrix)./ maxSignalMatrix;

meanOfEachMotionColumn = mean(motionMatrix);
meanMotionMatrix = repmat(meanOfEachMotionColumn,numberOfMotionRows,1);
 maxMotionMatrix = repmat(max(motionMatrix - meanMotionMatrix),numberOfMotionRows,1);
 centeredMotionMatrix = motionMatrix - meanMotionMatrix;
 processedMotionMatrix = (motionMatrix - meanMotionMatrix)./ maxMotionMatrix;

%----------------------- ALGORITHM ----------------------------
for k = 1:numberOfSignalColumns
    coefficients(:,k) = regress(centeredSignalMatrix(:,k),processedMotionMatrix);
    [normalized_coefficients(:,k),confidenceIntervals,correctedSignalMatrix(:,k)] = regress(processedSignalMatrix(:,k),processedMotionMatrix);
    predictorCenters(k) = sum(coefficients(:,k)' .* meanOfEachMotionColumn);
end

%-------------------- POST-PROCESSING -------------------------
%Reconstructs the original mean and amplitude of observed signal.
predictorCentersMatrix = repmat(predictorCenters,numberOfSignalRows,1);
correctedSignalMatrix = correctedSignalMatrix .* maxSignalMatrix + meanSignalMatrix - predictorCentersMatrix;

%--------------------------PLOT--------------------------------
for m = 1:numberOfSignalColumns
    figure; plot(time(:),signalMatrix(:,m),'k'); 
    hold on; plot(time(:),correctedSignalMatrix(:,m),'r');
    title(['Brain region ' int2str(m)]);
    xlabel('Time (sec)');
    ylabel('Contrast')
end

