USE StudySpace;
GO

-- =============================================
-- 1. TRIGGER TỰ ĐỘNG CẬP NHẬT RATING MENTOR
-- Logic: Khi bảng Review thay đổi (Insert/Update/Delete) -> Tính lại Avg Rating cho MentorProfile
-- Tối ưu: Dùng Common Table Expression (CTE) và Window Functions
-- =============================================
CREATE OR ALTER TRIGGER trg_UpdateMentorRatingStats
ON Review
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Tìm danh sách MentorId bị ảnh hưởng (từ cả bảng inserted và deleted)
    WITH AffectedMentors AS (
        SELECT mentorId FROM inserted
        UNION
        SELECT mentorId FROM deleted
    )
    -- 2. Cập nhật lại MentorProfile dựa trên tính toán Aggregate mới nhất
    UPDATE mp
    SET 
        mp.totalReviews = ISNULL(Stats.TotalCount, 0),
        mp.rating = ISNULL(Stats.AvgScore, 0.00),
        mp.updatedAt = GETDATE()
    FROM MentorProfile mp
    INNER JOIN AffectedMentors am ON mp.userId = am.mentorId -- Join UserID của Review với UserID của Profile
    OUTER APPLY (
        SELECT 
            COUNT(*) AS TotalCount,
            CAST(AVG(CAST(r.rating AS DECIMAL(10, 2))) AS DECIMAL(3, 2)) AS AvgScore
        FROM Review r
        WHERE r.mentorId = am.mentorId
    ) Stats;
END;
GO

-- =============================================
-- 2. TRIGGER TẠO THÔNG BÁO KHI CÓ KẾT NỐI MỚI
-- Logic: Insert vào MenteeConnection -> Insert vào Notification cho Mentor
-- =============================================
CREATE OR ALTER TRIGGER trg_NotifyNewConnection
ON MenteeConnection
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Notification (userId, title, content, isRead)
    SELECT 
        i.mentorId, -- Gửi cho Mentor
        N'Yêu cầu kết nối mới',
        N'Mentee ' + u.name + N' (' + u.email + N') muốn kết nối với bạn.',
        0
    FROM inserted i
    JOIN [User] u ON u.id = i.menteeId -- Lấy thông tin Mentee
    WHERE i.status = 'PENDING';
END;
GO

-- =============================================
-- 3. TRIGGER TẠO THÔNG BÁO KHI KẾT NỐI ĐƯỢC PHẢN HỒI
-- Logic: Update MenteeConnection -> Insert Notification cho Mentee
-- =============================================
CREATE OR ALTER TRIGGER trg_NotifyConnectionResponse
ON MenteeConnection
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ gửi khi status thay đổi
    INSERT INTO Notification (userId, title, content, isRead)
    SELECT 
        i.menteeId, -- Gửi cho Mentee
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
    JOIN [User] u ON u.id = i.mentorId -- Lấy thông tin Mentor
    WHERE i.status <> d.status -- Trạng thái thay đổi
      AND i.status IN ('ACCEPTED', 'REJECTED');
END;
GO

-- =============================================
-- 4. TRIGGER TỰ ĐỘNG TẠO REMINDER CHO SỰ KIỆN
-- Logic: Khi tạo CalendarEvent mới -> Tạo EventReminder mặc định (30p trước)
-- =============================================
CREATE OR ALTER TRIGGER trg_AutoCreateEventReminder
ON CalendarEvent
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO EventReminder (eventId, reminderTime, message, isActive)
    SELECT 
        i.id,
        DATEADD(MINUTE, -30, i.startTime), -- Nhắc trước 30 phút
        N'Sắp diễn ra: ' + i.title,
        1
    FROM inserted i
    WHERE i.startTime > GETDATE(); -- Chỉ tạo cho sự kiện tương lai
END;
GO