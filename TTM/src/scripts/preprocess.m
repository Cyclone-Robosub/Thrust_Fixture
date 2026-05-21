%%preprocess
%   This script applies a digital filter to the white noise layered data
%   and also adjusts for delays, editing the total time span of both the
%   ideal timeseries data and the filtered timeseries data.
% filter order is what you have to mess with
% I don't know enough to adaquately adjust it myself...
fs = 10;
wc = .05;
fo = 7;
dfilter = designfilt('lowpassfir', 'FilterOrder', fo, 'CutoffFrequency', wc, 'SampleRate', fs);
delay = mean(grpdelay(dfilter));
delay = ceil(delay);
dt = mean(exp_results.tout(2:end)-exp_results.tout(1:(end-1)));

%filter T
temp = filter(dfilter,exp_results.T.Data);
T_filt = timeseries(temp((delay+1):end),exp_results.tout(1:(end-delay)));
exp_results.T = T_filt;
%{
emp_results.LS_1 = addevent(exp_results.LS_1, 'overtime_LS_1', exp_results.tout(end)-delay*dt);
emp_results.LS_2 = addevent(exp_results.LS_2, 'overtime_LS_2', exp_results.tout(end)-delay*dt);
emp_results.LS_1_ideal = addevent(emp_results.LS_1, 'overtime_LS_1_ideal', emp_results.tout(end)-delay*dt);
emp_results.LS_2_ideal = addevent(emp_results.LS_2, 'overtime_LS_2_ideal', emp_results.tout(end)-delay*dt);

emp_results.LS_1 = gettsbeforeatevent(emp_results.LS_1, 'overtime_LS_1');
emp_results.LS_2 = gettsbeforeatevent(emp_results.LS_2, 'overtime_LS_2');
emp_results.LS_1_ideal = gettsbeforeatevent(emp_results.LS_1_ideal, 'overtime_LS_1_ideal');
emp_results.LS_2_ideal = gettsbeforeatevent(emp_results.LS_2_ideal, 'overtime_LS_2_ideal');
%}


clear temp
clear fs
clear fo
clear wc
clear T_filt