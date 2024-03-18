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
                and FDOCUMENTSTATUS = 'c')


--每天成本
SELECT A.FBILLNO,A.FDATE, C.FNUMBER,E.FNAME,E.FSPECIFICATION, CGJM.FPRICE, B.FQTY,T5L.FNAME
FROM T_STK_MISDELIVERY A
         LEFT JOIN T_STK_MISDELIVERYENTRY B ON A.FID = B.FID
         LEFT JOIN T_BD_MATERIAL C ON B.FMATERIALID = C.FMATERIALID
    LEFT JOIN T_BD_MATERIAL_L E ON E.FMATERIALID = C.FMATERIALID AND E.FLOCALEID = 2052
         LEFT JOIN T_ORG_ORGANIZATIONS_L D ON A.FSTOCKORGID = D.FORGID
         LEFT JOIN CGJM ON CGJM.物料编码 = C.FNUMBER
         LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = B.FUNITID AND T5L.FLOCALEID = 2052
WHERE D.FNAME = '第一事业部'
  AND A.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
  AND A.FDATE < CONVERT(date, GETDATE())