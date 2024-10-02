-- Drop the GamingSystem database if it exists 
DROP DATABASE IF EXISTS gamingsystem;
DROP ROLE Player;
DROP ROLE Employee;
DROP ROLE Manager;
-- Create the GamingSystem database 
CREATE DATABASE gamingsystem;
-- Connect to the GamingSystem database 
\c gamingsystem;


--------------------
----CREATE TABLE----
--------------------


-- Create the user schema for user-related tables 
CREATE SCHEMA user_schema;
-- Create Players table
CREATE TABLE user_schema.Players (
    PlayerID SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    RegistrationDate DATE
);

-- Create UserProfile table
CREATE TABLE user_schema.UserProfile (
    UserProfileID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    OnlineStatus VARCHAR(255),
    AvatarURL VARCHAR(255),
    Bio VARCHAR(255)
);
-- Create UserAccount table
CREATE TABLE user_schema.UserAccount (
    UserAccountID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    BankDetails VARCHAR(255),
    Username VARCHAR(255) NOT NULL,   
    CreditCardNumber VARCHAR(255),
    BillingAddress VARCHAR(255)
);
-- Create InGameBalance table
CREATE TABLE user_schema.InGameBalance (
    BalanceID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    InGameBalance INT,
    BalanceDate DATE
);
-- Create Transactions table
CREATE TABLE user_schema.Transactions (
    TransactionID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    TransactionType VARCHAR(255),
    Amount INT,
    TransactionDate DATE,
    ApprovedByManager BOOLEAN
);
-- Create the store schema for store-related tables 
CREATE SCHEMA store_schema;
-- Create Games table
CREATE TABLE store_schema.Games (
    GameID INT PRIMARY KEY,
    Title VARCHAR,
    Developer VARCHAR,
    Publisher VARCHAR,
    ReleaseDate DATE,
    Genre VARCHAR,
    Description VARCHAR
);
-- Create Library table
CREATE TABLE user_schema.Library (
    LibraryID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    GameID INT REFERENCES store_schema.Games(GameID),
    PurchaseDate DATE
);
ALTER TABLE user_schema.Library
ADD CONSTRAINT fk_library_game
FOREIGN KEY (GameID) REFERENCES store_schema.Games(GameID);

ALTER TABLE user_schema.Library
ADD CONSTRAINT fk_library_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create Reviews table
CREATE TABLE store_schema.Reviews (
    ReviewID SERIAL PRIMARY KEY,
    GameID INT REFERENCES store_schema.Games(GameID),
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    Rating INT,
    Comment VARCHAR(255)
);
ALTER TABLE store_schema.Reviews
ADD CONSTRAINT fk_reviews_game
FOREIGN KEY (GameID) REFERENCES store_schema.Games(GameID);

ALTER TABLE store_schema.Reviews
ADD CONSTRAINT fk_reviews_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create Store table
CREATE TABLE store_schema.Store (
    GameID INT PRIMARY KEY REFERENCES store_schema.Games(GameID),
    Price DECIMAL,
    Discount DECIMAL,
    Availability BOOLEAN,
    ReviewID INT REFERENCES store_schema.Reviews(ReviewID)
);
ALTER TABLE store_schema.Store
ADD CONSTRAINT fk_store_game
FOREIGN KEY (GameID) REFERENCES store_schema.Games(GameID);

ALTER TABLE store_schema.Store
ADD CONSTRAINT fk_store_review
FOREIGN KEY (ReviewID) REFERENCES store_schema.Reviews(ReviewID);

-- Create the community schema for community-related tables 
CREATE SCHEMA community_schema;
-- Create Tournaments table
CREATE TABLE community_schema.Tournaments (
    TournamentID SERIAL PRIMARY KEY,
    TournamentName VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    OrganiserID INT REFERENCES user_schema.Players(PlayerID),
    IsActive BOOLEAN,
    GameID INT REFERENCES store_schema.Games(GameID)
);
ALTER TABLE community_schema.Tournaments
ADD CONSTRAINT fk_tournaments_game
FOREIGN KEY (GameID) REFERENCES store_schema.Games(GameID);


-- Create TournamentParticipants table
CREATE TABLE community_schema.TournamentParticipants (
    ParticipantID SERIAL PRIMARY KEY,
    TournamentID INT REFERENCES community_schema.Tournaments(TournamentID),
    PlayerID INT REFERENCES user_schema.Players(PlayerID)
);
ALTER TABLE community_schema.TournamentParticipants
ADD CONSTRAINT fk_tournament_participants_tournament
FOREIGN KEY (TournamentID) REFERENCES community_schema.Tournaments(TournamentID);

ALTER TABLE community_schema.TournamentParticipants
ADD CONSTRAINT fk_tournament_participants_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create TournamentRegistration table
CREATE TABLE community_schema.TournamentRegistration (
    RegistrationID SERIAL PRIMARY KEY,
    TournamentID INT REFERENCES community_schema.Tournaments(TournamentID),
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    RegistrationDate DATE,
    RegistrationStatus VARCHAR(255)
);
ALTER TABLE community_schema.TournamentRegistration
ADD CONSTRAINT fk_tournament_registration_tournament
FOREIGN KEY (TournamentID) REFERENCES community_schema.Tournaments(TournamentID);

ALTER TABLE community_schema.TournamentRegistration
ADD CONSTRAINT fk_tournament_registration_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create Leaderboard table
CREATE TABLE community_schema.Leaderboard (
    LeaderboardID SERIAL PRIMARY KEY,
    GameID INT REFERENCES store_schema.Games(GameID),
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    Score INT,
    Rank INT
);
ALTER TABLE community_schema.Leaderboard
ADD CONSTRAINT fk_leaderboard_game
FOREIGN KEY (GameID) REFERENCES store_schema.Games(GameID);

