% nonzeros - extracts the non-zero elements of the matrix
function result = nonzeros(this)
    % We obtain the result from the find method
    [i j result] = find(this);

    if size(result,1) < size(result,2)
        result = result.';
    end
end
