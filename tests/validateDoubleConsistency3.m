function validateDoubleConsistency3(func, data1, data2, data3, epsilon, upToCommonLength, forceFull)
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
    epsilon = 1e-12;
end

if nargin < 6
    upToCommonLength = 0;
end

if nargin < 7
    forceFull = 0;
end

if ~isa(data1, 'cell') || ~isa(data2, 'cell') || ~isa(data3, 'cell')
    error('data should be provided in cell arrays');
end

if ((numel(data1) > 1) && (numel(data2) > 1) && ~isequal(size(data1), size(data2))) || ...
        (numel(data1) > 1) && (numel(data3) > 1) && ~isequal(size(data1), size(data3)) || ...
        (numel(data2) > 1) && (numel(data3) > 1) && ~isequal(size(data2), size(data3))
    error('incompatible data dimensions');
end

xdy = @(x,y) double(x)-double(y); % To circumvent bug in octave 4.4 not present in octave 4.2
if upToCommonLength == 1
    commonLength = @(x,y) min(length(x), length(y));
    checkOk = @(x,y) isequal(x,y) || (isempty(x) && isempty(y)) || (max(max(abs(xdy(x(1:commonLength(x,y)), y(1:commonLength(x,y)))))) <= epsilon);
else
    checkOk = @(x,y) isequal(x,y) || (isempty(x) && isempty(y)) || (isequal(numel(x), numel(y)) && (max(max(abs(xdy(x,y)))) <= epsilon));
end
if numel(data1) == 1
    if numel(data2) == 1
        % To check the value of each test individually, use:
        %   cellfun(@(y) full(checkOk(func(data1{1},data2{1},y), func(double(data1{1}),double(data2{1}),double(y)))), data3)
        if forceFull == 1
            assert(all(cellfun(@(y) full(checkOk(func(data1{1},data2{1},y), func(double(full(data1{1})),double(full(data2{1})),double(full(y))))), data3)));
        else
            assert(all(cellfun(@(y) full(checkOk(func(data1{1},data2{1},y), func(double(data1{1}),double(data2{1}),double(y)))), data3)));
        end
    elseif numel(data3) == 1
        % To check the value of each test individually, use:
        %   cellfun(@(y) full(checkOk(func(data1{1},y,data3{1}), func(double(data1{1}),double(y),double(data3{1})))), data2)
        if forceFull == 1
            assert(all(cellfun(@(y) full(checkOk(func(data1{1},y,data3{1}), func(double(full(data1{1})),double(full(y)),double(full(data3{1}))))), data2)));
        else
            assert(all(cellfun(@(y) full(checkOk(func(data1{1},y,data3{1}), func(double(data1{1}),double(y),double(data3{1})))), data2)));
        end
    else
        for i = 1:numel(data2)
            % To check the value of each test individually, use:
            %   checkOk(func(data1{1},data2{i},data3{i}), func(double(data1{1}),double(data2{i}),double(data3{i})))
            if forceFull == 1
                assert(checkOk(func(data1{1},data2{i},data3{i}), func(double(full(data1{1})),double(full(data2{i})),double(full(data3{i})))));
            else
                assert(checkOk(func(data1{1},data2{i},data3{i}), func(double(data1{1}),double(data2{i}),double(data3{i}))));
            end
        end
    end
else
    if numel(data2) == 1
        if numel(data3) == 1
            % To check the value of each test individually, use:
            %   cellfun(@(y) full(checkOk(func(y,data1{1},data3{1}), func(double(y),double(data2{1}),double(data3{1})))), data2)
            if forceFull == 1
                assert(all(cellfun(@(y) full(checkOk(func(y,data1{1},data3{1}), func(double(full(y)),double(full(data2{1})),double(full(data3{1}))))), data1)));
            else
                assert(all(cellfun(@(y) full(checkOk(func(y,data1{1},data3{1}), func(double(y),double(data2{1}),double(data3{1})))), data1)));
            end
        else
            for i = 1:numel(data1)
                % To check the value of each test individually, use:
                %   checkOk(func(data1{i},data2{1},data3{i}), func(double(data1{i}),double(data2{1}),double(data3{i})))
                if forceFull == 1
                    assert(checkOk(func(data1{i},data2{1},data3{i}), func(double(full(data1{i})),double(full(data2{1})),double(full(data3{i})))));
                else
                    assert(checkOk(func(data1{i},data2{1},data3{i}), func(double(data1{i}),double(data2{1}),double(data3{i}))));
                end
            end
        end
    else
        if numel(data3) == 1
            for i = 1:numel(data1)
                % To check the value of each test individually, use:
                %   checkOk(func(data1{i},data2{i},data3{1}), func(double(data1{i}),double(data2{i}),double(data3{1})))
                if forceFull == 1
                    assert(checkOk(func(data1{i},data2{i},data3{1}), func(full(double(data1{i})),double(full(data2{i})),double(full(data3{1})))));
                else
                    assert(checkOk(func(data1{i},data2{i},data3{1}), func(double(data1{i}),double(data2{i}),double(data3{1}))));
                end
            end
        else
            for i = 1:numel(data1)
                % To check the value of each test individually, use:
                %   checkOk(func(data1{i},data2{i},data3{i}), func(double(data1{i}),double(data2{i}),double(data3{i})))
                if forceFull == 1
                    assert(checkOk(func(data1{i},data2{i},data3{i}), func(double(full(data1{i})),double(full(data2{i})),double(full(data3{i})))));
                else
                    assert(checkOk(func(data1{i},data2{i},data3{i}), func(double(data1{i}),double(data2{i}),double(data3{i}))));
                end
            end
        end
    end
end

end
