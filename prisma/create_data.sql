USE tutor_platform;
GO

-- =============================================
-- 1. INSERT USERS
-- =============================================
INSERT INTO [User] (name, email, user_type, department, major, account_status) VALUES
(N'Nguyễn Quản Trị', 'admin@studyspace.vn', 'ADMIN', N'Phòng Đào Tạo', N'Quản trị hệ thống', 'Active'),
(N'Trần Minh Tuấn', 'tuan.tran@studyspace.vn', 'MENTOR', N'CNTT', N'Kỹ thuật phần mềm', 'Active'),
(N'Lê Thị Mai', 'mai.le@studyspace.vn', 'MENTOR', N'Kinh Tế', N'Marketing', 'Active'),
(N'Phạm Văn Hoàng', 'hoang.pham@studyspace.vn', 'MENTOR', N'Ngoại Ngữ', N'Tiếng Anh Thương Mại', 'Active'),
(N'Võ Thanh Hà', 'ha.vo@studyspace.vn', 'MENTOR', N'CNTT', N'Khoa học dữ liệu', 'Active'),
(N'Đỗ Quang Huy', 'huy.do@studyspace.vn', 'MENTOR', N'Kiến Trúc', N'Thiết kế đồ họa', 'Active'),
(N'Nguyễn Văn An', 'an.nguyen@student.vn', 'MENTEE', N'CNTT', N'Hệ thống thông tin', 'Active'),
(N'Phan Bảo Ngọc', 'ngoc.phan@student.vn', 'MENTEE', N'Kinh Tế', N'Quản trị kinh doanh', 'Active'),
(N'Vũ Đức Đam', 'dam.vu@student.vn', 'MENTEE', N'CNTT', N'Kỹ thuật phần mềm', 'Active'),
(N'Hoàng Thùy Linh', 'linh.hoang@student.vn', 'MENTEE', N'Ngoại Ngữ', N'Tiếng Trung', 'Active'),
(N'Đặng Văn Lâm', 'lam.dang@student.vn', 'MENTEE', N'Kiến Trúc', N'Nội thất', 'Active'),
(N'Bùi Tiến Dũng', 'dung.bui@student.vn', 'MENTEE', N'CNTT', N'An toàn thông tin', 'Active'),
(N'Lương Xuân Trường', 'truong.luong@student.vn', 'MENTEE', N'Kinh Tế', N'Kế toán', 'Active'),
(N'Nguyễn Phúc Nhân', 'nhanthiennguyenooko@gmail.com', 'ADMIN', N'Ban Quản Trị', N'An ninh mạng', 'Active'), -- Admin
(N'Nguyễn Phúc Nhân', 'nhan.nguyen2005phuyen@hcmut.edu.vn', 'MENTOR', N'Khoa học & Kỹ thuật Máy tính', N'Khoa học máy tính', 'Active'), -- Mentor
(N'Nguyễn Phúc Nhân', 'phucnhan289@gmail.com', 'MENTEE', N'Điện - Điện tử', N'Kỹ thuật Điều khiển & TĐH', 'Active'), -- Mentee
(N'Nguyễn Võ Vy Thương', 'nvythuogg@gmail.com', 'MENTEE', N'CNTT', N'Kỹ thuật phần mềm', 'Active'), -- Mentee
(N'Nguyễn Thị Anh Thư', 'anhthuxuanyen@gmail.com', 'MENTOR', N'Kinh Tế', N'Quản trị kinh doanh', 'Active'), -- Mentor
(N'Trần Văn Aanh', 'a.tran@mentor.vn', 'MENTOR', N'CNTT', N'AI & Machine Learning', 'Active'),
(N'Lê Thị Bình', 'b.le@mentor.vn', 'MENTOR', N'Kinh Tế', N'Finance', 'Active'),
(N'Phạm Minh Cương', 'c.pham@mentor.vn', 'MENTOR', N'Ngoại Ngữ', N'Tiếng Nhật', 'Active'),
(N'Nguyễn Thị Dung', 'd.nguyen@mentor.vn', 'MENTOR', N'CNTT', N'Blockchain', 'Active'),
(N'Vũ Văn Em', 'e.vu@mentor.vn', 'MENTOR', N'Kiến Trúc', N'Xây dựng', 'Active'),
(N'Đỗ Thị Phát', 'f.do@mentor.vn', 'MENTOR', N'Khoa học', N'Sinh học', 'Active'),
(N'Hồ Minh Giang', 'g.ho@mentor.vn', 'MENTOR', N'CNTT', N'Cyber Security', 'Active'),
(N'Ly Văn Hứa', 'h.ly@mentor.vn', 'MENTOR', N'Kinh Tế', N'Logistics', 'Active'),
(N'Kim Thị In', 'i.kim@mentor.vn', 'MENTOR', N'Ngoại Ngữ', N'Tiếng Hàn', 'Active'),
(N'Bùi Văn Khum', 'k.bui@mentor.vn', 'MENTOR', N'CNTT', N'DevOps', 'Active'),
(N'Trần Thị Linh', 'l.tran@student.vn', 'MENTEE', N'CNTT', N'Kỹ thuật phần mềm', 'Active'),
(N'Nguyễn Văn Mỹ', 'm.nguyen@student.vn', 'MENTEE', N'Kinh Tế', N'Marketing', 'Active'),
(N'Lê Văn Nhung', 'n.le@student.vn', 'MENTEE', N'Ngoại Ngữ', N'Tiếng Anh', 'Active'),
(N'Phạm Thị Ong', 'o.pham@student.vn', 'MENTEE', N'CNTT', N'Data Science', 'Active'),
(N'Vũ Thị Phát', 'p.vu@student.vn', 'MENTEE', N'Kiến Trúc', N'Nội thất', 'Active'),
(N'Đỗ Văn Quế', 'q.do@student.vn', 'MENTEE', N'Khoa học', N'Vật lý', 'Active'),
(N'Hồ Thị Rinh', 'r.ho@student.vn', 'MENTEE', N'CNTT', N'AI', 'Active'),
(N'Ly Văn Sùng', 's.ly@student.vn', 'MENTEE', N'Kinh Tế', N'Kế toán', 'Active'),
(N'Kim Văn Thúy', 't.kim@student.vn', 'MENTEE', N'Ngoại Ngữ', N'Tiếng Pháp', 'Active'),
(N'Bùi Thị Ung', 'u.bui@student.vn', 'MENTEE', N'CNTT', N'Web Development', 'Active'),
(N'Trần Văn Vinh', 'v.tran@student.vn', 'MENTEE', N'Điện - Điện tử', N'Điện tử', 'Active'),
(N'Nguyễn Thị Xinh', 'x.nguyen@student.vn', 'MENTEE', N'Kinh Tế', N'Quản trị', 'Active'),
(N'Lê Văn Yên', 'y.le@student.vn', 'MENTEE', N'CNTT', N'Mobile Dev', 'Active'),
(N'Phạm Văn Sen', 'z.pham@student.vn', 'MENTEE', N'Ngoại Ngữ', N'Tiếng Đức', 'Active'),
(N'Vũ Văn An', 'aa.vu@student.vn', 'MENTEE', N'Kiến Trúc', N'Thiết kế', 'Active');
GO

