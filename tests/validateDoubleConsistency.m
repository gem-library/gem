function validateDoubleConsistency(func, data, epsilon, upToCommonLength)
% validateDoubleConsistency(func, data, [epsilon])
%
% Checks that the action of function 'func' on the provided data is
% consistent with the function with same name applied to the data casted as
% double.

if nargin < 2
    error('not enough arguments');
end

if nargin < 3
    epsilon = 1e-12;
end

if nargin < 4
    upToCommonLength = 0;
end

if ~isa(data, 'cell')
    error('data should be provided in a cell array');
end

xdy = @(x,y) double(x)-double(y); % To circumvent bug in octave 4.4 not present in octave 4.2
if upToCommonLength
    commonLength = @(x,y) min(length(x), length(y));
    checkOk = @(x,y) isequal(x,y) || (isempty(x) && isempty(y)) || (max(max(abs(xdy(x(1:commonLength(x,y)), y(1:commonLength(x,y)))))) <= epsilon);
else
    checkOk = @(x,y) isequal(x,y) || (isempty(x) && isempty(y)) || (isequal(numel(x), numel(y)) && (max(max(abs(xdy(x,y)))) <= epsilon));
end
% To check the value of each test individually, use:
%   cellfun(@(x) full(max(max(abs(func(x)-func(double(x)))))), data)
%   cellfun(@(x) full(checkOk(func(x), func(double(x)))), data)
assert(all(cellfun(@(x) full(checkOk(func(x), func(double(x)))), data)));

end
