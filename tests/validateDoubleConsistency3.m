function validateDoubleConsistency3(func, data1, data2, data3, epsilon)
% validateDoubleConsistency3(func, data1, data2, data3, [epsilon])
%
% Checks that the action of function 'func' on the provided data is
% consistent with the function with same name applied to the data casted as
% double.
%
% Here, func accepts two arguments, the elements of data1, data2 and data3.

if nargin < 4
    error('not enough arguments');
end

if nargin < 5
    epsilon = 1e-14;
end

if ~isa(data1, 'cell') || ~isa(data2, 'cell') || ~isa(data3, 'cell')
    error('data should be provided in cell arrays');
end

if ((numel(data1) > 1) && (numel(data2) > 1) && ~isequal(size(data1), size(data2))) || ...
        (numel(data1) > 1) && (numel(data3) > 1) && ~isequal(size(data1), size(data3)) || ...
        (numel(data2) > 1) && (numel(data3) > 1) && ~isequal(size(data2), size(data3))
    error('incompatible data dimensions');
end

checkOk = @(x,y) isequal(x,y) || (isempty(x) && isempty(y)) || (isequal(numel(x), numel(y)) && (max(max(abs(x-y))) <= epsilon));
if numel(data1) == 1
    if numel(data2) == 1
        % To check the value of each test individually, use:
        %   cellfun(@(y) full(checkOk(func(data1{1},data2{1},y), func(double(data1{1}),double(data2{1}),double(y)))), data3)
        assert(all(cellfun(@(y) full(checkOk(func(data1{1},data2{1},y), func(double(data1{1}),double(data2{1}),double(y)))), data3)));
    elseif numel(data3) == 1
        % To check the value of each test individually, use:
        %   cellfun(@(y) full(checkOk(func(data1{1},y,data3{1}), func(double(data1{1}),double(y),double(data3{1})))), data2)
        assert(all(cellfun(@(y) full(checkOk(func(data1{1},y,data3{1}), func(double(data1{1}),double(y),double(data3{1})))), data2)));
    else
        for i = 1:numel(data2)
            % To check the value of each test individually, use:
            %   checkOk(func(data1{1},data2{i},data3{i}), func(double(data1{1}),double(data2{i}),double(data3{i})))
            assert(checkOk(func(data1{1},data2{i},data3{i}), func(double(data1{1}),double(data2{i}),double(data3{i}))));
        end
    end
else
    if numel(data2) == 1
        if numel(data3) == 1
            % To check the value of each test individually, use:
            %   cellfun(@(y) full(checkOk(func(y,data1{1},data3{1}), func(double(y),double(data2{1}),double(data3{1})))), data2)
            assert(all(cellfun(@(y) full(checkOk(func(y,data1{1},data3{1}), func(double(y),double(data2{1}),double(data3{1})))), data1)));
        else
            for i = 1:numel(data1)
                % To check the value of each test individually, use:
                %   checkOk(func(data1{i},data2{1},data3{i}), func(double(data1{i}),double(data2{1}),double(data3{i})))
                assert(checkOk(func(data1{i},data2{1},data3{i}), func(double(data1{i}),double(data2{1}),double(data3{i}))));
            end
        end
    else
        if numel(data3) == 1
            for i = 1:numel(data1)
                % To check the value of each test individually, use:
                %   checkOk(func(data1{i},data2{i},data3{1}), func(double(data1{i}),double(data2{i}),double(data3{1})))
                assert(checkOk(func(data1{i},data2{i},data3{1}), func(double(data1{i}),double(data2{i}),double(data3{1}))));
            end
        else
            for i = 1:numel(data1)
                % To check the value of each test individually, use:
                %   checkOk(func(data1{i},data2{i},data3{i}), func(double(data1{i}),double(data2{i}),double(data3{i})))
                assert(checkOk(func(data1{i},data2{i},data3{i}), func(double(data1{i}),double(data2{i}),double(data3{i}))));
            end
        end
    end
end

end
