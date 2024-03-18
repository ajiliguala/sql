--最新价格
WITH CGJM AS (SELECT FPRICE,
                     AA.物料编码,
                     AA.辅助属性规格,
                     AA.辅助属性编码
              FROM (SELECT po1.FPRICE,
                           po1.FMATERIALID,
                           PO.FDOCUMENTSTATUS,
                           MAT.FNUMBER                                                                                        AS 物料编码,
                           tFF100001.FNUMBER                                                                                  AS 辅助属性编码,
                           tFF100001_l.FDATAVALUE                                                                             AS 辅助属性规格,
                           ROW_NUMBER() OVER ( PARTITION BY MAT.FMATERIALID,tFF100001.FNUMBER ORDER BY PO.FAPPROVEDATE DESC ) AS rn
                    FROM T_PUR_PriceList po
                             LEFT JOIN t_PUR_PriceListEntry po1 ON (po.FID = po1.FID)
                             LEFT JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
                             LEFT JOIN t_BD_Material_L mat_l
                                       ON (mat.FMATERIALID = mat_l.FMATERIALID AND mat_l.FLOCALEID = 2052)
                             LEFT JOIN T_BD_FLEXSITEMDETAILV aux ON po1.FAuxPropId = aux.FID
                             LEFT JOIN T_BAS_AssistantDataEntry tFF100001 ON aux.FF100005 = tFF100001.FENTRYID
                             LEFT JOIN T_BAS_AssistantDataEntry_l tFF100001_l
                                       ON (tFF100001.FENTRYID = tFF100001_l.FENTRYID AND tFF100001_l.FLocaleId = 2052)
                    WHERE PO.FCREATEORGID = '1') AA
              WHERE rn = 1
                and FDOCUMENTSTATUS = 'c'),


--主材昨日数量
ZCZR AS (SELECT SUM(TEMP1.金额) AS 昨日主材成本
FROM (
SELECT CGJM.FPRICE,
       PO1.FACTUALQTY * CGJM.FPRICE AS 金额
FROM T_SP_PICKMTRL PO
         LEFT JOIN T_SP_PICKMTRLDATA PO1 ON PO.FID = PO1.FID
         LEFT JOIN T_ORG_ORGANIZATIONS_L c ON PO.FSTOCKORGID = c.FORGID
         LEFT JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
         LEFT JOIN t_BD_Material_L mat_l
                   ON (mat.FMATERIALID = mat_l.FMATERIALID AND mat_l.FLOCALEID = 2052)
         LEFT JOIN T_BD_FLEXSITEMDETAILV aux ON po1.FAuxPropId = aux.FID
         LEFT JOIN T_BAS_AssistantDataEntry tFF100001 ON aux.FF100005 = tFF100001.FENTRYID
         LEFT JOIN T_BAS_AssistantDataEntry_l tFF100001_l
                   ON (tFF100001.FENTRYID = tFF100001_l.FENTRYID AND tFF100001_l.FLocaleId = 2052)
         LEFT JOIN CGJM ON CGJM.物料编码 = MAT.FNUMBER AND CGJM.辅助属性编码 = tFF100001.FNUMBER
WHERE c.FNAME = '第一事业部'
  AND PO.FDATE >= DATEADD(day, -1, CONVERT(date, GETDATE()))
  AND PO.FDATE < CONVERT(date, GETDATE())
) TEMP1),


--主材当月数量
     DYZC AS (SELECT SUM(TEMP1.金额) AS 当月主材成本
              FROM (SELECT CGJM.FPRICE,
       PO1.FACTUALQTY * CGJM.FPRICE AS 金额
FROM T_SP_PICKMTRL PO
         LEFT JOIN T_SP_PICKMTRLDATA PO1 ON PO.FID = PO1.FID
         LEFT JOIN T_ORG_ORGANIZATIONS_L c ON PO.FSTOCKORGID = c.FORGID
         LEFT JOIN T_BD_Material mat ON (po1.FMaterialId = mat.FMaterialId)
         LEFT JOIN t_BD_Material_L mat_l
                   ON (mat.FMATERIALID = mat_l.FMATERIALID AND mat_l.FLOCALEID = 2052)
         LEFT JOIN T_BD_FLEXSITEMDETAILV aux ON po1.FAuxPropId = aux.FID
         LEFT JOIN T_BAS_AssistantDataEntry tFF100001 ON aux.FF100005 = tFF100001.FENTRYID
         LEFT JOIN T_BAS_AssistantDataEntry_l tFF100001_l
                   ON (tFF100001.FENTRYID = tFF100001_l.FENTRYID AND tFF100001_l.FLocaleId = 2052)
         LEFT JOIN CGJM ON CGJM.物料编码 = MAT.FNUMBER AND CGJM.辅助属性编码 = tFF100001.FNUMBER
WHERE c.FNAME = '第一事业部'
                      AND (
                        (DAY(GETDATE()) = 1 AND
                         DAY(DATEADD(DAY, -1, GETDATE())) = DAY(DATEADD(MONTH, -1, GETDATE())) AND
                         DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, PO.FDATE) AND
                         DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, PO.FDATE))
                            OR
                        (DAY(GETDATE()) != 1 AND
                         MONTH(DATEADD(DAY, -1, GETDATE())) = MONTH(GETDATE()) AND
                         DATEPART(YEAR, GETDATE()) = DATEPART(YEAR, PO.FDATE) AND
                         DATEPART(MONTH, GETDATE()) = DATEPART(MONTH, PO.FDATE))
                            OR
                        (DATEPART(YEAR, DATEADD(DAY, -1, GETDATE())) = DATEPART(YEAR, PO.FDATE) AND
                         DATEPART(MONTH, DATEADD(DAY, -1, GETDATE())) = DATEPART(MONTH, PO.FDATE))
                        )) TEMP1)

SELECT ZCZR.昨日主材成本, DYZC.当月主材成本
FROM ZCZR,
     DYZC;
