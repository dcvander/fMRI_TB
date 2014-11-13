function [ correctedSignalMatrix ] = linRegSignalAndHeadRotation( signalMatrix, rotationMatrix )
%Author: Derek Novo
%   This method takes in a predictor matrix (head rotations) and an observedsignal
%   matrix of which each column is a brain region and its corresponding
%   rows are its time series of varying signal intensity. The method
%   returns a matrix of the residuals generated from a multiple linear
%   regression test between the signal matrix and the predictor matrix.

%-------------------- SPACE CONSTANTS -------------------------
signalMatrixDimensions = size(signalMatrix);
numberOfSignalRows = signalMatrixDimensions(1);
numberOfSignalColumns = signalMatrixDimensions(2);

rotationMatrixDimensions = size(rotationMatrix);
numberOfRotationColumns = rotationMatrixDimensions(2);


%-------------------- PRE-ALLOCATION --------------------------
coefficients = zeros(numberOfRotationColumns,numberOfSignalColumns);
correctedSignalMatrix = zeros(numberOfSignalRows,numberOfSignalColumns);

for k = 1:numberOfSignalColumns
    coefficients(:,k) = regress(signalMatrix(:,k),rotationMatrix);
    correctedSignalMatrix(:,k) = signalMatrix(:,k) - rotationMatrix * coefficients(:,k);
end


    
end

