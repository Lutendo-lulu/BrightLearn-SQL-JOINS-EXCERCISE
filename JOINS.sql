-- Databricks notebook source
--Q1:Show every user who has a subscription. Match users to subscriptions
SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM database.default.users u
INNER JOIN database.schema.subscriptions s ON u.user_id = s.user_id; 

--Q2:Show every subscription with its matching plan name and monthly price 
SELECT
    s.subscription_id,
    s.user_id,
    p.plan_name,
    p.monthly_price
FROM  database.schema.subscriptions s 
INNER JOIN database.schema.plans p ON s.plan_id = p.plan_id; 

--Q3:Show every viewing session that has a matching show. Include the show title and genre
SELECT
    vs.session_id,
    vs.user_id,
    sh.show_title,
    sh.genre,
    vs.watch_minutes
FROM database.schema.viewing_sessions vs
INNER JOIN database.schema.shows sh ON vs.show_id = sh.show_id; 

--Q4:Show every viewing session with the user who watched it. Only show sessions with a matching user
SELECT
    u.user_name,
    u.country,
    vs.session_id,
    vs.show_id,
    vs.watch_minutes
FROM database.default.users u
INNER JOIN  database.schema.viewing_sessions vs ON u.user_id = vs.user_id; 

--Q5:Show users along with their subscriptions, the plan name, and the price. Use only users who have both a subscription and a valid plan 
SELECT
    u.user_name,
    u.country,
    p.plan_name,
    p.monthly_price,
    s.start_date
FROM database.default.users u
INNER JOIN database.schema.subscriptions s ON u.user_id = s.user_id
INNER JOIN database.schema.plans p ON s.plan_id  = p.plan_id; 


--Q6:Show every user and any subscriptions they have. Users without subscriptions must still appear
SELECT
    u.user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM  database.default.users u
LEFT JOIN database.schema.subscriptions s ON u.user_id = s.user_id;

--Q7:Show every plan and the subscriptions on it. Plans with no subscribers must still appear

SELECT
    p.plan_id,
    p.plan_name,
    s.subscription_id,
    s.user_id
FROM database.schema.plans  p
LEFT JOIN database.schema.subscriptions s ON p.plan_id = s.plan_id;

--Q8:Show every show and any viewing sessions on it. Shows that were never watched must still appear

SELECT
    sh.show_id,
    sh.show_title,
    vs.session_id,
    vs.watch_minutes
FROM database.schema.shows sh
LEFT JOIN database.schema.viewing_sessions vs ON sh.show_id = vs.show_id;

--Q9: Show every viewing session and the user who watched it. Sessions referencing users that do not exist must still appear (with NULL user details).

SELECT
    vs.session_id,
    vs.show_id,
    vs.watch_minutes,
    vs.user_id,
    u.user_name
FROM database.schema.viewing_sessions vs
LEFT JOIN database.default.users u ON vs.user_id = u.user_id; 

--Q10:Show every user, the plan they are on (if any), and the monthly price. Users without a subscription must still appear

SELECT
    u.user_name,
    u.country,
    p.plan_name,
    p.monthly_price
FROM database.default.users u
LEFT JOIN database.schema.subscriptions s ON u.user_id = s.user_id
LEFT JOIN database.schema.plans p ON s.plan_id  = p.plan_id; 

--Q11:Show every user and every subscription, including users without subscriptions AND subscriptions referencing users that do not exist.

SELECT
    COALESCE(u.user_id, s.user_id) AS user_id,
    u.user_name,
    s.subscription_id,
    s.start_date
FROM database.default.users u
FULL OUTER JOIN database.schema.subscriptions s ON u.user_id = s.user_id; 

--Q12: Show every plan and every subscription, including plans without subscribers AND any subscription referencing a plan that does not exist
SELECT
    COALESCE(p.plan_id, s.plan_id) AS plan_id,
    p.plan_name,
    s.subscription_id,
    s.user_id
FROM database.schema.plans p
FULL OUTER JOIN database.schema.subscriptions s ON p.plan_id = s.plan_id; 

--Q13:Show every show and every viewing session, including shows that were never watched AND sessions referencing shows that do not exist
SELECT
    COALESCE(sh.show_id, vs.show_id) AS show_id,
    sh.show_title,
    vs.session_id,
    vs.watch_minutes
FROM database.schema.shows sh
FULL OUTER JOIN database.schema.viewing_sessions vs ON sh.show_id = vs.show_id; 

--Q14:Show every user and every viewing session, including users with no sessions AND sessions referencing users who do not exist

SELECT
    COALESCE(u.user_id, vs.user_id) AS user_id,
    u.user_name,
    vs.session_id,
    vs.show_id,
    vs.watch_minutes
FROM database.default.users u
FULL OUTER JOIN database.schema.viewing_sessions vs ON u.user_id = vs.user_id; 

--Q15:Show every user, every subscription, and every plan in one query — using FULL OUTER JOIN throughout. This is the hardest question - get all gaps visible at once

SELECT
    COALESCE(u.user_id, s.user_id)   AS user_id,
    u.user_name,
    s.subscription_id,
    COALESCE(p.plan_id, s.plan_id)   AS plan_id,
    p.plan_name
FROM database.default.users u
FULL OUTER JOIN database.schema.subscriptions  s ON u.user_id = s.user_id
FULL OUTER JOIN  database.schema.plans p ON s.plan_id  = p.plan_id;

--BONUS QUESTIONS
--Q1:Which users have not subscribed to any plan 

SELECT u.user_id, u.user_name
FROM database.default.users u
LEFT JOIN  database.schema.subscriptions  s ON u.user_id = s.user_id
WHERE s.subscription_id IS NULL;


--Q2:Which subscriptions reference users that do not exist in the users table?
SELECT s.subscription_id, s.user_id
FROM database.schema.subscriptions s
LEFT JOIN  database.default.users  u ON s.user_id = u.user_id
WHERE u.user_id IS NULL; 


--Q3:Which shows have never been watched?
SELECT sh.show_id, sh.show_title
FROM database.schema.shows  sh
LEFT JOIN  database.schema.viewing_sessions vs ON sh.show_id = vs.show_id
WHERE vs.session_id IS NULL;

--Q4:Which viewing sessions reference shows that do not exist?
SELECT vs.session_id, vs.show_id
FROM database.schema.viewing_sessions vs
LEFT JOIN database.schema.shows sh ON vs.show_id = sh.show_id
WHERE sh.show_id IS NULL;

--Q5:Which plans have no subscribers?
SELECT p.plan_id, p.plan_name
FROM database.schema.plans p
LEFT JOIN database.schema.subscriptions s ON p.plan_id = s.plan_id
WHERE s.subscription_id IS NULL;



