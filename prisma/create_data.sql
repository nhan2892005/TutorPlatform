use tutor_platform;
go

PRINT '===== BẮT ĐẦU TẠO FULL MOCK DATA (AUTO ID) =====';

-- =============================================
-- 1. INSERT USERS (16 USERS: 2 ADMIN, 6 MENTORS, 8 MENTEES)
-- =============================================
INSERT INTO [User] (name, email, user_type, department, major, account_status) VALUES
-- ADMIN
(N'Nguyễn Thiện Nhân', 'nhanthiennguyenooko@gmail.com', 'ADMIN', N'Ban Quản Trị', N'An ninh mạng', 'Active'),
(N'Nguyễn Quản Trị', 'admin@studyspace.vn', 'ADMIN', N'Phòng Đào Tạo', N'Quản trị hệ thống', 'Active'),

-- MENTORS (Bao gồm 2 bắt buộc)
(N'Trần Minh Tuấn', 'tuan.tran@studyspace.vn', 'MENTOR', N'CNTT', N'Kỹ thuật phần mềm', 'Active'),
(N'Lê Thị Mai', 'mai.le@studyspace.vn', 'MENTOR', N'Kinh Tế', N'Marketing', 'Active'),
(N'Phạm Văn Hoàng', 'hoang.pham@studyspace.vn', 'MENTOR', N'Ngoại Ngữ', N'Tiếng Anh Thương Mại', 'Active'),
(N'Võ Thanh Hà', 'ha.vo@studyspace.vn', 'MENTOR', N'CNTT', N'Khoa học dữ liệu', 'Active'),
(N'Nguyễn Thị Anh Thư', 'anhthuxuanyen@gmail.com', 'MENTOR', N'Design', N'UX/UI Design', 'Active'),
(N'Nguyễn Phúc Nhân', 'nhan.nguyen2005phuyen@hcmut.edu.vn', 'MENTOR', N'CNTT', N'Khoa học máy tính', 'Active'),

-- MENTEES (Bao gồm 2 bắt buộc)
(N'Nguyễn Văn An', 'an.nguyen@student.vn', 'MENTEE', N'CNTT', N'Hệ thống thông tin', 'Active'),
(N'Phan Bảo Ngọc', 'ngoc.phan@student.vn', 'MENTEE', N'Kinh Tế', N'Quản trị kinh doanh', 'Active'),
(N'Vũ Đức Đam', 'dam.vu@student.vn', 'MENTEE', N'CNTT', N'Kỹ thuật phần mềm', 'Active'),
(N'Hoàng Thùy Linh', 'linh.hoang@student.vn', 'MENTEE', N'Ngoại Ngữ', N'Tiếng Trung', 'Active'),
(N'Nguyễn Phúc Nhân', 'phucnhan289@gmail.com', 'MENTEE', N'Điện - Điện tử', N'Kỹ thuật Điều khiển & TĐH', 'Active'),
(N'Nguyễn Võ Vy Thương', 'nvythuogg@gmail.com', 'MENTEE', N'CNTT', N'Thiết kế web', 'Active'),
(N'Đặng Văn Lâm', 'lam.dang@student.vn', 'MENTEE', N'Kiến Trúc', N'Nội thất', 'Active'),
(N'Lương Xuân Trường', 'truong.luong@student.vn', 'MENTEE', N'Kinh Tế', N'Kế toán', 'Active');
GO

-- =============================================
-- 2. INSERT MENTOR PROFILES
-- =============================================
INSERT INTO MentorProfile (userId, rating, totalReviews) VALUES
((SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 4.8, 15),
((SELECT id FROM [User] WHERE email = 'mai.le@studyspace.vn'), 4.9, 20),
((SELECT id FROM [User] WHERE email = 'hoang.pham@studyspace.vn'), 4.5, 10),
((SELECT id FROM [User] WHERE email = 'ha.vo@studyspace.vn'), 5.0, 8),
((SELECT id FROM [User] WHERE email = 'anhthuxuanyen@gmail.com'), 4.7, 12),
((SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'), 4.9, 25);
GO

-- =============================================
-- 3. INSERT CHUYEN MON
-- =============================================
INSERT INTO [ChuyenMon] (mentor_id, bang_cap) VALUES
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn')), N'Java Spring Boot'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn')), N'AWS Solutions Architect'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'mai.le@studyspace.vn')), N'Digital Marketing Master'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'hoang.pham@studyspace.vn')), N'IELTS 8.0'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'ha.vo@studyspace.vn')), N'Google Data Analytics'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'anhthuxuanyen@gmail.com')), N'Figma UX/UI'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'anhthuxuanyen@gmail.com')), N'Adobe XD Advanced'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn')), N'Giải thuật & Cấu trúc dữ liệu (VNOI)'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn')), N'C++ Advanced Programming'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn')), N'MERN Stack');
GO