ALTER TABLE community_schema.Leaderboard
ADD CONSTRAINT fk_leaderboard_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create Achievement table
CREATE TABLE user_schema.Achievement (
    AchievementID SERIAL PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    AchievementName VARCHAR(255),
    GameID INT REFERENCES store_schema.Games(GameID),
    UnlockDate DATE
);
ALTER TABLE user_schema.Achievement
ADD CONSTRAINT fk_achievement_game
FOREIGN KEY (GameID) REFERENCES store_schema.Games(GameID);

ALTER TABLE user_schema.Achievement
ADD CONSTRAINT fk_achievement_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create Newsfeed table
CREATE TABLE community_schema.Newsfeed (
    PostID SERIAL PRIMARY KEY,
    Content VARCHAR(255),
    AuthorID INT REFERENCES user_schema.Players(PlayerID),
    PostDate DATE
);
-- Create EsportsTeams table
CREATE TABLE community_schema.EsportsTeams (
    TeamID SERIAL PRIMARY KEY,
    TeamName VARCHAR(255),
    TeamDescription VARCHAR(255),
    TeamOwnerID INT REFERENCES user_schema.Players(PlayerID),
    TournamentID INT REFERENCES community_schema.Tournaments(TournamentID)
);
ALTER TABLE community_schema.EsportsTeams
ADD CONSTRAINT fk_esports_teams_owner
FOREIGN KEY (TeamOwnerID) REFERENCES user_schema.Players(PlayerID);

ALTER TABLE community_schema.EsportsTeams
ADD CONSTRAINT fk_esports_teams_tournament
FOREIGN KEY (TournamentID) REFERENCES community_schema.Tournaments(TournamentID);

-- Create EsportsTeamMembers table
CREATE TABLE community_schema.EsportsTeamMembers (
    TeamMemberID SERIAL PRIMARY KEY,
    TeamID INT REFERENCES community_schema.EsportsTeams(TeamID),
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    JoinDate DATE
);

-- Add constraints for EsportsTeamMembers table
ALTER TABLE community_schema.EsportsTeamMembers
ADD CONSTRAINT fk_esports_team_members_team
FOREIGN KEY (TeamID) REFERENCES community_schema.EsportsTeams(TeamID);

ALTER TABLE community_schema.EsportsTeamMembers
ADD CONSTRAINT fk_esports_team_members_player
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);    
-- Create NotificationQueue table
CREATE TABLE store_schema.NotificationQueue (
    NotificationID INT PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    NotificationType VARCHAR,
    Message VARCHAR,
    IsRead BOOLEAN,
    Timestamp TIMESTAMP
);
ALTER TABLE store_schema.NotificationQueue
ADD CONSTRAINT fk_notification_queue_user
FOREIGN KEY (PlayerID) REFERENCES user_schema.Players(PlayerID);

-- Create LeaderboardHistory table
CREATE TABLE community_schema.LeaderboardHistory (
    HistoryID INT PRIMARY KEY,
    LeaderboardID INT REFERENCES community_schema.Leaderboard(LeaderboardID),
    SnapshotDate TIMESTAMP,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    GameID INT REFERENCES store_schema.Games(GameID),
    Score INT
);

-- Create PlayerActivityLogs table
CREATE TABLE user_schema.PlayerActivityLogs (
    LogID INT PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    ActivityType VARCHAR,
    ActivityDetails VARCHAR,
    Timestamp TIMESTAMP
);
-- Create SupportTickets table
CREATE TABLE store_schema.SupportTickets (
    TicketID INT PRIMARY KEY,
    PlayerID INT REFERENCES user_schema.Players(PlayerID),
    IssueType VARCHAR,
    Description VARCHAR,
    Status VARCHAR,
    SubmissionDate DATE,
    ResolutionDate DATE
);
-- Create TournamentLeaderboardHistory table
CREATE TABLE community_schema.TournamentLeaderboardHistory (
    HistoryID INT PRIMARY KEY,
    LeaderboardID INT REFERENCES community_schema.Leaderboard(LeaderboardID),
    SnapshotDate TIMESTAMP,
    TeamID INT REFERENCES community_schema.EsportsTeams(TeamID),
    GameID INT REFERENCES store_schema.Games(GameID),
    Score INT
);

-- Create TournamentLeaderboard table
CREATE TABLE community_schema.TournamentLeaderboard (
    LeaderboardID INT PRIMARY KEY,
    GameID INT REFERENCES store_schema.Games(GameID),
    TeamID INT REFERENCES community_schema.EsportsTeams(TeamID),
    Score INT,
    Rank INT
);



------------------------
----PLAYER PRIVILEGE----
------------------------

-- Create the Player role
CREATE ROLE player;

DROP USER IF EXISTS playeruser;

-- Recreate the user
CREATE USER playeruser WITH PASSWORD 'pass';
-- Grant the Player permissions to the user
GRANT player to playeruser;

GRANT USAGE ON SCHEMA user_schema TO player;
GRANT USAGE ON SCHEMA store_schema TO player;
GRANT USAGE ON SCHEMA community_schema TO player;

-- Grant SELECT on all tables in user_schema to Player
GRANT SELECT ON ALL TABLES IN SCHEMA user_schema TO player;

-- Grant SELECT on all tables in community_schema to Player
GRANT SELECT ON ALL TABLES IN SCHEMA community_schema TO player;

