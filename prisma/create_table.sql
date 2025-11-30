USE tutor_platform;
GO

PRINT '===== CREATING TABLES =====';

-- User
CREATE SEQUENCE seq_user START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE [User] (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('USR' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_user AS VARCHAR(5)), 5)),
    [name] NVARCHAR(100),
    [email] NVARCHAR(100) NOT NULL UNIQUE,
    [account_status] NVARCHAR(20) DEFAULT 'Active',
    user_type VARCHAR(10) NOT NULL DEFAULT 'MENTEE',
    [department] NVARCHAR(100),
    [major] NVARCHAR(100),
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT chk_user_role CHECK (user_type IN ('ADMIN', 'MENTOR', 'MENTEE')),
);
GO

-- MentorProfile
CREATE SEQUENCE seq_mentorprofile START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE MentorProfile (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('MPR' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_mentorprofile AS VARCHAR(5)), 5)),
    [userId] VARCHAR(20) NOT NULL UNIQUE,
    [rating] DECIMAL(3, 2) NOT NULL DEFAULT 0.00,
    [totalReviews] INT NOT NULL DEFAULT 0,
    createdAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    updatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_mentorprofile_user FOREIGN KEY (userId) REFERENCES [User](id) ON DELETE CASCADE,
    CONSTRAINT chk_rating CHECK (rating >= 0.00 AND rating <= 5.00),
);
GO

CREATE TABLE [ChuyenMon] (
    [mentor_id] VARCHAR(20) NOT NULL,
    [bang_cap] NVARCHAR(255) NOT NULL,
    PRIMARY KEY (mentor_id, bang_cap),
    CONSTRAINT fk_chuyenmon_user FOREIGN KEY (mentor_id) REFERENCES [MentorProfile](id) ON DELETE CASCADE
);
GO

CREATE TABLE [LichTrong] (
    [ma_lich_trong] INT IDENTITY(1,1) PRIMARY KEY,
    [mentor_id] VARCHAR(20) NOT NULL,
    [ngay] DATE NOT NULL,
    [gio_bat_dau] TIME NOT NULL,
    [gio_ket_thuc] TIME NOT NULL,
    CONSTRAINT fk_lichtrong_user FOREIGN KEY (mentor_id) REFERENCES [MentorProfile](id) ON DELETE CASCADE,
    CONSTRAINT chk_lichtrong_time CHECK (gio_bat_dau < gio_ket_thuc)
);
GO

-- MenteeConnection
CREATE SEQUENCE seq_menteeconnection START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE MenteeConnection (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('MCN' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_menteeconnection AS VARCHAR(5)), 5)),
    [menteeId] VARCHAR(20) NOT NULL,
    [mentorId] VARCHAR(20) NOT NULL,
    [status] VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_menteeconn_mentee FOREIGN KEY (menteeId) REFERENCES [User](id),
    CONSTRAINT fk_menteeconn_mentor FOREIGN KEY (mentorId) REFERENCES [User](id),
    CONSTRAINT chk_conn_status CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED')),
    CONSTRAINT uk_mentee_mentor UNIQUE (menteeId, mentorId)
);
GO

-- CalendarEvent
CREATE SEQUENCE seq_calendarevent START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE CalendarEvent (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('EVT' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_calendarevent AS VARCHAR(5)), 5)),
    [title] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(MAX),
    [startTime] DATETIME2 NOT NULL,
    [endTime] DATETIME2 NOT NULL,
    [priority] VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    [isCompleted] BIT NOT NULL DEFAULT 0,
    [creatorId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_event_creator FOREIGN KEY (creatorId) REFERENCES [User](id),
    CONSTRAINT chk_event_time CHECK (startTime < endTime),
    CONSTRAINT chk_event_priority CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT'))
);
GO

-- EventAssignment
CREATE SEQUENCE seq_eventassignment START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE EventAssignment (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('EAS' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_eventassignment AS VARCHAR(5)), 5)),
    [eventId] VARCHAR(20) NOT NULL,
    [userId] VARCHAR(20) NOT NULL,
    [status] VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_eventassign_event FOREIGN KEY (eventId) REFERENCES CalendarEvent(id) ON DELETE CASCADE,
    CONSTRAINT fk_eventassign_user FOREIGN KEY (userId) REFERENCES [User](id),
    CONSTRAINT chk_eventassign_status CHECK (status IN ('PENDING', 'ACCEPTED', 'DECLINED', 'COMPLETED')),
    CONSTRAINT uk_event_user UNIQUE (eventId, userId)
);
GO