DECLARE @AdminNPN VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'nhanthiennguyenooko@gmail.com');
DECLARE @MentorNPN VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn');
DECLARE @MenteeNPN VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com');
DECLARE @MenteeVyThuong VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'nvythuogg@gmail.com');
DECLARE @MentorAnhThu VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'anhthuxuanyen@gmail.com');
DECLARE @MentorTuan VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn');
DECLARE @MentorMai VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'mai.le@studyspace.vn');
DECLARE @MentorHoang VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'hoang.pham@studyspace.vn');
DECLARE @MenteeAn VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'an.nguyen@student.vn');
DECLARE @MenteeNgoc VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'ngoc.phan@student.vn');
DECLARE @MentorA VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'a.tran@mentor.vn');
DECLARE @MenteeL VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'l.tran@student.vn');
GO

-- =============================================
-- 3. INSERT MENTOR PROFILES
-- =============================================
INSERT INTO MentorProfile (userId, rating, totalReviews) VALUES
(@MentorTuan, 4.8, 15), (@MentorMai, 4.9, 20), (@MentorHoang, 4.5, 10), (@MentorNPN, 5.0, 25), (@MentorAnhThu, 4.7, 18),
(@MentorA, 4.6, 12), ( (SELECT id FROM [User] WHERE email = 'b.le@mentor.vn'), 4.4, 9), ( (SELECT id FROM [User] WHERE email = 'c.pham@mentor.vn'), 4.3, 7),
( (SELECT id FROM [User] WHERE email = 'd.nguyen@mentor.vn'), 4.9, 22), ( (SELECT id FROM [User] WHERE email = 'e.vu@mentor.vn'), 4.1, 5),
( (SELECT id FROM [User] WHERE email = 'f.do@mentor.vn'), 4.8, 14), ( (SELECT id FROM [User] WHERE email = 'g.ho@mentor.vn'), 5.0, 30),
( (SELECT id FROM [User] WHERE email = 'h.ly@mentor.vn'), 4.2, 6), ( (SELECT id FROM [User] WHERE email = 'i.kim@mentor.vn'), 4.7, 16),
( (SELECT id FROM [User] WHERE email = 'k.bui@mentor.vn'), 4.5, 11);
GO