-- Grant SELECT on all tables in store_schema to Player
GRANT SELECT ON ALL TABLES IN SCHEMA store_schema TO player;

-- Grant SELECT, INSERT, UPDATE, DELETE on useraccount table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE user_schema.useraccount TO player; 

-- Grant SELECT, INSERT, UPDATE, DELETE on userprofile table
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE user_schema.userprofile TO player; 

-- Grant DELETE privilege on SupportTickets to delete resolved support issues
GRANT DELETE ON TABLE store_schema.SupportTickets TO player; 

-- Grant DELETE privilege on NotificationQueue to delete messages from history
GRANT DELETE ON TABLE store_schema.NotificationQueue TO player; 

-- Grant DELETE privilege on Library to allow users to delete games from their library
GRANT DELETE ON TABLE user_schema.Library TO player; 

--Grant privilges for user to make transaction
GRANT INSERT ON TABLE user_schema.Transactions to player;

GRANT UPDATE ON TABLE user_schema.InGameBalance to player;



--------------------------
----EMPLOYEE PRIVILEGE----
--------------------------



-- Grant necessary privileges or roles to the user if needed
CREATE ROLE employee;

-- Drop the existing user if it exists
DROP USER IF EXISTS employeeuser;

-- Recreate the user
CREATE USER employeeuser WITH PASSWORD 'pass';

GRANT employee to employeeuser;

GRANT USAGE ON SCHEMA user_schema TO employee;
GRANT USAGE ON SCHEMA store_schema TO employee;
GRANT USAGE ON SCHEMA community_schema TO employee;


-- Explicitly deny UPDATE, INSERT, DELETE on all tables
ALTER DEFAULT PRIVILEGES IN SCHEMA user_schema
REVOKE ALL ON TABLES FROM employee;

-- Grant SELECT on all tables
GRANT SELECT ON ALL TABLES IN SCHEMA user_schema TO employee;

-- Grant SELECT on all tables in community_schema to Employee
GRANT SELECT ON ALL TABLES IN SCHEMA community_schema TO employee;

-- Grant SELECT on all tables in store_schema to Employee
GRANT SELECT ON ALL TABLES IN SCHEMA store_schema TO employee;

GRANT INSERT ON TABLE user_schema.Transactions to employee;
GRANT UPDATE ON TABLE user_schema.InGameBalance to employee;

-- Grant SELECT on the specified columns so that employees are not able to view player bank details
GRANT SELECT (UserAccountID, PlayerID, BillingAddress) ON TABLE user_schema.useraccount TO employee;

-- Apply the employee role to the employee user
ALTER USER employeeuser SET ROLE employee;
-- Allow the employee to bypass role level security to be able to view all rows in the table
ALTER ROLE employee BYPASSRLS;



---------------------------
----MANAGER PERMISSIONS----
---------------------------



CREATE ROLE manager;
-- Drop the existing user if it exists
DROP USER IF EXISTS manageruser;

-- Recreate the user
-- Grant necessary privileges or roles to the user if needed
CREATE USER manageruser WITH PASSWORD 'pass';


-- Grant USAGE privilege on schema (required for SELECT)
GRANT USAGE ON SCHEMA user_schema TO manager;
GRANT USAGE ON SCHEMA store_schema TO manager;
GRANT USAGE ON SCHEMA community_schema TO manager;

--Grant all permissions on all tables in the other schemas to the manager
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA community_schema TO manager;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA store_schema TO manager;

-- Grant SELECT privilege on all tables in store_schema
GRANT SELECT ON ALL TABLES IN SCHEMA store_schema TO manager;

-- Grant SELECT privilege on all tables in community_schema
GRANT SELECT ON ALL TABLES IN SCHEMA community_schema TO manager;

-- Grant all permissions on userprofile table
GRANT ALL PRIVILEGES ON TABLE user_schema.userprofile TO manager;

-- Grant all permissions on achievement table
GRANT ALL PRIVILEGES ON TABLE user_schema.achievement TO manager;

-- Grant all permissions on ingamebalance table
GRANT ALL PRIVILEGES ON TABLE user_schema.ingamebalance TO manager;

-- Grant all permissions on transactions table
GRANT ALL PRIVILEGES ON TABLE user_schema.transactions TO manager;

-- Grant all permissions on library table
GRANT ALL PRIVILEGES ON TABLE user_schema.library TO manager;

-- Grant all permissions on playeractivitylogs table
GRANT ALL PRIVILEGES ON TABLE user_schema.playeractivitylogs TO manager;

-- Grant all permissions on players table
GRANT ALL PRIVILEGES ON TABLE user_schema.players TO manager;

-- Grant SELECT on the specified columns to prevent being able to view the players bank information
GRANT SELECT (UserAccountID, PlayerID, BillingAddress) ON TABLE user_schema.useraccount TO manager;


GRANT manager to manageruser;
ALTER USER manageruser SET ROLE manager;
ALTER ROLE manager BYPASSRLS;



------------------------
----CREATE TEST USER----
------------------------

DROP USER IF EXISTS testuser;
CREATE USER testuser WITH PASSWORD 'pass';
ALTER USER testuser SET ROLE player;
GRANT player TO testuser;

-- Create a new column to store player roles in the Players table
ALTER TABLE user_schema.Players
ADD COLUMN PlayerRole VARCHAR;

-- Set default role to 'Player' for existing players
UPDATE user_schema.Players
SET PlayerRole = 'player'
WHERE PlayerRole IS NULL;

