use tutor_platform;
go

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

CREATE OR ALTER PROCEDURE sp_AcceptConnectionAndInvite
    @ConnectionId VARCHAR(20),
    @MentorId VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Lấy thông tin connection
        DECLARE @MenteeId VARCHAR(20);
        SELECT @MenteeId = menteeId FROM MenteeConnection 
        WHERE id = @ConnectionId AND mentorId = @MentorId AND status = 'PENDING';

        IF @MenteeId IS NULL
            THROW 51000, N'Lỗi: Yêu cầu kết nối không tồn tại hoặc không thuộc về bạn.', 1;

        -- 2. Cập nhật trạng thái Connection
        UPDATE MenteeConnection
        SET status = 'ACCEPTED', updatedAt = GETDATE()
        WHERE id = @ConnectionId;

        -- 3. Tìm ChatServer do Mentor này sở hữu
        DECLARE @ServerId VARCHAR(20);
        SELECT TOP 1 @ServerId = id FROM ChatServer WHERE ownerId = @MentorId;

        -- 4. Nếu Mentor có Server, tự động mời Mentee vào
        IF @ServerId IS NOT NULL
        BEGIN
            -- Kiểm tra xem đã là thành viên chưa
            IF NOT EXISTS (SELECT 1 FROM ServerMember WHERE serverId = @ServerId AND userId = @MenteeId)
            BEGIN
                -- Thêm trực tiếp vào Member (Bỏ qua bước Invitation vì đã là Mentee ruột)
                INSERT INTO ServerMember (serverId, userId, role)
                VALUES (@ServerId, @MenteeId, 'MEMBER');
                
                PRINT N'Đã chấp nhận kết nối và thêm Mentee vào Community của Mentor.';
            END
        END
        ELSE
        BEGIN
            PRINT N'Đã chấp nhận kết nối (Mentor chưa có Server riêng).';
        END

        COMMIT TRANSACTION;
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