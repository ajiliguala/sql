--车间每日每月领料
with lrll as (SELECT YEAR(b.fdate)     AS '年',
                     MONTH(b.fdate)    AS '月',
                     DAY(b.fdate)      AS '日',
                     SUM(a.FACTUALQTY) AS '汇总实发数量',
                     e.FNAME
              FROM T_PRD_PICKMTRLDATA a
                       LEFT JOIN T_PRD_PICKMTRL b ON b.fid = a.fid
                       LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
              WHERE b.FPRDORGID = '100329'
                AND DAY(b.fdate) = DAY(GETDATE())
                AND YEAR(b.fdate) = YEAR(GETDATE())
                AND MONTH(b.fdate) = MONTH(GETDATE())
              GROUP BY e.FNAME, b.fdate),

     myll as (SELECT SUM(a.FACTUALQTY) AS '汇总实发数量',
                     e.FNAME
              FROM T_PRD_PICKMTRLDATA a
                       LEFT JOIN T_PRD_PICKMTRL b ON b.fid = a.fid
                       LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
              WHERE b.FPRDORGID = '100329'
                AND YEAR(b.fdate) = YEAR(GETDATE())
                AND MONTH(b.fdate) = MONTH(GETDATE())
              GROUP BY e.FNAME)

select YEAR(GETDATE()),
       MONTH(GETDATE()),
       DAY(GETDATE()),
       a.汇总实发数量 AS 当天数据,
       b.汇总实发数量 AS 当月数据,
       b.FNAME
from lrll a
         right JOIN MYLL B ON A.FNAME = B.FNAME
order by a.FNAME







