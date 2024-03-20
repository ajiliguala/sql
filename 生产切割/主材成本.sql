SELECT SCLL.FDATE,
       SCLL.FNUMBER,
       SCLL.FNAME,
       ISNULL(YFD.单价, 0)                   AS 单价,
       SCLL.FACTUALQTY,
			 SCLL.FAUXPROPID , YFD.FAUXPROPID,
       ISNULL(YFD.单价 * SCLL.FACTUALQTY, 0) AS 金额
--生产领料
FROM (SELECT PO.FDATE,
             PO1.FACTUALQTY,
             MAT.FNUMBER,
             PO1.FAUXPROPID,
             MAT_L.FNAME,
             PO1.FMATERIALID
      FROM T_SP_PICKMTRL PO
               INNER JOIN T_SP_PICKMTRLDATA PO1 ON PO.FID = PO1.FID
               INNER JOIN T_ORG_ORGANIZATIONS_L c ON PO.FSTOCKORGID = c.FORGID
               INNER JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
               INNER JOIN T_BD_MATERIAL_L mat_L ON (MAT.FMaterialId = mat_L.FMaterialId)
      WHERE c.FNAME = '第一事业部'
        AND PO.FDATE >= CASE
                            WHEN DAY(GETDATE()) = 1 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
                            ELSE
                                DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) END
        AND PO.FDATE < DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETDATE()))) SCLL
         --应付单
         LEFT JOIN (SELECT *
                    FROM (SELECT ROW_NUMBER() OVER ( PARTITION BY WL.FNUMBER,C.FAUXPROPID ORDER BY A.FCreateDate DESC ) AS XUHAO,
                                 A.FDATE,
                                 B.FMATERIALID,
                                 WL.FNUMBER,
                                 C.FAUXPROPID,
                                 B.FPRICEQTY,
                                 B.FNOTAXAMOUNT,
                                 B.FNOTAXAMOUNT / B.FPRICEQTY                                              AS 单价
                          FROM T_AP_PAYABLE A
                                   INNER JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                                   INNER JOIN T_AP_PAYABLEENTRY_O C ON B.FID = C.FID
                              AND B.FENTRYID = C.FENTRYID
                                   INNER JOIN (SELECT A.FMATERIALID,
                                                      A.FNUMBER
                                               FROM T_BD_MATERIAL A
 ) WL ON B.FMATERIALID = WL.FMATERIALID
                          WHERE 1 = 1
                            AND A.FDATE >= DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE())-1, 0)
                            AND A.FDOCUMENTSTATUS = 'C'
                            ) T
                    WHERE
                       T.XUHAO = 1) YFD ON SCLL.FNUMBER = YFD.FNUMBER AND SCLL.FAUXPROPID = YFD.FAUXPROPID