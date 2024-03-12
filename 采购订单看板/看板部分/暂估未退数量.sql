--暂估
WITH ZG AS
         (

-- 暂估，取所有的：
-- 付款核销状态不等于已完
-- 立账类型等于暂估
-- 生成方式为空
-- 表体开票核销状态不等于完全
             SELECT A.FBILLNO           AS 单据号,
                    FBUYIVQTY           AS 采购发票数量,
                    A.FWRITTENOFFSTATUS AS 付款核销状态,
                    A.FSETACCOUNTTYPE   AS 立账类型,
                    A.FBYVERIFY         AS 生成方式,
                    B.FOPENSTATUS       AS 表体开票核销状态,
                    C.FNAME             AS 单据类型,
                    A.FDATE             AS 业务日期,
                    D.FNAME             AS 供应商,
                    E.FNAME             AS 采购员,
                    G.FNAME             AS 物料名称,
                    F.FNUMBER           AS 物料编码,
                    G.FSPECIFICATION    AS 物料规格,
                    B.FPRICE            AS 单价,
                    B.FPRICEQTY         AS 数量,
                    YEAR(A.FDATE)       AS ApprovalYear,
                    MONTH(A.FDATE)      AS ApprovalMonth

             FROM T_AP_PAYABLE A
                      LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
                      LEFT JOIN T_BAS_BILLTYPE_L C ON A.FBILLTYPEID = C.FBILLTYPEID AND C.FLOCALEID = 2052
                      LEFT JOIN T_BD_SUPPLIER_L D on D.FSUPPLIERID = A.FSUPPLIERID
                      LEFT JOIN V_BD_BUYER_L E ON E.FID = A.FPURCHASERID
                      LEFT JOIN T_BD_MATERIAL F ON B.FMATERIALID = F.FMATERIALID
                      LEFT JOIN T_BD_MATERIAL_L G ON B.FMATERIALID = G.FMATERIALID
                      LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = B.FPRICEUNITID AND T5L.FLOCALEID = 2052
             WHERE A.FWRITTENOFFSTATUS <> 'C'
               AND A.FDOCUMENTSTATUS = 'C'
               AND A.FSETACCOUNTTYPE = '2'
               AND A.FBYVERIFY = '0'
               AND B.FOPENSTATUS <> 'C'
               AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331')),
--暂估已推发票
     ZG1 AS
         (

-- 发票

             SELECT A.FBILLNO           AS 单据号1,
                    FBUYIVQTY           AS 采购发票数量1,
                    A.FWRITTENOFFSTATUS AS 付款核销状态1,
                    A.FSETACCOUNTTYPE   AS 立账类型1,
                    A.FBYVERIFY         AS 生成方式1,
                    B.FOPENSTATUS       AS 表体开票核销状态1--T_AP_PAYABLEENTRY
             FROM T_AP_PAYABLE A
                      LEFT JOIN T_AP_PAYABLEENTRY B ON A.FID = B.FID
             WHERE A.FWRITTENOFFSTATUS <> 'C'
               AND A.FDOCUMENTSTATUS = 'C'
               AND A.FSETACCOUNTTYPE = '2'
               AND A.FBYVERIFY = '0'
               AND B.FOPENSTATUS <> 'C'
               AND B.FBUYIVQTY <> '0'
               AND A.FPAYORGID IN ('1', '100329', '100330', '100331', '100332', '3798064', '4355331'))
SELECT count(*)   AS 数量                 FROM ZG
                            LEFT JOIN ZG1 ON ZG.单据号 = ZG1.单据号1
                   WHERE ZG1.单据号1 IS NULL


