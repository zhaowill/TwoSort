
	/*reshape the dataset withe format of {stkcd comp var1 var2 ....}*/
	capture program drop reshape_a
	program define reshape_a
		version 14.0
		syntax [,split erase splitN(integer 50)]

		local var ""
		foreach tempVar of varlist _all{
			local var "`var' `tempVar'"         // 
		}
		tokenize `var'                          // 
		local first `1' `2'                     // 
		macro shift 2                           // 
		local rest `*'                          // 		
		
		/*分割 or 不分割数据集, 进行gather操作*/
		if("`split'"!=""){
			local k1=wordcount("`rest'")
			local k2=round(`k1'/`splitN')
			
			//
			local i=1
			local j=2
			foreach tempVar in `rest'{
				
				local splitPart`i' "`splitPart`i'' `tempVar'"
				
				if(mod(`j',`k2')==0){
					local i=`i'+1
				}
				local j=`j'+1
			}
			local numb=`i'
			
			//
			forvalues i=1(1)`numb'{
				preserve
					keep stkcd comp `splitPart`i''
					gather `splitPart`i''           // reshape处理
					save tempData`i'.dta, replace
				restore	
			}
			
			clear
			forvalues i=1(1)`numb'{
				append using tempData`i'.dta
			}
			
			//
			if("`erase'"!=""){
				forvalues i=1(1)`numb'{
					erase tempData`i'.dta
				}
			}
		}
		else{                          // non split dealing
			keep `first' `rest'        // this line can be deleted
			gather `rest'              // reshape处理
		}
		
	end
	

	/*读取wind下载下来的wide型excel数据：col1为股票代码,col2为股票名称,col(k)为不同日期的指标*/
	capture program drop readWind0
	program define readWind0, eclass 
		version 14.0
		syntax, var(string) [type(string)] timeType(string) t0(string)
			
			local varlist "`var'"
			
			if("`type'"==""){
				local type "xlsx"   // 默认是xlsx格式
			}
			
			/*提取被导入excel的信息*/
			qui import excel `varlist'.`type', describe
			local SHEET = r(worksheet_1)
			local RANGE = r(range_1)

			/*导入相应的excel*/
			import excel `varlist'.`type', sheet("`SHEET'") cellrange(`RANGE') firstrow	 clear
			
			//
			local var ""
			foreach tempVar of varlist _all{
				local var "`var' `tempVar'"         // 
			}
			tokenize `var'                          // 
			local first `1' `2'                     // 
			macro shift 2                           // 
			local rest `*'                          // 
			
			/*stkcd comp的命名*/
			rename (`first') (stkcd comp)
			
			/*其他变量的命名*/
			if("`timeType'"=="y"){
				local i `t0'
				foreach var in `rest'{
					rename `var' `varlist'`i'
					local i=`i'+1
				}
			}
			if("`timeType'"=="q"){
			
				//local t0 2010q3
				local y=substr("`t0'",1,4)
				local q=substr("`t0'",-1,1)
			
				foreach var in `rest'{
					rename `var' `varlist'`y'q`q'
					if(`q'<=4){
						local q = `q' + 1
					}				
					if(`q'==5){
						local q = 1
						local y = `y' + 1
					}
				}
			}
			if("`timeType'"=="m"){
				
				//local t0 2010m1
				local y=substr("`t0'",1,4)
				local m=substr(substr("`t0'",strpos("2015m12","m"),.),2,.)
			
				foreach var in `rest'{
					rename `var' `varlist'`y'm`m'
					if(`m'<=12){
						local m = `m' + 1
					}
					if(`m'==13){
						local m = 1
						local y = `y' + 1
					}
				}
			}
			
			drop if stkcd=="" | stkcd=="数据来源：Wind"
		
	end
	
	
	/*打包readWind0和reshape_a*/
	capture program drop readWind
	program define readWind 
		version 14.0
		syntax , var(string) timeType(string) t0(string) /*
		  */ [type(string) split erase splitN(integer 50)]
			
		readWind0, var(`var') type(`type') timeType(`timeType') t0(`t0')
		
		if("`split'"!=""){
			reshape_a, split splitN(`splitN') `erase'
		}
		else{
			reshape_a
		}
		
	end
	
	
	*cd "C:\Users\Administrator\Desktop\ICC\"
	*用法1(当数据量很大时候比较慢)：readWind, var(ROE) timeType(q) t0(2010q1)
	*用法2(当数据量很大时候相对比较快)：readWind, var(ROE) timeType(q) t0(2010q1) split splitN(11) erase