-- Create a test user
INSERT INTO user_schema.Players (PlayerID, Username, Email, RegistrationDate)
VALUES (1, 'testuser', 'test@example.com', CURRENT_DATE);

-- Set the test user role
UPDATE user_schema.Players
SET PlayerRole = 'player'
WHERE PlayerID = 1;


-- Set default role to 'Player' for existing players
ALTER TABLE user_schema.Players
ADD COLUMN IF NOT EXISTS RoleName VARCHAR DEFAULT 'player';

CREATE OR REPLACE FUNCTION player_role_check()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN current_setting('app.current_role') = 'player';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION employee_role_check()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN current_setting('app.current_role') = 'employee';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION manager_role_check()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN current_setting('app.current_role') = 'manager';
END;
$$ LANGUAGE plpgsql;

-- Assign the policies to the roles
ALTER TABLE user_schema.Players FORCE ROW LEVEL SECURITY;

-- Grant EXECUTE privilege on the functions to the roles
GRANT EXECUTE ON FUNCTION player_role_check() TO player;
GRANT EXECUTE ON FUNCTION employee_role_check() TO employee;
GRANT EXECUTE ON FUNCTION manager_role_check() TO manager;



-----------------------
----PLAYER POLICIES----
-----------------------



GRANT SELECT, UPDATE (Username, Email) ON TABLE user_schema.Players TO player;

-- Enable row-level security on user_schema.Players table
ALTER TABLE user_schema.Players ENABLE ROW LEVEL SECURITY;

-- Set row-level security policy for SELECT
CREATE POLICY player_select_policy
  ON user_schema.Players
  FOR SELECT
  USING (Username = current_user);

-- Set row-level security policy for UPDATE
CREATE POLICY player_update_policy
  ON user_schema.Players
  FOR UPDATE
  USING (Username = current_user);

-- Enable row-level security on useraccount table
ALTER TABLE user_schema.useraccount ENABLE ROW LEVEL SECURITY;

-- Set row-level security policy for SELECT
CREATE POLICY useraccount_select_policy
  ON user_schema.UserAccount
  FOR SELECT
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Set row-level security policy for INSERT
CREATE POLICY useraccount_insert_update
  ON user_schema.UserAccount
  FOR UPDATE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Set row-level security policy for UPDATE
CREATE POLICY useraccount_update_policy
  ON user_schema.UserAccount
  FOR UPDATE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Set row-level security policy for DELETE
CREATE POLICY useraccount_delete_policy
  ON user_schema.UserAccount
  FOR DELETE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));


-- Enable row-level security on userprofile table
ALTER TABLE user_schema.userprofile ENABLE ROW LEVEL SECURITY;

-- Set row-level security policy for userprofile table
CREATE POLICY userprofile_select_policy
  ON user_schema.UserProfile
  FOR SELECT
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

CREATE POLICY userprofile_update_policy
  ON user_schema.UserProfile
  FOR UPDATE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

ALTER TABLE user_schema.library ENABLE ROW LEVEL SECURITY;
-- Set row-level security policy for SELECT
CREATE POLICY library_select_policy
  ON user_schema.Library
  FOR SELECT
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Set row-level security policy for DELETE
CREATE POLICY library_delete_policy
  ON user_schema.Library
  FOR DELETE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Create row-level security policy for PlayerActivityLogs
ALTER TABLE user_schema.PlayerActivityLogs ENABLE ROW LEVEL SECURITY;
-- Set row-level security policy for SELECT
CREATE POLICY player_activity_logs_select_policy
  ON user_schema.PlayerActivityLogs
  FOR SELECT
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Set row-level security policy for DELETE
CREATE POLICY player_activity_logs_delete_policy
  ON user_schema.PlayerActivityLogs
  FOR DELETE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Create row-level security policy for NotificationQueue
ALTER TABLE store_schema.NotificationQueue ENABLE ROW LEVEL SECURITY;
-- Set row-level security policy for SELECT
CREATE POLICY notification_queue_select_policy
  ON store_schema.NotificationQueue
  FOR SELECT
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Set row-level security policy for DELETE
CREATE POLICY notification_queue_delete_policy
  ON store_schema.NotificationQueue
  FOR DELETE
  USING (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));



-------------
----VIEWS----
-------------



-- Create view to display player information
CREATE OR REPLACE VIEW user_schema.PlayerInformation AS
SELECT
    p.PlayerID,
    p.Username,
    p.Email,
    p.RegistrationDate,
    up.OnlineStatus,
    up.AvatarURL,
    up.Bio,
    ua.BillingAddress,
    ib.InGameBalance
FROM
    user_schema.Players p
JOIN user_schema.UserProfile up ON p.PlayerID = up.PlayerID
JOIN user_schema.UserAccount ua ON p.PlayerID = ua.PlayerID
JOIN user_schema.InGameBalance ib ON p.PlayerID = ib.PlayerID;

-- Create view to display player transactions
CREATE OR REPLACE VIEW user_schema.PlayerTransactions AS
SELECT
    p.PlayerID,
    t.TransactionID,
    t.TransactionType,
    t.Amount,
    t.TransactionDate,
    t.ApprovedByManager
FROM
    user_schema.Players p
JOIN user_schema.Transactions t ON p.PlayerID = t.PlayerID;

-- Create view to display game information
CREATE OR REPLACE VIEW store_schema.GameInformation AS
SELECT
    g.GameID,
    g.Title,
    g.Developer,
    g.Publisher,
    g.ReleaseDate,
    g.Genre,
    g.Description,
    s.Price,
    s.Discount,
    s.Availability,
    r.Rating,
    r.Comment
