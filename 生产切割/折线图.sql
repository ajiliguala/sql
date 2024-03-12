--生产用料清单
with SCYL as
         (SELECT DISTINCT B.FNUMBER                     AS 父项编码--入库
                        , e.FNUMBER                     AS 子项编码--领料
                        , A.FPRDORGID
                        , a.FBILLNO
                        , A.FMOBILLNO
                        , d.FNUMERATOR / d.FDENOMINATOR AS 比例
          FROM T_PRD_PPBOM A
                   LEFT JOIN T_BD_MATERIAL B ON A.FMATERIALID = B.FMATERIALID
                   LEFT JOIN T_PRD_PPBOMENTRY d ON d.FID = A.FID
                   LEFT JOIN T_BD_MATERIAL e ON d.FMATERIALID = e.FMATERIALID
          WHERE a.FPRDORGID = '100329'),
     RK_MONTH as (
--入库单每月
         SELECT year(b.fdate)   AS '年份',
                month(b.fdate)  AS '月',
                SUM(a.FREALQTY) AS '汇总实收数量',
                e.FNAME,
                C.FNUMBER,
                a.FMOBILLNO
         FROM T_PRD_INSTOCKENTRY a
                  LEFT JOIN
              T_PRD_INSTOCK b ON b.fid = a.fid
                  LEFT JOIN
              T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                  LEFT JOIN
              T_BD_MATERIAL C ON C.FMATERIALID = A.FMATERIALID
         WHERE b.FPRDORGID = '100329'
           AND E.FNAME IN ('一部镀膜车间', '一部蚀刻车间', '一部切割车间', '一部化强车间', '一部研磨车间')
           AND B.FDATE >= DATEADD(MONTH, -5, CONVERT(date, GETDATE()))
           AND B.FDATE < CONVERT(date, GETDATE())
         GROUP BY b.fdate, e.FNAME, C.FNUMBER, a.FMOBILLNO),

     LL_MONTH as ( --领料单每月
         SELECT DISTINCT year(b.fdate)     AS '年份',
                         month(b.fdate)    AS '月',
                         SUM(a.FACTUALQTY) AS '汇总实发数量',
                         e.FNAME,
                         C.FNUMBER,
                         a.FMOBILLNO,
                         B.FBILLNO,
                         a.FPPBOMBILLNO
         from T_PRD_PICKMTRLDATA a
                  left join T_PRD_PICKMTRL b on b.fid = a.fid
                  LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                  LEFT JOIN T_BD_MATERIAL C ON C.FMATERIALID = A.FMATERIALID
         WHERE b.FPRDORGID = '100329'
           AND E.FNAME IN ('一部镀膜车间', '一部蚀刻车间', '一部切割车间', '一部化强车间', '一部研磨车间')
           AND B.FDATE >= DATEADD(MONTH, -5, CONVERT(date, GETDATE()))
           AND B.FDATE < CONVERT(date, GETDATE())
           AND b.FPRDORGID = '100329'
         GROUP BY year(b.fdate),
                  month(b.fdate), e.FNAME, C.FNUMBER, a.FMOBILLNO, B.FBILLNO, a.FPPBOMBILLNO),

 CalculatedData AS (
SELECT
       A.年份,
       A.月,
       A.汇总实发数量,
       C.比例,
       A.FNAME,
       B.汇总实收数量,
        B.汇总实收数量 * C.比例 AS '计算汇总实收数量'
--C.FBILLNO ,A.FPPBOMBILLNO
FROM LL_MONTH A
        LEFT JOIN RK_MONTH B ON A.FMOBILLNO = B.FMOBILLNO
        RIGHT JOIN SCYL C ON C.父项编码 = B.FNUMBER AND C.子项编码 = A.FNUMBER AND C.FBILLNO = A.FPPBOMBILLNO
where
 A.FNAME IN ('一部镀膜车间', '一部蚀刻车间', '一部切割车间', '一部化强车间', '一部研磨车间')

                    ),
TEMP11 AS (
SELECT 年份,
       月,
             FNAME,
             SUM(汇总实发数量)                         AS '总汇总实发数量',
             SUM(计算汇总实收数量)                     AS '总计算实收数量',
             SUM(计算汇总实收数量) / SUM(汇总实发数量) as 产出比
FROM CalculatedData
where FNAME IN ('一部镀膜车间', '一部蚀刻车间', '一部切割车间', '一部化强车间', '一部研磨车间')
GROUP BY FNAME,年份,
       月)

SELECT 年份,
       月,FNAME,总汇总实发数量,总计算实收数量,产出比 FROM TEMP11

