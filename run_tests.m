function result = run_tests(withCoverage, fastCheck)
% function result = run_tests([withCoverage], [fastCheck])
%
% launches automatic tests for the GEM Library
% Generates code coverage data if the option 'withCoverage' is set to 1.

% Input management
if nargin < 1
    withCoverage = 0;
end

if nargin < 2
    fastCheck = 0;
end

global fastTests
if fastCheck == 1
    fastTests = 1;
else
    fastTests = 0;
end


% First, we make sure we are in the good folder
initialPath = pwd;
[pathStr, name, extension] = fileparts(which(mfilename));
cd(pathStr)

% We make sure gem is in the path
addpath([pathStr '/gem']);

% We make sure MOxUnit is in the path
MOxUnitInPath = false;
try
    moxunit_set_path;
    MOxUnitInPath = true;
catch
end
if ~MOxUnitInPath
    if exist([pathStr '/external/MOxUnit/MOxUnit/moxunit_set_path.m']) ~= 2
        error(['The MOxUnit library was not found in the folder ', pathStr, '/external/MOxUnit', char(10), ...
            'Did you run ''git submodule update --init''?', char(10), ...
            'The tests cannot be run.']);
    else
        addpath([pathStr '/external/MOxUnit/MOxUnit']);
        moxunit_set_path;
    end
end

% We make sure MOcov is in the path if needed
if withCoverage == 1
    MOcovInPath = false;
    try
        mocov_get_absolute_path('.');
        MOcovInPath = true;
    catch
    end
    if ~MOcovInPath
        if exist([pathStr '/external/MOcov/MOcov/mocov.m']) ~= 2
            error(['The MOcov library was not found in the folder ', pathStr, '/external/MOcov', char(10), ...
                'Did you run ''git submodule update --init?', char(10), ...
                'The tests cannot be run with coverage.']);
        else
            addpath([pathStr '/external/MOcov/MOcov']);
        end
    end
end

% We also add the test folder to the path
addpath([pathStr '/tests']);

% Run the tests
if withCoverage == 1
    result = moxunit_runtests('tests', '-verbose', '-recursive', '-junit_xml_file', 'testresults.xml', ...
                              '-with_coverage', '-cover', 'gem', '-cover_json_file', 'coverage.json');%, '-cover_xml_file', 'coverage.xml', '-cover_html_dir', 'coverage_html');
else
    result = moxunit_runtests('tests', '-verbose', '-recursive');
end

% Go back to the initial folder    
cd(initialPath);

end
