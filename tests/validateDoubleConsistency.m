function validateDoubleConsistency(func, data, epsilon)
% validateDoubleConsistency(func, data, [epsilon])
%
% Checks that the action of function 'func' on the provided data is
% consistent with the function with same name applied to the data casted as
% double.

if nargin < 3
    epsilon = 1e-14;
end

% To check the value of each test individually, use:
%   cellfun(@(x) full(max(abs(func(x)-func(double(x))), [], 'all')), data)
assert(all(cellfun(@(x) full(max(abs(func(x)-func(double(x))), [], 'all') <= epsilon), data)));

end
