function make(parallelization, useSharedGmpAndMpfr, genericBuild)
% make([parallelization], [useSharedGmpAndMpfr], [genericBuild])
%
% Use this script from matlab/octave to compile the C++ part of the GEM library.
%
% Parameters:
%   parallelization = 1 (default is 1) to enable openmp
%
%   useSharedGmpAndMpfr = 1 (default is 1) in order to use the GMP and MPFR
%     libraries installed on your system. If you do not have these
%     libraries pre-installed on your system, set useSharedGmpAndMpfr to 0
%     (see below for more details)
%
%   genericBuild = 1 (default is 0) to let matlab/octave choose the build
%     command. This should be more robust to the variety of systems setups
%     as matlab/octave is aware of its own installation, but is hard to
%     test. You can try this option if the default command doesn't work.
%
%
% Note 1 : The code relies on several external libraries such as eigen,
% spectra, gmp, mpfr and mpfrc++, which are included as git submodules.
% They should be downloaded with the command
%
%     git submodule update --init
%
% On ubuntu, the three remaining libraries can be installed by running the 
% following command in the terminal :
%
%     sudo apt install libgmp-dev libmpfr-dev libmpfrc++-dev
%
% The option 'useSharedGmpAndMpfr' can then be left to 1.
%
% Otherwise, if these last libraries are not installed on your system, it is 
% possible to perform a compilation with gmp and mpfr source codes directly
% instead of relying on precompiled gmp and mpfr libraries (this should be
% the way to go non-linux systems). On windows, these should be compiled on
% their own. On the other platforms, they can be built by the present
% script from matlab. For this, call this script from matlab with the
% option 'useSharedGmpAndMpfr' set to 0.
%
%
% Note 2 : Several of the command below are quite plaftorm/version specific.
% It is thus likely that they should be adapted to new versions of the
% operating system or matlab/octave. This is the reason for the 'genericBuild'
% option, though the default build mechanism does not always work. The following
% command is useful to see how matlab plans to perform the computation on a
% given system:
%   mex -n -R2017b -largeArrayDims -I../external/eigen/eigen -I../external/eigen/eigen/unsupported -I../external/eigen/spectra/include -I/usr/include -lmpfr -lgmp src/gem_mex.cpp src/gem.cpp src/sgem.cpp src/utils.cpp



%% Settings
if nargin < 1
    parallelization = 1;
end

% Set the following variable to 0 in order to compile a library which does
% not depend on shared gmp and mpfr libraries:
if nargin < 2
    useSharedGmpAndMpfr = 1;
end

if nargin < 3
    genericBuild = 0;
end

if (~ispc)
    warning('You are trying to compile the GEM library, but binaries may be available for your platform on https://www.github.com/gem-library/gem/releases');
end


