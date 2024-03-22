WITH CC AS (SELECT B.FDATE,
                   SUM(CASE
                           WHEN CHARINDEX('切割', E.FNAME) > 0 THEN a.FREALQTY * ml.F_MJM2
                           ELSE a.FREALQTY END) AS '汇总产出数量',
                   SCXL.FNAME                   AS 车间生产线,
                   E.FNAME                      AS 车间
            FROM T_PRD_INSTOCKENTRY a
                     INNER JOIN T_PRD_INSTOCK b ON b.fid = a.fid
                     INNER JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                     INNER JOIN PIKU_CJSCX SCX ON SCX.FID = B.F_PIKU_CJSCX
                     INNER JOIN PIKU_CJSCX_L SCXL ON SCX.FID = SCXL.FID
                     LEFT JOIN T_BD_MATERIAL ml ON ml.FMATERIALID = a.FMATERIALID
            WHERE b.FPRDORGID = '100329'
              AND B.FDATE >=
                  CASE

                      WHEN DAY(GETDATE()) = 1 THEN
                          DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
                      ELSE DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
                      END
              AND B.FDATE < DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETDATE())) --AND E.FNAME LIKE '%切割%'

            GROUP BY E.FNAME,
                     b.fdate,
                     SCXL.FNAME
            ),
TR AS (SELECT B.FDATE,
              SUM(CASE
                      WHEN CHARINDEX('切割', E.FNAME) > 0 THEN a.FACTUALQTY * ml.F_MJM2
                      ELSE a.FACTUALQTY END) AS '汇总投入数量',
              SCXL.FNAME                     AS 车间生产线,
              E.FNAME                        AS 车间
       FROM T_PRD_PICKMTRLDATA a
                INNER JOIN T_PRD_PICKMTRL b ON b.fid = a.fid
                INNER JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = b.FWORKSHOPID
                INNER JOIN PIKU_CJSCX SCX ON SCX.FID = B.F_PIKU_CJSCX
                INNER JOIN PIKU_CJSCX_L SCXL ON SCX.FID = SCXL.FID
                LEFT JOIN T_BD_MATERIAL ml ON ml.FMATERIALID = a.FMATERIALID
       WHERE b.FPRDORGID = '100329'
         AND B.FDATE >=
             CASE

                 WHEN DAY(GETDATE()) = 1 THEN
                     DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
                 ELSE DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
                 END
         AND B.FDATE < DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETDATE()))
       GROUP BY E.FNAME,
                b.fdate,
                SCXL.FNAME)

SELECT COALESCE(CC.FDATE, TR.FDATE) AS 日期,TR.汇总投入数量,CC.汇总产出数量,COALESCE(TR.车间生产线, CC.车间生产线) AS 车间生产线, COALESCE(CC.[车间], TR.[车间])AS 车间 FROM CC
FULL JOIN TR ON CC.FDATE=TR.FDATE AND TR.车间生产线=CC.车间生产线 ORDER BY  COALESCE(CC.FDATE, TR.FDATE)