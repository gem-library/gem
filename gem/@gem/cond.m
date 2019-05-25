% cond - the matrix condition number
function result = cond(this)
    % We compute the ratio of maximum and minumum singular values
    svdMax = svds(this, min([3 size(this)]));
    svdMin = svds(this, min([3 size(this)]), 'smallest');
    result = max(svdMax)/min(svdMin);
end