-- =============================================
-- 4. INSERT CHUYÊN MÔN
-- =============================================
DECLARE @MP_NPN VARCHAR(20) = (SELECT id FROM MentorProfile WHERE userId = @MentorNPN);
DECLARE @MP_AnhThu VARCHAR(20) = (SELECT id FROM MentorProfile WHERE userId = @MentorAnhThu);

INSERT INTO [ChuyenMon] (mentor_id, bang_cap) VALUES
(@MP_NPN, N'Giải thuật & Cấu trúc dữ liệu (VNOI)'), (@MP_NPN, N'C++ Advanced Programming'), (@MP_NPN, N'MERN Stack'), (@MP_NPN, N'Competitive Programming Gold'),
(@MP_AnhThu, N'Quản trị kinh doanh nâng cao'), (@MP_AnhThu, N'Marketing Digital Pro'), (@MP_AnhThu, N'Leadership MBA'),
( (SELECT id FROM MentorProfile WHERE userId = @MentorTuan), N'Java Spring Boot'), ( (SELECT id FROM MentorProfile WHERE userId = @MentorMai), N'Digital Marketing Master'),
( (SELECT id FROM MentorProfile WHERE userId = @MentorA), N'AI TensorFlow'), ( (SELECT id FROM MentorProfile WHERE userId = @MentorA), N'Python ML');
GO

-- =============================================
-- 5. INSERT LỊCH TRỐNG
-- =============================================
INSERT INTO [LichTrong] (mentor_id, ngay, gio_bat_dau, gio_ket_thuc) VALUES
(@MP_NPN, '2024-10-15', '08:00:00', '10:00:00'), (@MP_NPN, '2024-10-16', '14:00:00', '16:00:00'), (@MP_NPN, '2024-10-17', '09:00:00', '12:00:00'),
(@MP_NPN, '2024-10-18', '13:00:00', '15:00:00'), (@MP_NPN, '2024-10-20', '10:00:00', '11:00:00'),
(@MP_AnhThu, '2024-10-15', '09:00:00', '11:00:00'), (@MP_AnhThu, '2024-10-19', '15:00:00', '17:00:00'),
( (SELECT id FROM MentorProfile WHERE userId = @MentorTuan), '2024-10-16', '10:00:00', '12:00:00');
GO

-- =============================================
-- 6. INSERT MENTEE CONNECTION
-- =============================================
INSERT INTO MenteeConnection (menteeId, mentorId, status) VALUES
(@MenteeNPN, @MentorNPN, 'PENDING'), (@MenteeNPN, @MentorAnhThu, 'PENDING'), (@MenteeNPN, @MentorTuan, 'PENDING'),
(@MenteeVyThuong, @MentorNPN, 'PENDING'), (@MenteeVyThuong, @MentorAnhThu, 'PENDING'), (@MenteeAn, @MentorNPN, 'ACCEPTED'),
(@MenteeNgoc, @MentorMai, 'ACCEPTED'), (@MenteeL, @MentorA, 'PENDING'),
( (SELECT id FROM [User] WHERE email = 'm.nguyen@student.vn'), @MentorNPN, 'PENDING'),
( (SELECT id FROM [User] WHERE email = 'n.le@student.vn'), @MentorAnhThu, 'ACCEPTED');
GO

