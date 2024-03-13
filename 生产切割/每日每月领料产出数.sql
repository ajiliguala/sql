with drrk as (
--入库单每天
    SELECT year(b.fdate)              AS '年份',
           month(b.fdate)             AS '月',
           day(b.fdate)               as '日',
           SUM(a.FREALQTY)            AS '汇总实收数量',
           E.FNAME,
           SUM(a.FREALQTY * D.F_MJM2) AS '汇总面积'
    FROM T_PRD_INSTOCKENTRY a
             LEFT JOIN
         T_PRD_INSTOCK b ON b.fid = a.fid
             LEFT JOIN
         T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
             LEFT JOIN T_BD_MATERIAL D ON D.FMATERIALID = A.FMATERIALID
    where b.FPRDORGID = '100329'
      AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
      AND B.FDATE < CONVERT(date, GETDATE())
    GROUP BY E.FNAME, b.fdate),
     dyrk as (
--入库单每月
         SELECT year(GETDATE())            AS '年份',
                month(GETDATE())           AS '月',
                SUM(a.FREALQTY * D.F_MJM2) AS '汇总实收数量',
                E.FNAME
         FROM T_PRD_INSTOCKENTRY a
                  LEFT JOIN
              T_PRD_INSTOCK b ON b.fid = a.fid
                  LEFT JOIN
              T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                  LEFT JOIN T_BD_MATERIAL D ON a.FMATERIALID = D.FMATERIALID
         where b.FPRDORGID = '100329'
           AND (
             (DAY(GETDATE()) = 1 AND
              DAY(DATEADD(DAY, -1, GETDATE())) = DAY(DATEADD(MONTH, -1, GETDATE())) AND
              DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, B.FDATE) AND
              DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, B.FDATE))
                 OR
             (DAY(GETDATE()) != 1 AND
              MONTH(DATEADD(DAY, -1, GETDATE())) = MONTH(GETDATE()) AND
              DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, B.FDATE) AND
              DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, B.FDATE))
                 OR
             (DATEPART(YEAR, DATEADD(DAY, -1, GETDATE())) = DATEPART(YEAR, B.FDATE) AND
              DATEPART(MONTH, DATEADD(DAY, -1, GETDATE())) = DATEPART(MONTH, B.FDATE))
             )
         GROUP BY E.FNAME),
     mtll as (
         --领料单每天
         SELECT year(b.fdate)                AS '年份',
                month(b.fdate)               AS '月',
                day(b.fdate)                 as '日',
                SUM(a.FACTUALQTY * D.F_MJM2) AS '汇总实发数量',
                e.FNAME
         from T_PRD_PICKMTRLDATA a
                  left join T_PRD_PICKMTRL b on b.fid = a.fid
                  LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                  LEFT JOIN T_BD_MATERIAL D ON a.FMATERIALID = D.FMATERIALID
         WHERE b.FPRDORGID = '100329'
           AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
           AND B.FDATE < CONVERT(date, GETDATE())
         GROUP BY year(b.fdate),
                  month(b.fdate),
                  day(b.fdate), e.FNAME),

     myll as (
--领料单每月
         SELECT year(b.fdate) AS '年份', month(b.fdate) AS '月', SUM(a.FACTUALQTY * D.F_MJM2) AS '汇总实发数量', e.fname
         from T_PRD_PICKMTRLDATA a
                  left join T_PRD_PICKMTRL b on b.fid = a.fid
                  LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                  LEFT JOIN T_BD_MATERIAL D ON a.FMATERIALID = D.FMATERIALID
         WHERE b.FPRDORGID = '100329'
           AND (
             (DAY(GETDATE()) = 1 AND
              DAY(DATEADD(DAY, -1, GETDATE())) = DAY(DATEADD(MONTH, -1, GETDATE())) AND
              DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, B.FDATE) AND
              DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, B.FDATE))
                 OR
             (DAY(GETDATE()) != 1 AND
              MONTH(DATEADD(DAY, -1, GETDATE())) = MONTH(GETDATE()) AND
              DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, B.FDATE) AND
              DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, B.FDATE))
                 OR
             (DATEPART(YEAR, DATEADD(DAY, -1, GETDATE())) = DATEPART(YEAR, B.FDATE) AND
              DATEPART(MONTH, DATEADD(DAY, -1, GETDATE())) = DATEPART(MONTH, B.FDATE))
             )
         GROUP BY year(b.fdate), month(b.fdate), e.fname)

select year(getdate())                                          as 年份,
       MONTH(GETDATE())                                         AS 月,
       DAY(GETDATE() - 1)                                       AS 日,
       mtll.汇总实发数量                                        as 昨日投入,
       myll.汇总实发数量                                        AS 当月投入,
       drrk.汇总实收数量                                        as 昨日产出,
       dyrk.汇总实收数量                                        as 当月产出,
       COALESCE(drrk.FNAME, dyrk.FNAME, mtll.FNAME, myll.FNAME) AS 车间
from drrk
         full join dyrk on drrk.FNAME = dyrk.FNAME
         full join mtll on mtll.FNAME = drrk.FNAME
         full join myll on myll.FNAME = dyrk.FNAME
WHERE COALESCE(drrk.FNAME, dyrk.FNAME, mtll.FNAME, myll.FNAME) = '一部切割车间'


