SELECT   
    m.FNUMBER AS 商品编码,  
    ml.FNAME AS 物料名称,  
    ml.FSPECIFICATION AS 规格型号,  
    a.FPRODUCEDATE AS 生产日期,  
    a.FEXPIRYDATE AS 有效期至,  
    kcztL.FNAME AS 库存状态,  
    baseUnit.FNAME AS 单位,  
    a.FBASEQTY - 0 AS 库存量,  
    CASE   
        WHEN TSUB.FBASELOCKQTY IS NULL THEN a.FBASEQTY   
        ELSE a.FBASEQTY - TSUB.FBASELOCKQTY   
    END AS 可用量,  
    stockL.FName AS 仓库  
FROM   
    T_STK_INVENTORY a   
LEFT JOIN   
    T_BD_LOTMASTER lotStock ON lotStock.FLOTID = a.FLOT   
                            AND lotStock.FMATERIALID = a.FMATERIALID   
                            AND a.FSTOCKORGID = lotStock.FUSEORGID   
LEFT JOIN   
    (  
        SELECT   
            TLKE.FSUPPLYINTERID AS FINVENTRYID,   
            SUM(TLKE.FBASEQTY) AS FBASELOCKQTY,  
            SUM(TLKE.FSECQTY) AS FSECLOCKQTY   
        FROM   
            T_PLN_RESERVELINKENTRY TLKE   
        INNER JOIN   
            T_PLN_RESERVELINK TLKH ON TLKE.FID = TLKH.FID  
        WHERE   
            TLKE.FSUPPLYFORMID = 'STK_Inventory' AND TLKE.FLINKTYPE = '4'  
        GROUP BY   
            TLKE.FSUPPLYINTERID  
    ) TSUB ON a.FID = TSUB.FINVENTRYID  
INNER JOIN   
    T_BD_MATERIAL m ON m.FMATERIALID = a.FMATERIALID  
INNER JOIN   
    T_BD_MATERIAL_L mL ON ml.FMATERIALID = m.FMATERIALID AND ml.FLOCALEID = 2052  
INNER JOIN   
    t_BD_StockStatus kczt ON kczt.FSTOCKSTATUSID = a.FSTOCKSTATUSID  
INNER JOIN   
    T_BD_STOCKSTATUS_L kcztL ON kcztL.FSTOCKSTATUSID = kczt.FSTOCKSTATUSID AND kcztL.FLOCALEID = 2052  
INNER JOIN   
    T_BD_UNIT_L baseUnit ON baseUnit.FUNITID = a.FBASEUNITID AND baseUnit.FLOCALEID = 2052  
INNER JOIN   
    T_BD_Stock_L stockL ON stockL.FSTOCKID = a.FSTOCKID AND stockL.FLOCALEID = 2052  
WHERE   
    a.FBASEQTY > 0;