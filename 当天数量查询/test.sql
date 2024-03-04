
SET${DATETIMES}
SELECT subquery.FNAME,SUM(总数量) AS 总和 FROM (
    SELECT
        B.FNUMBER,
        C.FNAME,
        F_STYZ_Qty14,
        A.F_STYZ_YUE,
         CASE
            WHEN DAY('${DATETIMES}') = 1 THEN F_STYZ_Qty
            WHEN DAY('${DATETIMES}') = 2 THEN F_STYZ_Qty1
            WHEN DAY('${DATETIMES}') = 3 THEN F_STYZ_Qty2
            WHEN DAY('${DATETIMES}') = 4 THEN F_STYZ_Qty3
            WHEN DAY('${DATETIMES}') = 5 THEN F_STYZ_Qty4
            WHEN DAY('${DATETIMES}') = 6 THEN F_STYZ_Qty5
            WHEN DAY('${DATETIMES}') = 7 THEN F_STYZ_Qty6
            WHEN DAY('${DATETIMES}') = 8 THEN F_STYZ_Qty7
            WHEN DAY('${DATETIMES}') = 9 THEN F_STYZ_Qty8
            WHEN DAY('${DATETIMES}') = 10 THEN F_STYZ_Qty9
            WHEN DAY('${DATETIMES}') = 11 THEN F_STYZ_Qty10
            WHEN DAY('${DATETIMES}') = 12 THEN F_STYZ_Qty11
            WHEN DAY('${DATETIMES}') = 13 THEN F_STYZ_Qty12
            WHEN DAY('${DATETIMES}') = 14 THEN F_STYZ_Qty13
            WHEN DAY('${DATETIMES}') = 15 THEN F_STYZ_Qty14
            WHEN DAY('${DATETIMES}') = 16 THEN F_STYZ_Qty15
            WHEN DAY('${DATETIMES}') = 17 THEN F_STYZ_Qty16
            WHEN DAY('${DATETIMES}') = 18 THEN F_STYZ_Qty17
            WHEN DAY('${DATETIMES}') = 19 THEN F_STYZ_Qty18
            WHEN DAY('${DATETIMES}') = 20 THEN F_STYZ_Qty19
            WHEN DAY('${DATETIMES}') = 21 THEN F_STYZ_Qty20
            WHEN DAY('${DATETIMES}') = 22 THEN F_STYZ_Qty21
            WHEN DAY('${DATETIMES}') = 23 THEN F_STYZ_Qty22
            WHEN DAY('${DATETIMES}') = 24 THEN F_STYZ_Qty23
            WHEN DAY('${DATETIMES}') = 25 THEN F_STYZ_Qty24
            WHEN DAY('${DATETIMES}') = 26 THEN F_STYZ_Qty25
            WHEN DAY('${DATETIMES}') = 27 THEN F_STYZ_Qty26
            WHEN DAY('${DATETIMES}') = 28 THEN F_STYZ_Qty27
            WHEN DAY('${DATETIMES}') = 29 THEN F_STYZ_Qty28
            WHEN DAY('${DATETIMES}') = 30 THEN F_STYZ_Qty29
            WHEN DAY('${DATETIMES}') = 31 THEN F_STYZ_Qty30
        END AS 总数量
    FROM
        STYZ_t_Cust_Entry100125 A
        LEFT JOIN STYZ_t_Cust100104 B ON A.FID = B.FID
        LEFT JOIN T_ORG_ORGANIZATIONS_L C ON C.FORGID = B.FUSEORGID
    WHERE
        MONTH(A.F_STYZ_YUE) = MONTH('${DATETIMES}')
        AND YEAR(A.F_STYZ_YUE) = YEAR('${DATETIMES}')

) AS subquery
group by subquery.FNAME;
