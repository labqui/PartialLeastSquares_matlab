function [trnYhat,tstYhat,Coef,Res]=KPLS(trnK,tstK,trny,k)
% this function performs kernel partial least squeres regression 
%
% [trnYhat,tstYhat,Coef,Res]=KPLS(trnK,tstK,trny,k)
%
% trnK:input kernel for training
% tstK:input kernel for test
% trny:responce for training
% k:the number of components (default setting is 1)
%
% trnYhat:prediction for trainig
% tstYhat:prediction for test
% Coef   :results of KPLS
% Res    :residuals

if ~exist('k','var')
    k=1;
end

% size
[n,q]=size(trny);

% set parameter
MaxItr=1000;
tol=1e-8;

T=zeros(n,k);
U=zeros(n,k);
C=zeros(q,k);
dK=trnK;
dY=trny;

for i=1:k
% initialize 
u=randn(n,1);
t=zeros(n,1);

% iteration
for j=1:MaxItr
new_t=dK*u/norm(dK*u,2);
c=dY'*new_t;
new_u=dY*c/norm(dY*c,2);

% tolerance
if norm(new_u-u,2)<tol && norm(new_t-t)<tol
    u=new_u;
    t=new_t;
    break;
else
    u=new_u;
    t=new_t;
end
end

% deflation
dK=(eye(n)-t*t')*dK*(eye(n)-t*t');
dY=dY-t*t'*dY;
U(:,i)=u;
T(:,i)=t;
C(:,i)=c;
end

% store coefficients
Coef.U=U;
Coef.T=T;
Coef.C=C;

% store residuals
Res.X=dK;
Res.Y=dY;

% trnYhat:prediction for trainig
trnYhat=trnK*U*((T'*trnK*U)\T'*trny);

% trnYhat:prediction for test
tstYhat=tstK*U*((T'*trnK*U)\T'*trny);
    