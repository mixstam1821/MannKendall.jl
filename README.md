# Mann_Kendall.jl
The non-parametric Mann-Kendall test and Sen's Slope for Julia Programming Language

# Example
```julia
using MannKendall
y = rand(40*12)
x = collect(1:length(y))
mannkendall(x,y)                                                                                                                                              
(reject_null_hypothesis = false, p_value = 0.4369827573849885, Tau = -0.02374739039665971, slope = -7.613151196044908e-5, intercept = 0.5150870782436969)
```