DECLARE @ConnNPN_NPN VARCHAR(20) = (SELECT id FROM MenteeConnection WHERE menteeId = @MenteeNPN AND mentorId = @MentorNPN);
DECLARE @ConnVy_NPN VARCHAR(20) = (SELECT id FROM MenteeConnection WHERE menteeId = @MenteeVyThuong AND mentorId = @MentorNPN);

UPDATE MenteeConnection SET status = 'ACCEPTED', updatedAt = GETDATE() WHERE id IN (@ConnNPN_NPN, @ConnVy_NPN);
GO

-- =============================================
-- 7. INSERT CALENDAR EVENTS
-- =============================================
INSERT INTO CalendarEvent (title, description, startTime, endTime, priority, creatorId) VALUES
(N'Họp mentor với Mentee NPN', N'Hướng dẫn giải thuật', '2024-10-20 10:00:00', '2024-10-20 11:00:00', 'HIGH', @MentorNPN),
(N'Lớp học Marketing', N'Cho Vy Thương', '2024-10-22 14:00:00', '2024-10-22 16:00:00', 'MEDIUM', @MentorAnhThu),
(N'Webinar AI', N'Mở cho tất cả', '2024-10-25 09:00:00', '2024-10-25 12:00:00', 'URGENT', @MentorA),
(N'Buổi tư vấn cá nhân', N'Với Nguyễn Văn An', '2024-10-18 15:00:00', '2024-10-18 16:00:00', 'LOW', @MentorTuan);
GO

DECLARE @Event1 VARCHAR(20) = (SELECT TOP 1 id FROM CalendarEvent WHERE title = N'Họp mentor với Mentee NPN');
INSERT INTO EventAssignment (eventId, userId, status) VALUES
(@Event1, @MenteeNPN, 'ACCEPTED'), (@Event1, @MenteeVyThuong, 'PENDING');
GO

-- =============================================
-- 8. INSERT PROGRESS RECORD
-- =============================================
INSERT INTO ProgressRecord (menteeId, score, notes) VALUES
(@MenteeNPN, 95.5, N'Hoàn thành module Giải thuật nâng cao'), (@MenteeNPN, 88.0, N'Cải thiện C++'),
(@MenteeVyThuong, 92.0, N'Tốt Marketing cơ bản'), (@MenteeAn, 85.0, N'Java Spring Boot');
GO

-- =============================================
-- 9. INSERT REPORTS VIEW
-- =============================================
INSERT INTO ReportsView (userId, title, description, visibility) VALUES
(@AdminNPN, N'Báo cáo hệ thống', N'Tổng quan user', 'Private'),
(@MentorNPN, N'Báo cáo mentee', N'Tiến độ NPN & Vy Thương', 'Private');
GO

-- =============================================
-- 10. INSERT POSTS, IMAGES, COMMENTS, REACTIONS
-- =============================================
INSERT INTO Post (content, authorId) VALUES
(N'Lộ trình học ReactJS cho người mới?', @MenteeNPN), (N'Chia sẻ tài liệu Competitive Programming.', @MentorNPN),
(N'Hỏi về Arduino IoT', @MenteeVyThuong), (N'Mẹo Marketing 2024', @MentorAnhThu),
(N'Cách học AI nhanh?', @MenteeL);
GO

DECLARE @PostNPN1 VARCHAR(20) = (SELECT TOP 1 id FROM Post WHERE authorId = @MenteeNPN);
DECLARE @PostVy VARCHAR(20) = (SELECT TOP 1 id FROM Post WHERE authorId = @MenteeVyThuong);

INSERT INTO Images (post_id, image_url) VALUES
(@PostNPN1, N'https://example.com/image1.jpg'), (@PostVy, N'https://example.com/image2.png');

INSERT INTO Comment (content, postId, authorId) VALUES
(N'Học trên F8 nhé bạn.', @PostNPN1, @MentorNPN), (N'Em check lại chân tín hiệu nhé.', @PostVy, @MentorAnhThu);

INSERT INTO Reaction (type, postId, userId) VALUES
('LIKE', @PostNPN1, @MentorNPN), ('HEART', @PostVy, @MenteeNPN);
GO

