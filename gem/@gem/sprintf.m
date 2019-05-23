% sprintf - redirects to matlab's sprintf function with double conversion
%
% Standard format are supported up to double precision. To be more precise,
% use the format of the kind %25.20g . This produces a string of width at
% least 25, with 20 digits of precision (the width is adjusted if needed to
% fit all digits).
%
% Example : sprintf('%42.40g', [gem('pi'); gem('e')])
%
% See also toStrings.m
function result = sprintf(varargin)

    if (nargin == 2) && ischar(varargin{1}) ...
            && (varargin{1}(1) == '%') && (varargin{1}(2) ~= '#') && (sum(varargin{1}=='.')==1) && (varargin{1}(end) == 'g')

        % Then we construct the string by hand
        
        % parameters
        format = varargin{1};
        width = abs(str2double(format(2:find(format=='.')-1)));
        precision = str2double(format(find(format=='.')+1:end-1));
        width = max(width,precision+1);
        
        txt = toStrings(varargin{2},precision);
        if ~iscell(txt)
            tmp = txt;
            txt = cell(1);
            txt{1} = tmp;
        end
        for i = 1:numel(txt)
            if length(txt{i}) < width
                txt{i} = [char(32*ones(1,width-length(txt{i}))), txt{i}];
%             elseif length(txt{i}) > width
%                 warning('Truncating the number to fit requested width, is the width large enough for the requested precision?');
%                 txt{i} = txt{i}(1:width);
            end
        end
        
        text = '';
        for i = 1:size(txt,1)
            text(i,:) = [txt{i,:}];
        end
        
        result = text;
        
    else
        % We convert gem objects to double and rely on matlab's
        % implementation
        for i = 1:nargin
            if isequal(class(varargin{i}), 'gem') || isequal(class(varargin{i}), 'sgem')
                varargin{i} = double(varargin{i});
            end
        end

        % Now we call matlab's sprintf function
        result = sprintf(varargin{:});
    end
end
