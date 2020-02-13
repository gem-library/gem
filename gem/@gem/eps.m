% eps - spacing between floating point numbers corresponding to the
%       precision of the first element of the object
%
% supported formats:
%   eps(x)
function result = eps(this)
    sub.type = '()';
    sub.subs = {1};
    result = 10^(-gem(precision(subsref(this, sub))));
end
