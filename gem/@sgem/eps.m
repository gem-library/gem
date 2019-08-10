% eps - spacing between floating point numbers corresponding to the
%       precision of the first non-zero element of the object
%
% supported formats:
%   eps(x)
function result = eps(this)
    sub.type = '()';
    sub.subs = {find(this,1)};
    result = 10^(-gem(precision(subsref(this, sub))));
end
