SELECT
     RequisitionMaterialCount.TotalCount AS 采购申请单物料数,
		 MaterialCount.TotalCount AS 已推价目表物料数量,
   RequisitionMaterialCount.TotalCount-MaterialCount.TotalCount   AS 未申请推价目的数
FROM
    (SELECT COUNT( DISTINCT FNUMBER) AS TotalCount
              FROM (SELECT D.FNUMBER,
                           B.FCREATEDATE,
                          B.FUSEORGID,
                           ROW_NUMBER() OVER (PARTITION BY A.FMATERIALID ORDER BY B.FCREATEDATE DESC) AS rn
                    FROM t_PUR_PriceListEntry A
                             LEFT JOIN t_PUR_PriceList B ON A.FID = B.FID
                             LEFT JOIN T_BD_MATERIAL D ON A.FMATERIALID = D.FMATERIALID
                    WHERE A.FROWAUDITSTATUS = 'A'
                      AND B.FUSEORGID IN ('1')) AA
              WHERE rn = 1
    ) AS MaterialCount,
    (SELECT COUNT( DISTINCT D.FNUMBER) AS TotalCount
              FROM T_PUR_Requisition A
                       LEFT JOIN T_ORG_ORGANIZATIONS_L C ON C.FPKID = A.FAPPLICATIONORGID
                       INNER JOIN T_PUR_ReqEntry AA ON AA.FID = A.FID
                       LEFT JOIN T_BD_MATERIAL D ON AA.FMATERIALID = D.FMATERIALID
              WHERE  A.FAPPLICATIONORGID IN ('1')
    ) AS RequisitionMaterialCount;

