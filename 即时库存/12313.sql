WITH KEHU AS (  
    SELECT DISTINCT  
        T8L.FNAME,  
        T3L.FNUMBER  
    FROM  
        T_SAL_ORDER A  
        INNER JOIN T_SAL_ORDERENTRY C ON C.FID = A.FID  
        LEFT JOIN T_BD_CUSTOMER_L T8L ON T8L.FCUSTID = A.FCUSTID  
        INNER JOIN T_BD_MATERIAL T3L ON T3L.FMATERIALID = C.FMATERIALID  
    WHERE  
        A.FSALEORGID = 100332  
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
        INNER JOIN T_BD_STOCK T2 ON T1.FSTOCKID = T2.FSTOCKID  
        INNER JOIN T_BD_STOCK_L T2L ON T1.FSTOCKID = T2L.FSTOCKID AND T2L.FLOCALEID = 2052  
        INNER JOIN T_BD_MATERIAL T3 ON T1.FMATERIALID = T3.FMASTERID AND T1.FSTOCKORGID = T3.FUSEORGID  
        INNER JOIN T_BD_MATERIAL_L T3L ON T3.FMATERIALID = T3L.FMATERIALID AND T3L.FLOCALEID = 2052  
        INNER JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = T1.FBASEUNITID AND T5L.FLOCALEID = 2052  
        INNER JOIN T_ORG_ORGANIZATIONS_L T7L ON T7L.FORGID = T1.FSTOCKORGID  
    WHERE  
        T1.FBASEQTY <> 0 AND  
        T7L.FNAME IN ('(原)第五事业部', '车载事业部')
			--and t3.FNUMBER='01.05.0001.01982'		
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
            INNER JOIN T_SAL_ORDERENTRY C ON C.FID = A.FID  
            INNER JOIN T_SAL_ORDERENTRY_F B ON C.FID = B.FID AND B.FENTRYID = C.FENTRYID  
            INNER JOIN T_BD_MATERIAL WL ON C.FMATERIALID = WL.FMATERIALID  
            LEFT JOIN T_BD_CUSTOMER_L T8L ON T8L.FCUSTID = A.FCUSTID  
        WHERE  
            B.FPRICEUNITQTY <> 0 AND  
            A.FDOCUMENTSTATUS = 'C'
					--and wl.FNUMBER='01.05.0001.01982'		
    ) X  
    WHERE X.XUHAO = 1  
)  

SELECT
	T1.物料编码,
	T1.物料名称,
	T1.规格型号,
	T1.仓库名称,
	T1.车载事业部库存量,
	T1.原第五事业部库存量,
	T1.库存组织,
	T1.基本单位,
    CASE     
        WHEN TEMP2.客户 = '芜湖长信科技股份有限公司' THEN K.FNAME     
        ELSE TEMP2.客户     
    END AS 调整后的客户名称  
FROM TEMP1 t1  
LEFT JOIN KEHU k ON k.FNUMBER = t1.物料编码
LEFT JOIN TEMP2 ON T1.物料编码 = TEMP2.FNUMBER   
WHERE 
t1.物料编码 = '01.05.0001.01982'  AND 
t1.仓库名称 IN ('车载盖板成品库', '车载成品库', '(原)五部成品库')  
AND NOT EXISTS (  
    SELECT 1  
    FROM TEMP2 t2  
    WHERE t1.物料编码 = t2.FNUMBER 
)

-- UNION 
-- SELECT
-- 	T1.物料编码,
-- 	T1.物料名称,
-- 	T1.规格型号,
-- 	T1.仓库名称,
-- 	T1.车载事业部库存量,
-- 	T1.原第五事业部库存量,
-- 	T1.库存组织,
-- 	T1.基本单位,
--     CASE     
--         WHEN TEMP2.客户 = '芜湖长信科技股份有限公司' THEN K.FNAME     
--         ELSE TEMP2.客户     
--     END AS 调整后的客户名称  
-- FROM TEMP1 t1  
-- LEFT JOIN KEHU k ON k.FNUMBER = t1.物料编码
-- LEFT JOIN TEMP2 ON T1.物料编码 = TEMP2.FNUMBER   
-- where t1.仓库名称 IN ('车载盖板成品库', '车载成品库', '(原)五部成品库')
-- and t1.物料编码 = '01.05.0001.01982'

