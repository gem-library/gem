function validateDoubleConsistency(func, data, epsilon)
% validateDoubleConsistency(func, data, [epsilon])
%
% Checks that the action of function 'func' on the provided data is
% consistent with the function with same name applied to the data casted as
% double.

if nargin < 2
    error('not enough arguments');
end

if nargin < 3
    epsilon = 1e-13;
end

if ~isa(data, 'cell')
    error('data should be provided in a cell array');
end

% To check the value of each test individually, use:
%   cellfun(@(x) full(max(max(abs(func(x)-func(double(x)))))), data)
assert(all(cellfun(@(x) full(max(max(abs(func(x)-func(double(x))))) <= epsilon), data)));

end
