--每天成本
WITH QTCB AS (SELECT A.FDATE, C.FNUMBER, B.FQTY
              FROM T_STK_MISDELIVERY A
                       LEFT JOIN T_STK_MISDELIVERYENTRY B ON A.FID = B.FID
                       LEFT JOIN T_BD_MATERIAL C ON B.FMATERIALID = C.FMATERIALID
                       LEFT JOIN T_ORG_ORGANIZATIONS_L D ON A.FSTOCKORGID = D.FORGID
              WHERE D.FNAME = '第一事业部'
                AND A.FDATE >= CASE
                                   WHEN DAY(GETDATE()) = 1 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
                                   ELSE DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) END
                AND A.FDATE < DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETDATE())))

SELECT AA.FDATE,
       AA.物料编码,
       AA.数量,
       FPRICE,
       AA.数量*FPRICE AS 总金额
FROM (SELECT po1.FPRICE,
             po1.FMATERIALID,
             PO.FDOCUMENTSTATUS,
             MAT.FNUMBER                                                                      AS 物料编码,
             QTCB.FQTY                                                                        AS 数量,
             QTCB.FDATE,
             ROW_NUMBER() OVER ( PARTITION BY MAT.FMATERIALID ORDER BY PO.FAPPROVEDATE DESC ) AS rn
      FROM QTCB
               LEFT JOIN T_BD_Material mat ON (QTCB.FNUMBER = mat.FNUMBER)
               LEFT JOIN t_PUR_PriceListEntry po1 ON (PO1.FMATERIALID = MAT.FMATERIALID)
               LEFT JOIN T_PUR_PriceList po ON PO.FID = PO1.FID) AA
WHERE rn = 1
  and FDOCUMENTSTATUS = 'c'