-- =============================================
-- 11. INSERT REVIEWS & MENTOR FEEDBACK
-- =============================================
INSERT INTO Review (reviewerId, mentorId, rating, comment) VALUES
(@MenteeNPN, @MentorNPN, 5, N'Mentor dạy siêu hay!'), (@MenteeVyThuong, @MentorNPN, 5, N'10 điểm'),
(@MenteeAn, @MentorTuan, 4, N'Tốt'),
(@MenteeL, @MentorA, 5, N'Excellent');

INSERT INTO MentorFeedback (mentorId, menteeId, score, comment) VALUES
(@MentorNPN, @MenteeNPN, 98, N'Học giỏi, chăm chỉ'), (@MentorAnhThu, @MenteeVyThuong, 95, N'Tích cực');
GO

-- =============================================
-- 12. INSERT CHAT SERVERS, CHANNELS, MESSAGES, FILES, RECORDINGS
-- =============================================
INSERT INTO ChatServer (name, description, ownerId) VALUES
(N'Cộng đồng Algo NPN', N'Luyện thuật toán với NPN', @MentorNPN),
(N'Marketing Hub Anh Thư', N'Chia sẻ kinh doanh', @MentorAnhThu),
(N'Java Community', N'Java Spring Boot', @MentorTuan);

DECLARE @ServerNPN VARCHAR(20) = (SELECT id FROM ChatServer WHERE name = N'Cộng đồng Algo NPN');
DECLARE @ServerAnhThu VARCHAR(20) = (SELECT id FROM ChatServer WHERE name = N'Marketing Hub Anh Thư');

INSERT INTO ServerMember (serverId, userId, role) VALUES
(@ServerNPN, @MenteeNPN, 'MEMBER'), (@ServerNPN, @MenteeVyThuong, 'MEMBER'), (@ServerAnhThu, @MenteeVyThuong, 'MEMBER');

INSERT INTO ServerInvitation (serverId, invitedUserId, invitedById, status) VALUES
(@ServerNPN, @MenteeAn, @MentorNPN, 'PENDING');

INSERT INTO Channel (name, description, serverId) VALUES
(N'general', N'Chung', @ServerNPN), (N'dp-help', N'Quy hoạch động', @ServerNPN),
(N'marketing-tips', N'Mẹo hay', @ServerAnhThu);

DECLARE @ChannelDP VARCHAR(20) = (SELECT id FROM Channel WHERE name = N'dp-help' AND serverId = @ServerNPN);

INSERT INTO Message (content, authorId, channelId) VALUES
(N'Bài Knapsack khó quá anh ơi.', @MenteeNPN, @ChannelDP), (N'Dùng DP 2D là ra.', @MentorNPN, @ChannelDP),
(N'Hello everyone!', @MenteeVyThuong, @ChannelDP);

INSERT INTO [File] (name, url, size, messageId) VALUES
(N'dp_code.cpp', N'https://example.com/dp.cpp', 1024, (SELECT TOP 1 id FROM Message WHERE content LIKE N'%DP 2D%'));

INSERT INTO Recording (description, duration, channelId, recorderId) VALUES
(N'Ghi âm buổi giải DP', 3600, @ChannelDP, @MentorNPN);
GO

-- =============================================
-- 13. INSERT CHAT CONVERSATION & MESSAGES
-- =============================================
INSERT INTO ChatConversation (userId, title) VALUES
(@MenteeNPN, N'Chat với Bot Algo'), (@MenteeVyThuong, N'Chat Marketing Bot');

DECLARE @ConvNPN VARCHAR(20) = (SELECT id FROM ChatConversation WHERE userId = @MenteeNPN);

INSERT INTO ChatMessage (conversationId, content) VALUES
(@ConvNPN, N'Bot: Chào bạn, hỏi về DP đi!'), (@ConvNPN, N'Mentee: Knapsack là gì?'),
(@ConvNPN, N'Bot: Đây là bài toán ba lô...'), -- Thêm 20 tin nhắn giả chatbot
(@ConvNPN, N'Mentee: Cảm ơn bot!');
GO

-- =============================================
-- 14. INSERT NOTIFICATIONS
-- =============================================
INSERT INTO Notification (title, content, userId, isRead) VALUES
(N'Thông báo hệ thống', N'Chào mừng Nguyễn Phúc Nhân!', @MenteeNPN, 0),
(N'Update mới', N'Có event mới', @MentorNPN, 0);
GO
