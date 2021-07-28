% subsasgn - subscripted assignment
function result = subsasgn(this, subs, values)

% We do some checks
if (length(subs) > 1) || (length(subs.subs) > 2)
    error('Wrong call to gem::subsasgn');
end

% If this is empty (because it was not initialized, otherwise this function
% would not be called), it will be of type gem
if isequal(subs.type, '()') && isempty(this)
    this = gem([]);
end


% We extract the coordinates of the matrix
indices = cell(1,length(subs.subs));
s = size(this);
switch subs.type
    case '()'
        for i = 1:length(subs.subs)
            if isnumeric(subs.subs{i})
                indices{i} = subs.subs{i};
            elseif islogical(subs.subs{i})
                indices{i} = find(subs.subs{i});
            elseif isequal(subs.subs{i},':')
                if length(subs.subs) == 1
                    % We are calling with a single index a(:)
                    indices{i} = 1:prod(s);
                else
                    % We are calling with several indices, as in a(:,1)
                    indices{i} = 1:s(i);
                end
%            elseif isequal(subs.subs{i}, 0)
%                indices{i} = [];
            else
                error('Unrecognized indexing in gem::subsref')
            end
        end
    otherwise
        error('Wrong call to gem::subsref');
end


%% If needed, we prepare a copy of the object, only this object will be modified
if ((length(indices) == 1) && (isempty(indices{1}))) || ...
        ((length(indices) == 2) && (isempty(indices{1}) || isempty(indices{2})))
    % There is nothing to assign. But we check that the rhs does not
    % contain more than 1 element
    if numel(values) > 1
        error('In an assignment A(I) = B in gem::subsasgn, the number of elements in B and I must be the same');
    end
    result = this;
    return;
elseif (length(indices) == 2) && (numel(values) == 0)
    % We are deleting elements
    
    % Sanity check
    if isempty(indices{1}) || isempty(indices{2}) || (min(indices{1}) < 1) || (min(indices{2}) < 1) || (max(indices{1}) > s(1)) || (max(indices{2}) > s(2))
        error('Indices out of bound in gem::subsasgn')
    end
    
    if (length(indices{1}) < s(1)) && (length(indices{2}) < s(2))
        error('Null assignments are only possible for full lines or columns');
    elseif (length(indices{1}) < s(1))
        % We are deleting lines
        subs.subs{1} = setdiff(1:s(1), indices{1});
    else
        % We are deleting columns
        subs.subs{2} = setdiff(1:s(2), indices{2});
    end
    result = subsref(this, subs);    
    return;
end
result = copy(this);


%% Let's make some more checks
if length(indices) == 1
    if (min(indices{1}) < 1) || ((max(indices{1}) > prod(s)) && (min(s) > 1))
        error('Indices out of bound in gem::subsasgn');
    elseif max(indices{1}) > prod(s)
        % We need to increase the size of the vector
        if s(1) <= 1
            objId = result.objectIdentifier;
            gem_mex('resize', objId, 1, max(indices{1}));
        else
            objId = result.objectIdentifier;
            gem_mex('resize', objId, max(indices{1}), 1);
        end
    end

    if (length(indices{1}) ~= numel(values)) && (numel(values) ~= 1)
        error('Wrong number of elements in assignment');
    elseif numel(values) < length(indices{1})
        values = ones(length(indices{1}), 1)*values;
    elseif ~isequal([length(indices{1}) 1], size(values))
        values = reshape(values, [numel(values) 1]);
    end
else
    if isempty(indices{1}) || isempty(indices{2}) || (min(indices{1}) < 1) || (min(indices{2}) < 1)
        error('Indices out of bound in gem::subsasgn')
    end
    if (max(indices{1}) > s(1)) || (max(indices{2}) > s(2))
        % The matrix is too small so we increase its size
        objId = result.objectIdentifier;
        gem_mex('resize', objId, max(s(1), max(indices{1})), max(s(2), max(indices{2})));
    end

    if ~isequal(length(indices{1})*length(indices{2}), numel(values))
        if numel(values) == 1
            % The value is a scalar, assigned to a matrix, as in a(1:2,2)=0
            % so we copy the scalar the number of times needed
            values = ones(length(indices{1}), length(indices{2}))*values;
        else
            error('Wrong size in element assignment');
        end
    end

    if ~isequal([length(indices{1}) length(indices{2})], size(values))
        % The shape is not as expected...
        % If it's just a matter or transposition for a vector, we readjust
        % it...
        if min([length(indices{1}) length(indices{2})])==1
            values = reshape(values, [length(indices{1}) length(indices{2})]);
        else
            % Otherwise that's an error
            error('Subscripted assignment dimension mismatch');
        end
    end
end

% We make sure values are in a gem object
if ~isequal(class(values), 'gem')
    values = gem(values);
end


%% Now we assign the requested numbers to the current object
if length(indices) == 1
    objId1 = result.objectIdentifier;
    objId2 = values.objectIdentifier;
    gem_mex('subsasgn', objId1, objId2, indices{1}-1);
else
    objId1 = result.objectIdentifier;
    objId2 = values.objectIdentifier;
    gem_mex('subsasgn', objId1, objId2, indices{1}-1, indices{2}-1);
end


end
