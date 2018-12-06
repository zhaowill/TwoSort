
	capture program drop Group2
	
	//-定义分组函数
	capture program drop Group2  
	program define Group2
	version 14.0
	syntax , groupVar(string) groupName(string) groupN(integer) time(string)
	
		tempvar n1 n2 n3 n4 n5
		sort `time' `groupVar'
		by `time':gen  `n1' = _n if `groupVar'!=.   // 按time生成_n
		by `time':egen `n2' = max(`n1')             // 取给定time中的最大_n,记为n2
				  gen  `n3' = `n2'/`groupN'         // n2/分组数=每组间距,记为n3
				  gen  `n4' = round(`n3')           // 对n3取整处理,记为n4
				  gen  `n5' = `n3'-`n4'             // n3-n4,记为n5
		      *replace  `n3' = `n3'+1 if `n5'>0      // n5大于0则n3+1   旧方法
		       replace  `n4' = `n4'+1 if `n5'>0      // n5大于0则n3+1   新方法
			  
			  
			  
			  
		gen `groupName' = .
		forvalues i=1(1)`groupN'{

			local j=`i'-1
			
			*gen cutPoint`i'=`n3'*`i'        // 旧切割点定义方法
			 gen cutPoint`i'=`n4'*`i'        // 新定义方法
			
			if(`i'==1){
			
				replace `groupName'=`i' if `n1'<=cutPoint`i'
				
			}
			if(`i'!=1){
			
				replace `groupName'=`i' if `n1'<=cutPoint`i' & `n1'>cutPoint`j'
				
			}
			
		}
		
		drop cutPoint*
		
	end
