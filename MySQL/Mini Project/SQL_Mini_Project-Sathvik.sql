# Instructions:
# 1.	Create these tables in the database by running the database script provided
# 2.	The script also has statements to insert appropriate data into all these tables
# 3.	Test the successful execution of the script by selecting some rows from few tables
# 4.	Clearly understand the structure of each table and relationships among them
# 5.	Insert / update appropriate rows into relevant tables if you need to get more rows in the output to verify your answers

USE IPL;

# 1.Show the percentage of wins of each bidder in the order of highest to lowest percentage.

SELECT 
    BIDDER_ID,
    (COUNT(BID_STATUS) / (SELECT 
            COUNT(BID_STATUS)
        FROM
            IPL_BIDDING_DETAILS I
        WHERE
            I.BIDDER_ID = O.BIDDER_ID
        GROUP BY BIDDER_ID)) * 100 AS WIN_PERCENTAGE # (WIN_SUM/TOT_SUM)*100
FROM
    IPL_BIDDING_DETAILS O
WHERE
    UPPER(BID_STATUS) = 'WON' # COUNTED THE NUMBER OF WINS FOR THE SAME BIDDER GROUPING IT TOGETHER
GROUP BY BIDDER_ID
ORDER BY WIN_PERCENTAGE DESC;
# 2.Which teams have got the highest and the lowest no. of bids?

SELECT 
    IBD.BID_TEAM, T.TEAM_NAME, COUNT(IBD.BID_TEAM) AS NO_OF_BIDS
FROM
    IPL_BIDDING_DETAILS IBD
        INNER JOIN
    IPL_TEAM T ON T.TEAM_ID = IBD.BID_TEAM
GROUP BY BID_TEAM
HAVING NO_OF_BIDS IN (SELECT 
        MAX(TOTAL_BIDS) AS COUNT
    FROM
        (SELECT 
            COUNT(*) AS TOTAL_BIDS
        FROM
            IPL_BIDDING_DETAILS
        GROUP BY BID_TEAM) AS T UNION ALL SELECT 
        MIN(TOTAL_BIDS) AS COUNT
    FROM
        (SELECT 
            COUNT(*) AS TOTAL_BIDS
        FROM
            IPL_BIDDING_DETAILS
        GROUP BY BID_TEAM) AS T)
ORDER BY NO_OF_BIDS DESC;


# 3.In a given stadium, what is the percentage of wins by a team which had won the toss?

SELECT 
    A.STADIUM_ID,
    B.STADIUM_NAME,
    B.CITY,
    COUNT(A.MATCH_ID) AS TOTAL_MATCHES,
    TOSS_WIN_MATCH_WIN,
    ROUND((TOSS_WIN_MATCH_WIN / COUNT(A.MATCH_ID) * 100),
            2) AS WIN_PERCENTAGE
FROM
    IPL_MATCH_SCHEDULE A
        JOIN
    IPL_STADIUM B ON A.STADIUM_ID = B.STADIUM_ID
        JOIN
    IPL_MATCH C ON C.MATCH_ID = A.MATCH_ID
        JOIN
    (SELECT 
        F.STADIUM_ID, COUNT(F.MATCH_ID) AS TOSS_WIN_MATCH_WIN
    FROM
        IPL_MATCH E
    JOIN IPL_MATCH_SCHEDULE F ON F.MATCH_ID = E.MATCH_ID
    WHERE
        TOSS_WINNER = MATCH_WINNER
    GROUP BY STADIUM_ID) G ON G.STADIUM_ID = B.STADIUM_ID
GROUP BY STADIUM_ID , TOSS_WIN_MATCH_WIN
ORDER BY WIN_PERCENTAGE DESC;


# 4.What is the total no. of bids placed on the team that has won highest no. of matches?

SELECT 
    TEAM_ID,
    TEAM_NAME,
    MATCHES_WON,
    COUNT(BIDDER_ID) AS NO_OF_BIDS
FROM
    IPL_TEAM
        JOIN
    IPL_TEAM_STANDINGS USING (TEAM_ID)
        JOIN
    IPL_BIDDING_DETAILS ON BID_TEAM = TEAM_ID
GROUP BY TEAM_ID , MATCHES_WON
ORDER BY MATCHES_WON DESC
LIMIT 1;

# 5.From the current team standings, if a bidder places a bid on which of the teams, 
# there is a possibility of (s)he winning the highest no. of points – in simple words, 
# identify the team which has the highest jump in its total points (in terms of percentage) 
# from the previous year to current year.

SELECT 
    ITS0.TEAM_ID, IT.TEAM_NAME,
    (((SELECT 
            MATCHES_WON
        FROM
            IPL_TEAM_STANDINGS ITS1
        WHERE
            ITS0.TEAM_ID = ITS1.TEAM_ID
                AND TOURNMT_ID = '2018') - (SELECT 
            MATCHES_WON
        FROM
            IPL_TEAM_STANDINGS ITS2
        WHERE
            ITS0.TEAM_ID = ITS2.TEAM_ID
                AND TOURNMT_ID = '2017')) / 14) * 100 AS JUMP_PERCENTAGE
FROM
    IPL_TEAM_STANDINGS ITS0
JOIN IPL_TEAM IT
ON IT.TEAM_ID=ITS0.TEAM_ID
GROUP BY TEAM_ID
ORDER BY JUMP_PERCENTAGE DESC
LIMIT 1;