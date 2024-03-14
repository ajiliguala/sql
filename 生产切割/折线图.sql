SELECT
    ISNULL(实收.年份, 实发.年份) AS 年份,
    ISNULL(实收.月, 实发.月) AS 月,
    CONCAT(ISNULL(实收.年份, 实发.年份), '-', ISNULL(实收.月, 实发.月)) AS 年月,
    实收.汇总实收数量,
    实发.汇总实发数量,
    实发.汇总实发数量/实收.汇总实收数量 AS 产出比,
    ISNULL(实收.FNAME, 实发.FNAME) AS FNAME
FROM
    (
        SELECT
            YEAR(B.FDATE) AS 年份,
            MONTH(B.FDATE) AS 月,
            SUM(A.FREALQTY * D.F_MJM2) AS 汇总实收数量,
            E.FNAME
        FROM
            T_PRD_INSTOCKENTRY A
            LEFT JOIN T_PRD_INSTOCK B ON B.FID = A.FID
            LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = B.FWORKSHOPID
            LEFT JOIN T_BD_MATERIAL D ON A.FMATERIALID = D.FMATERIALID
        WHERE
            B.FPRDORGID = '100329'
            AND B.FDATE >= DATEADD(MONTH, -5, CONVERT(DATE, GETDATE()))
            AND B.FDATE < CONVERT(DATE, GETDATE())
        AND E.FNAME NOT IN ('一部AF车间', '一部G6化强车间', '一部G6切割车间','一部AR镀膜车间')
        GROUP BY
            E.FNAME, YEAR(B.FDATE), MONTH(B.FDATE)
    ) AS 实收
    FULL JOIN
    (
        SELECT
            YEAR(B.FDATE) AS 年份,
            MONTH(B.FDATE) AS 月,
            SUM(A.FACTUALQTY * D.F_MJM2) AS 汇总实发数量,
            E.FNAME
        FROM
            T_PRD_PICKMTRLDATA A
            LEFT JOIN T_PRD_PICKMTRL B ON B.FID = A.FID
            LEFT JOIN T_BD_DEPARTMENT_L E ON E.FDEPTID = B.FWORKSHOPID
            LEFT JOIN T_BD_MATERIAL D ON A.FMATERIALID = D.FMATERIALID
        WHERE
            B.FPRDORGID = '100329'
            AND B.FDATE >= DATEADD(MONTH, -5, CONVERT(DATE, GETDATE()))
            AND B.FDATE < CONVERT(DATE, GETDATE())
        AND E.FNAME NOT IN ('一部AF车间', '一部G6化强车间', '一部G6切割车间','一部AR镀膜车间')
        GROUP BY
            E.FNAME, YEAR(B.FDATE), MONTH(B.FDATE)
    ) AS 实发
    ON 实收.年份 = 实发.年份 AND 实收.月 = 实发.月 AND 实收.FNAME = 实发.FNAME
ORDER BY
    年份, 月, FNAME;
