SELECT   
    T3.FNUMBER AS ���ϱ���,  
    T3L.FNAME AS ��������,  
    T3L.FSPECIFICATION AS ����ͺ�,  
    T2L.FNAME AS �ֿ�����,  
    T6L.FNUMBER AS ����,  
    SUM(T1.FBASEQTY) AS '�����(������λ)', -- ʹ��SUM�����Կ���������ۼ�  
    T5L.FNAME AS ������λ,  
    t7l.FNAME AS �����֯,  
    t3.FMNEMONICCODE AS ������,  
    t3.FOLDNUMBERGZ AS '�����ϱ��루���ݣ�',  
    t8l.FNAME AS �ͻ�  
FROM   
    T_STK_INVENTORY t1  
INNER JOIN t_BD_Stock T2 ON T1.FSTOCKID = T2.FSTOCKID  
INNER JOIN t_BD_Stock_l T2L ON T1.FSTOCKID = T2L.FSTOCKID AND T2L.FLOCALEID = 2052   
INNER JOIN T_BD_MATERIAL T3 ON T1.FMaterialId = T3.FMasterId AND T1.FSTOCKORGID = T3.FUSEORGID  
INNER JOIN T_BD_MATERIAL_L T3L ON T3.FMaterialId = T3L.FMaterialId AND T3L.FLOCALEID = 2052   
INNER JOIN T_BD_UNIT_L T5L ON T5L.FUNITID = t1.FBASEUNITID AND T5L.FLOCALEID = 2052   
LEFT JOIN T_BD_LOTMASTER T6L ON T6L.FLOTID = T1.FLOT    
INNER JOIN T_ORG_ORGANIZATIONS_L t7l ON t7l.FORGID = t1.FSTOCKORGID  
LEFT JOIN t_Sal_CustMatMappingEntry t7c ON t7c.FMATERIALID = t3.FMATERIALID  
LEFT JOIN t_Sal_CustMatMapping t8 ON t8.FID = t7c.FID  
LEFT JOIN T_BD_CUSTOMER_l t8l ON t8l.FCUSTID = t8.FCUSTOMERID   
WHERE   
    T1.FBASEQTY <> 0 AND  
    t7l.FNAME IN ('ԭ������ҵ��', '������ҵ��') 
		--AND T3.FNUMBER = '03.01.1003.00006'  
GROUP BY   
    T3.FNUMBER, -- ������Ҫ������ֶ�  
    T3L.FNAME,   
    T3L.FSPECIFICATION,   
    T2L.FNAME,   
    T6L.FNUMBER,   
    T5L.FNAME,   
    t7l.FNAME,   
    t3.FMNEMONICCODE,   
    t3.FOLDNUMBERGZ,   
    t8l.FNAME -- ע�������г�������SELECT�Ӿ��е��ֶΣ����˱�SUM�ۺϵ��ֶ�'�����(������λ)'  
;