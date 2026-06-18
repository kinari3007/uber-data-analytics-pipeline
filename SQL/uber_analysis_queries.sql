-- SECTION 1: OVERALL BUSINESS KPIs


-- 1. Get Overall Aggregate Metrics (Total Rides, Revenue, Averages)
SELECT 
    COUNT("Booking ID") AS Total_Rides,
    SUM("Booking Value") AS Total_Revenue,
    ROUND(AVG("Booking Value"), 2) AS Average_Fare,
    ROUND(AVG("Ride Distance"), 2) AS Average_Distance_KM,
    ROUND(AVG("Customer Rating"), 2) AS Average_Customer_Rating
FROM uber_trips;

-- 2. Calculate the total booking value of rides completed successfully
SELECT 
    SUM("Booking Value") AS Total_Successful_Revenue 
FROM uber_trips 
WHERE "Booking Status" = 'Completed';


-- SECTION 2: VEHICLE PERFORMANCE & RATINGS


-- 3. Vehicle Performance: Volume vs. Value (Which drives the most revenue?)
SELECT 
    "Vehicle Type",
    COUNT("Booking ID") AS Total_Rides,
    SUM("Booking Value") AS Total_Revenue,
    ROUND(AVG("Booking Value"), 2) AS Avg_Fare_Per_Ride
FROM uber_trips
GROUP BY "Vehicle Type"
ORDER BY Total_Revenue DESC;

-- 4. Find the average ride distance for each vehicle type
SELECT 
    "Vehicle Type", 
    ROUND(AVG("Ride Distance"), 2) AS Avg_Distance_KM 
FROM uber_trips 
GROUP BY "Vehicle Type"
ORDER BY Avg_Distance_KM DESC;

-- 5. Find the average customer rating per vehicle type
SELECT 
    "Vehicle Type", 
    ROUND(AVG("Customer Rating"), 2) AS Avg_Customer_Rating 
FROM uber_trips 
GROUP BY "Vehicle Type"
ORDER BY Avg_Customer_Rating DESC;

-- 6. Find the maximum and minimum driver ratings for Premier Sedan
SELECT 
    MAX("Driver Ratings") AS Max_Rating, 
    MIN("Driver Ratings") AS Min_Rating 
FROM uber_trips 
WHERE "Vehicle Type" = 'Premier Sedan';


-- SECTION 3: CUSTOMER BEHAVIOR & PAYMENTS


-- 7. Retrieve all successful bookings
SELECT * FROM uber_trips 
WHERE "Booking Status" = 'Completed';

-- 8. List the top 5 customers who booked the highest number of rides
SELECT 
    "Customer ID", 
    COUNT("Booking ID") AS Total_Rides 
FROM uber_trips 
GROUP BY "Customer ID" 
ORDER BY Total_Rides DESC 
LIMIT 5;

-- 9. Payment Method Preferences (Revenue by Payment Type)
SELECT 
    "Payment Method",
    COUNT("Booking ID") AS Total_Transactions,
    SUM("Booking Value") AS Total_Revenue
FROM uber_trips
WHERE "Payment Method" IS NOT NULL
GROUP BY "Payment Method"
ORDER BY Total_Transactions DESC;

-- 10. Retrieve all rides where payment was made using UPI
SELECT * FROM uber_trips 
WHERE "Payment Method" = 'UPI';


-- SECTION 4: CANCELLATIONS & BOTTLENECKS


-- 11. Cancellation breakdown by WHO cancelled (Percentage of Total)
SELECT 
    "Booking Status",
    COUNT("Booking ID") AS Ride_Count,
    ROUND(COUNT("Booking ID") * 100.0 / (SELECT COUNT(*) FROM uber_trips), 2) AS Percentage_of_Total
FROM uber_trips
GROUP BY "Booking Status"
ORDER BY Ride_Count DESC;

-- 12. Get the total number of cancelled rides by customers specifically
SELECT 
    COUNT(*) AS Total_Customer_Cancellations 
FROM uber_trips 
WHERE "Booking Status" = 'Cancelled by Customer';

-- 13. Top overall reasons for Driver Cancellations
SELECT 
    "Driver Cancellation Reason",
    COUNT("Booking ID") AS Total_Cancellations
FROM uber_trips
WHERE "Booking Status" = 'Cancelled by Driver'
  AND "Driver Cancellation Reason" IS NOT NULL
GROUP BY "Driver Cancellation Reason"
ORDER BY Total_Cancellations DESC;

-- 14. Get the number of rides cancelled by drivers due to personal and car-related issues
SELECT 
    COUNT(*) AS Driver_Cancelled_Personal_Issues 
FROM uber_trips 
WHERE "Booking Status" = 'Cancelled by Driver' 
  AND "Driver Cancellation Reason" = 'Personal & Car related issues';

-- 15. List all incomplete rides along with the exact reason
SELECT 
    "Booking ID", 
    "Incomplete Rides Reason" 
FROM uber_trips 
WHERE "Booking Status" = 'Incomplete';


-- SECTION 5: GEOSPATIAL & TEMPORAL ANALYSIS


-- 16. Geospatial Hotspots: Top 10 Busiest Pickup Locations
SELECT 
    "Pickup Location",
    COUNT("Booking ID") AS Total_Pickups,
    SUM("Booking Value") AS Total_Revenue_Generated
FROM uber_trips
GROUP BY "Pickup Location"
ORDER BY Total_Pickups DESC
LIMIT 10; 

-- 17. Surge Pricing & Peak Hours: Average fare and volume by hour of the day
SELECT 
    EXTRACT(HOUR FROM "Time") AS Hour_of_Day,
    COUNT("Booking ID") AS Ride_Volume,
    ROUND(AVG("Booking Value"), 2) AS Average_Fare
FROM uber_trips
GROUP BY EXTRACT(HOUR FROM "Time")
ORDER BY Hour_of_Day ASC;