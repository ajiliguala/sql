WITH CGJM AS (SELECT FPRICE,
                     AA.物料编码
              FROM (SELECT po1.FPRICE,
                           po1.FMATERIALID,
                           PO.FDOCUMENTSTATUS,
                           MAT.FNUMBER                                                                      AS 物料编码,
                           ROW_NUMBER() OVER ( PARTITION BY MAT.FMATERIALID ORDER BY PO.FAPPROVEDATE DESC ) AS rn
                    FROM T_PUR_PriceList po
                             LEFT JOIN t_PUR_PriceListEntry po1 ON (po.FID = po1.FID)
                             LEFT JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
                             LEFT JOIN t_BD_Material_L mat_l
                                       ON (mat.FMATERIALID = mat_l.FMATERIALID AND mat_l.FLOCALEID = 2052)) AA
              WHERE rn = 1
                and FDOCUMENTSTATUS = 'c'),


--每天成本

     QTZRCB AS (SELECT SUM(AA.金额) AS 其他昨日成本
              FROM (SELECT A.FDATE, C.FNUMBER, CGJM.FPRICE, B.FQTY, CGJM.FPRICE * B.FQTY AS 金额
                    FROM T_STK_MISDELIVERY A
                             LEFT JOIN T_STK_MISDELIVERYENTRY B ON A.FID = B.FID
                             LEFT JOIN T_BD_MATERIAL C ON B.FMATERIALID = C.FMATERIALID
                             LEFT JOIN T_ORG_ORGANIZATIONS_L D ON A.FSTOCKORGID = D.FORGID
                             LEFT JOIN CGJM ON CGJM.物料编码 = C.FNUMBER
                    WHERE D.FNAME = '第一事业部'
                      AND A.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
                      AND A.FDATE < CONVERT(date, GETDATE())) AA),
     QTDYCB AS (SELECT SUM(AA.金额) AS 其他当月成本
              FROM (SELECT A.FDATE, C.FNUMBER, CGJM.FPRICE, B.FQTY, CGJM.FPRICE * B.FQTY AS 金额
                    FROM T_STK_MISDELIVERY A
                             LEFT JOIN T_STK_MISDELIVERYENTRY B ON A.FID = B.FID
                             LEFT JOIN T_BD_MATERIAL C ON B.FMATERIALID = C.FMATERIALID
                             LEFT JOIN T_ORG_ORGANIZATIONS_L D ON A.FSTOCKORGID = D.FORGID
                             LEFT JOIN CGJM ON CGJM.物料编码 = C.FNUMBER
                    WHERE D.FNAME = '第一事业部'
                      AND (
                        (DAY(GETDATE()) = 1 AND
                         DAY(DATEADD(DAY, -1, GETDATE())) = DAY(DATEADD(MONTH, -1, GETDATE())) AND
                         DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, A.FDATE) AND
                         DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, A.FDATE))
                            OR
                        (DAY(GETDATE()) != 1 AND
                         MONTH(DATEADD(DAY, -1, GETDATE())) = MONTH(GETDATE()) AND
                         DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, A.FDATE) AND
                         DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, A.FDATE))
                            OR
                        (DATEPART(YEAR, DATEADD(DAY, -1, GETDATE())) = DATEPART(YEAR, A.FDATE) AND
                         DATEPART(MONTH, DATEADD(DAY, -1, GETDATE())) = DATEPART(MONTH, A.FDATE))
                        )) AA)

SELECT QTZRCB.其他昨日成本, QTDYCB.其他当月成本
FROM QTZRCB,
     QTDYCB;
