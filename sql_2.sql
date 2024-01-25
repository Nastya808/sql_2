CREATE TABLE Mountains (
    MountainID INT IDENTITY(1,1) PRIMARY KEY,
    MountainName NVARCHAR(100) NOT NULL,
    Height INT NOT NULL,
    Country NVARCHAR(50) NOT NULL,
    Region NVARCHAR(50) NOT NULL
);

CREATE TABLE Climbers (
    ClimberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Address NVARCHAR(100) NOT NULL
);

CREATE TABLE ClimbingGroups (
    GroupID INT IDENTITY(1,1) PRIMARY KEY,
    GroupName NVARCHAR(100) NOT NULL,
    MountainID INT FOREIGN KEY REFERENCES Mountains(MountainID),
    StartTime DATETIME NOT NULL
);

CREATE TABLE ClimbingEvents (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    GroupID INT FOREIGN KEY REFERENCES ClimbingGroups(GroupID),
    ClimberID INT FOREIGN KEY REFERENCES Climbers(ClimberID),
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL
);

CREATE PROCEDURE AddMountain
    @MountainName NVARCHAR(100),
    @Height INT,
    @Country NVARCHAR(50),
    @Region NVARCHAR(50)
AS
BEGIN
    INSERT INTO Mountains (MountainName, Height, Country, Region)
    VALUES (@MountainName, @Height, @Country, @Region);
END;

CREATE PROCEDURE EditMountain
    @MountainID INT,
    @MountainName NVARCHAR(100),
    @Height INT,
    @Country NVARCHAR(50),
    @Region NVARCHAR(50)
AS
BEGIN
    UPDATE Mountains
    SET MountainName = @MountainName, Height = @Height, Country = @Country, Region = @Region
    WHERE MountainID = @MountainID;
END;

CREATE PROCEDURE AddClimber
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Address NVARCHAR(100)
AS
BEGIN
    INSERT INTO Climbers (FirstName, LastName, Address)
    VALUES (@FirstName, @LastName, @Address);
END;

CREATE PROCEDURE EditClimber
    @ClimberID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Address NVARCHAR(100)
AS
BEGIN
    UPDATE Climbers
    SET FirstName = @FirstName, LastName = @LastName, Address = @Address
    WHERE ClimberID = @ClimberID;
END;

CREATE PROCEDURE DeleteClimber
    @ClimberID INT
AS
BEGIN
    DELETE FROM Climbers
    WHERE ClimberID = @ClimberID;
END;

CREATE PROCEDURE AddClimbingGroup
    @GroupName NVARCHAR(100),
    @MountainID INT,
    @StartTime DATETIME
AS
BEGIN
    INSERT INTO ClimbingGroups (GroupName, MountainID, StartTime)
    VALUES (@GroupName, @MountainID, @StartTime);
END;

CREATE PROCEDURE AddClimbingGroup
    @GroupName NVARCHAR(100),
    @MountainID INT,
    @StartTime DATETIME
AS
BEGIN
    INSERT INTO ClimbingGroups (GroupName, MountainID, StartTime)
    VALUES (@GroupName, @MountainID, @StartTime);
END;

CREATE PROCEDURE EditClimbingGroup
    @GroupID INT,
    @GroupName NVARCHAR(100),
    @MountainID INT,
    @StartTime DATETIME
AS
BEGIN
    UPDATE ClimbingGroups
    SET GroupName = @GroupName, MountainID = @MountainID, StartTime = @StartTime
    WHERE GroupID = @GroupID;
END;

CREATE PROCEDURE DeleteClimbingGroup
    @GroupID INT
AS
BEGIN
    DELETE FROM ClimbingGroups
    WHERE GroupID = @GroupID;
END;

CREATE PROCEDURE AddClimbingEvent
    @GroupID INT,
    @ClimberID INT,
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    INSERT INTO ClimbingEvents (GroupID, ClimberID, StartDate, EndDate)
    VALUES (@GroupID, @ClimberID, @StartDate, @EndDate);
END;

CREATE PROCEDURE EditClimbingEvent
    @EventID INT,
    @GroupID INT,
    @ClimberID INT,
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    UPDATE ClimbingEvents
    SET GroupID = @GroupID, ClimberID = @ClimberID, StartDate = @StartDate, EndDate = @EndDate
    WHERE EventID = @EventID;
END;

CREATE PROCEDURE DeleteClimbingEvent
    @EventID INT
AS
BEGIN
    DELETE FROM ClimbingEvents
    WHERE EventID = @EventID;
END;

SELECT m.MountainName, cg.GroupName, ce.StartDate, ce.EndDate
FROM Mountains m
JOIN ClimbingGroups cg ON m.MountainID = cg.MountainID
JOIN ClimbingEvents ce ON cg.GroupID = ce.GroupID
ORDER BY m.MountainName, ce.StartDate;

DECLARE @StartDate DATETIME = '2024-01-01';
DECLARE @EndDate DATETIME = '2024-12-31';

SELECT cl.FirstName, cl.LastName, ce.StartDate, ce.EndDate
FROM Climbers cl
JOIN ClimbingEvents ce ON cl.ClimberID = ce.ClimberID
WHERE ce.StartDate BETWEEN @StartDate AND @EndDate;

SELECT cl.FirstName, cl.LastName, m.MountainName, COUNT(ce.EventID) AS TotalClimbs
FROM Climbers cl
JOIN ClimbingEvents ce ON cl.ClimberID = ce.ClimberID
JOIN ClimbingGroups cg ON ce.GroupID = cg.GroupID
JOIN Mountains m ON cg.MountainID = m.MountainID
GROUP BY cl.FirstName, cl.LastName, m.MountainName
ORDER BY cl.LastName, cl.FirstName, m.MountainName;

CREATE PROCEDURE AddClimbingGroup
    @GroupName NVARCHAR(100),
    @MountainName NVARCHAR(100),
    @StartTime DATETIME
AS
BEGIN
    DECLARE @MountainID INT;
    SELECT @MountainID = MountainID FROM Mountains WHERE MountainName = @MountainName;

    INSERT INTO ClimbingGroups (GroupName, MountainID, StartTime)
    VALUES (@GroupName, @MountainID, @StartTime);
END;

SELECT m.MountainName, COUNT(DISTINCT cl.ClimberID) AS TotalClimbers
FROM Mountains m
JOIN ClimbingGroups cg ON m.MountainID = cg.MountainID
JOIN ClimbingEvents ce ON cg.GroupID = ce.GroupID
JOIN Climbers cl ON ce.ClimberID = cl.ClimberID
GROUP BY m.MountainName
ORDER BY m.MountainName;
