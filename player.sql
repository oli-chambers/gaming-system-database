----------------------
----EXECUTE SELECT----
----------------------


SHOW ROLE;
set search_path to user_schema;
SELECT * FROM achievement;
SELECT * FROM ingamebalance;
SELECT * FROM library;
SELECT * FROM playeractivitylogs;
SELECT * FROM players;
SELECT * FROM transactions;
SELECT * FROM useraccount; 
SELECT UserAccountID, PlayerID, BillingAddress FROM useraccount;
SELECT * FROM userprofile;
set search_path to community_schema;
SELECT * FROM esportsteammembers;
SELECT * FROM esportsteams;
SELECT * FROM leaderboard;
SELECT * FROM leaderboardhistory;
SELECT * FROM newsfeed;
SELECT * FROM tournaments;
SELECT * FROM tournamentleaderboard;
SELECT * FROM tournamentleaderboardhistory;
SELECT * FROM tournamentparticipants;
SELECT * FROM tournamentregistration;
SET search_path TO store_schema;
SELECT * FROM games;
SELECT * FROM notificationqueue;
SELECT * FROM reviews;
SELECT * FROM store;
SELECT * FROM supporttickets;


--------------------
---EXECUTE VIEWS----
--------------------


SELECT * FROM gameinformation;
SET search_path TO user_schema;
----The Player will not be able to execute the view due to not having permission, can only be executed by managers----
SELECT * FROM alllibrary;
SELECT * FROM playerachievements; 
SELECT * FROM playeractivitylogsview; 
----The Player will not be able to execute the view due to not having permission, can only be executed by managers and employees----
SELECT * FROM playerinformation;
SELECT * FROM playerlibrary;
----The Player will not be able to execute the view due to not having permission, can only be executed by managers and employees----
SELECT * FROM playertransactions;
SET search_path TO community_schema;
SELECT * FROM available_tournaments_view;
SELECT * FROM esportsteaminformation;
SELECT * FROM leaderboard_history_view;
SELECT * FROM leaderboardinformation;
SELECT * FROM newsfeedinformation;
SELECT * FROM tournament_leaderboard_history_view;
SELECT * FROM tournamentinformation;


-------------------------
----EXECUTE FUNCTIONS----
-------------------------


--Apply-For-Purchase function
Set search_path To user_schema;
SELECT * FROM transactions;
SET search_path TO public;
SELECT apply_for_purchase(12, 1);
Set search_path To user_schema;
SELECT * FROM transactions;


--Make-Payment function
Set search_path To user_schema;
SELECT * FROM ingamebalance;
SET search_path TO public;
select make_payment(12, 50);
Set search_path To user_schema;
SELECT * FROM ingamebalance;


--Transfer-Funds function
Set search_path To user_schema;
SELECT * FROM ingamebalance;
SET search_path TO public;
SELECT transfer_funds(12, 11, 100);
Set search_path To user_schema;
SELECT * FROM ingamebalance;


--Approve-transaction function
Set search_path To user_schema;
SELECT * FROM transactions;
SET search_path TO public;
----The Player will not be able to execute the function due to not having permission, can only be executed by managers----
SELECT approve_transaction(1);
Set search_path To user_schema;
SELECT * FROM transactions;

--Get-Game-Reviews
SET search_path TO public;
SELECT get_game_reviews(1);
