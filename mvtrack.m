
%returns 0 if the distance is greater than the max dist provided
function [c] = mvtrack(ma,mb,maxError, Fc)
 c=0;
 dEpi   = Bmv_epidist(double([ma 1]'),double([mb 1]'),Fc);
if (dEpi<maxError)
    c=1;
end                        
 
%% test
c = dEpi;

