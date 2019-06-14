%% Examples
%
% Here are a few example illustrating usage of the *GEM Library*.

%%
% * Printing the 100 first decimals of $\pi$
disp(gem('pi',100), -1)

%%
% * Getting a string description of the first 100 decimals of $\pi$
toStrings(gem('pi',100))

%%
% * Creating 50-digits precision representations of the numbers 2 and 1.23,
% and of the vector [1 2 3]
a = gem(2)
b = gem(1.23)
c = gem([1 2 3])
%%
% When translating a number from double form, exactly 15 digits are taken
% into account.

%%
% * Creating a 50-digits representation of a number provided in text form
% (all specified digits are taken into account for numbers provided in
% string format)
d = gem('1.23456789123456789+2i')

%%
% * The default working and display precision
gem.workingPrecision
gem.displayPrecision

%%
% * Computing the few largest eigenvalues of a random matrix
eigs(gem.rand(100,100))

%%
% * Summing 8th powers: $\sum_{i=1}^{100000} i^8$
e = sum(gem([1:100000]).^8);
disp(e,-1)

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
% (here numerical errors were accumulated up to the last two digits)


%%
% * A sparse identity
sgem(speye(3))

%%
% * |gem| and |sgem| objects can be saved to files
g = 1./gem([1:6]);
save('filename','a');
clean a;
load('filename');
g

%%
% * The slowest continued fraction converges to the golden ratio. 118
% iterations are needed to recover 50 digits of precision:
x = gem(1);
for i = 1:118
    x = 1/(1+x);
    disp(num2str(1+x,50));
end
disp(num2str((1+sqrt(gem(5)))/2, 50))
