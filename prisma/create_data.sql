PRINT '===== BẮT ĐẦU TẠO MOCK DATA (AUTO ID) =====';

-- =============================================
-- 1. INSERT USERS (KHÔNG CẦN ĐIỀN ID)
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
(N'Nguyễn Thiện Nhân', 'nhanthiennguyenooko@gmail.com', 'ADMIN', N'Ban Quản Trị', N'An ninh mạng', 'Active'),
(N'Nguyễn Phúc Nhân', 'nhan.nguyen2005phuyen@hcmut.edu.vn', 'MENTOR', N'Khoa học & Kỹ thuật Máy tính', N'Khoa học máy tính', 'Active'),
(N'Nguyễn Phúc Nhân', 'phucnhan289@gmail.com', 'MENTEE', N'Điện - Điện tử', N'Kỹ thuật Điều khiển & TĐH', 'Active');
GO

-- =============================================
-- 2. INSERT MENTOR PROFILES
-- =============================================
INSERT INTO MentorProfile (userId, rating, totalReviews) VALUES
((SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 4.8, 15),
((SELECT id FROM [User] WHERE email = 'mai.le@studyspace.vn'), 4.9, 20),
((SELECT id FROM [User] WHERE email = 'hoang.pham@studyspace.vn'), 4.5, 10),
((SELECT id FROM [User] WHERE email = 'ha.vo@studyspace.vn'), 5.0, 8),
((SELECT id FROM [User] WHERE email = 'huy.do@studyspace.vn'), 4.2, 5),
((SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'), 5.0, 3);
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
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn')), N'Giải thuật & Cấu trúc dữ liệu (VNOI)'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn')), N'C++ Advanced Programming'),
((SELECT id FROM MentorProfile WHERE userId = (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn')), N'MERN Stack');
GO

-- =============================================
-- 4. INSERT MENTEE CONNECTION
-- =============================================
INSERT INTO MenteeConnection (menteeId, mentorId, status) VALUES
((SELECT id FROM [User] WHERE email = 'an.nguyen@student.vn'), (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 'ACCEPTED'),
((SELECT id FROM [User] WHERE email = 'ngoc.phan@student.vn'), (SELECT id FROM [User] WHERE email = 'mai.le@studyspace.vn'), 'ACCEPTED'),
((SELECT id FROM [User] WHERE email = 'dam.vu@student.vn'), (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn'), 'PENDING'),
((SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com'), (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'), 'ACCEPTED');
GO

-- =============================================
-- 5. INSERT POSTS & COMMENTS
-- =============================================
INSERT INTO Post (content, authorId) VALUES
(N'Lộ trình học ReactJS cho người mới?', (SELECT id FROM [User] WHERE email = 'an.nguyen@student.vn')),
(N'Chia sẻ tài liệu IELTS Technology.', (SELECT id FROM [User] WHERE email = 'hoang.pham@studyspace.vn')),
(N'Ai rành mạch Arduino giúp mình với!', (SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com'));
GO

DECLARE @PostId1 VARCHAR(20) = (SELECT TOP 1 id FROM Post WHERE authorId = (SELECT id FROM [User] WHERE email = 'an.nguyen@student.vn'));
DECLARE @PostIdArduino VARCHAR(20) = (SELECT TOP 1 id FROM Post WHERE authorId = (SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com'));

INSERT INTO Comment (content, postId, authorId) VALUES
(N'Học trên F8 nhé bạn.', @PostId1, (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn')),
-- Mentor Nhân comment bài Mentee Nhân
(N'Em check lại chân tín hiệu Analog nhé.', @PostIdArduino, (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'));
GO

-- =============================================
-- 6. INSERT CHAT SERVERS & CHANNELS
-- =============================================
INSERT INTO ChatServer (name, description, ownerId) VALUES
(N'Cộng đồng Java', N'Java Spring Boot', (SELECT id FROM [User] WHERE email = 'tuan.tran@studyspace.vn')),
(N'HCMUT Algo Training', N'Luyện thuật toán', (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'));
GO

DECLARE @ServerJava VARCHAR(20) = (SELECT id FROM ChatServer WHERE name = N'Cộng đồng Java');
DECLARE @ServerAlgo VARCHAR(20) = (SELECT id FROM ChatServer WHERE name = N'HCMUT Algo Training');

INSERT INTO Channel (name, description, serverId) VALUES
(N'general', N'Chung', @ServerJava),
(N'code-help', N'Hỏi đáp', @ServerJava),
(N'dynamic-programming', N'Quy hoạch động', @ServerAlgo);
GO

-- =============================================
-- 7. INSERT MESSAGES
-- =============================================
DECLARE @ChannelDP VARCHAR(20) = (SELECT id FROM Channel WHERE name = N'dynamic-programming');

INSERT INTO Message (content, authorId, channelId) VALUES
(N'Bài này khó quá anh ơi.', (SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com'), @ChannelDP),
(N'Dùng quy hoạch động là ra nhé.', (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'), @ChannelDP);
GO

-- =============================================
-- 8. INSERT REVIEWS
-- =============================================
INSERT INTO Review (reviewerId, mentorId, rating, comment) VALUES
((SELECT id FROM [User] WHERE email = 'phucnhan289@gmail.com'), 
 (SELECT id FROM [User] WHERE email = 'nhan.nguyen2005phuyen@hcmut.edu.vn'), 
 5, N'Mentor dạy rất nhiệt tình, 10 điểm!');
GO

PRINT '===== ĐÃ TẠO DATA THÀNH CÔNG (KHÔNG CẦN RESET SEQUENCE) =====';
GO