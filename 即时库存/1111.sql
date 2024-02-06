WITH KEHU AS (  
    SELECT DISTINCT  
        T8L.FNAME,  
        T3L.FNUMBER  
    FROM  
        T_SAL_ORDER A  
        LEFT JOIN T_SAL_ORDERENTRY C ON C.FID = A.FID  
        LEFT JOIN T_BD_CUSTOMER_L T8L ON T8L.FCUSTID = A.FCUSTID  
        LEFT JOIN T_BD_MATERIAL T3L ON T3L.FMATERIALID = C.FMATERIALID  
    WHERE  
        A.FSALEORGID = 100332  
				--and t3l.FNUMBER='01.05.0001.01982'
),  
TEMP1 AS (  
    SELECT 
        T3.FNUMBER AS 物料编码,  
        T3L.FNAME AS 物料名称,  
        T3L.FSPECIFICATION AS 规格型号,  
        T2L.FNAME AS 仓库名称,  
        CASE  
            WHEN T7L.FNAME = '车载事业部' THEN SUM(T1.FBASEQTY)  
            ELSE NULL  
        END AS '车载事业部库存量',  
        CASE  
            WHEN T7L.FNAME = '(原)第五事业部' THEN SUM(T1.FBASEQTY)  
            ELSE NULL  
        END AS '原第五事业部库存量',  
        T7L.FNAME AS 库存组织,  
        T5L.FNAME AS 基本单位  
    FROM  
        T_STK_INVENTORY T1  
        LEFT JOIN T_BD_STOCK T2 ON T1.FSTOCKID = T2.FSTOCKID  
        LEFT JOIN T_BD_STOCK_L T2L ON T1.FSTOCKID = T2L.FSTOCKID AND T2L.FLOCALEID = 2052  
        LEFT JOIN T_BD_MATERIAL T3 ON T1.FMATERIALID = T3.FMASTERID AND T1.FSTOCKORGID = T3.FUSEORGID  
        LEFT JOIN T_BD_MATERIAL_L T3L ON T3.FMATERIALID = T3L.FMATERIALID AND T3L.FLOCALEID = 2052  
        LEFT JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = T1.FBASEUNITID AND T5L.FLOCALEID = 2052  
        LEFT JOIN T_ORG_ORGANIZATIONS_L T7L ON T7L.FORGID = T1.FSTOCKORGID  
    WHERE  
        T1.FBASEQTY <> 0 AND  
        T7L.FNAME IN ( '(原)第五事业部','车载事业部')
			--and t3.FNUMBER='03.02.3001.00138'		
    GROUP BY  
        T3.FNUMBER,  
        T3L.FNAME,  
        T3L.FSPECIFICATION,  
        T2L.FNAME,  
        T1.FMATERIALID,  
        T1.FPRODUCEDATE,  
        T1.FEXPIRYDATE,  
        T5L.FNAME,  
        T7L.FNAME  
),  
TEMP2 AS (  
    SELECT  
        X.FNUMBER,  
        X.客户  
    FROM (  
        SELECT  
            ROW_NUMBER() OVER (PARTITION BY WL.FNUMBER ORDER BY A.FCREATEDATE DESC) AS XUHAO,  
            WL.FNUMBER,  
            T8L.FNAME AS 客户  
        FROM  
            T_SAL_ORDER A  
            LEFT JOIN T_SAL_ORDERENTRY C ON C.FID = A.FID  
            LEFT JOIN T_SAL_ORDERENTRY_F B ON C.FID = B.FID AND B.FENTRYID = C.FENTRYID  
            LEFT JOIN T_BD_MATERIAL WL ON C.FMATERIALID = WL.FMATERIALID  
            LEFT JOIN T_BD_CUSTOMER_L T8L ON T8L.FCUSTID = A.FCUSTID  
        WHERE  
            B.FPRICEUNITQTY <> 0 AND  
            A.FDOCUMENTSTATUS = 'C'
					--and wl.FNUMBER='01.05.0001.01982'		
    ) X  
    WHERE X.XUHAO = 1  
)  
SELECT  DISTINCT
	TEMP4.物料编码,
	TEMP4.物料名称,
	TEMP4.规格型号,
	TEMP4.仓库名称,
	TEMP4.车载事业部库存量,
	TEMP4.原第五事业部库存量,
	TEMP4.库存组织,
	TEMP4.基本单位,
	temp4.客户,
	temp4.调整后的客户名称 
FROM
(
SELECT   DISTINCT
    TEMP1.物料编码,  
    TEMP1.物料名称,  
    TEMP1.规格型号,  
    TEMP1.仓库名称,
		--TEMP1.车载事业部库存量,	
    sum(TEMP1.车载事业部库存量) as 车载事业部库存量,  
    sum(TEMP1.原第五事业部库存量) as 原第五事业部库存量,  
    TEMP1.库存组织,  
    TEMP1.基本单位,
		temp2.客户,
     CASE     
        WHEN TEMP2.客户 = '芜湖长信科技股份有限公司' THEN KEHU.FNAME     
        ELSE TEMP2.客户     
    END AS 调整后的客户名称   
FROM TEMP1     
LEFT OUTER  JOIN TEMP2 ON TEMP1.物料编码 = TEMP2.FNUMBER     
LEFT JOIN KEHU ON KEHU.FNUMBER = TEMP1.物料编码
	WHERE
		TEMP1.仓库名称 IN ( '车载盖板成品库', '车载成品库', '(原)五部成品库' ) 
		AND TEMP2.客户  IN ( '芜湖长信科技股份有限公司' ) 
-- 		AND NOT EXISTS ( SELECT 1 FROM TEMP2 t2 WHERE temp1.物料编码 = t2.FNUMBER )
-- 		AND TEMP1.[物料编码]='01.05.0001.01982'  
GROUP BY     
    TEMP1.物料编码,  
    TEMP1.物料名称,  
    TEMP1.规格型号,  
    TEMP1.仓库名称,
    KEHU.FNAME,  
    TEMP1.库存组织,  
    TEMP1.基本单位,
		temp2.客户 ) temp4 

	