-- EventReminder
CREATE SEQUENCE seq_eventreminder START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE EventReminder (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('RMD' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_eventreminder AS VARCHAR(5)), 5)),
    [eventId] VARCHAR(20) NOT NULL,
    [reminderTime] DATETIME2 NOT NULL,
    [message] NVARCHAR(255),
    [isActive] BIT NOT NULL DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_reminder_event FOREIGN KEY (eventId) REFERENCES CalendarEvent(id) ON DELETE CASCADE
);
GO

-- Notification
CREATE SEQUENCE seq_notification START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Notification (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('NTF' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_notification AS VARCHAR(5)), 5)),
    [title] NVARCHAR(255) NOT NULL,
    [content] NVARCHAR(MAX) NOT NULL,
    [isRead] BIT NOT NULL DEFAULT 0,
    [userId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_notification_user FOREIGN KEY (userId) REFERENCES [User](id),
);
GO

-- ProgressRecord
CREATE SEQUENCE seq_progressrecord START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE ProgressRecord (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('PRG' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_progressrecord AS VARCHAR(5)), 5)),
    [menteeId] VARCHAR(20) NOT NULL,
    [score] DECIMAL(5, 2) NOT NULL,
    [notes] NVARCHAR(MAX),
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_progress_mentee FOREIGN KEY (menteeId) REFERENCES [User](id),
    CONSTRAINT chk_progress_score CHECK (score >= 0 AND score <= 100),
);
GO

-- Post
CREATE SEQUENCE seq_post START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Post (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('POST' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_post AS VARCHAR(5)), 5)),
    [content] NVARCHAR(MAX) NOT NULL,
    [authorId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_post_author FOREIGN KEY (authorId) REFERENCES [User](id)
);
GO

CREATE SEQUENCE seq_img START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE [Images] (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('IMG' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_img AS VARCHAR(5)), 5)),
    [post_id] VARCHAR(20) NOT NULL,
    [image_url] NVARCHAR(255) NOT NULL,
    CONSTRAINT fk_image_post FOREIGN KEY (post_id) REFERENCES Post(id) ON DELETE CASCADE,
    CONSTRAINT chk_image_format CHECK (image_url LIKE '%.jpg' OR image_url LIKE '%.png')
);
GO

-- Comment
CREATE SEQUENCE seq_comment START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Comment (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('CMT' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_comment AS VARCHAR(5)), 5)),
    [content] NVARCHAR(MAX) NOT NULL,
    [postId] VARCHAR(20) NOT NULL,
    [authorId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_comment_post FOREIGN KEY (postId) REFERENCES Post(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_author FOREIGN KEY (authorId) REFERENCES [User](id)
);
GO

-- Reaction
CREATE SEQUENCE seq_reaction START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Reaction (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('RCT' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_reaction AS VARCHAR(5)), 5)),
    [type] VARCHAR(20) NOT NULL,
    [postId] VARCHAR(20) NOT NULL,
    [userId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_reaction_post FOREIGN KEY (postId) REFERENCES Post(id) ON DELETE CASCADE,
    CONSTRAINT fk_reaction_user FOREIGN KEY (userId) REFERENCES [User](id),
    CONSTRAINT chk_reaction_type CHECK (type IN ('LIKE', 'HEART', 'HAHA', 'SAD', 'CONGRATS')),
    CONSTRAINT uk_post_user_reaction UNIQUE (postId, userId)
);
GO

-- Review
CREATE SEQUENCE seq_review START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Review (
    id VARCHAR(20) PRIMARY KEY DEFAULT ('RVW' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_review AS VARCHAR(5)), 5)),
    reviewerId VARCHAR(20) NOT NULL,
    mentorId VARCHAR(20) NOT NULL,
    rating INT NOT NULL,
    comment NVARCHAR(MAX),
    createdAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_review_reviewer FOREIGN KEY (reviewerId) REFERENCES [User](id),
    CONSTRAINT fk_review_mentor FOREIGN KEY (mentorId) REFERENCES [User](id),
    CONSTRAINT chk_review_rating CHECK (rating >= 0 AND rating <= 5)
);
GO

-- MentorFeedback
CREATE SEQUENCE seq_mentorfeedback START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE MentorFeedback (
    id VARCHAR(20) PRIMARY KEY DEFAULT ('FDB' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_mentorfeedback AS VARCHAR(5)), 5)),
    mentorId VARCHAR(20) NOT NULL,
    menteeId VARCHAR(20) NOT NULL,
    score INT,
    comment NVARCHAR(MAX),
    createdAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_feedback_mentor FOREIGN KEY (mentorId) REFERENCES [User](id),
    CONSTRAINT fk_feedback_mentee FOREIGN KEY (menteeId) REFERENCES [User](id),
    CONSTRAINT chk_feedback_score CHECK (score IS NULL OR (score >= 0 AND score <= 100))
);
GO

