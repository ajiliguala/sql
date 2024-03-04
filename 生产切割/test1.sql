--入库单每天 
SELECT 
    year(b.fdate) AS '年份',
    month(b.fdate) AS '月',
    day(b.fdate)as '日',
    SUM(a.FREALQTY) AS '汇总实收数量'
FROM 
    T_PRD_INSTOCKENTRY a
LEFT JOIN 
    T_PRD_INSTOCK b ON b.fid = a.fid
LEFT JOIN 
    T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
WHERE
B.FDATE>='${starttime}' and B.FDATE<'${endtime}'
GROUP BY 
    year(b.fdate), 
    month(b.fdate), 
    day(b.fdate)
ORDER BY 
    year(b.fdate)desc, 
    month(b.fdate)desc,
		day(b.fdate)desc;
		
--领料单每天
SELECT year(b.fdate) AS '年份',
    month(b.fdate) AS '月',
    day(b.fdate)as '日',
    SUM(a.FACTUALQTY) AS '汇总实发数量'
from T_PRD_PICKMTRLDATA a 
left join T_PRD_PICKMTRL b on b.fid=a.fid
LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
WHERE e.fname='一部切割车间'
AND
B.FDATE>='${starttime}' and B.FDATE<'${endtime}'
GROUP BY 
    year(b.fdate), 
    month(b.fdate), 
    day(b.fdate)
ORDER BY 
    year(b.fdate)desc, 
    month(b.fdate)desc,
		day(b.fdate)desc;


--入库单每月
SELECT 
    year(b.fdate) AS '年份',
    month(b.fdate) AS '月',
    SUM(a.FREALQTY) AS '汇总实收数量'
FROM 
    T_PRD_INSTOCKENTRY a
LEFT JOIN 
    T_PRD_INSTOCK b ON b.fid = a.fid
LEFT JOIN 
    T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
WHERE 
    e.fname = '一部切割车间'
AND
B.FDATE>='${starttime}' and B.FDATE<'${endtime}'
GROUP BY 
    year(b.fdate), 
    month(b.fdate)
ORDER BY 
    year(b.fdate)desc, 
    month(b.fdate)desc

		
		--领料单每月
SELECT year(b.fdate) AS '年份',
    month(b.fdate) AS '月',
    SUM(a.FACTUALQTY) AS '汇总实发数量'
from T_PRD_PICKMTRLDATA a 
left join T_PRD_PICKMTRL b on b.fid=a.fid
LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
WHERE e.fname='一部切割车间'
GROUP BY 
    year(b.fdate), 
    month(b.fdate)
ORDER BY 
    year(b.fdate) desc, 
    month(b.fdate) desc