FROM
    store_schema.Games g
JOIN store_schema.Store s ON g.GameID = s.GameID
LEFT JOIN store_schema.Reviews r ON g.GameID = r.GameID;

-- Create view to display tournament information
CREATE OR REPLACE VIEW community_schema.TournamentInformation AS
SELECT
    t.TournamentID,
    t.TournamentName,
    t.StartDate,
    t.EndDate,
    t.OrganiserID,
    t.IsActive,
    t.GameID,
    COUNT(tp.ParticipantID) AS ParticipantsCount
FROM
    community_schema.Tournaments t
LEFT JOIN community_schema.TournamentParticipants tp ON t.TournamentID = tp.TournamentID
GROUP BY
    t.TournamentID;

-- Create view to display leaderboard information
CREATE OR REPLACE VIEW community_schema.LeaderboardInformation AS
SELECT
    l.LeaderboardID,
    l.GameID,
    l.PlayerID,
    l.Score,
    l.Rank,
    p.Username
FROM
    community_schema.Leaderboard l
JOIN user_schema.Players p ON l.PlayerID = p.PlayerID
ORDER BY Rank ASC;

-- Create view to display newsfeed information
CREATE OR REPLACE VIEW community_schema.NewsfeedInformation AS
SELECT
    nf.PostID,
    nf.Content,
    nf.AuthorID,
    nf.PostDate,
    p.Username AS AuthorUsername
FROM
    community_schema.Newsfeed nf
JOIN user_schema.Players p ON nf.AuthorID = p.PlayerID
ORDER BY PostDate DESC;;

-- Create view to display esports team information
CREATE OR REPLACE VIEW community_schema.EsportsTeamInformation AS
SELECT
    et.TeamID,
    et.TeamName,
    et.TeamDescription,
    et.TeamOwnerID,
    et.TournamentID,
    tm.PlayerID AS TeamMemberID,
    tm.JoinDate,
    p.Username AS TeamOwnerUsername
FROM
    community_schema.EsportsTeams et
JOIN community_schema.EsportsTeamMembers tm ON et.TeamID = tm.TeamID
JOIN user_schema.Players p ON et.TeamOwnerID = p.PlayerID;

-- Create view to display player achievements
CREATE OR REPLACE VIEW user_schema.PlayerAchievements AS
SELECT
    a.AchievementID,
    a.PlayerID,
    a.AchievementName,
    a.GameID,
    a.UnlockDate,
    g.Title AS GameTitle
FROM
    user_schema.Achievement a
