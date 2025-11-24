USE StudySpace;
GO

-- =============================================
-- 1. HÀM LẤY ĐIỂM ĐÁNH GIÁ TRUNG BÌNH MENTOR
-- Tối ưu: Truy vấn trực tiếp bảng MentorProfile đã có sẵn cột rating (cache)
-- thay vì phải tính toán lại từ bảng Review mỗi lần gọi.
-- =============================================
CREATE OR ALTER FUNCTION fn_GetMentorAverageRating
(
    @UserId VARCHAR(20)
)
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @AvgRating DECIMAL(3, 2);
    
    -- MentorProfile liên kết với User qua userId
    SELECT @AvgRating = mp.rating
    FROM MentorProfile mp
    WHERE mp.userId = @UserId;

    RETURN ISNULL(@AvgRating, 0.00);
END;
GO

-- =============================================
-- 3. HÀM LẤY SỰ KIỆN SẮP TỚI (Inline TVF)
-- Tối ưu: Gom nhóm logic OR trong WHERE, kiểm tra trạng thái hoàn thành
-- =============================================
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
        (ce.creatorId = @UserId OR ea.userId = @UserId) -- Là người tạo hoặc người được gán
        AND ce.startTime > GETDATE()
        AND ce.isCompleted = 0 -- Sự kiện chưa hoàn thành
        AND (ea.status IS NULL OR ea.status IN ('PENDING', 'ACCEPTED')) -- Nếu được gán thì phải chưa từ chối
);
GO