	
	
	capture program drop CalculationVW

	//-定义计算加权收益率函数
	program define CalculationVW
	version 14.0
	syntax varlist(max=2), groupVar(string) time(string)
		
		*-调用变量分割函数
		DivideVar `varlist'
		
		*-计算主体程序
		tempvar value_return sum_v value_return_sum_v
		gen `value_return'=$y*$x
		bys `groupVar' `time':egen `sum_v'=sum($x)
		gen `value_return_sum_v'=`value_return'/`sum_v'
		bys `groupVar' `time':egen VW_$y=sum(`value_return_sum_v')
		
	end