JOIN store_schema.Games g ON a.GameID = g.GameID
WHERE (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Create view to display player library
CREATE OR REPLACE VIEW user_schema.PlayerLibrary AS
SELECT
    l.LibraryID,
    l.PlayerID,
    l.GameID,
    l.PurchaseDate,
    g.Title,
    g.Developer,
    g.Publisher,
    g.ReleaseDate,
    g.Genre,
    g.Description
FROM
    user_schema.Library l
JOIN store_schema.Games g ON l.GameID = g.GameID
WHERE (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Create view to display player library
CREATE OR REPLACE VIEW user_schema.AllLibrary AS
SELECT
    l.LibraryID,
    l.PlayerID,
    l.GameID,
    l.PurchaseDate,
    g.Title,
    g.Developer,
    g.Publisher,
    g.ReleaseDate,
    g.Genre,
    g.Description
FROM
    user_schema.Library l
JOIN store_schema.Games g ON l.GameID = g.GameID;


CREATE VIEW community_schema.leaderboard_history_view AS
SELECT HistoryID, LeaderboardID, SnapshotDate, PlayerID, GameID, Score
FROM community_schema.LeaderboardHistory
ORDER BY Score ASC;

CREATE VIEW community_schema.available_tournaments_view AS
SELECT TournamentID, TournamentName, StartDate, EndDate, IsActive
FROM community_schema.Tournaments
WHERE IsActive = true
ORDER BY TournamentID ASC;


CREATE VIEW community_schema.tournament_leaderboard_history_view AS
SELECT TLH.HistoryID, TLH.LeaderboardID, TLH.SnapshotDate, TLH.TeamID, TLH.GameID, TLH.Score
FROM community_schema.TournamentLeaderboardHistory TLH
JOIN community_schema.TournamentLeaderboard TL ON TLH.LeaderboardID = TL.LeaderboardID
JOIN community_schema.Tournaments T ON TL.GameID = T.GameID
ORDER BY TLH.Score ASC;

-- Create a view for PlayerActivityLogs
CREATE OR REPLACE VIEW user_schema.PlayerActivityLogsView AS
SELECT *
FROM user_schema.PlayerActivityLogs
WHERE (PlayerID = (SELECT PlayerID FROM user_schema.Players WHERE Username = current_user));

-- Grant SELECT permission on views to Manager role
GRANT SELECT ON user_schema.PlayerInformation TO Manager;
GRANT SELECT ON user_schema.PlayerTransactions TO Manager;
GRANT SELECT ON store_schema.GameInformation TO Manager;
GRANT SELECT ON community_schema.TournamentInformation TO Manager;
GRANT SELECT ON community_schema.LeaderboardInformation TO Manager;
GRANT SELECT ON community_schema.NewsfeedInformation TO Manager;
GRANT SELECT ON community_schema.EsportsTeamInformation TO Manager;
GRANT SELECT ON user_schema.PlayerAchievements TO Manager;
GRANT SELECT ON user_schema.PlayerLibrary TO Manager;
GRANT SELECT ON user_schema.AllLibrary TO Manager;
GRANT SELECT ON community_schema.leaderboard_history_view TO Manager;
GRANT SELECT ON community_schema.available_tournaments_view TO Manager;
GRANT SELECT ON community_schema.tournament_leaderboard_history_view TO Manager;
GRANT SELECT ON user_schema.PlayerActivityLogsView TO Manager;

-- Grant SELECT permission on views to Employee role
GRANT SELECT ON user_schema.PlayerInformation TO Employee;
GRANT SELECT ON user_schema.PlayerTransactions TO Employee;
GRANT SELECT ON store_schema.GameInformation TO Employee;
GRANT SELECT ON community_schema.TournamentInformation TO Employee;
GRANT SELECT ON community_schema.LeaderboardInformation TO Employee;
GRANT SELECT ON community_schema.NewsfeedInformation TO Employee;
GRANT SELECT ON community_schema.EsportsTeamInformation TO Employee;
GRANT SELECT ON user_schema.PlayerAchievements TO Employee;
GRANT SELECT ON user_schema.PlayerLibrary TO Employee;
GRANT SELECT ON community_schema.leaderboard_history_view TO Employee;
GRANT SELECT ON community_schema.available_tournaments_view TO Employee;
GRANT SELECT ON community_schema.tournament_leaderboard_history_view TO Employee;
GRANT SELECT ON user_schema.PlayerActivityLogsView TO Employee;

-- Grant SELECT permission on views to Player role
GRANT SELECT ON store_schema.GameInformation TO Player;
GRANT SELECT ON community_schema.TournamentInformation TO Player;
GRANT SELECT ON community_schema.LeaderboardInformation TO Player;
GRANT SELECT ON community_schema.NewsfeedInformation TO Player;
GRANT SELECT ON community_schema.EsportsTeamInformation TO Player;
GRANT SELECT ON user_schema.PlayerAchievements TO Player;
GRANT SELECT ON user_schema.PlayerLibrary TO Player;
GRANT SELECT ON community_schema.leaderboard_history_view TO Player;
GRANT SELECT ON community_schema.available_tournaments_view TO Player;
GRANT SELECT ON community_schema.tournament_leaderboard_history_view TO Player;
GRANT SELECT ON user_schema.PlayerActivityLogsView TO Player;



-----------------
----FUNCTIONS----
-----------------



-- Manager can approve an outstanding transaction
CREATE OR REPLACE FUNCTION approve_transaction(transaction_id INTEGER)
RETURNS VOID AS $$
BEGIN
    -- Set ApprovedByManager to true
    UPDATE user_schema.Transactions
    SET ApprovedByManager = true
    WHERE TransactionID = transaction_id;
END;
$$ LANGUAGE plpgsql;
-- Grant execute permission to the manager role
GRANT EXECUTE ON FUNCTION approve_transaction(INTEGER) TO manager;

-- Transaction of funds between a user's accounts 
CREATE OR REPLACE FUNCTION transfer_funds(
    from_player_id INT,
    to_player_id INT,
    amount INT
) RETURNS BOOLEAN AS 
$$ 
DECLARE 
    from_balance INT; 
BEGIN 
    -- Check if the from player has sufficient balance 
    SELECT InGameBalance INTO from_balance 
    FROM user_schema.InGameBalance 
    WHERE PlayerID = from_player_id; 

    IF from_balance >= amount THEN 
        -- Deduct amount from the from player's balance 
        UPDATE user_schema.InGameBalance 
        SET InGameBalance = from_balance - amount 
        WHERE PlayerID = from_player_id; 

        -- Add amount to the to player's balance 
        UPDATE user_schema.InGameBalance 
        SET InGameBalance = InGameBalance + amount 
        WHERE PlayerID = to_player_id; 

        RETURN TRUE; 
    ELSE 
        -- Raise an exception if the from player does not have enough funds
        RAISE EXCEPTION 'Insufficient funds for transfer.';
        RETURN FALSE; 
    END IF; 
END; 
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION transfer_funds TO manager;
GRANT EXECUTE ON FUNCTION transfer_funds TO employee;
GRANT EXECUTE ON FUNCTION transfer_funds TO player;


-- Applying for in-game purchases
CREATE OR REPLACE FUNCTION apply_for_purchase(
    player_id INT,
    item_id INT
) RETURNS BOOLEAN AS 
$$ 
DECLARE 
    item_price DECIMAL; 
BEGIN 
    -- Get the price of the in-game item 
    SELECT Price INTO item_price 
    FROM store_schema.Store 
    WHERE GameID = item_id; 

    -- Insert a new transaction record
    INSERT INTO user_schema.Transactions (PlayerID, TransactionType, Amount, TransactionDate, ApprovedByManager)
    VALUES (player_id, 'Purchase', item_price, CURRENT_DATE, FALSE);

    RETURN TRUE; 
END; 
$$ LANGUAGE plpgsql;

GRANT USAGE, SELECT ON SEQUENCE user_schema.transactions_transactionid_seq TO player;
GRANT USAGE, SELECT ON SEQUENCE user_schema.transactions_transactionid_seq TO employee;
GRANT USAGE, SELECT ON SEQUENCE user_schema.transactions_transactionid_seq TO manager;
GRANT EXECUTE ON FUNCTION apply_for_purchase TO manager;
GRANT EXECUTE ON FUNCTION apply_for_purchase TO employee;
GRANT EXECUTE ON FUNCTION apply_for_purchase TO player;


CREATE OR REPLACE FUNCTION make_payment(
    player_id INT,
    amount INT
) RETURNS BOOLEAN AS 
$$ 
DECLARE 
    from_balance INT; 
BEGIN 
    -- Check if the from player has sufficient balance 
    SELECT InGameBalance INTO from_balance 
    FROM user_schema.InGameBalance 
    WHERE PlayerID = player_id; 

    IF from_balance >= amount THEN 
        -- Deduct amount from the from player's balance 
        UPDATE user_schema.InGameBalance 
        SET InGameBalance = from_balance - amount 
        WHERE PlayerID = player_id; 

        RETURN TRUE; 
    ELSE 
        -- Raise an exception if the from player does not have enough funds
        RAISE EXCEPTION 'Insufficient funds for transfer.';
        RETURN FALSE; 
    END IF;  
END; 
$$ LANGUAGE plpgsql; 

GRANT EXECUTE ON FUNCTION make_payment TO manager;


--Function dispaysreviews for specified game
CREATE OR REPLACE FUNCTION get_game_reviews(input_game_id INT)
RETURNS TABLE (
    ReviewID INT,
    PlayerID INT,
    GameID INT,
    Rating INT,
    Comment VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        r.ReviewID,
        r.PlayerID,
        r.GameID,
        r.Rating,
        r.Comment
    FROM
        store_schema.reviews r
    WHERE
        r.GameID = input_game_id;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION get_game_reviews TO manager;
GRANT EXECUTE ON FUNCTION get_game_reviews TO employee;
GRANT EXECUTE ON FUNCTION get_game_reviews TO player;



-----------------
----TEST DATA----
-----------------



-- Insert test data into Players table
INSERT INTO user_schema.Players (PlayerID, Username, Email, RegistrationDate, PlayerRole)
VALUES 
  (10, 'player', 'testuser1@example.com', '2022-01-01', 'player'),
  (11, 'employee', 'testuser2@example.com', '2022-01-02', 'employee'),
  (12, 'manager', 'testuser3@example.com', '2022-01-03', 'manager');

-- Insert test data into UserProfile table
INSERT INTO user_schema.UserProfile (UserProfileID, PlayerID, OnlineStatus, AvatarURL, Bio)
VALUES 
  (1, 10, 'Online', 'avatar1.jpg', 'Test bio for user 1'),
  (2, 11, 'Offline', 'avatar2.jpg', 'Test bio for user 2'),
  (3, 12, 'Online', 'avatar3.jpg', 'Test bio for user 3');

-- Insert test data into UserAccount table
INSERT INTO user_schema.UserAccount (UserAccountID, PlayerID, BankDetails, Username, CreditCardNumber, BillingAddress)
VALUES
  (1, 10, 'Bank1', 'player', '1111-1111-1111-1111', 'Address1'),
  (2, 11, 'Bank2', 'employee', '2222-2222-2222-2222', 'Address2'),
  (3, 12, 'Bank3', 'manager', '3333-3333-3333-3333', 'Address3');

-- Insert test data into InGameBalance table
INSERT INTO user_schema.InGameBalance (BalanceID, PlayerID, InGameBalance, BalanceDate)
VALUES 
  (1, 10, 1000, '2022-01-01'),
  (2, 11, 1500, '2022-01-02'),
  (3, 12, 2000, '2022-01-03');

-- Insert test data into Transactions table
INSERT INTO user_schema.Transactions (TransactionID, PlayerID, TransactionType, Amount, TransactionDate, ApprovedByManager)
VALUES 
  (101, 10, 'Deposit', 500, '2022-01-01', true),
  (102, 11, 'Withdrawal', 200, '2022-01-02', false),
  (103, 12, 'Deposit', 100, '2022-01-03', true);

-- Insert test data into Games table
INSERT INTO store_schema.Games (GameID, Title, Developer, Publisher, ReleaseDate, Genre, Description)
VALUES 
  (1, 'Game1', 'Developer1', 'Publisher1', '2022-01-01', 'Action', 'Description for Game1'),
  (2, 'Game2', 'Developer2', 'Publisher2', '2022-01-02', 'Adventure', 'Description for Game2'),
  (3, 'Game3', 'Developer3', 'Publisher3', '2022-01-03', 'Strategy', 'Description for Game3');

-- Insert test data into Library table
INSERT INTO user_schema.Library (LibraryID, PlayerID, GameID, PurchaseDate)
VALUES 
  (1, 10, 1, '2022-01-01'),
  (2, 11, 2, '2022-01-02'),
  (3, 12, 3, '2022-01-03');

-- Insert test data into Reviews table
INSERT INTO store_schema.Reviews (ReviewID, GameID, PlayerID, Rating, Comment)
VALUES 
  (1, 1, 10, 4, 'Good game!'),
  (2, 2, 11, 5, 'Amazing storyline!'),
  (3, 3, 12, 3, 'Needs improvement.');

-- Insert test data into Store table
INSERT INTO store_schema.Store (GameID, Price, Discount, Availability, ReviewID)
VALUES 
  (1, 49.99, 0.1, true, 1),
  (2, 59.99, 0.2, true, 2),
  (3, 39.99, 0.0, true, 3);

-- Insert test data into Leaderboard table
INSERT INTO community_schema.Leaderboard (LeaderboardID, GameID, PlayerID, Score, Rank)
VALUES
  (1, 1, 10, 1500, 1),
  (2, 1, 11, 1400, 2),
  (3, 2, 12, 1600, 1);

  -- Insert test data into LeaderboardHistory table
INSERT INTO community_schema.LeaderboardHistory (HistoryID, LeaderboardID, SnapshotDate, PlayerID, GameID, Score)
VALUES
  (1, 1, '2022-01-01 12:00:00', 10, 1, 1500),
  (2, 2, '2022-02-01 12:00:00', 11, 1, 1400),
  (3, 3, '2022-01-01 12:00:00', 12, 2, 1600);

-- Insert test data into PlayerActivityLogs table
INSERT INTO user_schema.PlayerActivityLogs (LogID, PlayerID, ActivityType, ActivityDetails, Timestamp)
VALUES
  (1, 10, 'Login', 'Logged in successfully', '2022-01-01 10:00:00'),
  (2, 11, 'Purchase', 'Bought in-game item', '2022-02-01 15:30:00'),
  (3, 12, 'Logout', 'Logged out', '2022-01-01 12:00:00');

-- Insert test data into SupportTickets table
INSERT INTO store_schema.SupportTickets (TicketID, PlayerID, IssueType, Description, Status, SubmissionDate, ResolutionDate)
VALUES
  (1, 10, 'Bug', 'Game crashing on startup', 'Open', '2022-01-02', NULL),
  (2, 11, 'Payment', 'Billing issue with purchase', 'Closed', '2022-02-02', '2022-02-05'),
  (3, 12, 'General Inquiry', 'Question about game features', 'Open', '2022-01-03', NULL);

-- Insert test data into Tournaments table
INSERT INTO community_schema.Tournaments (TournamentID, TournamentName, StartDate, EndDate, OrganiserID, IsActive, GameID)
VALUES
  (1, 'Tournament A', '2022-03-01', '2022-03-10', 10, true, 1),
  (2, 'Tournament B', '2022-03-05', '2022-03-15', 11, true, 2),
  (3, 'Tournament C', '2022-03-10', '2022-03-20', 12, false, 3);

-- Insert test data into EsportsTeams table
INSERT INTO community_schema.EsportsTeams (TeamID, TeamName, TeamDescription, TeamOwnerID, TournamentID)
VALUES
  (1, 'Team A', 'Competitive Gamers', 10, 1),
  (2, 'Team B', 'Casual Players', 11, 2),
  (3, 'Team C', 'Esports Enthusiasts', 12, 3);

-- Insert test data into EsportsTeamMembers table
INSERT INTO community_schema.EsportsTeamMembers (TeamID, PlayerID, JoinDate)
VALUES
  (1, 10, '2022-02-12'),
  (1, 11, '2022-02-14'),
  (2, 10, '2022-02-18'),
  (3, 12, '2022-02-22'),
  (3, 11, '2022-02-24'),
  (3, 12, '2022-02-26');

-- Insert test data into TournamentLeaderboard table
INSERT INTO community_schema.TournamentLeaderboard (LeaderboardID, GameID, TeamID, Score, Rank)
VALUES
  (201, 3, 1, 800, 1),
  (202, 3, 2, 750, 2),
  (203, 2, 3, 900, 1);

-- Insert test data into TournamentParticipants table
INSERT INTO community_schema.TournamentParticipants (TournamentID, PlayerID)
VALUES
  (1, 10),
  (1, 11),
  (2, 10),
  (3, 12),
  (3, 11),
  (3, 12);

-- Insert test data into TournamentRegistration table
INSERT INTO community_schema.TournamentRegistration (TournamentID, PlayerID, RegistrationDate, RegistrationStatus)
VALUES
  (1, 10, '2022-02-15', 'Confirmed'),
  (1, 11, '2022-02-16', 'Confirmed'),
  (2, 10, '2022-02-20', 'Confirmed'),
  (3, 12, '2022-02-25', 'Pending'),
  (3, 11, '2022-02-26', 'Pending'),
  (3, 11, '2022-02-27', 'Confirmed');

-- Insert test data into Achievement table
INSERT INTO user_schema.Achievement (PlayerID, AchievementName, GameID, UnlockDate)
VALUES
  (10, 'First Achievement', 1, '2022-02-10'),
  (11, 'Great Explorer', 2, '2022-02-15'),
  (12, 'Master Gamer', 3, '2022-02-20');

-- Insert test data into Newsfeed table
INSERT INTO community_schema.Newsfeed (Content, AuthorID, PostDate)
VALUES
  ('Exciting News!', 10, '2022-03-01'),
  ('Game Updates', 11, '2022-03-05'),
  ('Community Highlights', 12, '2022-03-10');

-- Insert test data into TournamentLeaderboardHistory table
INSERT INTO community_schema.TournamentLeaderboardHistory (HistoryID, LeaderboardID, SnapshotDate, TeamID, GameID, Score) VALUES
(1, 1, '2024-02-01 08:00:00', 1, 3, 100),
(2, 1, '2024-02-02 08:00:00', 2, 3, 90),
(3, 2, '2024-02-03 08:00:00', 3, 2, 110),
(4, 2, '2024-02-04 08:00:00', 1, 2, 95),
(5, 3, '2024-02-01 08:00:00', 2, 1, 80),
(6, 3, '2024-02-02 08:00:00', 3, 1, 85);

-- Insert test data into NotificationQueue table
INSERT INTO store_schema.NotificationQueue (NotificationID, PlayerID, NotificationType, Message, IsRead, Timestamp)
VALUES
  (1, 10, 'System', 'Welcome to the tournament!', false, '2022-03-01 08:00:00'),
  (2, 11, 'Game', 'New achievement unlocked!', false, '2022-03-05 10:30:00'),
  (3, 12, 'Community', 'Your team is leading!', false, '2022-03-10 12:00:00');



