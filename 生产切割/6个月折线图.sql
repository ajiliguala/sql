with temp as (
--入库单每月
    SELECT year(b.fdate)   AS '年份',
           month(b.fdate)  AS '月',
           SUM(a.FREALQTY) AS '汇总实收数量',
           e.FNAME
    FROM T_PRD_INSTOCKENTRY a
             LEFT JOIN
         T_PRD_INSTOCK b ON b.fid = a.fid
             LEFT JOIN
         T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
    WHERE b.FPRDORGID = '100329'
      AND B.FDATE >= DATEADD(MONTH, -5, CONVERT(date, GETDATE()))
      AND B.FDATE < CONVERT(date, GETDATE())
    GROUP BY year(b.fdate),
             month(b.fdate), e.FNAME),

     temp1 as ( --领料单每月
         SELECT year(b.fdate)     AS '年份',
                month(b.fdate)    AS '月',
                SUM(a.FACTUALQTY) AS '汇总实发数量',
                e.FNAME
         from T_PRD_PICKMTRLDATA a
                  left join T_PRD_PICKMTRL b on b.fid = a.fid
                  LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
         WHERE b.FPRDORGID = '100329'
           AND B.FDATE >= DATEADD(MONTH, -5, CONVERT(date, GETDATE()))
           AND B.FDATE < CONVERT(date, GETDATE())
           AND E.FNAME='一部切割车间'
         GROUP BY year(b.fdate),
                  month(b.fdate), e.FNAME)

SELECT  A.年份,A.月,B.汇总实发数量,A.汇总实收数量,A.汇总实收数量/B.汇总实发数量 as 产出率,A.FNAME FROM
TEMP A
LEFT JOIN TEMP1 B ON A.FNAME=B.FNAME AND A.年份=B.年份 AND A.月=B.月
WHERE A.FNAME='一部切割车间'