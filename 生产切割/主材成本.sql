--最新价格
WITH CGJM AS (SELECT DISTINCT FPRICE,
                              AA.物料编码,
                              AA.辅助属性规格,
                              AA.辅助属性编码,
                              FMATERIALID
              FROM (SELECT po1.FPRICE,
                           po1.FMATERIALID,
                           PO.FDOCUMENTSTATUS,
                           MAT.FNUMBER                                                                                    AS 物料编码,
                           tFF100001.FNUMBER                                                                              AS 辅助属性编码,
                           tFF100001_l.FDATAVALUE                                                                         AS 辅助属性规格,
                           ROW_NUMBER() OVER ( PARTITION BY MAT.FNUMBER,tFF100001.FNUMBER ORDER BY PO.FAPPROVEDATE DESC ) AS rn
                    FROM T_PUR_PriceList po
                             LEFT JOIN t_PUR_PriceListEntry po1 ON (po.FID = po1.FID)
                             LEFT JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
                             LEFT JOIN t_BD_Material_L mat_l
                                       ON (mat.FMATERIALID = mat_l.FMATERIALID AND mat_l.FLOCALEID = 2052)
                             LEFT JOIN T_BD_FLEXSITEMDETAILV aux ON po1.FAuxPropId = aux.FID
                             LEFT JOIN T_BAS_AssistantDataEntry tFF100001 ON aux.FF100005 = tFF100001.FENTRYID
                             LEFT JOIN T_BAS_AssistantDataEntry_l tFF100001_l
                                       ON (tFF100001.FENTRYID = tFF100001_l.FENTRYID AND
                                           tFF100001_l.FLocaleId = 2052)
                    WHERE PO.FDOCUMENTSTATUS = 'C') AA
              WHERE rn = 1)

SELECT PO.FDATE,
       CGJM.FPRICE,
       PO1.FACTUALQTY,
       MAT.FNUMBER,
       tFF100001_l.FDATAVALUE,
       PO1.FACTUALQTY * CGJM.FPRICE AS 金额
FROM T_SP_PICKMTRL PO
         LEFT JOIN T_SP_PICKMTRLDATA PO1 ON PO.FID = PO1.FID
         LEFT JOIN T_ORG_ORGANIZATIONS_L c ON PO.FSTOCKORGID = c.FORGID
         LEFT JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
         LEFT JOIN T_BD_FLEXSITEMDETAILV aux ON po1.FAuxPropId = aux.FID
         LEFT JOIN T_BAS_AssistantDataEntry tFF100001 ON aux.FF100005 = tFF100001.FENTRYID
         LEFT JOIN T_BAS_AssistantDataEntry_l tFF100001_l
                   ON (tFF100001.FENTRYID = tFF100001_l.FENTRYID AND tFF100001_l.FLocaleId = 2052)
         LEFT JOIN CGJM ON CGJM.物料编码 = MAT.FNUMBER AND (CGJM.辅助属性规格 = tFF100001_l.FDATAVALUE OR
                                                            (CGJM.辅助属性规格 IS NULL AND tFF100001_l.FDATAVALUE IS NULL))
WHERE c.FNAME = '第一事业部'
  AND PO.FDATE >= CASE
                      WHEN DAY(GETDATE()) = 1 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
                      ELSE
                          DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) END
  AND PO.FDATE < DATEADD(DAY, 0, DATEDIFF(DAY, 0, GETDATE()))