using Statistics, StatsFuns
# The non-parametric Mann-Kendall test and Sen's Slope for Julia Programming Language. 
# inspired by [1] TheilSen.m [Copyright (c) 2015, Zachary Danziger] , and [2] Mann_Kendall.m  [Copyright (c) 2009, Simone Fatichi]
# The Mann-Kendall Test is used to determine whether a time series has a monotonic upward or downward trend. It does not require that the data be normally distributed or linear. It does require that there is no autocorrelation.
# The null hypothesis for this test is that there is no trend, and the alternative hypothesis is that there is a trend in the two-sided test or that there is an upward trend (or downward trend) in the one-sided test.
# INPUT: x=collect(1:length(y)) , y: data (1-D Array), alpha: significance level (0.05 is the default)
# OUTPUT: reject_null_hypothesis,p_value,Tau,slope,intercept ,    *reject_null_hypothesis is True or False
# ~ ATTENTION ! It does have some limitations to computer memory. For example, if a dataset is around 10,000 in length, 1.0 GB RAM do not work. ~
# ~ I would greatly appreciate if anyone could find a solution to this. Created on 26/04/2021 by Michael Stamatis ~
function mk(x,y,alpha=0.05)
	V=reshape(y,length(y),1)   ;   n=length(V)
	i=0; j=0; S=0; 
	for i=1:n-1
	   for j= i+1:n 
	      S= S + sign(V[j]-V[i])
	   end
	end
	VarS=(n*(n-1)*(2*n+5))/18  ;   StdS=sqrt(VarS) 
	if S >= 0
	   Z=((S-1)/StdS)
	elseif S==0
		Z=0
	else
	   Z=(S+1)/StdS
	end
	p_value=2*(1-normcdf(abs(Z))) # Two-tailed test 
	pz=norminvcdf(1-alpha/2)
	H=abs(Z)>pz #
	tau = S/(0.5*n*(n-1))   #Mann-Kendall coefficient NOT adjusted for ties

	sz = size([x y])
	data = Matrix([x y]) 
	C = zeros(size([x y])[1],size([x y])[1])
    for i=1:sz[1]
        # accumulate slopes
        C[i,:] = (data[i,2].-data[:,2])./(data[i,1] .- data[:,1]);
    end
    m = median(filter(!isnan, C[:]))                       # calculate slope estimate

    b = median(data[:,2].-m*data[:,1])   # calculate intercept if requested
	result = (reject_null_hypothesis=H,p_value=p_value,Tau=tau,slope=m,intercept=b)
	return result
end

# Example
# julia> y = rand(40*12)
# julia> x=collect(1:length(y))
# julia> mk(x,y)                                                                                                                                              
# (reject_null_hypothesis = false, p_value = 0.4369827573849885, Tau = -0.02374739039665971, slope = -7.613151196044908e-5, intercept = 0.5150870782436969)
