function [out,lc,lv] = partialcorr_shrinkage(x, ztrans)

% this function is made to estimate the partial correlation with shrinkage

if nargin ==1
    ztrans = 0;
end
[n,d] = size(x);
clear(n);

R = rank(cov(x));
if R == d+1 % do simple inversion
    disp('Simple inversion')
    ic=-inv(cov(x));
    r=(ic ./ repmat(sqrt(diag(ic)),1,d)) ./ repmat(sqrt(diag(ic))',d,1);
    r=r - diag(diag(r));
else % we need to adjust covariance matrix
    [CV,lc,lv] = covshrinkKPM(x,1);
%     CV = shrinkDiag(x, .02);
    ic = -inv(CV);
    r=(ic ./ repmat(sqrt(diag(ic)),1,d)) ./ repmat(sqrt(diag(ic))',d,1);
    r=r - diag(diag(r));
end

if ztrans
    out = 0.5 * log((1+r) ./ (1-r));
else
    out = r;
end
return

%% below is modified matlab
[n,d]=size(x);
sizeOut = [d d];
dz = d - 2;
outClass = superiorfloat(x);

coef = zeros(sizeOut,outClass);
    for i = 1:d
        % Only do the lower triangle and diagonal.  Do the diagonal just to
        % get NaNs where we need them.
        j0 = 1; j1 = i;
        for j = j0:j1
            xx = x(:,[i j]);
            zz = x(:,setdiff(1:d,[i j]));
            nn = n;
            z1 = [ones(nn,1) zz];
%             resid = xx - z1*(z1 \ xx);
%             resid = xx - z1 * (inv(z1) * xx);


            % Some of the X variables might be perfectly predictable from Z,
            % and the residuals should then be zero, but roundoff could throw
            % that off slightly.  If a column of residuals is effectively zero
            % relative to the original variable, then assume we've predicted
            % exactly.  This prevents computing spuriously valid correlations
            % when they really should be NaN.  In particular, on the diagonal
            % the two sets of residuals are always identical, but they may be
            % effectively zero, leading to a NaN instead of a 1.
            tol = max(nn,dz)*eps(class(xx))*sqrt(sum(abs(xx).^2,1));
            resid(:,sqrt(sum(abs(resid).^2,1)) < tol) = 0;

            coef(i,j) = sum(prod(resid,2)) ./ prod(sqrt(sum(abs(resid).^2,1)),2);
        end
    end
    
    % Force a one on the diagonal, but preserve NaNs.
    ii = find(~isnan(diag(coef)));
    coef((ii-1)*d+ii) = 1;

    % Reflect to lower triangle.
    coef = tril(coef) + tril(coef,-1)';
    
    out=coef;