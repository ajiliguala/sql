-- SELECT
-- 				AA.FNUMBER,
-- 				AA.FMATERIALID,
-- 				AA.FMODIFYDATE,
-- 				AA.rnk,
-- 				AA.FORGID
-- 				FROM
-- 				(SELECT
-- 				B.FMATERIALID,
-- 				A.FNUMBER,
-- 				A.FMODIFYDATE,
-- 				D.FORGID,
-- 				ROW_NUMBER ( ) OVER ( PARTITION BY B.FNUMBER ORDER BY A.FMODIFYDATE DESC ) AS rnk
-- 				FROM T_ENG_BOM A
-- 				LEFT JOIN T_BD_MATERIAL B ON A.FMATERIALID= B.FMATERIALID
-- 				LEFT JOIN T_ORG_ORGANIZATIONS_L D ON A.FUSEORGID= D.FORGID
-- 				WHERE D.FORGID='1915285'
-- 				AND B.FMATERIALID='3669015'
-- 				)AA
-- 			WHERE AA.rnk=1
SELECT  * FROM T_SAL_ORDERFIN
SELECT  * FROM T_BD_MATERIAL