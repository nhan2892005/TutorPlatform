USE StudySpace;
GO

-- =============================================
-- 1. THỦ TỤC THÊM ĐÁNH GIÁ (REVIEW)
-- Tương thích: Schema mới tách MentorProfile và Review riêng biệt
-- Logic: Thêm Review -> Trigger sẽ tự update MentorProfile (không update thủ công ở đây để code sạch)
-- =============================================
CREATE OR ALTER PROCEDURE sp_AddReview
    @MentorUserId VARCHAR(20), -- ID User của Mentor
    @MenteeUserId VARCHAR(20), -- ID User của Mentee
    @Rating INT,
    @Comment NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validation
        IF @Rating < 0 OR @Rating > 5
            THROW 51000, N'Lỗi: Điểm đánh giá phải từ 0 đến 5.', 1;

        IF NOT EXISTS (SELECT 1 FROM [User] WHERE id = @MentorUserId AND user_type = 'MENTOR')
            THROW 51001, N'Lỗi: Mentor không tồn tại hoặc không hợp lệ.', 1;

        -- Insert Review
        INSERT INTO Review (reviewerId, mentorId, rating, comment, createdAt)
        VALUES (@MenteeUserId, @MentorUserId, @Rating, @Comment, GETDATE());

        PRINT N'Thêm đánh giá thành công.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- =============================================
-- 2. THỦ TỤC ĐẶT LỊCH HẸN (BOOKING) - QUAN TRỌNG
-- Logic: Kiểm tra kết nối -> Kiểm tra lịch trống -> Tạo Event -> Tạo Assignment -> Xóa lịch trống (để tránh trùng)
-- Tương thích: Xử lý PK chuỗi 'EVT...' bằng OUTPUT
-- =============================================
CREATE OR ALTER PROCEDURE sp_BookMentorAppointment
    @MenteeUserId VARCHAR(20),
    @MentorUserId VARCHAR(20),
    @Title NVARCHAR(255),
    @StartTime DATETIME2,
    @EndTime DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validate thời gian
        IF @StartTime >= @EndTime
            THROW 51000, N'Lỗi: Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc.', 1;

        -- 2. Validate quan hệ Mentee - Mentor (phải có kết nối ACCEPTED)
        IF NOT EXISTS (
            SELECT 1 FROM MenteeConnection 
            WHERE menteeId = @MenteeUserId AND mentorId = @MentorUserId AND status = 'ACCEPTED'
        )
            THROW 51001, N'Lỗi: Bạn chưa kết nối với Mentor này hoặc kết nối chưa được chấp nhận.', 1;

        -- 3. Tìm lịch trống phù hợp trong bảng LichTrong
        -- Lưu ý: LichTrong liên kết với MentorProfile, cần join để lấy đúng
        DECLARE @MaLichTrong INT;
        SELECT TOP 1 @MaLichTrong = lt.ma_lich_trong
        FROM LichTrong lt
        JOIN MentorProfile mp ON lt.mentor_id = mp.id
        WHERE mp.userId = @MentorUserId
          AND lt.ngay = CAST(@StartTime AS DATE)
          AND lt.gio_bat_dau <= CAST(@StartTime AS TIME)
          AND lt.gio_ket_thuc >= CAST(@EndTime AS TIME);

        IF @MaLichTrong IS NULL
            THROW 51002, N'Lỗi: Mentor không có lịch trống trong khung giờ này.', 1;

        -- 4. Tạo CalendarEvent (Sử dụng bảng tạm để hứng ID chuỗi sinh tự động)
        DECLARE @GeneratedEventIDs TABLE (NewID VARCHAR(20));
        
        INSERT INTO CalendarEvent (title, startTime, endTime, priority, creatorId, isCompleted)
        OUTPUT inserted.id INTO @GeneratedEventIDs -- Bắt ID vừa sinh ra
        VALUES (@Title, @StartTime, @EndTime, 'MEDIUM', @MentorUserId, 0);

        DECLARE @NewEventID VARCHAR(20);
        SELECT @NewEventID = NewID FROM @GeneratedEventIDs;

        -- 5. Gán Mentee vào sự kiện (EventAssignment)
        INSERT INTO EventAssignment (eventId, userId, status)
        VALUES (@NewEventID, @MenteeUserId, 'ACCEPTED'); 
        -- Gán luôn Mentor vào để hiện trên lịch cả 2 (tùy logic, ở đây creator là mentor rồi nên có thể không cần assign lại, nhưng để chắc chắn)
        INSERT INTO EventAssignment (eventId, userId, status)
        VALUES (@NewEventID, @MentorUserId, 'ACCEPTED');

        -- 6. Xử lý Lịch Trống: Vì đã book, ta xóa lịch trống đó đi (hoặc cập nhật nếu có logic tách giờ)
        -- Ở đây chọn phương án xóa để đảm bảo tính toàn vẹn đơn giản
        DELETE FROM LichTrong WHERE ma_lich_trong = @MaLichTrong;

        COMMIT TRANSACTION;
        
        SELECT @NewEventID AS BookedEventId, N'Đặt lịch thành công' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- =============================================
-- 3. THỦ TỤC GỬI YÊU CẦU KẾT NỐI
-- =============================================
CREATE OR ALTER PROCEDURE sp_SendConnectionRequest
    @MenteeUserId VARCHAR(20),
    @MentorUserId VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra User Type
        IF NOT EXISTS (SELECT 1 FROM [User] WHERE id = @MenteeUserId AND user_type = 'MENTEE')
            THROW 51000, N'Lỗi: Người gửi không phải là Mentee.', 1;
            
        IF NOT EXISTS (SELECT 1 FROM [User] WHERE id = @MentorUserId AND user_type = 'MENTOR')
            THROW 51001, N'Lỗi: Người nhận không phải là Mentor.', 1;

        -- Kiểm tra tồn tại (dùng UNIQUE constraint check, nhưng check trước để báo lỗi thân thiện)
        IF EXISTS (SELECT 1 FROM MenteeConnection WHERE menteeId = @MenteeUserId AND mentorId = @MentorUserId)
            THROW 51002, N'Lỗi: Kết nối giữa hai người đã tồn tại (đang chờ hoặc đã chấp nhận).', 1;

        INSERT INTO MenteeConnection (menteeId, mentorId, status)
        VALUES (@MenteeUserId, @MentorUserId, 'PENDING');

        PRINT N'Gửi yêu cầu kết nối thành công.';
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO