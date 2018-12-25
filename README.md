# TwoSort
Twosort method for acadamic research

本来想写一系列的小命令实现资产定价研究中的常见方法。但是自己太懒，目前只写了几个比较小的命令。主要有：`Group2` `readWind` `CalculationVW`这三个方法。  

其中，
`Group2`主要用于快速分组，在资产定价研究中分组检验是常见的方法。在前期的研究中，我主要采用的是egen命令进行分位数分组，但遗憾的是当数据非常大的时候这一命令运行速度就非常慢。所以我写了这一分组命令，在样本非常大的时候分组速度要比egen快很多很多。但是最近突然发现，有个现成的分组命令，也可以实现快速的分组，所以尴尬了。。  

`CalculationVW`主要用于计算加权收益率。  

`readWind`主要是用于处理万德数据库下载下来的EXCEL格式，实现快速导入到Stata中进行实证分析。
