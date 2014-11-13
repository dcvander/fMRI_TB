function [ correctedSignalMatrix] = linRegSignalAndHeadRotation_version_3( signalMatrix, motionMatrix )
%Author(s): Derek Novo
%
%   This method takes in a predictor matrix (head motion) and an observed signal
%   matrix of which each column is a brain region and its corresponding
%   rows are its time series of varying signal intensity. The method
%   returns a matrix of the residuals generated from a multiple linear
%   regression tests between the signal matrix and the predictor matrix.
%   Version 3 takes into account signals with nonzero means and nonnormalized
%   amplitudes. It tries to preserve the desired signal's actual mean.
%   TO-DO LIST: Does it still work for nonnormalized motion
%   signals? Rid code of unnecessary variables; e.g., maxSignalMatrix,
%   coefficients, centeredMotionMatrix, etc. may be redundant.

%-------------------- SPACE CONSTANTS -------------------------
signalMatrixDimensions = size(signalMatrix);
numberOfSignalRows = signalMatrixDimensions(1);
numberOfSignalColumns = signalMatrixDimensions(2);

motionMatrixDimensions = size(motionMatrix);
numberOfMotionColumns = motionMatrixDimensions(2);
numberOfMotionRows = motionMatrixDimensions(1);


%-------------------- PRE-ALLOCATION --------------------------
normalized_coefficients = zeros(numberOfMotionColumns,numberOfSignalColumns);
coefficients = zeros(numberOfMotionColumns,numberOfSignalColumns);
predictorCenters = zeros(1,numberOfSignalColumns);
correctedSignalMatrix = zeros(numberOfSignalRows,numberOfSignalColumns);


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
 % centeredMotionMatrix = motionMatrix - meanMotionMatrix;
 processedMotionMatrix = (motionMatrix - meanMotionMatrix)./ maxMotionMatrix;

%----------------------- ALGORITHM ----------------------------
for k = 1:numberOfSignalColumns
    coefficients(:,k) = regress(centeredSignalMatrix(:,k),processedMotionMatrix);
    [normalized_coefficients(:,k),confidenceIntervals,correctedSignalMatrix(:,k)] = regress(processedSignalMatrix(:,k),processedMotionMatrix);
    predictorCenters(k) = sum(coefficients(:,k)' .* meanOfEachMotionColumn);
end

%-------------------- POST-PROCESSING -------------------------
%Reconstructs
predictorCentersMatrix = repmat(predictorCenters,numberOfSignalRows,1);
correctedSignalMatrix = correctedSignalMatrix .* maxSignalMatrix + meanSignalMatrix - predictorCentersMatrix;

% figure; plot(signalMatrix(:,1),'b'); hold on; plot(cleanedMat(:,1),'r')

    
end

