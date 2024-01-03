--Question 1
--How many accidents have occured in urban areas versus rural areas?

SELECT Area,COUNT(AccidentIndex) AS 'Total Accident'
FROM ACCIDENT
GROUP BY Area

--Question 2
--Which day of the week has the highest number of accidents?

SELECT Day,COUNT(AccidentIndex) AS 'Total Accident'
FROM ACCIDENT
GROUP BY Day
ORDER BY 'Total Accident' DESC

--Question 3
--What is the average age of vehicle involved in accidents based on their type?

SELECT VehicleType,AVG(AgeVehicle) AS 'Age Vehicle'
FROM VEHICLE
WHERE AgeVehicle IS NOT NULL
GROUP BY VehicleType

--Question 4
--Can we identify any trends in accidents based on the age of vehicles involved?

SELECT AgeVehicleGroup,COUNT(AccidentIndex) AS 'Total Accident',AVG(AgeVehicle) AS 'Average Year'
FROM(
	SELECT AgeVehicle,AccidentIndex,
		CASE
			WHEN AgeVehicle BETWEEN 0 AND 5 THEN 'New'
			WHEN AgeVehicle BETWEEN 6 AND 10 THEN 'Middle'			
			ELSE 'Old'
		END AS AgeVehicleGroup
	FROM VEHICLE
	WHERE AgeVehicle IS NOT NULL
) as SUBQUERY
GROUP BY AgeVehicleGroup

--Question 5
--Are there any specific weather conditions that contribute to severe accidents?

DECLARE @Severity varchar(100)
SET @Severity = 'Fatal'    --Slight,Serious,Fatal

SELECT WeatherConditions,COUNT(AccidentIndex) AS 'Total Accidents'
FROM ACCIDENT
WHERE Severity=@Severity
GROUP BY WeatherConditions
ORDER BY 'Total Accidents'

--Question 6
--Do accidents often involve impacts on the left hand side of vehicles?

SELECT LeftHand,COUNT(AccidentIndex) AS 'Total Accident'
FROM VEHICLE
WHERE LeftHand IS NOT NULL
GROUP BY LeftHand

--Question 7
--Are there any relationships between journey purposes and the severity of accidents?

SELECT JourneyPurpose,COUNT(Severity) AS 'Total Accident'
FROM VEHICLE V INNER JOIN ACCIDENT A
	ON V.AccidentIndex=A.AccidentIndex
GROUP BY JourneyPurpose
ORDER BY 'Total Accident' DESC

--Question 8
--Calculate the average age of vehicles involved in accidents, considering day light and Point of impact.

SELECT A.LightConditions,V.PointImpact,AVG(V.AgeVehicle) 'Average Year'
FROM VEHICLE V INNER JOIN ACCIDENT A ON 
	V.AccidentIndex=A.AccidentIndex
WHERE AgeVehicle IS NOT NULL
GROUP BY LightConditions,PointImpact 
ORDER BY LightConditions DESC
