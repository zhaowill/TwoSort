{smcl}
{right:version:  1.0.0}
{cmd:help readWind} {right:December 18, 2018}
{hline}

{title:Title}

{p 4 8}{cmd:readWind}  -  Read the data downloaded from the Wind into Stata in a long form {p_end}


{title:Syntax}

{p 8 15 2}
{cmd:readWind}
{cmd:,} 
{cmd:var(name of excel)}
{cmd:timeType(time type)}
{cmd:t0(start time of the sample)}
[{it:split}
{it:splitN(k)}
{it:erase}]

{title:Description}

{p 4 4 2} {cmd: var} var is the name of the excel. {p_end}

{p 4 4 2} {cmd: timeType} timeType refers to whether the downloaded sample is annual, quarterly or monthly, so its value is y/q/m. {p_end}

{p 4 4 2} {cmd: t0} Sample start time, for example, if you choose to download it from January 1995, then this t0 will write 1995m1. Quarterly and monthly correspond to 1995q1 and 1995 respectively.. {p_end}

{p 4 4 2} {cmd: split splitN (n) erase} are optional. When the column of data is too large, the speed of data format conversion is relatively slow. So we adopt a compromise method to divide the sample into n small samples,
 and then process them in turn and merge them together.  The recommended value of n is between 1/10 and 1/20 of the number of the data columns. {p_end}


{title:Example}
 {p 4 8 2}{stata "readWind, var(ROE) timeType(q) t0(1995q1)" :. readWind, var(ROE) timeType(q) t0(1995q1)} {p_end}
 {p 4 8 2}{stata "readWind, var(ROE) timeType(q) t0(1995q1) split splitN(10) erase" :. readWind, var(ROE) timeType(q) t0(1995q1) split splitN(10) erase} {p_end}



{title:Author}


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *
*                                                                                *
*  DevinChu                                                                      *
*  Department of Finance and Insurance, School of Business, NanJing University   *
*  Email: zhuhong_bing@163.com                                                   *
*                                                                                *
*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*