-- =============================================
-- 4. INSERT LICH TRONG (Lịch trống cho Mentors)
-- =============================================
DECLARE @MentorTuấn VARCHAR(20) = (SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'));
DECLARE @MentorAnhThư VARCHAR(20) = (SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'anhthuxuanyen@gmail.com'));
DECLARE @MentorNhan VARCHAR(20) = (SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'));

INSERT INTO LichTrong (mentor_id, ngay, gio_bat_dau, gio_ket_thuc) VALUES
(@MentorTuấn, '2024-10-15', '09:00', '10:00'),
(@MentorTuấn, '2024-10-16', '14:00', '15:30'),
(@MentorAnhThư, '2024-10-17', '10:00', '11:00'),
(@MentorAnhThư, '2024-10-18', '16:00', '17:30'),
(@MentorNhan, '2024-10-20', '19:00', '20:00'),
(@MentorNhan, '2024-10-21', '20:00', '21:30');
GO

-- =============================================
-- 5. INSERT MENTEE CONNECTION (Nhiều kết nối, tập trung user mẫu)
-- =============================================
DECLARE @MenteePhucNhan VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com');
DECLARE @MenteeVyThuong VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'nvythuogg@gmail.com');
DECLARE @MentorNhanUser VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn');
DECLARE @MentorAnhThuUser VARCHAR(20) = (SELECT id FROM [User] WHERE email = 'anhthuxuanyen@gmail.com');

