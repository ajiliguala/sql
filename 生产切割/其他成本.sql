SELECT QTCB.FDATE,
       QTCB.FNUMBER,
       QTCB.FNAME,
       ISNULL(YFD.单价, 0)             AS 单价,
       QTCB.FQTY,
       ISNULL(YFD.单价 * QTCB.FQTY, 0) AS 金额
FROM (SELECT A.FDATE, C.FNUMBER, B.FQTY, E.FNAME
      FROM T_STK_MISDELIVERY A
               INNER JOIN T_STK_MISDELIVERYENTRY B ON A.FID = B.FID
               INNER JOIN T_BD_MATERIAL C ON B.FMATERIALID = C.FMATERIALID
               INNER JOIN T_BD_MATERIAL_L E ON E.FMATERIALID = C.FMATERIALID
               INNER JOIN T_ORG_ORGANIZATIONS_L D ON A.FSTOCKORGID = D.FORGID
      WHERE D.FNAME = '第一事业部'
        AND A.FDATE >= CASE
                           WHEN DAY(GETDATE()) = 1 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
                           ELSE DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) END
        AND A.FDATE < DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETDATE()))
        AND A.FDOCUMENTSTATUS = 'C') QTCB
         LEFT JOIN (SELECT DISTINCT *
                    FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY WL.FNUMBER ORDER BY A.FCreateDate DESC ) AS XUHAO,
                                 B.FMATERIALID,
                                 WL.FNUMBER,
                                 CASE
                                     WHEN B.FPRICEQTY <> 0 THEN B.FNOTAXAMOUNT / B.FPRICEQTY
                                     ELSE NULL
                                     END                                                                   AS 单价
                          FROM T_AP_PAYABLE A
                                   INNER JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                                   INNER JOIN (SELECT A.FMATERIALID, A.FNUMBER FROM T_BD_MATERIAL A) WL
                                              ON B.FMATERIALID = WL.FMATERIALID
                          WHERE 1 = 1
                            AND A.FDATE >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) - 1, 0)
                            AND A.FDOCUMENTSTATUS = 'C') T
                    WHERE T.XUHAO = 1) YFD ON QTCB.FNUMBER = YFD.FNUMBER