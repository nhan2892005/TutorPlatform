USE tutor_platform;
GO

CREATE OR ALTER FUNCTION fn_GetMentorAverageRating
(
    @UserId VARCHAR(20)
)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @AvgRating DECIMAL(3, 2);
    
    SELECT @AvgRating = mp.rating
    FROM MentorProfile mp
    WHERE mp.userId = @UserId;

    RETURN ISNULL(@AvgRating, 0.00);
END;
GO

CREATE OR ALTER FUNCTION fn_FindSuitableMentors
(
    @SkillKeyword NVARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        u.id AS MentorUserId,
        u.name AS MentorName,
        mp.rating,
        cm.bang_cap AS Specialization,
        (
            SELECT TOP 1 lt.ngay 
            FROM LichTrong lt 
            WHERE lt.mentor_id = mp.id AND lt.ngay >= CAST(GETDATE() AS DATE)
            ORDER BY lt.ngay ASC, lt.gio_bat_dau ASC
        ) AS NextAvailableDate
    FROM [User] u
    JOIN MentorProfile mp ON u.id = mp.userId
    JOIN ChuyenMon cm ON cm.mentor_id = mp.id
    WHERE u.user_type = 'MENTOR'
      AND u.account_status = 'Active'
      AND cm.bang_cap LIKE N'%' + @SkillKeyword + N'%'
);
GO

CREATE OR ALTER FUNCTION fn_GetUpcomingEvents
(
    @UserId VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        ce.id AS EventId,
        ce.title,
        ce.description,
        ce.startTime,
        ce.endTime,
        ce.priority,
        ea.status AS AssignmentStatus
    FROM CalendarEvent ce
    LEFT JOIN EventAssignment ea ON ea.eventId = ce.id
    WHERE 
        (ce.creatorId = @UserId OR ea.userId = @UserId)
        AND ce.startTime > GETDATE()
        AND ce.isCompleted = 0
        AND (ea.status IS NULL OR ea.status IN ('PENDING', 'ACCEPTED'))
);
GO