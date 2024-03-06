with drrk as (
--入库单每天
    SELECT year(b.fdate)   AS '年份',
           month(b.fdate)  AS '月',
           day(b.fdate)    as '日',
           SUM(a.FREALQTY) AS '汇总实收数量',
           E.FNAME
    FROM T_PRD_INSTOCKENTRY a
             LEFT JOIN
         T_PRD_INSTOCK b ON b.fid = a.fid
             LEFT JOIN
         T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
    where b.FPRDORGID = '100329'
      AND year(b.fdate) = year(GETDATE())
      AND month(b.fdate) = month(GETDATE())
      AND day(b.fdate) = day(GETDATE())
    GROUP BY E.FNAME, b.fdate),

     dyrk as (
--入库单每月
         SELECT SUM(a.FREALQTY) AS '汇总实收数量',
                E.FNAME
         FROM T_PRD_INSTOCKENTRY a
                  LEFT JOIN
              T_PRD_INSTOCK b ON b.fid = a.fid
                  LEFT JOIN
              T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
         where b.FPRDORGID = '100329'
           AND year(b.fdate) = year(GETDATE())
           AND month(b.fdate) = month(GETDATE())
         GROUP BY E.FNAME)


select YEAR(GETDATE())  AS 年,
       MONTH(GETDATE()) AS 月,
       DAY(GETDATE())   AS 日,
       a.汇总实收数量   AS 当天数据,
       b.汇总实收数量   AS 当月数据,
       b.FNAME
from drrk a
         right JOIN dyrk B ON A.FNAME = B.FNAME
order by a.FNAME