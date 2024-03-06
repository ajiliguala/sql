SELECT KH.FNAME                                                       AS 客户,
       WL.FNUMBER                                                     AS 物料代码,
       WL.FNAME                                                       AS 物料名称,
       T.[日期],
       T.QTY                                                          AS 数量,
       T.F_STYZ_PRICE                                                 AS 单价,
--T.FMATERIALID,
--T.FSETTLECURRID,
       BB.FNAME,
       CASE WHEN T.FSETTLECURRID = 1 THEN 1 ELSE HL.FEXCHANGERATE END AS 汇率,
       CASE
           WHEN T.FSETTLECURRID = 1 THEN T.QTY * T.F_STYZ_PRICE / 10000
           ELSE T.QTY * T.F_STYZ_PRICE * HL.FEXCHANGERATE / 10000 END AS 金额

FROM (SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY                                        AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 1 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY1                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码


      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 2 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY2                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 3 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY3                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 4 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY4                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 5 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY5                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 6 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY6                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 7 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY7                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 8 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY8                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 9 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY9                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 10 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY10                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 11 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY11                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 12 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY12                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 13 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY13                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 14 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY14                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 15 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY15                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 16 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY16                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 17 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY17                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 18 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY18                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 19 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY19                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 20 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY20                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 21 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY21                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 22 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY22                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 23 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY23                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 24 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY24                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 25 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY25                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 26 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY26                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 27 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY27                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 28 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY28                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 29 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY29                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码

      UNION ALL
      SELECT A.FUSEORGID,
             B.F_STYZ_KH,
             B.F_STYZ_JHY,
             B.F_STYZ_XSY,
             DATEADD(MONTH, DATEDIFF(MONTH, 0, B.F_STYZ_YUE), 0) + 30 AS 日期,
             B.FMATERIALID,
             B.FSETTLECURRID,
             B.FEXCHANGERATE2,
             B.F_STYZ_PRICE,
             B.F_STYZ_QTY30                                           AS QTY
      FROM STYZ_t_Cust100104 A
               INNER JOIN STYZ_t_Cust_Entry100125 B ON A.FID = B.FID
      WHERE A.FUSEORGID = 1915285 -----这是车载事业部的内码
     ) T
         INNER JOIN (SELECT A.FMATERIALID, A.FNUMBER, B.FNAME
                     FROM T_BD_MATERIAL A
                              INNER JOIN T_BD_MATERIAL_L B ON A.FMATERIALID = B.FMATERIALID
                     WHERE B.FLOCALEID = 2052) WL ON T.FMATERIALID = WL.FMATERIALID
         INNER JOIN (SELECT *FROM T_BD_CUSTOMER_L A WHERE A.FLOCALEID = 2052) KH ON T.F_STYZ_KH = KH.FCUSTID
         INNER JOIN (SELECT * FROM T_BD_CURRENCY_L A WHERE A.FLOCALEID = 2052) BB ON T.FSETTLECURRID = BB.FCURRENCYID
         LEFT JOIN (SELECT *
                    FROM (SELECT ROW_NUMBER() OVER (PARTITION BY A.FCYFORID ORDER BY A.FBEGDATE DESC) AS XUHAO,
                                 A.FCYFORID,
                                 A.FBEGDATE,
                                 A.FEXCHANGERATE
                          FROM T_BD_Rate A) T
                    WHERE T.XUHAO = 1) HL ON HL.FCYFORID = T.FSETTLECURRID
WHERE
   T.QTY <> 0
  AND T.[日期] >= CASE
    WHEN DAY (GETDATE()) = 1 THEN DATEADD(MONTH
    , DATEDIFF(MONTH
    , 0
    , GETDATE()) - 1
    , 0)
ELSE
DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) END
AND T.[日期] < CASE
                     WHEN DAY(GETDATE()) = 1 THEN DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
ELSE DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0) END
ORDER BY T.[日期]