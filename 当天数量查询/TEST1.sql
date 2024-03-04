

SELECT subquery.FNAME,SUM(总数量) AS 总和 FROM (
    SELECT
        B.FNUMBER,
        C.FNAME,
        F_STYZ_Qty14,
        A.F_STYZ_YUE,
         CASE
            WHEN DAY('2024-3-15') = 1 THEN F_STYZ_Qty
            WHEN DAY('2024-3-15') = 2 THEN F_STYZ_Qty1
            WHEN DAY('2024-3-15') = 3 THEN F_STYZ_Qty2
            WHEN DAY('2024-3-15') = 4 THEN F_STYZ_Qty3
            WHEN DAY('2024-3-15') = 5 THEN F_STYZ_Qty4
            WHEN DAY('2024-3-15') = 6 THEN F_STYZ_Qty5
            WHEN DAY('2024-3-15') = 7 THEN F_STYZ_Qty6
            WHEN DAY('2024-3-15') = 8 THEN F_STYZ_Qty7
            WHEN DAY('2024-3-15') = 9 THEN F_STYZ_Qty8
            WHEN DAY('2024-3-15') = 10 THEN F_STYZ_Qty9
            WHEN DAY('2024-3-15') = 11 THEN F_STYZ_Qty10
            WHEN DAY('2024-3-15') = 12 THEN F_STYZ_Qty11
            WHEN DAY('2024-3-15') = 13 THEN F_STYZ_Qty12
            WHEN DAY('2024-3-15') = 14 THEN F_STYZ_Qty13
            WHEN DAY('2024-3-15') = 15 THEN F_STYZ_Qty14
            WHEN DAY('2024-3-15') = 16 THEN F_STYZ_Qty15
            WHEN DAY('2024-3-15') = 17 THEN F_STYZ_Qty16
            WHEN DAY('2024-3-15') = 18 THEN F_STYZ_Qty17
            WHEN DAY('2024-3-15') = 19 THEN F_STYZ_Qty18
            WHEN DAY('2024-3-15') = 20 THEN F_STYZ_Qty19
            WHEN DAY('2024-3-15') = 21 THEN F_STYZ_Qty20
            WHEN DAY('2024-3-15') = 22 THEN F_STYZ_Qty21
            WHEN DAY('2024-3-15') = 23 THEN F_STYZ_Qty22
            WHEN DAY('2024-3-15') = 24 THEN F_STYZ_Qty23
            WHEN DAY('2024-3-15') = 25 THEN F_STYZ_Qty24
            WHEN DAY('2024-3-15') = 26 THEN F_STYZ_Qty25
            WHEN DAY('2024-3-15') = 27 THEN F_STYZ_Qty26
            WHEN DAY('2024-3-15') = 28 THEN F_STYZ_Qty27
            WHEN DAY('2024-3-15') = 29 THEN F_STYZ_Qty28
            WHEN DAY('2024-3-15') = 30 THEN F_STYZ_Qty29
            WHEN DAY('2024-3-15') = 31 THEN F_STYZ_Qty30
        END AS 总数量
    FROM
        STYZ_t_Cust_Entry100125 A
        LEFT JOIN STYZ_t_Cust100104 B ON A.FID = B.FID
        LEFT JOIN T_ORG_ORGANIZATIONS_L C ON C.FORGID = B.FUSEORGID
    WHERE
        MONTH(A.F_STYZ_YUE) = 3
        AND YEAR(A.F_STYZ_YUE) = 2024

) AS subquery
group by subquery.FNAME;