%% We perform some checks
% This file needs to be run from within its folder
tmp = mfilename('fullpath');
if ispc
    tmp = tmp(1:find(tmp=='\',1,'last')-1);
else
    tmp = tmp(1:find(tmp=='/',1,'last')-1);
end
if ~isequal(tmp, pwd)
    error('The gem library should be compiled from its own folder.');
end

% We extract the matlab version
v = version;
vDots = find(v=='.');
v = str2num(v(1:vDots(2)-1));


% We check that the eigen and spectra source code were downloaded
list = dir('external');
eigenFolder = '';
spectraFolder = '';
for i=1:length(list)
    if isequal(lower(list(i).name(1:min(end,5))),'eigen')
        eigenFolder = list(i).name;
    end
    if isequal(lower(list(i).name(1:min(end,7))),'spectra')
        spectraFolder = list(i).name;
    end
end
if isempty(eigenFolder)
    error('The eigen folder was not found in the gem/external folder. Please run the command `git submodule update --init`.');
end
if isempty(spectraFolder)
    error('The spectra source code was not found in the gem/external folder. Please run the command `git submodule update --init`');
end
eigenFolder = ['external/', eigenFolder];
spectraFolder = ['external/', spectraFolder];


% We set the flags needed for parallelization (if requested and if possible)
if parallelization == 1
    parallelizationFlag = '-pthread -fopenmp';
else
    parallelizationFlag = '';
end


% additional flags
optimizationFlag = '-O3';

% all flags
flags = [parallelizationFlag, ' ', optimizationFlag];%, ' -R2017b'];

% Check if we are running octave
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;


%% Now we proceed to compilation
if useSharedGmpAndMpfr == 1
    if (ismac) || (~isunix)
        % If we pass here, we expect to be on a non-linux machine, but
        % environments are only well defined on linux... so we suggest to
        % go proceed another way
        warning('Trying to compile the GEM library with shared GMP and MPFR libraries, but it is not clear whether these libraries are available on the system. You may want to try compiling without shared libraries first.');
    end
    
    if genericBuild == 1
        % We just do a generic build
        cd src
        eval(['mex -I../', eigenFolder, ' -I../', eigenFolder, '/unsupported -I../', spectraFolder, '/include -lmpfr -lgmp ', flags, ' gem_mex.cpp gem.cpp sgem.cpp utils.cpp']);
        eval(['mex -I../', eigenFolder, ' -I../', eigenFolder, '/unsupported -I../', spectraFolder, '/include -lmpfr -lgmp ', flags, ' sgem_mex.cpp gem.cpp sgem.cpp utils.cpp']);
        resultCode(1) = exist(['./gem_mex.', mexext]) ~= 3;
        resultCode(2) = exist(['./sgem_mex.', mexext]) ~= 3;
        eval(['movefile *.', mexext, ' ../gem']);
        cd ..
    else
        if isOctave
            resultCode(1) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/utils.cpp -o src/utils.o']);
            resultCode(2) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/gem.cpp -o src/gem.o']);
            resultCode(3) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/gem_mex.cpp -o src/gem_mex.o']);
            resultCode(4) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/sgem.cpp -o src/sgem.o']);
            resultCode(5) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/sgem_mex.cpp -o src/sgem_mex.o']);
            resultCode(6) = unix(['g++ -Wl,--no-undefined -fstack-protector-strong -Wl,-z,relro -shared src/gem_mex.o src/gem.o src/sgem.o src/utils.o -lmpfr -lgmp -L', matlabroot, '/lib/octave/', version, ' -L/usr/lib/x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu/octave/', version, ' -loctinterp -loctave -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o gem/gem_mex.', mexext]);
            resultCode(7) = unix(['g++ -Wl,--no-undefined -fstack-protector-strong -Wl,-z,relro -shared src/sgem_mex.o src/sgem.o src/gem.o src/utils.o -lmpfr -lgmp -L', matlabroot, '/lib/octave/', version, ' -L/usr/lib/x86_64-linux-gnu -L/usr/lib/x86_64-linux-gnu/octave/', version, ' -loctinterp -loctave -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o gem/sgem_mex.', mexext]);
        else
            resultCode(1) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/utils.cpp -o src/utils.o']);
            resultCode(2) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/gem.cpp -o src/gem.o']);
            resultCode(3) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/gem_mex.cpp -o src/gem_mex.o']);
            resultCode(4) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/sgem.cpp -o src/sgem.o']);
            resultCode(5) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG src/sgem_mex.cpp -o src/sgem_mex.o']);
            resultCode(6) = unix(['g++ -Wl,--no-undefined  -shared -Wl,--version-script,"', matlabroot, '/extern/lib/', lower(computer), '/mexFunction.map" src/gem_mex.o src/gem.o src/sgem.o src/utils.o   -lmpfr  -lgmp   -Wl,-rpath-link,', matlabroot, '/bin/', lower(computer), ' -L"', matlabroot, '/bin/', lower(computer), '" -lmx -lmex -lmat -lm -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o gem/gem_mex.', mexext]);
            resultCode(7) = unix(['g++ -Wl,--no-undefined  -shared -Wl,--version-script,"', matlabroot, '/extern/lib/', lower(computer), '/mexFunction.map" src/sgem_mex.o src/sgem.o src/gem.o src/utils.o   -lmpfr  -lgmp   -Wl,-rpath-link,', matlabroot, '/bin/', lower(computer), ' -L"', matlabroot, '/bin/', lower(computer), '" -lmx -lmex -lmat -lm -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o gem/sgem_mex.', mexext]);
        end
    end
else
    % Here we compile a version of the library which does not rely on the
    % gmp and mpfr shared libraries. Rather, it uses the source code of
    % these libraries directly, or a precompiled version (in the case of
    % windows).

    % We check that the gmp, mpfr and mpfrc++ sources are available
    gmpFolder = '';
    mpfrFolder = '';
    mpfrcppFolder = '';
    for i=1:length(list)
        if isequal(lower(list(i).name(1:min(end,3))),'gmp')
            gmpFolder = list(i).name;
        end
        if isequal(lower(list(i).name(1:min(end,4))),'mpfr') && ~isequal(lower(list(i).name(1:min(end,7))),'mpfrc++')
            mpfrFolder = list(i).name;
        end
        if isequal(lower(list(i).name(1:min(end,7))),'mpfrc++')
            mpfrcppFolder = list(i).name;
        end
    end
    if isempty(gmpFolder)
        error('The gmp source code was not found.');
    end
    if isempty(mpfrFolder)
        error('The mpfr source code was not found.');
    end
    if isempty(mpfrcppFolder) || ~isequal(exist(['external/', mpfrcppFolder, '/mpreal.h']), 2)
        error('The mpfrc++ source code was not found.');
    end
    
    % We compile the libraries if needed
    cd external
    if exist('staticLibraries') ~= 7
        unix('mkdir staticLibraries');
    end
    if (ispc) && (exist('staticLibraries/windows') == 7)
        % We just copy the pre-compiled libraries for windows
        disp('Copying pre-compiled GMP and MPFR libraries from the ''external/staticLibraries/windows'' subfolder.')
        copyfile external/staticLibraries/windows/* external/staticLibraries/
    else
        if exist('staticLibraries/lib/libgmp.a') ~= 2
            if ispc
                error('Please download msys (e.g. from https://sourceforge.net/projects/mingw-w64/files/External%20binary%20packages%20%28Win64%20hosted%29/MSYS%20%2832-bit%29/MSYS-20111123.zip/download) and follow the instructions in docs/compilationInstructions.md before launching this file.');
            end
            cd(gmpFolder);
            unix('./configure --disable-shared --enable-static CFLAGS=-fPIC --with-pic --prefix=`pwd`/../staticLibraries');
            unix('make');
            unix('make check');
            unix('make install');
            cd ..
        end
        if exist('staticLibraries/lib/libmpfr.a') ~= 2
            cd(mpfrFolder);
            unix('./autogen.sh')
            unix('./configure --disable-shared --enable-static CFLAGS=-fPIC --with-pic --prefix=`pwd`/../staticLibraries --with-gmp=`pwd`/../staticLibraries');
            unix('make');
            unix('make check');
            unix('make install');
            cd ..
        end
    end
    cd ..

    
    % Now gmp and mpfr should be ready, we can compile gem
    cd src
    % We adjust all paths
    eigenFolder = ['../', eigenFolder];
    spectraFolder = ['../', spectraFolder];
    mpfrcppFolder = ['../external/', mpfrcppFolder];
    
    if (genericBuild == 1) || (ismac && isOctave) || (ispc)
        % We just do a generic build, wither because it was asked for, or
        % because this is the best we can do on these systems.
        if ~isempty(parallelizationFlag)
            parallelizationFlag = ['CXXFLAGS=''$CXXFLAGS ', parallelizationFlag, ''''];
        end
        if ~isempty(optimizationFlag)
            optimizationFlag = ['CXXOPTIMFLAGS=''', optimizationFlag, ' $CXXOPTIMFLAGS ', optimizationFlag, ''''];
        end
        eval(['mex -v ', parallelizationFlag, ' ', optimizationFlag, ' LDFLAGS=''$LDFLAGS -fopenmp'' -R2017b -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I', mpfrcppFolder, ' -I../external/staticLibraries/include -L../external/staticLibraries/lib -lmpfr -lgmp gem_mex.cpp gem.cpp sgem.cpp utils.cpp']);
        eval(['mex -v ', parallelizationFlag, ' ', optimizationFlag, ' LDFLAGS=''$LDFLAGS -fopenmp'' -R2017b -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', spectraFolder, '/include -I', mpfrcppFolder, ' -I../external/staticLibraries/include -L../external/staticLibraries/lib -lmpfr -lgmp sgem_mex.cpp gem.cpp sgem.cpp utils.cpp']);
        resultCode(1) = exist(['./gem_mex.', mexext]) ~= 3;
        resultCode(2) = exist(['./sgem_mex.', mexext]) ~= 3;
        eval(['movefile *.', mexext, ' ../gem']);
    else
        if isunix && (~ismac)
            if isOctave
                resultCode(1) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG utils.cpp -o utils.o']);
                resultCode(2) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG gem.cpp -o gem.o']);
                resultCode(3) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG gem_mex.cpp -o gem_mex.o']);
                resultCode(4) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG sgem.cpp -o sgem.o']);
                resultCode(5) = unix(['g++ -c -Wdate-time  -I"', matlabroot, '/include/octave-', version, '/octave" -I/usr/include/hdf5/serial -I/usr/include/mpi -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include -fstack-protector-strong -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG sgem_mex.cpp -o sgem_mex.o']);
                resultCode(6) = unix(['g++ -Wl,--no-undefined -fstack-protector-strong -Wl,-z,relro -shared gem_mex.o gem.o sgem.o utils.o ../external/staticLibraries/lib/libmpfr.a ../external/staticLibraries/lib/libgmp.a -L', matlabroot, '/lib/x86_64-linux-gnu/octave/', version, ' -loctinterp -loctave -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o ../gem/gem_mex.', mexext]);
                resultCode(7) = unix(['g++ -Wl,--no-undefined -fstack-protector-strong -Wl,-z,relro -shared sgem_mex.o sgem.o gem.o utils.o ../external/staticLibraries/lib/libmpfr.a ../external/staticLibraries/lib/libgmp.a -L', matlabroot, '/lib/x86_64-linux-gnu/octave/', version, ' -loctinterp -loctave -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o ../gem/sgem_mex.', mexext]);
            else
                resultCode(1) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG utils.cpp -o utils.o']);
                resultCode(2) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG gem.cpp -o gem.o']);
                resultCode(3) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG gem_mex.cpp -o gem_mex.o']);
                resultCode(4) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG sgem.cpp -o sgem.o']);
                resultCode(5) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', flags, ' -DEIGEN_NO_DEBUG -DNDEBUG sgem_mex.cpp -o sgem_mex.o']);
                resultCode(6) = unix(['g++ -Wl,--no-undefined  -shared -Wl,--version-script,"', matlabroot, '/extern/lib/', lower(computer), '/mexFunction.map" gem_mex.o gem.o sgem.o utils.o  ../external/staticLibraries/lib/libmpfr.a ../external/staticLibraries/lib/libgmp.a  -Wl,-rpath-link,', matlabroot, '/bin/', lower(computer), ' -L"', matlabroot, '/bin/', lower(computer), '" -lmx -lmex -lmat -lm -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o ../gem/gem_mex.', mexext]);
                resultCode(7) = unix(['g++ -Wl,--no-undefined  -shared -Wl,--version-script,"', matlabroot, '/extern/lib/', lower(computer), '/mexFunction.map" sgem_mex.o sgem.o gem.o utils.o  ../external/staticLibraries/lib/libmpfr.a ../external/staticLibraries/lib/libgmp.a  -Wl,-rpath-link,', matlabroot, '/bin/', lower(computer), ' -L"', matlabroot, '/bin/', lower(computer), '" -lmx -lmex -lmat -lm -lstdc++ ', flags, ' -DEIGEN_NO_DEBUG -o ../gem/sgem_mex.', mexext]);
            end
        elseif ismac
            % Note that Octave on OSX returns true for both ismac and
            % isunix... still, if we are here we must be called from matlab
            % For mac it seems we can just use gcc almost the same way...er, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', parallelizationFlag, ' ', optimizationFlag, ' -DEIGEN_NO_DEBUG -DNDEBUG gem_mex.cpp -o gem_mex.o']);
            resultCode(4) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', parallelizationFlag, ' ', optimizationFlag, ' -DEIGEN_NO_DEBUG -DNDEBUG sgem.cpp -o sgem.o']);
            resultCode(5) = unix(['g++ -c -D_GNU_SOURCE -DMATLAB_MEX_FILE -DMEX_DOUBLE_HANDLE  -I', eigenFolder, ' -I', eigenFolder, '/unsupported -I', mpfrcppFolder, ' -I../external/staticLibraries/include -I', spectraFolder, '/include -I/usr/include  -I"', matlabroot, '/extern/include" -I"', matlabroot, '/simulink/include" -ansi -fexceptions -fPIC -fno-omit-frame-pointer -Wno-deprecated -std=c++11 ', parallelizationFlag, ' ', optimizationFlag, ' -DEIGEN_NO_DEBUG -DNDEBUG sgem_mex.cpp -o sgem_mex.o']);
            resultCode(6) = unix(['g++ -Wl,-undefined,error  -shared gem_mex.o gem.o sgem.o utils.o  ../external/staticLibraries/lib/libmpfr.a ../external/staticLibraries/lib/libgmp.a  -L"', matlabroot, '/bin/', lower(computer), '" -lmx -lmex -lmat -lm -lstdc++ ', parallelizationFlag, ' ', optimizationFlag, ' -DEIGEN_NO_DEBUG -o ../gem/gem_mex.', mexext]);
            resultCode(7) = unix(['g++ -Wl,-undefined,error  -shared sgem_mex.o sgem.o gem.o utils.o  ../external/staticLibraries/lib/libmpfr.a ../external/staticLibraries/lib/libgmp.a  -L"', matlabroot, '/bin/', lower(computer), '" -lmx -lmex -lmat -lm -lstdc++ ', parallelizationFlag, ' ', optimizationFlag, ' -DEIGEN_NO_DEBUG -o ../gem/sgem_mex.', mexext]);
        else
            error('System not recognized');
        end
    end
    cd ..
end

% Was the compilation successful?
if sum(resultCode) == 0
    disp('Compilation successful.');
else
    error('Compilation error.');
end

return;


