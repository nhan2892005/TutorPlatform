USE tutor_platform;
GO

CREATE OR ALTER TRIGGER trg_UpdateMentorRatingStats
ON Review
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    WITH AffectedMentors AS (
        SELECT mentorId FROM inserted
        UNION
        SELECT mentorId FROM deleted
    )
    UPDATE mp
    SET 
        mp.totalReviews = ISNULL(Stats.TotalCount, 0),
        mp.rating = ISNULL(Stats.AvgScore, 0.00),
        mp.updatedAt = GETDATE()
    FROM MentorProfile mp
    INNER JOIN AffectedMentors am ON mp.userId = am.mentorId
    OUTER APPLY (
        SELECT 
            COUNT(*) AS TotalCount,
            CAST(AVG(CAST(r.rating AS DECIMAL(10, 2))) AS DECIMAL(3, 2)) AS AvgScore
        FROM Review r
        WHERE r.mentorId = am.mentorId
    ) Stats;
END;
GO

CREATE OR ALTER TRIGGER trg_NotifyNewConnection
ON MenteeConnection
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notification (userId, title, content, isRead)
    SELECT 
        i.mentorId,
        N'Yêu cầu kết nối mới',
        N'Mentee ' + u.name + N' (' + u.email + N') muốn kết nối với bạn.',
        0
    FROM inserted i
    JOIN [User] u ON u.id = i.menteeId
    WHERE i.status = 'PENDING';
END;
GO

CREATE OR ALTER TRIGGER trg_NotifyConnectionResponse
ON MenteeConnection
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notification (userId, title, content, isRead)
    SELECT 
        i.menteeId,
        CASE 
            WHEN i.status = 'ACCEPTED' THEN N'Kết nối được chấp nhận'
            ELSE N'Kết nối bị từ chối'
        END,
        CASE 
            WHEN i.status = 'ACCEPTED' THEN N'Mentor ' + u.name + N' đã đồng ý kết nối.'
            ELSE N'Mentor ' + u.name + N' đã từ chối yêu cầu của bạn.'
        END,
        0
    FROM inserted i
    JOIN deleted d ON i.id = d.id
    JOIN [User] u ON u.id = i.mentorId
    WHERE i.status <> d.status
      AND i.status IN ('ACCEPTED', 'REJECTED');
END;
GO

CREATE OR ALTER TRIGGER trg_AutoCreateEventReminder
ON CalendarEvent
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO EventReminder (eventId, reminderTime, message, isActive)
    SELECT 
        i.id,
        DATEADD(MINUTE, -30, i.startTime),
        N'Sắp diễn ra: ' + i.title,
        1
    FROM inserted i
    WHERE i.startTime > GETDATE();
END;
GO