%% Examples
%
% Here are a few example illustrating usage of the *GEM Library*.


%% Remarkable numbers

%%
% * Printing the 100 first decimals of $\pi$
disp(gem('pi',100), -1)

%%
% Getting a string description of the first 100 decimals of $\pi$
toStrings(gem('pi',100))

%%
% * The number $e^{\sqrt{163}\pi}$ is not an integer
f = exp(sqrt(gem(163))*gem('pi'));
display(f, -1)

%%
% * The power of two irrationals can be rational
% (see also <http://www.numericana.com/answer/irrational.htm>)
x = log2(gem(9))
y = gem(2)^0.5
disp(y^x, -1)
%%
% (here numerical errors accumulated up to the last two digits)

%%
% * A sum of 8th powers: $\sum_{i=1}^{100000} i^8$
e = sum(gem([1:100000]).^8);
disp(e,-1)

%%
% * The slowest continued fraction converges to the golden ratio. 118
% iterations are needed to recover 50 digits of precision:
x = gem(1);
for i = 1:118
    x = 1/(1+x);
    if mod(i-8,10) == 0
        disp(num2str(1+x,50));
    end
end
disp(num2str((1+sqrt(gem(5)))/2, 50))

%%
% * The first few Mersenne prime numbers
p  =  [2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127, 521, 607, 1279]';
mersennes = gem(2,400).^p-1;
for i = 1:length(mersennes)
    disp(mersennes(i),-1)
end


%% Matrix manipulations

%%
% * The sparse identity and its inverse
Id = sgem(speye(3))
inv(Id)

%%
% * Computing the few largest eigenvalues of a random matrix
eigs(gem.rand(100,100))

%%
% * Solving a sparse linear system in high precision
A = sgem([2 4 1 2 2 5 1 3 5 3 4], [1 1 2 2 3 3 4 4 4 5 5], [4 -2 2 -1 -1 4 1 3 2 -6 2]);
b = [8; -1; -18; 8; 20];
x = A\b

%%
% * To solve a linear program in high precision, see <https://yalmip.github.io/solver/refiner/ Refiner>.


%% Good to know

%%
% * The default working and display precision
gem.workingPrecision
gem.displayPrecision

%%
% * |gem| and |sgem| objects can be saved to files
g = 1./gem([1:6]);
save('filename','a');
clean g;
load('filename');
g

