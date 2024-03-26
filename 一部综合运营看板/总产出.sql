WITH SCRK AS (SELECT SUM(SCRK_S.FREALQTY * ML.F_MJM2) AS 'SCRK总产出'
              FROM T_PRD_INSTOCK SCRK
                       INNER JOIN T_PRD_INSTOCKENTRY SCRK_S ON SCRK.FID = SCRK_S.FID
                       INNER JOIN T_BD_MATERIAL ML ON ML.FMATERIALID = SCRK_S.FMATERIALID
              WHERE SCRK_S.FSTOCKID = '103760'--一部成品A品库
                AND (
                  (DAY(GETDATE()) = 1 AND
                   DAY(DATEADD(DAY, -1, GETDATE())) = DAY(DATEADD(MONTH, -1, GETDATE())) AND
                   DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, SCRK.FDATE) AND
                   DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, SCRK.FDATE))
                      OR
                  (DAY(GETDATE()) != 1 AND
                   MONTH(DATEADD(DAY, -1, GETDATE())) = MONTH(GETDATE()) AND
                   DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, SCRK.FDATE) AND
                   DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, SCRK.FDATE))
                      OR
                  (DATEPART(YEAR, DATEADD(DAY, -1, GETDATE())) = DATEPART(YEAR, SCRK.FDATE) AND
                   DATEPART(MONTH, DATEADD(DAY, -1, GETDATE())) = DATEPART(MONTH, SCRK.FDATE))
                  )
                AND DAY(SCRK.FDATE) < DAY(GETDATE())),
     JSKC AS (SELECT SUM(JSKC.FBASEQTY * ML.F_MJM2) AS 'JSKC总产出'
              FROM T_STK_INVENTORY JSKC
                       INNER JOIN T_BD_MATERIAL ML ON ML.FMATERIALID = JSKC.FMATERIALID
              WHERE JSKC.FSTOCKID IN ('409674', '409675', '409676')-- 一部切割半成品库  一部研磨半成品库 一部化强半成品库
                AND (
                  (DAY(GETDATE()) = 1 AND
                   DAY(DATEADD(DAY, -1, GETDATE())) = DAY(DATEADD(MONTH, -1, GETDATE())) AND
                   DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, JSKC.FPRODUCEDATE) AND
                   DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, JSKC.FPRODUCEDATE))
                      OR
                  (DAY(GETDATE()) != 1 AND
                   MONTH(DATEADD(DAY, -1, GETDATE())) = MONTH(GETDATE()) AND
                   DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, JSKC.FPRODUCEDATE) AND
                   DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, JSKC.FPRODUCEDATE))
                      OR
                  (DATEPART(YEAR, DATEADD(DAY, -1, GETDATE())) = DATEPART(YEAR, JSKC.FPRODUCEDATE) AND
                   DATEPART(MONTH, DATEADD(DAY, -1, GETDATE())) = DATEPART(MONTH, JSKC.FPRODUCEDATE))
                  )
                AND DAY(JSKC.FPRODUCEDATE) < DAY(GETDATE())
              )

SELECT
SCRK总产出 + JSKC总产出 AS '总产出' FROM SCRK,JSKC





