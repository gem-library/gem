function validateDoubleConsistency2(func, data1, data2, epsilon)
% validateDoubleConsistency2(func, data1, data2, [epsilon])
%
% Checks that the action of function 'func' on the provided data is
% consistent with the function with same name applied to the data casted as
% double.
%
% Here, func accepts two arguments, the elements of data1 and data2.

if nargin < 3
    error('not enough arguments');
end

if nargin < 4
    epsilon = 1e-14;
end

if ~isa(data1, 'cell') || ~isa(data2, 'cell')
    error('data should be provided in cell arrays');
end

if (numel(data1) > 1) && (numel(data2) > 1) && ~isequal(size(data1), size(data2))
    error('incompatible data dimensions');
end

checkOk = @(x,y) isequal(x,y) || (isempty(x) && isempty(y)) || (isequal(numel(x), numel(y)) && (max(max(abs(x-y))) <= epsilon));
if numel(data1) == 1
    % To check the value of each test individually, use:
    %   cellfun(@(y) full(checkOk(func(data1{1},y), func(double(data1{1}),double(y)))), data2)
    assert(all(cellfun(@(y) full(checkOk(func(data1{1},y), func(double(data1{1}),double(y)))), data2)));
elseif numel(data2) == 1
    % To check the value of each test individually, use:
    %   cellfun(@(x) full(checkOk(func(x,data2{1}), func(double(x),double(data2{1})))), data1)
    assert(all(cellfun(@(x) full(checkOk(func(x,data2{1}), func(double(x),double(data2{1})))), data1)));
else
    for i = 1:numel(data1)
        % To check the value of each test individually, use:
        %   checkOk(func(data1{i},data2{i}), func(double(data1{i}),double(data2{i})))
        assert(checkOk(func(data1{i},data2{i}), func(double(data1{i}),double(data2{i}))));
    end
end

end
