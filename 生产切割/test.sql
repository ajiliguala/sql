with drrk as (
--入库单每天
    SELECT year(b.fdate)   AS '年份',
           month(b.fdate)  AS '月',
           day(b.fdate)    as '日',
           SUM(a.FREALQTY) AS '汇总实收数量'

    FROM T_PRD_INSTOCKENTRY a
             LEFT JOIN
         T_PRD_INSTOCK b ON b.fid = a.fid
             LEFT JOIN
         T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
    where b.FPRDORGID = '100329'
      AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
      AND B.FDATE < CONVERT(date, GETDATE())


    GROUP BY b.fdate),

     dyrk as (
--入库单每月
         SELECT SUM(a.FREALQTY) AS '汇总实收数量'

         FROM T_PRD_INSTOCKENTRY a
                  LEFT JOIN
              T_PRD_INSTOCK b ON b.fid = a.fid
                  LEFT JOIN
              T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
         where b.FPRDORGID = '100329'
           --     AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
--     AND B.FDATE < CONVERT(date, GETDATE())
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
             )),
     --车间每日每月领料
     lrll as (SELECT YEAR(b.fdate)     AS '年',
                     MONTH(b.fdate)    AS '月',
                     DAY(b.fdate)      AS '日',
                     SUM(a.FACTUALQTY) AS '汇总实发数量'

              FROM T_PRD_PICKMTRLDATA a
                       LEFT JOIN T_PRD_PICKMTRL b ON b.fid = a.fid
                       LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
              WHERE b.FPRDORGID = '100329'
                AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
                AND B.FDATE < CONVERT(date, GETDATE())
              GROUP BY b.fdate),
     myll as (SELECT SUM(a.FACTUALQTY) AS '汇总实发数量'

              FROM T_PRD_PICKMTRLDATA a
                       LEFT JOIN T_PRD_PICKMTRL b ON b.fid = a.fid
                       LEFT JOIN T_BD_DEPARTMENT_L e ON e.FDEPTID = b.FWORKSHOPID
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
                  ))

select temp.领料单当天数据,
       temp.领料单当月数据,
       SUM(a.汇总实收数量) AS 入库单当天数据总数,
       SUM(b.汇总实收数量) AS 入库单当月数据总数
from drrk a
         right JOIN dyrk B ON A.FNAME = B.FNAME
         left join (select YEAR(GETDATE())  AS 年,
                           MONTH(GETDATE()) AS 月,
                           DAY(GETDATE())   AS 日,
                           a.汇总实发数量   AS 领料单当天数据,
                           b.汇总实发数量   AS 领料单当月数据,
                           b.FNAME
                    from lrll a
                             right JOIN MYLL B ON A.FNAME = B.FNAME) temp on temp.FNAME = b.FNAME
GROUP BY temp.领料单当天数据, temp.领料单当月数据
ORDER BY temp.领料单当天数据;