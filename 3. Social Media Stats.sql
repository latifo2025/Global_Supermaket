/* Script below calculates most effective method of advertising by country
Two Common table expressions (CTE) are used to count successful channels by country and then unpivot the data
The main outer query only shows the social media channels ranked first by country */
WITH 		Advertising_Method AS
(SELECT 	m."Country", SUM("Twitter_ad") AS Twitter, 
			SUM("Instagram_ad") AS Instagram, SUM("Facebook_ad") AS Facebook
FROM		ad_data_cleaned a
INNER JOIN	marketing_data_cleaned m
ON			a."ID" = m."ID"
GROUP BY 	m."Country"),
--CTE below unpivots the advertising channel columns to work out which is the most popular by country
Unpivot AS
(SELECT 	a."Country", ad.*, 
			DENSE_RANK() OVER(PARTITION BY a."Country" 
			ORDER BY Lead_Conversions DESC) AS Ranking
FROM 		Advertising_Method a
CROSS JOIN LATERAL (
VALUES 
       		(a.Twitter, 'Twitter'),
       		(a.Instagram, 'Instagram'),
       		(a.Facebook, 'Facebook')) AS ad(Lead_Conversions, Channel))
SELECT 		"Country", Lead_Conversions, Channel
FROM 		Unpivot
WHERE		Ranking = 1;


/* Script below calculates most effective method of advertising by marital status
Two Common table expressions (CTE) are used to count successful channels by marital status and then unpivot the data
The main outer query only shows the social media channels ranked first by marital status */
WITH 		Advertising_Method AS
(SELECT 	CASE WHEN m."Marital_Status" IN ('Absurd', 'Alone', 'YOLO')
			THEN 'Other' 
			ELSE "Marital_Status"  END "Marital_Status", 
			SUM("Twitter_ad") AS Twitter, SUM("Instagram_ad") AS Instagram, 
			SUM("Facebook_ad") AS Facebook
FROM		ad_data_cleaned a
INNER JOIN	marketing_data_cleaned m
ON			a."ID" = m."ID"
GROUP BY 	m."Marital_Status"),
--CTE below unpivots the advertising channel columns to work out which is the most popular by marital status
Unpivot AS
(SELECT 	a."Marital_Status", ad.*, 
			DENSE_RANK() OVER(PARTITION BY a."Marital_Status" 
			ORDER BY Lead_Conversions DESC) AS Ranking
FROM 		Advertising_Method a
CROSS JOIN LATERAL (
VALUES 
       		(a.Twitter, 'Twitter'),
       		(a.Instagram, 'Instagram'),
       		(a.Facebook, 'Facebook')) AS ad(Lead_Conversions, Channel))
SELECT 		"Marital_Status", Lead_Conversions, Channel
FROM 		Unpivot
WHERE		Ranking = 1;

