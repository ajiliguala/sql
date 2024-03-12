--入库单每天
WITH RK AS (SELECT year(b.fdate)   AS '年份',
                   month(b.fdate)  AS '月',
                   day(b.fdate)    as '日',
                   SUM(a.FREALQTY) AS '汇总实收数量',
                   E.FNAME,
                   A.FMOBILLNO
            FROM T_PRD_INSTOCKENTRY a
                     LEFT JOIN
                 T_PRD_INSTOCK b ON b.fid = a.fid
                     LEFT JOIN
                 T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
            GROUP BY year(b.fdate),
                     month(b.fdate),
                     day(b.fdate), E.FNAME, A.FMOBILLNO),
       
--领料单每天
    LL AS (SELECT year(b.fdate)     AS '年份',
                  month(b.fdate)    AS '月',
                  day(b.fdate)      as '日',
                  SUM(a.FACTUALQTY) AS '汇总实发数量',
                  E.FNAME,
                  A.FMOBILLNO
           from T_PRD_PICKMTRLDATA a
                    left join T_PRD_PICKMTRL b on b.fid = a.fid
                    LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
           WHERE e.fname = '一部切割车间'
           GROUP BY year(b.fdate),
                    month(b.fdate),
                    day(b.fdate), E.FNAME, B.FBILLNO, A.FMOBILLNO)


SELECT  LL.FNAME, LL.年份,LL.月,LL.日,LL.汇总实发数量,RK.汇总实收数量 FROM LL

LEFT JOIN RK ON LL.FMOBILLNO=RK.FMOBILLNO
WHERE LL.年份>=2024
AND LL.月=3
AND LL.日=8
ORDER BY  LL.月 DESC,LL.日 DESC


SELECT SUM.FNAME,SUM.年份,SUM.月,SUM.日,SUM(SUM.汇总实发数量) AS 汇总实发数量,SUM(SUM.汇总实收数量) AS 汇总实收数量
FROM SUM
WHERE SUM.FNAME='一部切割车间'
AND SUM.年份>=2024
AND SUM.月>=3

group by SUM.FNAME,SUM.年份,SUM.月,SUM.日