-- ChatServer
CREATE SEQUENCE seq_chatserver START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE ChatServer (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('SRV' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_chatserver AS VARCHAR(5)), 5)),
    [name] NVARCHAR(100) NOT NULL,
    [description] NVARCHAR(MAX),
    [image] NVARCHAR(500),
    [ownerId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_server_owner FOREIGN KEY (ownerId) REFERENCES [User](id)
);
GO

-- ServerInvitation
CREATE SEQUENCE seq_serverinvitation START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE ServerInvitation (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('INV' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_serverinvitation AS VARCHAR(5)), 5)),
    [serverId] VARCHAR(20) NOT NULL,
    [invitedUserId] VARCHAR(20) NOT NULL,
    [invitedById] VARCHAR(20) NOT NULL,
    [status] VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_invitation_server FOREIGN KEY (serverId) REFERENCES ChatServer(id) ON DELETE CASCADE,
    CONSTRAINT fk_invitation_invited FOREIGN KEY (invitedUserId) REFERENCES [User](id),
    CONSTRAINT fk_invitation_inviter FOREIGN KEY (invitedById) REFERENCES [User](id),
    CONSTRAINT chk_invitation_status CHECK (status IN ('PENDING', 'ACCEPTED', 'DECLINED')),
    CONSTRAINT uk_server_inviteduser UNIQUE (serverId, invitedUserId)
);
GO

-- ServerMember
CREATE SEQUENCE seq_servermember START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE ServerMember (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('MBR' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_servermember AS VARCHAR(5)), 5)),
    [serverId] VARCHAR(20) NOT NULL,
    [userId] VARCHAR(20) NOT NULL,
    [role] VARCHAR(20) NOT NULL DEFAULT 'MEMBER',
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_member_server FOREIGN KEY (serverId) REFERENCES ChatServer(id) ON DELETE CASCADE,
    CONSTRAINT fk_member_user FOREIGN KEY (userId) REFERENCES [User](id),
    CONSTRAINT chk_member_role CHECK (role IN ('OWNER', 'ADMIN', 'MEMBER')),
    CONSTRAINT uk_server_user UNIQUE (serverId, userId)
);
GO

-- Channel
CREATE SEQUENCE seq_channel START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Channel (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('CHN' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_channel AS VARCHAR(5)), 5)),
    [name] NVARCHAR(100) NOT NULL,
    [description] NVARCHAR(MAX),
    [serverId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_channel_server FOREIGN KEY (serverId) REFERENCES ChatServer(id) ON DELETE CASCADE,
    CONSTRAINT uk_server_channelname UNIQUE (serverId, name)
);
GO

-- Message
CREATE SEQUENCE seq_message START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE Message (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('MSG' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_message AS VARCHAR(5)), 5)),
    [content] NVARCHAR(MAX),
    [authorId] VARCHAR(20) NOT NULL,
    [channelId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_message_author FOREIGN KEY (authorId) REFERENCES [User](id),
    CONSTRAINT fk_message_channel FOREIGN KEY (channelId) REFERENCES Channel(id) ON DELETE CASCADE,
);
GO

-- File
CREATE SEQUENCE seq_file START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE [File] (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('FIL' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_file AS VARCHAR(5)), 5)),
    [name] NVARCHAR(255) NOT NULL,
    [url] NVARCHAR(500) NOT NULL,
    [size] BIGINT NOT NULL,
    [messageId] VARCHAR(20) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_file_message FOREIGN KEY (messageId) REFERENCES Message(id) ON DELETE CASCADE,
    CONSTRAINT chk_file_size CHECK (size > 0 AND size <= 52428800) -- 50MB max
);
GO

-- ChatConversation
CREATE SEQUENCE seq_chatconversation START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE ChatConversation (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('CNV' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_chatconversation AS VARCHAR(5)), 5)),
    [userId] VARCHAR(20) NOT NULL,
    [title] NVARCHAR(255),
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [updatedAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_conversation_user FOREIGN KEY (userId) REFERENCES [User](id) ON DELETE CASCADE
);
GO

-- ChatMessage
CREATE SEQUENCE seq_chatmessage START WITH 1 INCREMENT BY 1;
GO
CREATE TABLE ChatMessage (
    [id] VARCHAR(20) PRIMARY KEY DEFAULT ('CHM' + RIGHT('00000' + CAST(NEXT VALUE FOR seq_chatmessage AS VARCHAR(5)), 5)),
    [conversationId] VARCHAR(20) NOT NULL,
    [content] NVARCHAR(MAX) NOT NULL,
    [createdAt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_chatmessage_conversation FOREIGN KEY (conversationId) REFERENCES ChatConversation(id) ON DELETE CASCADE,
);
GO

PRINT '===== TABLES CREATED SUCCESSFULLY =====';
GO
