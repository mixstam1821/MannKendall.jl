using MannKendall
using Test

y = rand(40*12)
x=collect(1:length(y))
reject_null_hypothesis, p_value, Tau, slope, intercept = mannkendall(x,y, alpha=0.05)
@test reject_null_hypothesis == false
@test p_value == 0.4369827573849885
@test Tau == -0.02374739039665971
@test slope == -7.613151196044908e-5
@test intercept == 0.5150870782436969
