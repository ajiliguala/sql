WITH CGJM AS (SELECT DISTINCT FNUMBER, FUSEORGID
              FROM (SELECT D.FNUMBER,
                           B.FCREATEDATE,
                           B.FUSEORGID,
                           ROW_NUMBER() OVER (PARTITION BY A.FMATERIALID ORDER BY B.FCREATEDATE DESC) AS rn
                    FROM t_PUR_PriceListEntry A
                             LEFT JOIN t_PUR_PriceList B ON A.FID = B.FID
                             LEFT JOIN T_BD_MATERIAL D ON A.FMATERIALID = D.FMATERIALID
                    WHERE A.FROWAUDITSTATUS = 'A'
                      AND B.FUSEORGID IN ('1')) AA
    --WHERE rn = 1
),
     CGSQ AS (SELECT DISTINCT a.FBILLNO             AS 单据编号,
                              B.FNAME               AS 单据类型,
                              D.FNUMBER             AS 物料编码,
                              AA.F_PIKU_SYR         AS 使用人,
                              E.FNAME               AS 物料名称,
                              E.FSPECIFICATION      AS 物料规格,
                              t5l.FNAME             AS 单位,
                              aa.FREQQTY            AS 数量,
                              a.FAPPROVEDATE        AS 采购申请审核日期,
                              d.F_CGY               AS 执行采购,
                              aa.F_KFCG             AS 开发采购,
                              A.FAPPLICATIONORGID,
                              YEAR(a.FAPPROVEDATE)  AS ApprovalYear,
                              MONTH(a.FAPPROVEDATE) AS ApprovalMonth
              FROM T_PUR_Requisition A
                       LEFT JOIN T_ORG_ORGANIZATIONS_L C ON C.FPKID = A.FAPPLICATIONORGID
                       INNER JOIN T_PUR_ReqEntry AA ON AA.FID = A.FID
                       LEFT JOIN T_BD_MATERIAL D ON AA.FMATERIALID = D.FMATERIALID
                       LEFT JOIN T_BD_MATERIAL_L E ON AA.FMATERIALID = E.FMATERIALID
                       LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = aa.FUNITID AND T5L.FLOCALEID = 2052
              LEFT JOIN T_BAS_BILLTYPE_L B ON A.FBILLTYPEID = B.FBILLTYPEID AND B.FLOCALEID = 2052
              WHERE A.FAPPLICATIONORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')
              AND A.FDOCUMENTSTATUS='C'
              )
SELECT count(*) AS 数量
               FROM CGSQ
                        LEFT JOIN CGJM ON CGSQ.物料编码 = CGJM.FNUMBER
               WHERE CGJM.FNUMBER IS NULL