INSERT INTO MenteeConnection (menteeId, mentorId, status) VALUES
-- Tập trung Phúc Nhân Mentee
(@MenteePhucNhan, @MentorNhanUser, 'ACCEPTED'),
(@MenteePhucNhan, (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 'PENDING'),
(@MenteePhucNhan, @MentorAnhThuUser, 'ACCEPTED'),

-- Vy Thương
(@MenteeVyThuong, @MentorAnhThuUser, 'ACCEPTED'),
(@MenteeVyThuong, @MentorNhanUser, 'PENDING'),

-- Khác
((SELECT id FROM [User] WHERE email = 'an.nguyen@student.vn'), (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 'ACCEPTED'),
((SELECT id FROM [User] WHERE email = 'ngoc.phan@student.vn'), (SELECT id FROM [User] WHERE email = 'mai.le@studyspace.vn'), 'ACCEPTED'),
((SELECT id FROM [User] WHERE email = 'dam.vu@student.vn'), (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 'PENDING'),
((SELECT id FROM [User] WHERE email = 'linh.hoang@student.vn'), (SELECT id FROM [User] WHERE email = 'hoang.pham@studyspace.vn'), 'ACCEPTED');
GO

-- =============================================
-- 6. INSERT CALENDAR EVENT & ASSIGNMENT (Lớp học, events)
-- =============================================
DECLARE @Event1 VARCHAR(20), @Event2 VARCHAR(20), @Event3 VARCHAR(20);

INSERT INTO CalendarEvent (title, description, startTime, endTime, priority, creatorId)
OUTPUT INSERTED.id INTO @Event1 VALUES ('Lớp C++ Advanced - Phúc Nhân', N'Học C++ với Mentor Nhân', '2024-10-20 19:00', '2024-10-20 20:00', 'HIGH', @MentorNhanUser);

INSERT INTO CalendarEvent (title, description, startTime, endTime, priority, creatorId)
OUTPUT INSERTED.id INTO @Event2 VALUES ('Workshop UX/UI - Vy Thương', N'Thiết kế Figma', '2024-10-17 10:00', '2024-10-17 11:00', 'MEDIUM', @MentorAnhThuUser);

INSERT INTO CalendarEvent (title, description, startTime, endTime, priority, creatorId)
OUTPUT INSERTED.id INTO @Event3 VALUES ('Họp Mentor Meeting', N'Tổng kết tuần', '2024-10-25 14:00', '2024-10-25 15:00', 'URGENT', (SELECT id FROM [User] WHERE email = 'nhanthiennguyenooko@gmail.com'));

-- Assignments
INSERT INTO EventAssignment (eventId, userId, status) VALUES
(@Event1, @MenteePhucNhan, 'ACCEPTED'),
(@Event2, @MenteeVyThuong, 'PENDING'),
(@Event3, @MentorNhanUser, 'ACCEPTED'),
(@Event3, @MentorAnhThuUser, 'ACCEPTED');
GO

-- =============================================
-- 7. INSERT PROGRESS RECORD
-- =============================================
INSERT INTO ProgressRecord (menteeId, score, notes) VALUES
(@MenteePhucNhan, 95.5, N'Xuất sắc thuật toán DP'),
(@MenteeVyThuong, 88.0, N'Tốt về Figma prototypes'),
((SELECT id FROM [User] WHERE email = 'an.nguyen@student.vn'), 75.0, N'Cần cải thiện Java');
GO

-- =============================================
-- 8. INSERT REPORTS VIEW
-- =============================================
INSERT INTO ReportsView (userId, title, description, visibility) VALUES
(@MentorNhanUser, N'Báo cáo Algo Training', N'Thống kê VNOI', 'Public'),
(@MenteePhucNhan, N'Tiến độ học C++', N'95% hoàn thành', 'Private'),
((SELECT id FROM [User] WHERE email = 'nhanthiennguyenooko@gmail.com'), N'Tổng quan Platform', N'Dữ liệu Q4', 'Private');
GO

-- =============================================
-- 9. INSERT POSTS, IMAGES, COMMENTS, REACTIONS
-- =============================================
DECLARE @PostPhucNhan VARCHAR(20), @PostVy VARCHAR(20);

INSERT INTO Post (content, authorId)
OUTPUT INSERTED.id INTO @PostPhucNhan VALUES (N'Ai rành mạch Arduino giúp mình với! Lỗi analog pin.', @MenteePhucNhan);

INSERT INTO Post (content, authorId)
OUTPUT INSERTED.id INTO @PostVy VALUES (N'Chia sẻ template Figma cho landing page?', @MenteeVyThuong);

-- Images
INSERT INTO Images (post_id, image_url) VALUES (@PostPhucNhan, '/images/arduino_error.png');
INSERT INTO Images (post_id, image_url) VALUES (@PostVy, '/images/figma_template.jpg');

-- Comments
INSERT INTO Comment (content, postId, authorId) VALUES
(N'Check chân A0 và reference voltage nhé.', @PostPhucNhan, @MentorNhanUser),
(N'Dùng template này: [link]', @PostVy, @MentorAnhThuUser);

-- Reactions
INSERT INTO Reaction (type, postId, userId) VALUES
('HEART', @PostPhucNhan, @MentorNhanUser),
('LIKE', @PostVy, @MenteePhucNhan);
GO

-- =============================================
-- 10. INSERT REVIEW & MENTOR FEEDBACK
-- =============================================
INSERT INTO Review (reviewerId, mentorId, rating, comment) VALUES
(@MenteePhucNhan, @MentorNhanUser, 5, N'Mentor Nhân dạy siêu hay!'),
(@MenteeVyThuong, @MentorAnhThuUser, 5, N'UX/UI pro thực thụ!');

INSERT INTO MentorFeedback (mentorId, menteeId, score, comment) VALUES
(@MentorNhanUser, @MenteePhucNhan, 98, N'Mentee chăm chỉ, code nhanh'),
(@MentorAnhThuUser, @MenteeVyThuong, 90, N'Thiện chí học hỏi');
GO

-- =============================================
-- 11. INSERT CHAT SERVER, MEMBER, INVITATION, CHANNEL
-- =============================================
DECLARE @ServerAlgo VARCHAR(20), @ServerUX VARCHAR(20);

INSERT INTO ChatServer (name, description, ownerId)
OUTPUT INSERTED.id INTO @ServerAlgo VALUES (N'HCMUT Algo Training', N'Luyện thuật toán VNOI', @MentorNhanUser);

INSERT INTO ChatServer (name, description, ownerId)
OUTPUT INSERTED.id INTO @ServerUX VALUES (N'UX/UI Design Community', N'Figma & Adobe XD', @MentorAnhThuUser);

-- Members
INSERT INTO ServerMember (serverId, userId, role) VALUES
(@ServerAlgo, @MenteePhucNhan, 'MEMBER'),
(@ServerUX, @MenteeVyThuong, 'MEMBER');

-- Invitations
INSERT INTO ServerInvitation (serverId, invitedUserId, invitedById, status) VALUES
(@ServerAlgo, @MenteeVyThuong, @MentorNhanUser, 'PENDING');

-- Channels
INSERT INTO Channel (name, description, serverId) VALUES
(N'general', N'Thảo luận chung', @ServerAlgo),
(N'dp', N'Quy hoạch động', @ServerAlgo),
(N'figma-help', N'Hỏi đáp Figma', @ServerUX);
GO

-- =============================================
-- 12. INSERT MESSAGES & FILES
-- =============================================
DECLARE @ChannelDP VARCHAR(20) = (SELECT id FROM Channel WHERE name = N'dp');
DECLARE @Msg1 VARCHAR(20);

INSERT INTO Message (content, authorId, channelId)
OUTPUT INSERTED.id INTO @Msg1 VALUES (N'Bài DP knapsack khó quá anh ơi.', @MenteePhucNhan, @ChannelDP);

INSERT INTO Message (content, authorId, channelId) VALUES
(N'Dùng memoization 2D nhé: code [paste]', @MentorNhanUser, @ChannelDP),
(N'File solution đính kèm.', @MentorNhanUser, @ChannelDP);

INSERT INTO [File] (name, url, size, messageId) VALUES
(N'knapsack_dp.cpp', '/files/knapsack.cpp', 2048, @Msg1);
GO

-- =============================================
-- 13. INSERT CHAT CONVERSATION & MESSAGES (Chatbot cá nhân)
-- =============================================
DECLARE @ConvPhucNhan VARCHAR(20);

INSERT INTO ChatConversation (userId, title)
OUTPUT INSERTED.id INTO @ConvPhucNhan VALUES (@MenteePhucNhan, N'Chatbot Algo Helper');

INSERT INTO ChatMessage (conversationId, content) VALUES
(@ConvPhucNhan, N'Bot: Chào Phúc Nhân! Hỏi gì về thuật toán?'),
(@ConvPhucNhan, N'User: Giải thích BFS?'),
(@ConvPhucNhan, N'Bot: BFS dùng Queue, visit level by level...');
GO

-- =============================================
-- 14. INSERT RECORDING
-- =============================================
INSERT INTO Recording (description, duration, channelId, recorderId) VALUES
(N'Recording lớp C++', 3600, @ChannelDP, @MentorNhanUser);
GO

PRINT '===== ĐÃ TẠO FULL DATA THÀNH CÔNG - TẤT CẢ BẢNG CÓ DỮ LIỆU! =====';
PRINT 'User mẫu:';
PRINT '- Mentee Phúc Nhân (phucnhan289@gmail.com): 2 connections ACCEPTED, progress 95.5, post Arduino, chat DP';
PRINT '- Admin Nhân (nhanthiennguyenooko@gmail.com): Tạo event meeting';
PRINT '- Mentor Nhân (nhan.nguyen2005phuyen@hcmut.edu.vn): Server Algo, 25 reviews';
PRINT '- Mentee Vy Thương (nvythuogg@gmail.com): Connection UX, post Figma';
PRINT '- Mentor Anh Thư (anhthuxuanyen@gmail.com): Server UX, chuyên Figma';
GO