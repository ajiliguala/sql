-- 比例
with temp1 as
(
SELECT
A.FBILLNO as 编码
,B.FNUMBER AS 父项编码
,C.FNAME AS 父项名称
,C.FSPECIFICATION AS 父项规格
,e.FNUMBER AS 子项编码
,f.FNAME AS  子项名称
,f.FSPECIFICATION AS 子项规格
,a.fid
,A.FPRDORGID
,A.FWORKSHOPID
,d.FDENOMINATOR as 分母
,d.FNUMERATOR as 分子
 FROM  T_PRD_PPBOM A
LEFT JOIN T_BD_MATERIAL B ON A.FMATERIALID=B.FMATERIALID
LEFT JOIN T_BD_MATERIAL_L C ON C.FMATERIALID=B.FMATERIALID
LEFT JOIN T_PRD_PPBOMENTRY d ON d.FID=A.FID
LEFT JOIN T_BD_MATERIAL e ON d.FMATERIALID=e.FMATERIALID
LEFT JOIN T_BD_MATERIAL_L f ON f.FMATERIALID=e.FMATERIALID
),
temp0 as
(select
    C.FNUMBER AS 物料编码
	 ,h.FBILLNO as 单据编号
	 	,h.FPRDORGID
		,a.fsrcbillno as 用料清单编号
    from T_PRD_PICKMTRLDATA a
    inner join T_PRD_PICKMTRLDATA_LK a_lk on a.fentryid=a_lk.fentryid
		inner join T_PRD_PICKMTRL h on h.fid=a.fid
    LEFT JOIN T_BD_MATERIAL C ON C.FMATERIALID = a.FMATERIALID
    LEFT JOIN T_BD_MATERIAL_L D ON D.FMATERIALID = C.FMATERIALID
    LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = a.FWORKSHOPID
		where h.FPRDORGID='100329'
),
temp2 as
(select
d.FNUMBER AS 物料编码
,b.fbillno

  from T_PRD_INSTOCKENTRY a
	-- 入库单
  inner join T_PRD_INSTOCKENTRY_LK a_lk on a_lk.fentryid=a.fentryid
	inner join T_PRD_INSTOCK b on b.fid=a.fid
	  LEFT JOIN T_BD_MATERIAL d ON d.FMATERIALID = a.FMATERIALID
    LEFT JOIN T_BD_MATERIAL_L e ON e.FMATERIALID = d.FMATERIALID
		LEFT JOIN T_BD_DEPARTMENT_L g ON g.FDEPTID = b.FWORKSHOPID
	  where b.FPRDORGID='100329'

),

-- 数量
 drrk as (
--入库单每天
    SELECT year(b.fdate)   AS '年份',
           month(b.fdate)  AS '月',
           day(b.fdate)    as '日',
           SUM(a.FREALQTY) AS '汇总实收数量',
           E.FNAME,
           C.FNUMBER AS WLBM
    FROM T_PRD_INSTOCKENTRY a
             LEFT JOIN
         T_PRD_INSTOCK b ON b.fid = a.fid
             LEFT JOIN
         T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
    LEFT JOIN T_BD_MATERIAL C ON C.FMATERIALID = a.FMATERIALID
    LEFT JOIN T_BD_MATERIAL_L D ON D.FMATERIALID = C.FMATERIALID
    LEFT JOIN T_BD_DEPARTMENT_L F ON F.FDEPTID = a.FWORKSHOPID
    where b.FPRDORGID = '100329'
      AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
      AND B.FDATE < CONVERT(date, GETDATE())
    GROUP BY E.FNAME, b.fdate, C.FNUMBER),

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
             )

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
                AND B.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
                AND B.FDATE < CONVERT(date, GETDATE())


              GROUP BY e.FNAME, b.fdate),
     myll as (SELECT SUM(a.FACTUALQTY) AS '汇总实发数量',
                     e.FNAME
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
                  )
              GROUP BY e.FNAME),
     ZH AS (select

--     YEAR(GETDATE())  AS 年,
--     MONTH(GETDATE()) AS 月,
--     DAY(GETDATE())   AS 月,
temp.领料单当天数据,
temp.领料单当月数据,
a.汇总实收数量 AS 入库单当天数据,
b.汇总实收数量 AS 入库单当月数据,
b.FNAME,
A.WLBM AS FXBM
            from drrk a
                     right JOIN dyrk B ON A.FNAME = B.FNAME

                     left join (select YEAR(GETDATE())  AS 年,
                                       MONTH(GETDATE()) AS 月,
                                       DAY(GETDATE())   AS 日,
                                       a.汇总实发数量   AS 领料单当天数据,
                                       b.汇总实发数量   AS 领料单当月数据,
                                       b.FNAME
                                from lrll a
                                         right JOIN MYLL B ON A.FNAME = B.FNAME) temp on temp.FNAME = b.FNAME)

SELECT SUM(ZH.领料单当天数据) AS 领料单当天数据,
       SUM(ZH.领料单当月数据) AS 领料单当月数据,
       SUM(ZH.入库单当天数据)*N.比例 AS 入库单当天数据,
       SUM(ZH.入库单当月数据) AS 入库单当月数据,
       ZH.FXBM
FROM ZH
left join(
select x.分子/x.分母 AS 比例 ,y.物料编码,y.用料清单编号,x.父项编码 as 父项 from temp1 x
LEFT JOIN temp2 ON x. 父项编码=temp2.物料编码
right join temp0 y on y.物料编码=x.子项编码 and y.用料清单编号=x.编码
where y.FPRDORGID = '100329'
)n on n.父项=ZH.FXBM
GROUP BY N.比例,
         ZH.FXBM
