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
         GROUP BY E.FNAME),
     --车间每日每月领料
     lrll as (SELECT YEAR(b.fdate)     AS '年',
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
select YEAR(GETDATE())  AS 年,
       MONTH(GETDATE()) AS 月,
       DAY(GETDATE())   AS 月,
       temp.领料单当天数据,
       temp.领料单当月数据,
       a.汇总实收数量   AS 入库单当天数据,
       b.汇总实收数量   AS 入库单当月数据,
       b.FNAME
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
order by a.FNAME