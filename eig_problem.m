% Here we give an example of complex non-hermitian matrix with degenerate
% eigenvalues, fow which it is difficult to compute the eigendecomposition
% with the current method.

load eig_problem.mat


%%
% We show the problem : this decomposition fails (!)
[a b] = eig(y);

a*b-y*a


%%
% Reproduce the problem step by step
yy = [real(y) imag(y); -imag(y) real(y)];

% This decomposition is correct
[aa bb] = eig(yy);
aa*bb-yy*aa

s = size(y,1);
for i = 1:2:2*s
    bigIfCase1 = [aa(1:s,i) + aa(s+[1:s],i+1); aa(1:s,i+1) - aa(s+[1:s],i)];
    bigIfCase2 = [aa(1:s,i) - aa(s+[1:s],i+1); aa(1:s,i+1) + aa(s+[1:s],i)];
    if norm(bigIfCase1) > 1e-3 && norm(bigIfCase2) > 1e-3
        disp(['Both indicators are large for i = ', num2str(i), ' (!)']);
    end
end


% We try to construct eigenvectors anyway







%%
% If the eigenvalues are slightly non-degenerate (here with difference
% ~1e-15, then the splitting works better
yyy = gem(a*b*inv(a));
[aaa bbb] = eig(yyy);
aaa*bbb-yyy*aaa

%%
% In this case, the eigenvectors have a very specific form (which is
% detected by the c++ code)
yyyy = [real(yyy) imag(yyy); -imag(yyy) real(yyy)];
[aaaa bbbb] = eig(yyyy)
