	//-定义变量分类函数
	/**/
	program define DivideVar
	version 14.0
	syntax varlist(min=1)
	
		*-提取varlist中的第一个变量为y，其余的变量为x
		local i=1
		global x ""
		foreach var in `varlist'{
			
			if(`i'==1){
				global y "`var'"
			}
			if(`i'!=1){
				global x "$x `var'"
			}
			local i=`i'+1
		}
		
		
	end
