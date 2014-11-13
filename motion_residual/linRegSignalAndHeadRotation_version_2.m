function [ correctedSignalMatrix ] = linRegSignalAndHeadRotation_version_2( signalMatrix, rotationMatrix )
%Authors: Derek Novo
%   This method takes in a predictor matrix (head rotations) and an observedsignal
%   matrix of which each column is a brain region and its corresponding
%   rows are its time series of varying signal intensity. The method
%   returns a matrix of the residuals generated from a multiple linear
%   regression test between the signal matrix and the predictor matrix.
%   Version 2 uses the same method as Version 1, but with more returns;
%   i.e., we do not have to multiply each predictor signal with its
%   coefficient and subtract the resulting signals from the observed
%   signal.

%-------------------- SPACE CONSTANTS -------------------------
signalMatrixDimensions = size(signalMatrix);
numberOfSignalRows = signalMatrixDimensions(1);
numberOfSignalColumns = signalMatrixDimensions(2);

rotationMatrixDimensions = size(rotationMatrix);
numberOfRotationColumns = rotationMatrixDimensions(2);


%-------------------- PRE-ALLOCATION --------------------------
coefficients = zeros(numberOfRotationColumns,numberOfSignalColumns);
correctedSignalMatrix = zeros(numberOfSignalRows,numberOfSignalColumns);

%----------------------- ALGORITHM ----------------------------
for k = 1:numberOfSignalColumns
    [coefficients(:,k),confidenceIntervals,correctedSignalMatrix(:,k)] = regress(signalMatrix(:,k),rotationMatrix);
end


    
end

