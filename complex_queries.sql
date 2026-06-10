-- Complex SQL Queries

-- 1. Hotel Revenue
SELECT h.name AS hotel_name,
       SUM(p.amount) AS total_revenue
FROM hotel h
JOIN room r ON h.hotel_id = r.hotel_id
JOIN reservation_room rr ON r.room_id = rr.room_id
JOIN payment p ON rr.reservation_id = p.reservation_id
GROUP BY h.name;

-- 2. Guests staying more than 3 days
SELECT g.name, r.checkin_date, r.checkout_date
FROM reservation r
JOIN guest g ON r.guest_id = g.guest_id
WHERE (r.checkout_date - r.checkin_date) > 3;

-- 3. Hotels with no reservations
SELECT h.name
FROM hotel h
WHERE NOT EXISTS (
    SELECT 1
    FROM room r
    JOIN reservation_room rr ON r.room_id = rr.room_id
    WHERE r.hotel_id = h.hotel_id
);

-- 4. Top 5 highest-paying guests
SELECT *
FROM (
    SELECT g.name,
           SUM(p.amount) AS total_paid
    FROM guest g
    JOIN reservation r ON g.guest_id = r.guest_id
    JOIN payment p ON r.reservation_id = p.reservation_id
    GROUP BY g.name
    ORDER BY total_paid DESC
)
WHERE ROWNUM <= 5;


-- 5. Total services per staff member
SELECT s.name AS staff_name,
       COUNT(sr.service_record_id) AS total_services
FROM staff s
LEFT JOIN service_record sr ON s.staff_id = sr.staff_id
GROUP BY s.name
ORDER BY total_services DESC;

-- 6. Rooms never reserved
SELECT r.room_id, r.status
FROM room r
LEFT JOIN reservation_room rr ON r.room_id = rr.room_id
WHERE rr.room_id IS NULL;

-- 7. Total revenue per service
SELECT s.name AS service_name,
       SUM(sr.quantity * s.service_charge) AS total_service_revenue
FROM service s
JOIN service_record sr ON s.service_id = sr.service_id
GROUP BY s.name
ORDER BY total_service_revenue DESC;

-- 8. Guests with no payments
SELECT g.name
FROM guest g
WHERE g.guest_id NOT IN (
    SELECT r.guest_id
    FROM reservation r
    JOIN payment p ON r.reservation_id = p.reservation_id
);

-- 9. Most expensive room type per hotel
SELECT h.name AS hotel,
       rt.name AS room_type,
       rt.rate
FROM hotel h
JOIN room r ON h.hotel_id = r.hotel_id
JOIN room_type rt ON r.room_type_id = rt.room_type_id
WHERE rt.rate = (
    SELECT MAX(rt2.rate)
    FROM room r2
    JOIN room_type rt2 ON r2.room_type_id = rt2.room_type_id
    WHERE r2.hotel_id = h.hotel_id
);

-- 10. Reservations per room type
SELECT rt.name AS room_type,
       COUNT(rr.reservation_id) AS total_reservations
FROM room_type rt
JOIN room r ON rt.room_type_id = r.room_type_id
JOIN reservation_room rr ON r.room_id = rr.room_id
GROUP BY rt.name;

-- 11. Payments above average
SELECT r.reservation_id, g.name, p.amount
FROM reservation r
JOIN guest g ON r.guest_id = g.guest_id
JOIN payment p ON r.reservation_id = p.reservation_id
WHERE p.amount > (SELECT AVG(amount) FROM payment);

-- 12. Staff with > 2 service records
SELECT s.name,
       COUNT(sr.service_record_id) AS total_services
FROM staff s
JOIN service_record sr ON s.staff_id = sr.staff_id
GROUP BY s.name
HAVING COUNT(sr.service_record_id) > 2;

-- 13. Most frequently used service
SELECT service_name, total_usage
FROM (
    SELECT s.name AS service_name,
           SUM(sr.quantity) AS total_usage,
           RANK() OVER (ORDER BY SUM(sr.quantity) DESC) AS rnk
    FROM service s
    JOIN service_record sr ON s.service_id = sr.service_id
    GROUP BY s.name
)
WHERE rnk = 1;

-- 14. Guests who booked in more than one hotel
SELECT g.name, COUNT(DISTINCT h.hotel_id) AS hotel_count
FROM guest g
JOIN reservation r ON g.guest_id = r.guest_id
JOIN reservation_room rr ON r.reservation_id = rr.reservation_id
JOIN room room ON rr.room_id = room.room_id
JOIN hotel h ON room.hotel_id = h.hotel_id
GROUP BY g.name
HAVING COUNT(DISTINCT h.hotel_id) > 1;

-- 15. Guests who booked but never used services
(
    SELECT g.guest_id, g.name
    FROM guest g
    JOIN reservation r ON g.guest_id = r.guest_id
)
MINUS
(
    SELECT g2.guest_id, g2.name
    FROM guest g2
    JOIN reservation r2 ON g2.guest_id = r2.guest_id
    JOIN service_record sr ON sr.reservation_id = r2.reservation_id
);

--16 Find reservation with highest total service cost (analytic function)
SELECT reservation_id, total_service_cost
FROM (
    SELECT sr.reservation_id,
           SUM(sr.quantity * s.service_charge) AS total_service_cost,
           RANK() OVER (ORDER BY SUM(sr.quantity * s.service_charge) DESC) AS rnk
    FROM service_record sr
    JOIN service s ON sr.service_id = s.service_id
    GROUP BY sr.reservation_id
)
WHERE rnk = 1;


--17 Who performed the most services in Correlated Subquery — Find staff wtheir hotel
SELECT s.staff_id, s.name, s.hotel_id
FROM staff s
WHERE (
    SELECT COUNT(*)
    FROM service_record sr
    WHERE sr.staff_id = s.staff_id
) = (
    SELECT MAX(COUNT(*))
    FROM staff s2
    JOIN service_record sr2 ON s2.staff_id = sr2.staff_id
    WHERE s2.hotel_id = s.hotel_id
    GROUP BY s2.staff_id
);


