-- =============================================
-- Author:		Suja
-- Create date: 11/02/2025
-- Description:	Added New Columns to Book Table 
-- =============================================
  ALTER TABLE 
  [LibrarySystem-Army].[dbo].[Book]
  ADD  
	VolumeNo NVARCHAR(20) NULL, 
	Vendor NVARCHAR(20) NULL,
	BillNo NVARCHAR(20) NULL,
	BillDate DateTime NULL,
	OfficeOrder  NVARCHAR(20) NULL,
	OfficeOrderDate DateTime NULL,
	Discount decimal(18,2) NULL,
	RackNo integer
-- ==================END========================

-- =============================================
-- Author:		Arshad
-- Create date: 10/02/2025
-- Description:	Create New Table for Volume Table 
-- =============================================
CREATE TABLE Volume (
    ID INT IDENTITY(1,1) PRIMARY KEY,       -- Unique Volume ID
    JournalID INT NOT NULL,                 -- Foreign Key to Journal
    VolumeNo NVARCHAR(50) NOT NULL,         -- Volume Number
    IssueNo NVARCHAR(50) NOT NULL,          -- Issue Number
    Month NVARCHAR(50) NOT NULL,            -- Month
    Remark NVARCHAR(255) NULL,              -- Remarks
    IsActive BIT DEFAULT 1,                 -- Active Status (1 = Active, 0 = Inactive)
    CreatedDate DATETIME DEFAULT GETDATE(), -- Record Creation Time
    UpdatedDate DATETIME DEFAULT GETDATE(), -- Last Update Time

    CONSTRAINT FK_Volume_Journal FOREIGN KEY (JournalID) REFERENCES Journal(ID) ON DELETE CASCADE
);
GO


-- =============================================
-- Author:		Arshad
-- Create date: 09/02/2025
-- Description:	Add Foreign Key for Subjects Table 
-- =============================================

ALTER TABLE Journal 
ADD CONSTRAINT FK_Journal_Subject FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID);


-- =============================================
-- Author:		Arshad
-- Create date: 09/02/2025
-- Description:	Drop Existing Foreign Key in Journal Table  
-- =============================================

ALTER TABLE Journal DROP CONSTRAINT FK_Journal_Language; 

-- =============================================
-- Author:		Arshad
-- Create date: 09/02/2025
-- Description:	Rename Coolumn Name of LanguageID to SubjectID  in Journal Table  
-- =============================================

EXEC sp_rename 'Journal.LanguageID', 'SubjectID', 'COLUMN';

-- =============================================
-- Author:		Arshad
-- Create date: 09/02/2025
-- Description:	Create a New Table for Subject  
-- =============================================
CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);
-- =============================================
-- Author:		Arshad
-- Create date: 08/02/2025
-- Description:	Create a New Table for Volume  
-- =============================================
CREATE TABLE Volume (
    ID INT IDENTITY(1,1) PRIMARY KEY,  -- Primary key with auto-increment
    VolumeNo NVARCHAR(50) NOT NULL,    -- Volume number
    IssueNo NVARCHAR(50) NOT NULL,     -- Issue number
    Month NVARCHAR(50) NOT NULL,       -- Month
    Remark NVARCHAR(MAX),              -- Remark (optional, can be NULL)
    JournalID INT NOT NULL,            -- Foreign key referencing Journal table
    CONSTRAINT FK_Journal FOREIGN KEY (JournalID) REFERENCES Journal(ID)
);


-- =============================================
-- Author:		Arshad
-- Create date: 08/02/2025
-- Description:	Alter the table Of Journal  
-- =============================================

ALTER TABLE Journal
DROP COLUMN VolumeNo, IssueNo, Month, Remark;

EXEC sp_rename 'Journal.OrderDate', 'InvoiceDate', 'COLUMN';


-- =============================================
-- Author:		Arshad
-- Create date: 07/02/2025
-- Description:	Add New Missing Columns table For Journal  
-- =============================================ALTER TABLE Journal
ADD 
    VolumeNo NVARCHAR(20) NOT NULL, -- Volume number
    IssueNo NVARCHAR(20) NOT NULL, -- Issue number
    Month NVARCHAR(20) NOT NULL, -- Month
    Remark NVARCHAR(500), -- Optional remarks
    IsActive BIT NOT NULL DEFAULT 1; -- Active status (default is 1 = active)



-- =============================================
-- Author:		Arshad
-- Create date: 07/02/2025
-- Description:	Add New table For Journal  
-- =============================================
CREATE TABLE Journal (
    ID INT IDENTITY(1,1) PRIMARY KEY, -- Auto-incrementing primary key
    JournalName NVARCHAR(255) NOT NULL,
    Frequency INT NOT NULL, -- Number of journals in a year
    Price DECIMAL(10, 2) NOT NULL,
    InvoiceNo NVARCHAR(50) NOT NULL,
    OrderDate DATE NOT NULL,
    OrderNo NVARCHAR(50) NOT NULL,
    LanguageID INT NOT NULL,
    FOREIGN KEY (LanguageID) REFERENCES Language(LanguageID)
);
-- =============================================
-- Author:		Arshad
-- Create date: 04/02/2025
-- Description:	Add New Column To Candidate Table 
-- =============================================

ALTER TABLE [LibrarySystem-Army].[dbo].[Candidate]
ADD 
    DOB DATE NULL,
    Stream VARCHAR(100) NULL,
    AcademicYear INT NULL,
    PermanentAddress NVARCHAR(255) NULL,
    PresentAddress NVARCHAR(255) NULL,
    Email VARCHAR(100) NULL,
    ParentsContact VARCHAR(15) NULL,
    Photo VARBINARY(MAX) NULL;


-- =============================================
-- Author:		Arshad
-- Create date: 04/02/2025
-- Description:	Used to Find existing student id 
-- =============================================



-- =============================================
-- Author:		Arshad
-- Create date: 02/02/2025
-- Description:	New Scrypt Created
-- Execution:	
-- =============================================
GO
/****** Object:  Database [LibrarySystem-Army]    Script Date: 23-08-2024 11:11:05 ******/
CREATE DATABASE [LibrarySystem-Army]
GO
USE [LibrarySystem-Army]
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateCandidateBarcode]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 07/03/2020
-- Description:	Used to generate candidate barcode
-- Execution:	SELECT dbo.GenerateCandidateBarcode()
-- =============================================
CREATE FUNCTION [dbo].[GenerateCandidateBarcode]()
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @Barcode NVARCHAR(50); 
	
	SET 
		@Barcode = (SELECT MAX(Barcode) FROM Candidate);

	IF (@Barcode IS NULL)
	BEGIN
		SET
			@Barcode='000001';
	END

	ELSE
	BEGIN
		DECLARE @i int set @i = RIGHT(@Barcode, 5) + 1 
		
		SET 
			@Barcode=(RIGHT('00000' + CONVERT(NVARCHAR(50), @i), 6));
	END

	RETURN @Barcode;
END
GO
/****** Object:  Table [dbo].[Author]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[AuthorID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Author] PRIMARY KEY CLUSTERED 
(
	[AuthorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[BookID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[AuthorID] [int] NOT NULL,
	[PublisherID] [int] NOT NULL,
	[LanguageID] [int] NULL,
	[CategoryID] [int] NULL,
	[Edition] [varchar](20) NULL,
	[Funds] [varchar](100) NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[ISBN] [varchar](20) NULL,
	[Description] [varchar](200) NULL,
	[IsRestricted] [bit] NULL,
	[TotalQuantity] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Book] PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookBarcode]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookBarcode](
	[BookBarcodeID] [int] IDENTITY(1,1) NOT NULL,
	[BookID] [int] NOT NULL,
	[Barcode] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_BookBarcode] PRIMARY KEY CLUSTERED 
(
	[BookBarcodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookHistory]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookHistory](
	[BookHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[BookBarcodeID] [int] NOT NULL,
	[CandidateID] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[Status] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_BookHistory] PRIMARY KEY CLUSTERED 
(
	[BookHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Candidate]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candidate](
	[CandidateID] [int] IDENTITY(1,1) NOT NULL,
	[Barcode] [varchar](10) NULL,
	[Role] [varchar](20) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[ContactNumber] [varchar](15) NOT NULL,
	[ServiceNo] [varchar](50) NOT NULL,
	[Rank] [varchar](50) NULL,
	[Unit] [varchar](50) NULL,
	[CountryID] [int] NULL,
	[CourseID] [int] NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[Battalion] [varchar](50) NULL,
	[TOSDate] [date] NULL,
	[SOSDate] [date] NULL,
	[ThumbImpression] [varchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Candidate] PRIMARY KEY CLUSTERED 
(
	[CandidateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CandidateDue]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CandidateDue](
	[CandidateDueID] [int] IDENTITY(1,1) NOT NULL,
	[BookBarcodeID] [int] NOT NULL,
	[CandidateID] [int] NOT NULL,
	[DueAmount] [decimal](18, 2) NOT NULL,
	[Remark] [varchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_CandidateDue] PRIMARY KEY CLUSTERED 
(
	[CandidateDueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[ParentID] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CourseID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[FromDate] [varchar](20) NOT NULL,
	[ToDate] [varchar](20) NOT NULL,
	[Description] [varchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[CourseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IssueBook]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IssueBook](
	[IssueBookID] [int] IDENTITY(1,1) NOT NULL,
	[BookBarcodeID] [int] NOT NULL,
	[CandidateID] [int] NOT NULL,
	[IssuedOn] [date] NOT NULL,
	[ReturnDate] [date] NOT NULL,
	[ReturnedOn] [date] NULL,
	[LastRenewaledOn] [date] NULL,
	[NoOfTimeRenewal] [int] NOT NULL,
	[Remark] [varchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_IssueBook] PRIMARY KEY CLUSTERED 
(
	[IssueBookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MissingBook]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MissingBook](
	[MissingBookID] [int] IDENTITY(1,1) NOT NULL,
	[BookBarcodeID] [int] NOT NULL,
	[Remark] [varchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_MissingBook] PRIMARY KEY CLUSTERED 
(
	[MissingBookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Publisher]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Publisher](
	[PublisherID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[ContactNumber] [varchar](15) NULL,
	[AlternateContactNumber] [varchar](15) NULL,
	[EmailID] [varchar](200) NULL,
	[Fax] [varchar](15) NULL,
	[Website] [varchar](200) NULL,
	[Address] [varchar](max) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Publisher] PRIMARY KEY CLUSTERED 
(
	[PublisherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 23-08-2024 11:11:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ContactNumber] [varchar](15) NULL,
	[Email] [varchar](200) NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[ThumbImpression] [varchar](max) NULL,
	[UID] [varchar](50) NULL,
	[Role] [varchar](10) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Author] ON 

INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'Sanjeev Joshi', N'Sanjeev Joshi is the  “Ek Samandar, Mere Andar”  Books Author', 1, CAST(N'2024-07-02T18:42:12.010' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'Dr. Rajen Saikia', N'Author of Political History', 1, CAST(N'2024-07-02T18:43:25.093' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'Gujarat State Disaster Management Authority', N'Authority ', 1, CAST(N'2024-07-02T18:44:09.620' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'Arup Kumar Dutta', N'Arup Kumar Dutta ', 1, CAST(N'2024-07-02T18:44:32.293' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, N'Minister Dr. Mansukh Mandaviya', N'Minister Dr. Mansukh Mandaviya', 1, CAST(N'2024-07-02T18:44:49.690' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (6, N'Chitra Banerjee Divakaruni', N'Chitra Banerjee Divakaruni ', 1, CAST(N'2024-07-02T18:45:23.157' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (7, N'M.J. Akbar and K Natwar Singh', N'	M.J. Akbar and K Natwar Singh', 1, CAST(N'2024-07-02T18:45:38.917' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (8, N'R.K. Pachnanda', N'R.K. Pachnanda, Bibek Debroy, Anirban Ganguly, and Uttam Kumar Sinha', 1, CAST(N'2024-07-02T18:46:03.683' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (9, N'General Manoj Mukund Naravane', N'General Manoj Mukund Naravane', 1, CAST(N'2024-07-02T18:46:21.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (10, N'Manorama Mishra', N'	Manorama Mishra', 1, CAST(N'2024-07-02T18:46:34.590' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (11, N'Vairamuthu', N'Vairamuthu', 1, CAST(N'2024-07-02T18:46:49.403' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (12, N'Geeta Singh and Arif Khan Bharti', N'	Geeta Singh and Arif Khan Bharti', 1, CAST(N'2024-07-02T18:47:07.077' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (13, N'Jane Austen', N'Jane Austen author by this book Pride and Prejudice', 1, CAST(N'2024-07-04T10:53:43.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (14, N' Harper Lee', N' Harper Lee ', 1, CAST(N'2024-07-04T10:53:59.243' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (15, N'Miguel de Cervantes', NULL, 1, CAST(N'2024-07-04T10:54:14.780' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1007, N'Richar E Simpkin', NULL, 3, CAST(N'2020-08-28T10:35:04.560' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1008, N'Nasim Zehra', NULL, 3, CAST(N'2020-08-28T11:11:33.490' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1009, N'Robert Leonhard', NULL, 3, CAST(N'2020-08-28T11:16:21.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Author] ([AuthorID], [Name], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1010, N'Lt Gen Prakash Menon', NULL, 3, CAST(N'2020-08-28T11:22:19.840' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Author] OFF
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'The Story of Indian Philosophy', 13, 2, 7, 1, N'-', N'25000', CAST(250.00 AS Decimal(18, 2)), N'0223', N'The working title for this book at first was “Indian Philosophy, which I always wanted to know but had no time to do so.”', 1, 100, 1, CAST(N'2024-08-07T15:58:58.280' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'shekchili', 13, 4, 3, 0, N'-', N'testing', CAST(200.00 AS Decimal(18, 2)), N'7418', NULL, 1, 300, 1, CAST(N'2024-08-08T15:30:42.287' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'The Art of Maneuver', 1009, 1004, 7, 12, N'-', N'ALG 2020', CAST(2495.00 AS Decimal(18, 2)), N'81-85567-37-9', NULL, 0, 2, 3, CAST(N'2020-08-28T11:19:05.297' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'The Strategy Trap India and Pakistan Under The Nuclear Shadow', 1010, 1005, 7, 12, N'-', N'ALG 2020', CAST(895.00 AS Decimal(18, 2)), N'978-81-8328-524-7', NULL, 0, 2, 3, CAST(N'2020-08-28T11:24:47.153' AS DateTime), 3, CAST(N'2020-08-28T12:33:01.510' AS DateTime), 1)
INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, N'B1', 1007, 3, 7, 14, N'-', N'F1', CAST(120.00 AS Decimal(18, 2)), N'1234-1234-1234-1234', N'desc goes here', 1, 2, 3, CAST(N'2020-08-28T12:33:58.630' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (6, N'B2', 1007, 1002, 4, 3, N'-', N'F1', CAST(135.00 AS Decimal(18, 2)), N'1234-1234-1234-1234', NULL, 0, 1, 3, CAST(N'2020-08-28T12:35:40.090' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Book] ([BookID], [Name], [AuthorID], [PublisherID], [LanguageID], [CategoryID], [Edition], [Funds], [Price], [ISBN], [Description], [IsRestricted], [TotalQuantity], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (7, N'TESTING', 1008, 1003, 5, 13, N'TESTING ', N'TESTING', CAST(300.00 AS Decimal(18, 2)), N'741', N'EUYTRE', 0, 10, 1, CAST(N'2024-08-08T17:26:47.613' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
SET IDENTITY_INSERT [dbo].[BookBarcode] ON 

INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, 1, N'RS000001', 1, CAST(N'2024-08-07T15:58:58.287' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, 1, N'RS000002', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, 1, N'RS000003', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, 1, N'RS000004', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, 1, N'RS000005', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (6, 1, N'RS000006', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (7, 1, N'RS000007', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (8, 1, N'RS000008', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (9, 1, N'RS000009', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (10, 1, N'RS000010', 1, CAST(N'2024-08-07T15:58:58.290' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (11, 1, N'RS000011', 1, CAST(N'2024-08-07T15:58:58.293' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (12, 1, N'RS000012', 1, CAST(N'2024-08-07T15:58:58.297' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (13, 1, N'RS000013', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (14, 1, N'RS000014', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (15, 1, N'RS000015', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (16, 1, N'RS000016', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (17, 1, N'RS000017', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (18, 1, N'RS000018', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (19, 1, N'RS000019', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (20, 1, N'RS000020', 1, CAST(N'2024-08-07T15:58:58.300' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (21, 1, N'RS000021', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (22, 1, N'RS000022', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (23, 1, N'RS000023', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (24, 1, N'RS000024', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (25, 1, N'RS000025', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (26, 1, N'RS000026', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (27, 1, N'RS000027', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (28, 1, N'RS000028', 1, CAST(N'2024-08-07T15:58:58.303' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (29, 1, N'RS000029', 1, CAST(N'2024-08-07T15:58:58.307' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (30, 1, N'RS000030', 1, CAST(N'2024-08-07T15:58:58.307' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (31, 1, N'RS000031', 1, CAST(N'2024-08-07T15:58:58.307' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (32, 1, N'RS000032', 1, CAST(N'2024-08-07T15:58:58.307' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (33, 1, N'RS000033', 1, CAST(N'2024-08-07T15:58:58.307' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (34, 1, N'RS000034', 1, CAST(N'2024-08-07T15:58:58.307' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (35, 1, N'RS000035', 1, CAST(N'2024-08-07T15:58:58.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (36, 1, N'RS000036', 1, CAST(N'2024-08-07T15:58:58.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (37, 1, N'RS000037', 1, CAST(N'2024-08-07T15:58:58.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (38, 1, N'RS000038', 1, CAST(N'2024-08-07T15:58:58.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (39, 1, N'RS000039', 1, CAST(N'2024-08-07T15:58:58.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (40, 1, N'RS000040', 1, CAST(N'2024-08-07T15:58:58.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (41, 1, N'RS000041', 1, CAST(N'2024-08-07T15:58:58.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (42, 1, N'RS000042', 1, CAST(N'2024-08-07T15:58:58.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (43, 1, N'RS000043', 1, CAST(N'2024-08-07T15:58:58.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (44, 1, N'RS000044', 1, CAST(N'2024-08-07T15:58:58.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (45, 1, N'RS000045', 1, CAST(N'2024-08-07T15:58:58.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (46, 1, N'RS000046', 1, CAST(N'2024-08-07T15:58:58.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (47, 1, N'RS000047', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (48, 1, N'RS000048', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (49, 1, N'RS000049', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (50, 1, N'RS000050', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (51, 1, N'RS000051', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (52, 1, N'RS000052', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (53, 1, N'RS000053', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (54, 1, N'RS000054', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (55, 1, N'RS000055', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (56, 1, N'RS000056', 1, CAST(N'2024-08-07T15:58:58.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (57, 1, N'RS000057', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (58, 1, N'RS000058', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (59, 1, N'RS000059', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (60, 1, N'RS000060', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (61, 1, N'RS000061', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (62, 1, N'RS000062', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (63, 1, N'RS000063', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (64, 1, N'RS000064', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (65, 1, N'RS000065', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (66, 1, N'RS000066', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (67, 1, N'RS000067', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (68, 1, N'RS000068', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (69, 1, N'RS000069', 1, CAST(N'2024-08-07T15:58:58.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (70, 1, N'RS000070', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (71, 1, N'RS000071', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (72, 1, N'RS000072', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (73, 1, N'RS000073', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (74, 1, N'RS000074', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (75, 1, N'RS000075', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (76, 1, N'RS000076', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (77, 1, N'RS000077', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (78, 1, N'RS000078', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (79, 1, N'RS000079', 1, CAST(N'2024-08-07T15:58:58.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (80, 1, N'RS000080', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (81, 1, N'RS000081', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (82, 1, N'RS000082', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (83, 1, N'RS000083', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (84, 1, N'RS000084', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (85, 1, N'RS000085', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (86, 1, N'RS000086', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (87, 1, N'RS000087', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (88, 1, N'RS000088', 1, CAST(N'2024-08-07T15:58:58.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (89, 1, N'RS000089', 1, CAST(N'2024-08-07T15:58:58.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (90, 1, N'RS000090', 1, CAST(N'2024-08-07T15:58:58.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (91, 1, N'RS000091', 1, CAST(N'2024-08-07T15:58:58.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (92, 1, N'RS000092', 1, CAST(N'2024-08-07T15:58:58.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (93, 1, N'RS000093', 1, CAST(N'2024-08-07T15:58:58.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (94, 1, N'RS000094', 1, CAST(N'2024-08-07T15:58:58.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (95, 1, N'RS000095', 1, CAST(N'2024-08-07T15:58:58.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (96, 1, N'RS000096', 1, CAST(N'2024-08-07T15:58:58.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (97, 1, N'RS000097', 1, CAST(N'2024-08-07T15:58:58.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (98, 1, N'RS000098', 1, CAST(N'2024-08-07T15:58:58.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (99, 1, N'RS000099', 1, CAST(N'2024-08-07T15:58:58.333' AS DateTime), NULL, NULL, 1)
GO
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (100, 1, N'RS000100', 1, CAST(N'2024-08-07T15:58:58.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1002, 2, N'RS000101', 1, CAST(N'2024-08-08T15:30:42.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1003, 2, N'RS000102', 1, CAST(N'2024-08-08T15:30:42.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1004, 2, N'RS000103', 1, CAST(N'2024-08-08T15:30:42.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1005, 2, N'RS000104', 1, CAST(N'2024-08-08T15:30:42.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1006, 2, N'RS000105', 1, CAST(N'2024-08-08T15:30:42.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1007, 2, N'RS000106', 1, CAST(N'2024-08-08T15:30:42.310' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1008, 2, N'RS000107', 1, CAST(N'2024-08-08T15:30:42.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1009, 2, N'RS000108', 1, CAST(N'2024-08-08T15:30:42.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1010, 2, N'RS000109', 1, CAST(N'2024-08-08T15:30:42.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1011, 2, N'RS000110', 1, CAST(N'2024-08-08T15:30:42.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1012, 2, N'RS000111', 1, CAST(N'2024-08-08T15:30:42.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1013, 2, N'RS000112', 1, CAST(N'2024-08-08T15:30:42.313' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1014, 2, N'RS000113', 1, CAST(N'2024-08-08T15:30:42.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1015, 2, N'RS000114', 1, CAST(N'2024-08-08T15:30:42.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1016, 2, N'RS000115', 1, CAST(N'2024-08-08T15:30:42.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1017, 2, N'RS000116', 1, CAST(N'2024-08-08T15:30:42.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1018, 2, N'RS000117', 1, CAST(N'2024-08-08T15:30:42.317' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1019, 2, N'RS000118', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1020, 2, N'RS000119', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1021, 2, N'RS000120', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1022, 2, N'RS000121', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1023, 2, N'RS000122', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1024, 2, N'RS000123', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1025, 2, N'RS000124', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1026, 2, N'RS000125', 1, CAST(N'2024-08-08T15:30:42.320' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1027, 2, N'RS000126', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1028, 2, N'RS000127', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1029, 2, N'RS000128', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1030, 2, N'RS000129', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1031, 2, N'RS000130', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1032, 2, N'RS000131', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1033, 2, N'RS000132', 1, CAST(N'2024-08-08T15:30:42.323' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1034, 2, N'RS000133', 1, CAST(N'2024-08-08T15:30:42.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1035, 2, N'RS000134', 1, CAST(N'2024-08-08T15:30:42.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1036, 2, N'RS000135', 1, CAST(N'2024-08-08T15:30:42.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1037, 2, N'RS000136', 1, CAST(N'2024-08-08T15:30:42.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1038, 2, N'RS000137', 1, CAST(N'2024-08-08T15:30:42.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1039, 2, N'RS000138', 1, CAST(N'2024-08-08T15:30:42.327' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1040, 2, N'RS000139', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1041, 2, N'RS000140', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1042, 2, N'RS000141', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1043, 2, N'RS000142', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1044, 2, N'RS000143', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1045, 2, N'RS000144', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1046, 2, N'RS000145', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1047, 2, N'RS000146', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1048, 2, N'RS000147', 1, CAST(N'2024-08-08T15:30:42.330' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1049, 2, N'RS000148', 1, CAST(N'2024-08-08T15:30:42.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1050, 2, N'RS000149', 1, CAST(N'2024-08-08T15:30:42.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1051, 2, N'RS000150', 1, CAST(N'2024-08-08T15:30:42.333' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1052, 2, N'RS000151', 1, CAST(N'2024-08-08T15:30:42.430' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1053, 2, N'RS000152', 1, CAST(N'2024-08-08T15:30:42.433' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1054, 2, N'RS000153', 1, CAST(N'2024-08-08T15:30:42.433' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1055, 2, N'RS000154', 1, CAST(N'2024-08-08T15:30:42.433' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1056, 2, N'RS000155', 1, CAST(N'2024-08-08T15:30:42.433' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1057, 2, N'RS000156', 1, CAST(N'2024-08-08T15:30:42.433' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1058, 2, N'RS000157', 1, CAST(N'2024-08-08T15:30:42.433' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1059, 2, N'RS000158', 1, CAST(N'2024-08-08T15:30:42.437' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1060, 2, N'RS000159', 1, CAST(N'2024-08-08T15:30:42.437' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1061, 2, N'RS000160', 1, CAST(N'2024-08-08T15:30:42.437' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1062, 2, N'RS000161', 1, CAST(N'2024-08-08T15:30:42.437' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1063, 2, N'RS000162', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1064, 2, N'RS000163', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1065, 2, N'RS000164', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1066, 2, N'RS000165', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1067, 2, N'RS000166', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1068, 2, N'RS000167', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1069, 2, N'RS000168', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1070, 2, N'RS000169', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1071, 2, N'RS000170', 1, CAST(N'2024-08-08T15:30:42.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1072, 2, N'RS000171', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1073, 2, N'RS000172', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1074, 2, N'RS000173', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1075, 2, N'RS000174', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1076, 2, N'RS000175', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1077, 2, N'RS000176', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1078, 2, N'RS000177', 1, CAST(N'2024-08-08T15:30:42.443' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1079, 2, N'RS000178', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1080, 2, N'RS000179', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1081, 2, N'RS000180', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1082, 2, N'RS000181', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1083, 2, N'RS000182', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1084, 2, N'RS000183', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1085, 2, N'RS000184', 1, CAST(N'2024-08-08T15:30:42.447' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1086, 2, N'RS000185', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1087, 2, N'RS000186', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1088, 2, N'RS000187', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1089, 2, N'RS000188', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1090, 2, N'RS000189', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1091, 2, N'RS000190', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1092, 2, N'RS000191', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1093, 2, N'RS000192', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1094, 2, N'RS000193', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1095, 2, N'RS000194', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1096, 2, N'RS000195', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1097, 2, N'RS000196', 1, CAST(N'2024-08-08T15:30:42.450' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1098, 2, N'RS000197', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1099, 2, N'RS000198', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1100, 2, N'RS000199', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
GO
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1101, 2, N'RS000200', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1102, 2, N'RS000201', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1103, 2, N'RS000202', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1104, 2, N'RS000203', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1105, 2, N'RS000204', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1106, 2, N'RS000205', 1, CAST(N'2024-08-08T15:30:42.453' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1107, 2, N'RS000206', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1108, 2, N'RS000207', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1109, 2, N'RS000208', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1110, 2, N'RS000209', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1111, 2, N'RS000210', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1112, 2, N'RS000211', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1113, 2, N'RS000212', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1114, 2, N'RS000213', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1115, 2, N'RS000214', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1116, 2, N'RS000215', 1, CAST(N'2024-08-08T15:30:42.457' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1117, 2, N'RS000216', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1118, 2, N'RS000217', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1119, 2, N'RS000218', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1120, 2, N'RS000219', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1121, 2, N'RS000220', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1122, 2, N'RS000221', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1123, 2, N'RS000222', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1124, 2, N'RS000223', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1125, 2, N'RS000224', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1126, 2, N'RS000225', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1127, 2, N'RS000226', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1128, 2, N'RS000227', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1129, 2, N'RS000228', 1, CAST(N'2024-08-08T15:30:42.460' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1130, 2, N'RS000229', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1131, 2, N'RS000230', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1132, 2, N'RS000231', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1133, 2, N'RS000232', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1134, 2, N'RS000233', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1135, 2, N'RS000234', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1136, 2, N'RS000235', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1137, 2, N'RS000236', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1138, 2, N'RS000237', 1, CAST(N'2024-08-08T15:30:42.463' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1139, 2, N'RS000238', 1, CAST(N'2024-08-08T15:30:42.467' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1140, 2, N'RS000239', 1, CAST(N'2024-08-08T15:30:42.467' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1141, 2, N'RS000240', 1, CAST(N'2024-08-08T15:30:42.467' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1142, 2, N'RS000241', 1, CAST(N'2024-08-08T15:30:42.467' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1143, 2, N'RS000242', 1, CAST(N'2024-08-08T15:30:42.467' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1144, 2, N'RS000243', 1, CAST(N'2024-08-08T15:30:42.467' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1145, 2, N'RS000244', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1146, 2, N'RS000245', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1147, 2, N'RS000246', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1148, 2, N'RS000247', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1149, 2, N'RS000248', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1150, 2, N'RS000249', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1151, 2, N'RS000250', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1152, 2, N'RS000251', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1153, 2, N'RS000252', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1154, 2, N'RS000253', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1155, 2, N'RS000254', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1156, 2, N'RS000255', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1157, 2, N'RS000256', 1, CAST(N'2024-08-08T15:30:42.470' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1158, 2, N'RS000257', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1159, 2, N'RS000258', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1160, 2, N'RS000259', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1161, 2, N'RS000260', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1162, 2, N'RS000261', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1163, 2, N'RS000262', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1164, 2, N'RS000263', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1165, 2, N'RS000264', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1166, 2, N'RS000265', 1, CAST(N'2024-08-08T15:30:42.473' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1167, 2, N'RS000266', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1168, 2, N'RS000267', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1169, 2, N'RS000268', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1170, 2, N'RS000269', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1171, 2, N'RS000270', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1172, 2, N'RS000271', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1173, 2, N'RS000272', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1174, 2, N'RS000273', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1175, 2, N'RS000274', 1, CAST(N'2024-08-08T15:30:42.477' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1176, 2, N'RS000275', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1177, 2, N'RS000276', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1178, 2, N'RS000277', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1179, 2, N'RS000278', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1180, 2, N'RS000279', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1181, 2, N'RS000280', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1182, 2, N'RS000281', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1183, 2, N'RS000282', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1184, 2, N'RS000283', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1185, 2, N'RS000284', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1186, 2, N'RS000285', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1187, 2, N'RS000286', 1, CAST(N'2024-08-08T15:30:42.480' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1188, 2, N'RS000287', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1189, 2, N'RS000288', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1190, 2, N'RS000289', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1191, 2, N'RS000290', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1192, 2, N'RS000291', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1193, 2, N'RS000292', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1194, 2, N'RS000293', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1195, 2, N'RS000294', 1, CAST(N'2024-08-08T15:30:42.483' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1196, 2, N'RS000295', 1, CAST(N'2024-08-08T15:30:42.487' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1197, 2, N'RS000296', 1, CAST(N'2024-08-08T15:30:42.487' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1198, 2, N'RS000297', 1, CAST(N'2024-08-08T15:30:42.487' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1199, 2, N'RS000298', 1, CAST(N'2024-08-08T15:30:42.487' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1200, 2, N'RS000299', 1, CAST(N'2024-08-08T15:30:42.487' AS DateTime), NULL, NULL, 1)
GO
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1201, 2, N'RS000300', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1202, 2, N'RS000301', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1203, 2, N'RS000302', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1204, 2, N'RS000303', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1205, 2, N'RS000304', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1206, 2, N'RS000305', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1207, 2, N'RS000306', 1, CAST(N'2024-08-08T15:30:42.500' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1208, 2, N'RS000307', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1209, 2, N'RS000308', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1210, 2, N'RS000309', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1211, 2, N'RS000310', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1212, 2, N'RS000311', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1213, 2, N'RS000312', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1214, 2, N'RS000313', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1215, 2, N'RS000314', 1, CAST(N'2024-08-08T15:30:42.503' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1216, 2, N'RS000315', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1217, 2, N'RS000316', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1218, 2, N'RS000317', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1219, 2, N'RS000318', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1220, 2, N'RS000319', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1221, 2, N'RS000320', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1222, 2, N'RS000321', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1223, 2, N'RS000322', 1, CAST(N'2024-08-08T15:30:42.507' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1224, 2, N'RS000323', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1225, 2, N'RS000324', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1226, 2, N'RS000325', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1227, 2, N'RS000326', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1228, 2, N'RS000327', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1229, 2, N'RS000328', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1230, 2, N'RS000329', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1231, 2, N'RS000330', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1232, 2, N'RS000331', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1233, 2, N'RS000332', 1, CAST(N'2024-08-08T15:30:42.510' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1234, 2, N'RS000333', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1235, 2, N'RS000334', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1236, 2, N'RS000335', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1237, 2, N'RS000336', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1238, 2, N'RS000337', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1239, 2, N'RS000338', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1240, 2, N'RS000339', 1, CAST(N'2024-08-08T15:30:42.513' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1241, 2, N'RS000340', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1242, 2, N'RS000341', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1243, 2, N'RS000342', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1244, 2, N'RS000343', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1245, 2, N'RS000344', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1246, 2, N'RS000345', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1247, 2, N'RS000346', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1248, 2, N'RS000347', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1249, 2, N'RS000348', 1, CAST(N'2024-08-08T15:30:42.517' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1250, 2, N'RS000349', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1251, 2, N'RS000350', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1252, 2, N'RS000351', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1253, 2, N'RS000352', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1254, 2, N'RS000353', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1255, 2, N'RS000354', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1256, 2, N'RS000355', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1257, 2, N'RS000356', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1258, 2, N'RS000357', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1259, 2, N'RS000358', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1260, 2, N'RS000359', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1261, 2, N'RS000360', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1262, 2, N'RS000361', 1, CAST(N'2024-08-08T15:30:42.520' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1263, 2, N'RS000362', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1264, 2, N'RS000363', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1265, 2, N'RS000364', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1266, 2, N'RS000365', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1267, 2, N'RS000366', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1268, 2, N'RS000367', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1269, 2, N'RS000368', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1270, 2, N'RS000369', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1271, 2, N'RS000370', 1, CAST(N'2024-08-08T15:30:42.523' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1272, 2, N'RS000371', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1273, 2, N'RS000372', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1274, 2, N'RS000373', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1275, 2, N'RS000374', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1276, 2, N'RS000375', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1277, 2, N'RS000376', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1278, 2, N'RS000377', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1279, 2, N'RS000378', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1280, 2, N'RS000379', 1, CAST(N'2024-08-08T15:30:42.527' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1281, 2, N'RS000380', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1282, 2, N'RS000381', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1283, 2, N'RS000382', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1284, 2, N'RS000383', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1285, 2, N'RS000384', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1286, 2, N'RS000385', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1287, 2, N'RS000386', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1288, 2, N'RS000387', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1289, 2, N'RS000388', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1290, 2, N'RS000389', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1291, 2, N'RS000390', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1292, 2, N'RS000391', 1, CAST(N'2024-08-08T15:30:42.530' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1293, 2, N'RS000392', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1294, 2, N'RS000393', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1295, 2, N'RS000394', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1296, 2, N'RS000395', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1297, 2, N'RS000396', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1298, 2, N'RS000397', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1299, 2, N'RS000398', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1300, 2, N'RS000399', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
GO
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1301, 2, N'RS000400', 1, CAST(N'2024-08-08T15:30:42.533' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1302, 7, N'NR000001', 1, CAST(N'2024-08-08T17:26:47.673' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1303, 7, N'NR000002', 1, CAST(N'2024-08-08T17:26:47.673' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1304, 7, N'NR000003', 1, CAST(N'2024-08-08T17:26:47.677' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1305, 7, N'NR000004', 1, CAST(N'2024-08-08T17:26:47.677' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1306, 7, N'NR000005', 1, CAST(N'2024-08-08T17:26:47.677' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1307, 7, N'NR000006', 1, CAST(N'2024-08-08T17:26:47.677' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1308, 7, N'NR000007', 1, CAST(N'2024-08-08T17:26:47.677' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1309, 7, N'NR000008', 1, CAST(N'2024-08-08T17:26:47.680' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1310, 7, N'NR000009', 1, CAST(N'2024-08-08T17:26:47.680' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[BookBarcode] ([BookBarcodeID], [BookID], [Barcode], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1311, 7, N'NR000010', 1, CAST(N'2024-08-08T17:26:47.680' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[BookBarcode] OFF
GO
SET IDENTITY_INSERT [dbo].[BookHistory] ON 

INSERT [dbo].[BookHistory] ([BookHistoryID], [BookBarcodeID], [CandidateID], [Date], [Status], [CreatedBy], [CreatedOn], [IsActive]) VALUES (1, 1, 1, CAST(N'2020-09-01' AS Date), N'ISSUE', 1, CAST(N'2020-09-01T16:52:06.950' AS DateTime), 1)
INSERT [dbo].[BookHistory] ([BookHistoryID], [BookBarcodeID], [CandidateID], [Date], [Status], [CreatedBy], [CreatedOn], [IsActive]) VALUES (2, 10, 1, CAST(N'2020-09-01' AS Date), N'ISSUE', 1, CAST(N'2020-09-01T17:03:49.917' AS DateTime), 1)
INSERT [dbo].[BookHistory] ([BookHistoryID], [BookBarcodeID], [CandidateID], [Date], [Status], [CreatedBy], [CreatedOn], [IsActive]) VALUES (3, 1302, 4, CAST(N'2024-08-08' AS Date), N'ISSUE', 1, CAST(N'2024-08-08T17:27:20.693' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[BookHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[Candidate] ON 

INSERT [dbo].[Candidate] ([CandidateID], [Barcode], [Role], [Name], [ContactNumber], [ServiceNo], [Rank], [Unit], [CountryID], [CourseID], [FromDate], [ToDate], [Battalion], [TOSDate], [SOSDate], [ThumbImpression], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'000001', N'POSTED', N' Tushar Mali', N'8529637410', N'1', N'2', N'1', 1, 0, NULL, NULL, N'YES', CAST(N'2024-08-07' AS Date), CAST(N'2024-08-20' AS Date), NULL, 1, CAST(N'2024-08-07T15:38:57.810' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Candidate] ([CandidateID], [Barcode], [Role], [Name], [ContactNumber], [ServiceNo], [Rank], [Unit], [CountryID], [CourseID], [FromDate], [ToDate], [Battalion], [TOSDate], [SOSDate], [ThumbImpression], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'000002', N'TRAINEE', N'ROSHNI PATIL', N'7418529633', N'022200022', N'5', N'1', 1, 1, CAST(N'2024-08-08' AS Date), CAST(N'2025-08-10' AS Date), NULL, NULL, NULL, NULL, 1, CAST(N'2024-08-08T12:34:10.380' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Candidate] ([CandidateID], [Barcode], [Role], [Name], [ContactNumber], [ServiceNo], [Rank], [Unit], [CountryID], [CourseID], [FromDate], [ToDate], [Battalion], [TOSDate], [SOSDate], [ThumbImpression], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'000003', N'Teacher', N'TEJAS MARATHE', N'8529637413', N'79632145', N'10', N'2', 1, 0, NULL, NULL, NULL, CAST(N'2024-08-08' AS Date), CAST(N'2024-08-11' AS Date), NULL, 1, CAST(N'2024-08-08T12:35:19.623' AS DateTime), 1, CAST(N'2024-08-08T15:13:28.790' AS DateTime), 1)
INSERT [dbo].[Candidate] ([CandidateID], [Barcode], [Role], [Name], [ContactNumber], [ServiceNo], [Rank], [Unit], [CountryID], [CourseID], [FromDate], [ToDate], [Battalion], [TOSDate], [SOSDate], [ThumbImpression], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'000004', N'Student', N'student name', N'8527419633', N'741', NULL, NULL, NULL, 1, CAST(N'2024-08-08' AS Date), CAST(N'2025-08-20' AS Date), NULL, NULL, NULL, NULL, 1, CAST(N'2024-08-08T13:32:00.367' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Candidate] ([CandidateID], [Barcode], [Role], [Name], [ContactNumber], [ServiceNo], [Rank], [Unit], [CountryID], [CourseID], [FromDate], [ToDate], [Battalion], [TOSDate], [SOSDate], [ThumbImpression], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, N'000005', N'Teacher', N'teacher ', N'852', N'741', NULL, NULL, NULL, 0, NULL, NULL, NULL, CAST(N'2024-08-08' AS Date), CAST(N'2024-08-08' AS Date), NULL, 1, CAST(N'2024-08-08T15:13:58.197' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Candidate] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'Technical', NULL, 1, CAST(N'2020-03-02T11:51:15.110' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'Others', NULL, 1, CAST(N'2020-03-02T11:51:25.940' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'Automotive', 1, 1, CAST(N'2020-03-02T11:51:55.080' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'Armaments & Missile', 1, 1, CAST(N'2020-03-02T11:52:05.153' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (6, N'Magazine', 2, 1, CAST(N'2020-03-02T11:52:47.753' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (7, N'Story Book', 2, 1, CAST(N'2020-03-02T11:53:08.810' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (8, N'Electronic', 1, 1, CAST(N'2020-08-26T11:12:12.893' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (12, N'Tactics', 1, 1, CAST(N'2020-08-26T11:15:20.830' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (13, N'GS', 1, 1, CAST(N'2020-08-26T11:16:23.880' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Category] ([CategoryID], [Name], [ParentID], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (14, N'Reference', 1, 1, CAST(N'2020-08-26T11:18:23.140' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([CountryID], [Name], [CreatedBy], [CreatedOn], [IsActive]) VALUES (1, N'INDIA', -1, CAST(N'2024-07-04T14:36:22.440' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[Course] ON 

INSERT [dbo].[Course] ([CourseID], [Name], [FromDate], [ToDate], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'BCA', N'08-08-2024', N'08-08-2025', NULL, 1, CAST(N'2024-08-08T12:32:16.183' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Course] ([CourseID], [Name], [FromDate], [ToDate], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'BCA', N'01-09-2020', N'15-12-2020', NULL, 1, CAST(N'2020-09-01T16:28:01.337' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Course] ([CourseID], [Name], [FromDate], [ToDate], [Description], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'MCA', N'01-09-2020', N'10-11-2020', NULL, 1, CAST(N'2020-09-01T16:28:16.810' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Course] OFF
GO
SET IDENTITY_INSERT [dbo].[IssueBook] ON 

INSERT [dbo].[IssueBook] ([IssueBookID], [BookBarcodeID], [CandidateID], [IssuedOn], [ReturnDate], [ReturnedOn], [LastRenewaledOn], [NoOfTimeRenewal], [Remark], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, 1, 1, CAST(N'2020-09-01' AS Date), CAST(N'2020-08-31' AS Date), NULL, NULL, 0, N'Issued', 1, CAST(N'2020-09-01T16:52:06.947' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[IssueBook] ([IssueBookID], [BookBarcodeID], [CandidateID], [IssuedOn], [ReturnDate], [ReturnedOn], [LastRenewaledOn], [NoOfTimeRenewal], [Remark], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, 10, 1, CAST(N'2020-09-01' AS Date), CAST(N'2020-09-08' AS Date), NULL, NULL, 0, NULL, 1, CAST(N'2020-09-01T17:03:49.913' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[IssueBook] ([IssueBookID], [BookBarcodeID], [CandidateID], [IssuedOn], [ReturnDate], [ReturnedOn], [LastRenewaledOn], [NoOfTimeRenewal], [Remark], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, 1302, 4, CAST(N'2024-08-08' AS Date), CAST(N'2024-08-15' AS Date), NULL, NULL, 0, N'T', 1, CAST(N'2024-08-08T17:27:20.687' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[IssueBook] OFF
GO
SET IDENTITY_INSERT [dbo].[Language] ON 

INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'ENGLISH', 2, CAST(N'2020-04-27T15:23:30.827' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'HINDI', 2, CAST(N'2020-04-27T15:23:36.777' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'MARATHI', 2, CAST(N'2020-04-27T15:23:42.917' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'URDU', 2, CAST(N'2020-04-27T15:23:47.877' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, N'SANSKRIT', 2, CAST(N'2020-04-27T15:23:56.173' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (6, N'OTHER', 2, CAST(N'2020-04-27T15:24:02.720' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Language] ([LanguageID], [Name], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (7, N'English', 2, CAST(N'2020-08-24T10:20:47.460' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Language] OFF
GO
SET IDENTITY_INSERT [dbo].[Publisher] ON 

INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'Jaico Publishing House', N'7418529633', N'796321455', N'Jaico@gmail.com', NULL, NULL, N'mumbai', 1, CAST(N'2024-08-07T15:50:16.660' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'Westland Publications', N'7418529638', N'9963758455', N'Westland@gmail.com', NULL, NULL, N'Westland Publications pune ', 1, CAST(N'2024-08-07T15:51:09.440' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'Penguin Random House India', N'8529637410', N'7896543210', N'Penguin@gmail.com', NULL, NULL, N'Penguin Random House India delhi', 1, CAST(N'2024-08-07T15:52:24.580' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'Roli Books', N'725413', N'7418529639', N'Roli@gmail.com', NULL, NULL, N'Roli Books', 1, CAST(N'2024-08-07T15:53:05.830' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, N' Rupa Publications', N'253641', NULL, N'rupa@gmail.com', NULL, NULL, N'. Rupa Publications', 1, CAST(N'2024-08-07T15:53:52.643' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1002, N'Brassey''s', N' ', NULL, NULL, NULL, NULL, N'Federal Republic of Germany', 3, CAST(N'2020-08-28T10:38:11.823' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1003, N'SANG-E-MEEL PUBLICATIONS', N' ', NULL, NULL, NULL, NULL, NULL, 3, CAST(N'2020-08-28T11:13:08.263' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1004, N'The English Book Depot', N' ', NULL, NULL, NULL, NULL, NULL, 3, CAST(N'2020-08-28T11:17:33.703' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[Publisher] ([PublisherID], [Name], [ContactNumber], [AlternateContactNumber], [EmailID], [Fax], [Website], [Address], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1005, N'Wisdom Tree', N' ', NULL, NULL, NULL, NULL, NULL, 3, CAST(N'2020-08-28T11:23:02.020' AS DateTime), NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Publisher] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([UserID], [Name], [ContactNumber], [Email], [UserName], [Password], [ThumbImpression], [UID], [Role], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (1, N'Admin', N'9999999999', N'admin@gmail.com', N'admin', N'123', NULL, NULL, N'ADMIN', 1, CAST(N'2020-04-27T14:02:57.857' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[User] ([UserID], [Name], [ContactNumber], [Email], [UserName], [Password], [ThumbImpression], [UID], [Role], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (2, N'User', N'8888888888', N'user@gmail.com', N'user', N'123', NULL, NULL, N'LIBRARIAN', 0, CAST(N'2020-04-27T14:04:15.270' AS DateTime), 2, CAST(N'2020-08-24T09:40:20.433' AS DateTime), 0)
INSERT [dbo].[User] ([UserID], [Name], [ContactNumber], [Email], [UserName], [Password], [ThumbImpression], [UID], [Role], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (3, N'Yogesh ', N'7588092711', N'yogeshmusale66@gmail.com', N'LIbrarian', N'5566', NULL, NULL, N'LIBRARIAN', 0, CAST(N'2020-08-24T09:41:12.593' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[User] ([UserID], [Name], [ContactNumber], [Email], [UserName], [Password], [ThumbImpression], [UID], [Role], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (4, N'Avinash', N'9682570294', N'karanjuleavinash87@gmail.com', N'Librarian', N'5566', NULL, NULL, N'LIBRARIAN', 0, CAST(N'2020-08-24T11:06:51.380' AS DateTime), NULL, NULL, 1)
INSERT [dbo].[User] ([UserID], [Name], [ContactNumber], [Email], [UserName], [Password], [ThumbImpression], [UID], [Role], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn], [IsActive]) VALUES (5, N'Avinash', N'9682570294', N'karanjuleavinash87@gmail.com', N'LIBRARIAN', N'0127', NULL, NULL, N'LIBRARIAN', 0, CAST(N'2020-08-24T11:08:02.230' AS DateTime), 3, CAST(N'2020-08-24T11:08:15.583' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[User] OFF
GO
ALTER TABLE [dbo].[Author] ADD  CONSTRAINT [DF_Author_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Author] ADD  CONSTRAINT [DF_Author_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Book] ADD  CONSTRAINT [DF_Book_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Book] ADD  CONSTRAINT [DF_Book_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BookBarcode] ADD  CONSTRAINT [DF_BookBarcode_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[BookBarcode] ADD  CONSTRAINT [DF_BookBarcode_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[BookHistory] ADD  CONSTRAINT [DF_BookHistory_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[BookHistory] ADD  CONSTRAINT [DF_BookHistory_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Candidate] ADD  CONSTRAINT [DF_Candidate_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Candidate] ADD  CONSTRAINT [DF_Candidate_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[CandidateDue] ADD  CONSTRAINT [DF_CandidateDue_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[CandidateDue] ADD  CONSTRAINT [DF_CandidateDue_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [DF_Category_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Country] ADD  CONSTRAINT [DF_Country_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[IssueBook] ADD  CONSTRAINT [DF_IssueBook_NoOfTimeRenewal]  DEFAULT ((0)) FOR [NoOfTimeRenewal]
GO
ALTER TABLE [dbo].[IssueBook] ADD  CONSTRAINT [DF_IssueBook_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[IssueBook] ADD  CONSTRAINT [DF_IssueBook_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[MissingBook] ADD  CONSTRAINT [DF_MissingBook_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[MissingBook] ADD  CONSTRAINT [DF_MissingBook_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Publisher] ADD  CONSTRAINT [DF_Publisher_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Publisher] ADD  CONSTRAINT [DF_Publisher_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
/****** Object:  StoredProcedure [dbo].[ChangePassword]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to change the password
-- =============================================
CREATE PROC [dbo].[ChangePassword]
	@UserID												INT,
	@CurrentPassword									VARCHAR(50),
	@NewPassword										VARCHAR(50),
	@CreatedBy											INT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF EXISTS(SELECT 1 FROM [User] WHERE UserID = @UserID AND [Password] = @CurrentPassword)
		BEGIN
			UPDATE
				[User]
			SET
				[Password]	= @NewPassword,
				UpdatedBy	= @CreatedBy,
				UpdatedOn	= GETDATE()
			WHERE
				UserID		= @UserID
			AND
				[Password]	= @CurrentPassword

			SET
				@OutputMessage = 'SUCCESS';
		END
		ELSE
		BEGIN
			SET
				@OutputMessage = 'Invalid';
		END
		
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[CheckAvailableBookBarcode]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arshad Ali
-- Create date: 25/12/2019
-- Description:	Used to show all book detail
-- Execution:	EXEC CheckAvailableBookBarcode 1
-- =============================================
CREATE PROC [dbo].[CheckAvailableBookBarcode]
	@BookBarcodeID										INT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM IssueBook WHERE BookBarcodeID  = @BookBarcodeID AND IsActive = 1)
	BEGIN
		SELECT
			1
		FROM
			IssueBook					AS IB
		WHERE
			IB.ReturnedOn IS NOT NULL
		AND
			IB.BookBarcodeID = @BookBarcodeID
		AND
			IB.IsActive = 1;
	END
	ELSE
	BEGIN
		SELECT 1;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[DeactiveAuthor]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to deactive the author
-- =============================================
CREATE PROC [dbo].[DeactiveAuthor]
	@AuthorID											INT,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

		IF EXISTS(SELECT 1 FROM Book WHERE AuthorID = @AuthorID AND IsActive = 1)
	BEGIN
		SET
			@OutputMessage = 'Book is Available in stock, you can not delete thi Author.';
		RETURN;
	END


	BEGIN TRY
		BEGIN
			UPDATE
				Author
			SET
				IsActive			= 0,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				AuthorID			= @AuthorID
			SET
				@ID = @AuthorID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeactiveBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to deactive book
-- =============================================
CREATE PROC [dbo].[DeactiveBook]
	@BookID												INT,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN
			UPDATE
				Book
			SET
				IsActive			= 0,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				BookID	= @BookID
			SET
				@ID = @BookID;


			UPDATE
				BookBarcode
			SET
				IsActive			= 0,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				BookID		= @BookID
			SET
				@ID = @BookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeactiveBookBarcode]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to deactive the book barcode
-- =============================================
CREATE PROC [dbo].[DeactiveBookBarcode]
	@BookBarcodeID										INT,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN
			UPDATE
				BookBarcode
			SET
				IsActive			= 0,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				BookBarcodeID		= @BookBarcodeID
			SET
				@ID = @BookBarcodeID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeactiveLanguage]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shaikh Rizwan
-- Create date: 18/12/2019
-- Description:	Used to deactive the author
-- =============================================
CREATE PROC [dbo].[DeactiveLanguage]
	@LanguageID											INT,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

		IF EXISTS(SELECT 1 FROM Book WHERE AuthorID = @LanguageID AND IsActive = 1)
	BEGIN
		SET
			@OutputMessage = 'Book is Available in stock, you can not delete this Language.';
		RETURN;
	END


	BEGIN TRY
		BEGIN
			UPDATE
				Language
			SET
				IsActive			= 0,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				LanguageID			= @LanguageID
			SET
				@ID = @LanguageID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeactivePublisher]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to deactive the publisher
-- =============================================
CREATE PROC [dbo].[DeactivePublisher]
	@PublisherID										INT,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Book WHERE PublisherID = @PublisherID AND IsActive = 1)
	BEGIN
		SET
			@OutputMessage = 'Book is Available in stock, you can not delete thi publisher.';
		RETURN;
	END

	BEGIN TRY
		BEGIN
			UPDATE
				Publisher
			SET
				IsActive			= 0,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				PublisherID			= @PublisherID
			SET
				@ID = @PublisherID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[DeactiveUser]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to deactive the user
-- =============================================
CREATE PROC [dbo].[DeactiveUser]
	@UserID												INT,
	@CreatedBy											INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

		IF EXISTS(SELECT 1 FROM IssueBook WHERE CandidateID  = @UserID AND IsActive = 1)
	BEGIN
		SET
			@OutputMessage = 'You cannot Delete the candidate, it has issued a book.';
		RETURN;
	END

	BEGIN TRY
		BEGIN
			UPDATE
				[User]
			SET
				IsActive			= 0,
				UpdatedBy			= @CreatedBy,
				UpdatedOn			= GETDATE()
			WHERE
				UserID			= @UserID
			SET
				@ID = @UserID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GetBarcode]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 28/12/2019
-- Description:	Used to get barcode
-- EXCUTION: EXEC GetBarcode 1, NULL
-- =============================================
CREATE PROC [dbo].[GetBarcode]
	@IsRestricted										BIT,
	@OutputMessage										VARCHAR(MAX) = NULL	OUT		
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @Barcode								VARCHAR(50); 
	
		SELECT 
			@Barcode = MAX(CAST(Barcode AS VARCHAR)) 
		FROM 
			BookBarcode AS BB
		INNER JOIN 
			Book AS B 
		ON 
			BB.BookID = B.BookID 
		WHERE 
			BB.IsActive = 1 
		AND 
			B.IsActive = 1 
		AND 
			B.IsRestricted = @IsRestricted;

		IF (@Barcode IS NULL)
		BEGIN
			SET
				@Barcode = '000001';
		END

		ELSE
		BEGIN
			DECLARE @i int set @i = RIGHT(@Barcode, 5) + 1;
			
			SET 
				@Barcode = (RIGHT('00000' + CONVERT(NVARCHAR(50), @i), 6));
		END

		IF(@IsRestricted = 1)
		BEGIN
			SET
				@OutputMessage = 'RS'+@Barcode;
		END
		ELSE
		BEGIN
			SET
				@OutputMessage = 'NR'+@Barcode;
		END

		
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[GetBookByBarcode]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 25/12/2019
-- Description:	Used to show all book detail
--select * from BookBarcode
-- Execution:	EXEC GetBookByBarcode @Barcode='RS000001'
-- =============================================
CREATE PROC [dbo].[GetBookByBarcode]
	@Barcode											NVARCHAR(50)	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		B.BookID										AS BookID,
		B.[Name]										AS [Name],
		B.Edition										AS Edition,
		B.Price											AS Price,
		B.ISBN											AS ISBN,
		B.[Description]									AS [Description],
		B.TotalQuantity									AS TotalQuantity,

		L.LanguageID									AS LanguageID,
		L.[Name]										AS [Language],	

		B.AuthorID										AS AuthorID,
		A.[Name]										AS Author,

		B.PublisherID									AS PublisherID,
		P.[Name]										AS Publisher,

		BB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS Barcode,
		C.CategoryID									AS CategoryID,
		C.[Name]										AS Category,
		B.Funds											AS Funds,
		B.IsRestricted									AS IsRestricted
	FROM
		Book											AS B
	LEFT JOIN
		BookBarcode										AS BB
	ON
		BB.BookID = B.BookID
	INNER JOIN
		Author											AS A
	ON
		A.AuthorID = B.AuthorID
	INNER JOIN
		Publisher										AS P
	ON
		P.PublisherID = B.PublisherID
	INNER JOIN
		[Language]										AS L
	ON
		L.LanguageID = B.LanguageID
	INNER JOIN
		Category										AS C
	ON 
		C.CategoryID = B.CategoryID
		
	WHERE
		(BB.Barcode = @Barcode OR @Barcode IS NULL)
	AND
		B.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[LatestIssueBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arshad Ali
-- Create date: 11/01/2020
-- Description:	Used to show Latest 5 Issue Book
-- Execution:	EXEC LatestIssueBook
-- =============================================
CREATE PROC [dbo].[LatestIssueBook]
	@IssueBookID										INT				= NULL,
	@BookBarcodeID										INT				= NULL,
	@CandidateID										INT				= NULL,
	@UserID												INT				= NULL,
	@Barcode											VARCHAR(50)		= NULL,
	@SearchValue										VARCHAR(100)	= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT TOP 5
		IB.IssueBookID									AS IssueBookID,
		IB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,
		BB.BookID										AS BookID,
		B.[Name]										AS BookName,
		IB.CandidateID									AS CandidateID,
		IB.IssuedOn										AS IssuedOn,
		IB.ReturnDate									AS ReturnDate,
		IB.ReturnedOn									AS ReturnedOn,
		IB.LastRenewaledOn								AS LastRenewaledOn,
		IB.NoOfTimeRenewal								AS NoOfTimeRenewal,
		IB.Remark										AS Remark,
		C.[Name]										AS CandidateName
	FROM
		IssueBook										AS IB
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = IB.BookBarcodeID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	INNER JOIN
		Candidate										AS C
	ON
		C.CandidateID = IB.CandidateID
	WHERE
		IB.ReturnedOn IS NULL
	AND
		(IB.IssueBookID = @IssueBookID OR @IssueBookID IS NULL)
	AND
		(IB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(IB.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(IB.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(BB.Barcode = @Barcode OR @Barcode IS NULL)
	AND
		IB.IsActive = 1
	AND
		(@SearchValue									IS NULL OR 
		IB.IssuedOn										LIKE '%' + @SearchValue + '%' OR
		IB.ReturnDate									LIKE '%' + @SearchValue + '%' OR
		IB.ReturnedOn									LIKE '%' + @SearchValue + '%' OR
		IB.LastRenewaledOn								LIKE '%' + @SearchValue + '%' OR
		B.[Name]										LIKE '%' + @SearchValue + '%' OR
		C.[Name]										LIKE '%' + @SearchValue + '%' )
	ORDER BY IssueBookID DESC 
END
GO
/****** Object:  StoredProcedure [dbo].[LoginValidateUser]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to lagin validate user
-- Execution:	EXEC LoginValidateUser
-- =============================================
CREATE PROC [dbo].[LoginValidateUser]
	@UserName											VARCHAR(50),
	@Password											VARCHAR(50),
	@Role												VARCHAR(20)
AS		
BEGIN
	SET NOCOUNT ON;

	SELECT
		U.UserID										AS UserID,
		U.[Name]										AS [Name],
		U.ContactNumber									AS ContactNumber,
		U.Email											AS Email,
		U.UserName										AS UserName,
		U.[Password]									AS [Password],
		U.ThumbImpression								AS ThumbImpression,
		U.[UID]											AS [UID],
		U.[Role]										AS [Role]
	FROM
		[User]											AS U
	WHERE
		U.UserName = @UserName	
	AND
		U.[Password] = @Password
	AND
		U.[Role] = @Role
	AND
		U.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveAuthor]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save author details
-- =============================================
CREATE PROC [dbo].[SaveAuthor]
	@AuthorID											INT				= NULL,
	@Name												NVARCHAR(100),
	@Description										NVARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Author WHERE AuthorID = @AuthorID)
		BEGIN
			INSERT INTO
				Author([Name], [Description], CreatedBy)
			VALUES
				(@Name, @Description, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Author
			SET
				[Name]				= @Name,
				[Description]		= @Description,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				AuthorID			= @AuthorID
			SET
				@ID = @AuthorID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveBackFileToComputerLocation]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 02/09/2020
-- Description:	Used to save backup
-- EXEC SaveBackFileToComputerLocation
-- =============================================
CREATE PROC [dbo].[SaveBackFileToComputerLocation]
(
	@Path								VARCHAR(100),
	@FileName							VARCHAR(50)
)
AS
BEGIN 
	SET
		@Path = @Path + @FileName+'.bkp';
		
	BACKUP DATABASE LibrarySystem
	TO DISK = @Path;
END
GO
/****** Object:  StoredProcedure [dbo].[SaveBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save book details
-- =============================================
CREATE PROC [dbo].[SaveBook]
	@BookID												INT				= NULL,
	@Name												NVARCHAR(200),
	@AuthorID											INT,
	@Edition											VARCHAR(20)		= NULL,
	@PublisherID										INT,
	@LanguageID											INT				= NULL,
	@Price												DECIMAL(18,2),
	@ISBN												VARCHAR(20)		= NULL,
	@Description										VARCHAR(200)	= NULL,
	@Funds												VARCHAR(100)	= NULL,
	@CategoryID											INT,
	@IsRestricted										BIT				= NULL,
	@TotalQuantity										INT,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Book WHERE BookID = @BookID)
		BEGIN
			INSERT INTO
				Book([Name], AuthorID, Edition, PublisherID, LanguageID, Price, ISBN, [Description], TotalQuantity, Funds, IsRestricted, CategoryID, CreatedBy)
			VALUES
				(@Name, @AuthorID, @Edition, @PublisherID, @LanguageID, @Price, @ISBN, @Description, @TotalQuantity, @Funds, @IsRestricted, @CategoryID, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Book
			SET
				[Name]				= @Name,
				AuthorID			= @AuthorID,
				Edition				= @Edition,
				PublisherID			= @PublisherID,
				LanguageID			= @LanguageID,
				Price				= @Price,
				Funds				= @Funds,
				IsRestricted		= @IsRestricted,
				CategoryID			= @CategoryID,
				ISBN				= @ISBN,	
				[Description]		= @Description,
				TotalQuantity		= @TotalQuantity,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				BookID				= @BookID
			SET
				@ID = @BookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveBookBarcode]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save book barcode details
-- =============================================
CREATE PROC [dbo].[SaveBookBarcode]
	@BookBarcodeID										INT				= NULL,
	@BookID												INT,
	@Barcode											VARCHAR(50),
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM BookBarcode WHERE BookBarcodeID = @BookBarcodeID)
		BEGIN
			INSERT INTO
				BookBarcode(BookID, Barcode, CreatedBy)
			VALUES
				(@BookID, @Barcode, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				BookBarcode
			SET
				BookID				= @BookID,
				Barcode				= @Barcode,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				BookBarcodeID		= @BookBarcodeID
			SET
				@ID = @BookBarcodeID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveCandidate]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 26/02/2020
-- Description:	Used to save candidate detail
-- =============================================
CREATE PROC [dbo].[SaveCandidate]
	@CandidateID										INT				= NULL,
	@Role												VARCHAR(20),
	@Name												NVARCHAR(100),
	@ContactNumber										VARCHAR(15),
	@ServiceNo											VARCHAR(50),
	@CourseID											INT				= NULL,
	@FromDate											DATE			= NULL,
	@ToDate												DATE			= NULL,
	@TOSDate											DATE			= NULL,
	@SOSDate											DATE			= NULL,
	@ThumbImpression									VARCHAR(MAX)	= NULL,
	@UserID												INT				= NULL,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Candidate WHERE CandidateID = @CandidateID)
		BEGIN
			INSERT INTO
				Candidate([Role], Barcode, [Name], ContactNumber, ServiceNo, CourseID, FromDate, ToDate,
						 TOSDate, SOSDate, ThumbImpression, CreatedBy)
			VALUES
				(@Role, dbo.GenerateCandidateBarcode(),  @Name, @ContactNumber, @ServiceNo, @CourseID, @FromDate, @ToDate, 
				 @TOSDate, @SOSDate, @ThumbImpression, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Candidate
			SET
				[Role]			= @Role,
				[Name]			= @Name,
				ContactNumber	= @ContactNumber,
				ServiceNo       = @ServiceNo,
				CourseID        = @CourseID,
				FromDate		= @FromDate,
				ToDate			= @ToDate,
				TOSDate         = @TOSDate,
				SOSDate         = @SOSDate,
				Thumbimpression = @ThumbImpression,
				UpdatedBy       = @UserID,
				UpdatedOn       = GETDATE()
 			WHERE
				CandidateID		= @CandidateID
			SET
				@ID = @CandidateID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveCandidateDue]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save candidate due detail
-- =============================================
CREATE PROC [dbo].[SaveCandidateDue]
	@CandidateDueID										INT				= NULL,
	@BookBarcodeID										INT,
	@CandidateID										INT,
	@DueAmount											DECIMAL(18,2),
	@Remark												VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM CandidateDue WHERE CandidateDueID = @CandidateDueID)
		BEGIN
			INSERT INTO
				CandidateDue(BookBarcodeID, CandidateID, DueAmount, Remark, CreatedBy)
			VALUES
				(@BookBarcodeID, @CandidateID, @DueAmount, @Remark, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				CandidateDue
			SET
				BookBarcodeID		= @BookBarcodeID,
				CandidateID			= @CandidateID,
				DueAmount			= @DueAmount,
				Remark				= @Remark
			WHERE
				CandidateDueID		= @CandidateDueID
			SET
				@ID = @CandidateDueID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveCategory]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 05/11/2019
-- Description:	Used to save categories details
-- =============================================
CREATE PROC [dbo].[SaveCategory]
	@CategoryID											INT				= NULL,
	@Name												VARCHAR(100),
	@ParentID											INT				= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Category WHERE CategoryID = @CategoryID)
		BEGIN
			INSERT INTO
				Category(Name, ParentID, CreatedBy)
			VALUES
				(@Name, @ParentID, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Category
			SET
				Name				= @Name,
				ParentID			= @ParentID,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				CategoryID			= @CategoryID
			SET
				@ID = @CategoryID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[SaveCountry]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 26/02/2020
-- Description:	Used to save country detail
-- =============================================
CREATE PROC [dbo].[SaveCountry]
	@CountryID											INT				= NULL,
	@Name												VARCHAR(100),
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Country WHERE CountryID = @CountryID)
		BEGIN
			INSERT INTO
				Country([Name], CreatedBy)
			VALUES
				(@Name, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Country
			SET
				[Name]				= @Name
			WHERE
				CountryID			= @CountryID
			SET
				@ID = @CountryID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveCourse]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 26/02/2020
-- Description:	Used to save course detail
-- =============================================
CREATE PROC [dbo].[SaveCourse]
	@CourseID											INT				= NULL,
	@Name												VARCHAR(100),
	@FromDate											VARCHAR(20),
	@ToDate												VARCHAR(20),
	@Description										VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Course WHERE CourseID = @CourseID)
		BEGIN
			INSERT INTO
				Course([Name], FromDate, ToDate, [Description], CreatedBy)
			VALUES
				(@Name, @FromDate, @ToDate, @Description, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Course
			SET
				[Name]				= @Name,
				FromDate			= @FromDate,
				ToDate				= @ToDate,
				[Description]       = @Description,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				CourseID			= @CourseID
			SET
				@ID = @CourseID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveIssueBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save issue book detail
-- =============================================
CREATE PROC [dbo].[SaveIssueBook]
	@IssueBookID										INT				= NULL,
	@BookBarcodeID										INT,
	@CandidateID										INT,
	@IssuedOn											DATE,
	@ReturnDate											DATE,
	@Remark												VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM  IssueBook WHERE BookBarcodeID = @BookBarcodeID AND  ReturnDate IS NULL) 
	BEGIN
			SET @OutputMessage =  'This book barcode already given some one';
			return; 
	END

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM IssueBook WHERE IssueBookID = @IssueBookID)
		BEGIN
			INSERT INTO
				IssueBook(BookBarcodeID, CandidateID, IssuedOn, ReturnDate, Remark, CreatedBy)
			VALUES
				(@BookBarcodeID, @CandidateID, @IssuedOn, @ReturnDate, @Remark, @UserID);

			INSERT INTO 
				BookHistory(BookBarcodeID, CandidateID, [Date], [Status], CreatedBy)
			VALUES
				(@BookBarcodeID, @CandidateID, @IssuedOn, 'ISSUE', @UserID)

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				IssueBook
			SET
				BookBarcodeID		= @BookBarcodeID,
				CandidateID			= @CandidateID,
				IssuedOn			= @IssuedOn,
				ReturnDate			= @ReturnDate,
				Remark				= @Remark,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				IssueBookID			= @IssueBookID
			SET
				@ID = @IssueBookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveLanguage]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shaikh Rizwan	
-- Create date: 01/20/2020
-- Description:	Used to save Language details
-- =============================================
CREATE PROC [dbo].[SaveLanguage]
	@LanguageID											INT				= NULL,
	@Name												VARCHAR(50),
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM [Language] WHERE LanguageID = @LanguageID)
		BEGIN
			INSERT INTO
				[Language]([Name], CreatedBy)
			VALUES
				(@Name, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				[Language]
			SET
				[Name]				= @Name,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				LanguageID			= @LanguageID
			SET
				@ID = @LanguageID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveMissingBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save missing book
-- =============================================
CREATE PROC [dbo].[SaveMissingBook]
	@MissingBookID										INT				= NULL,
	@BookBarcodeID										INT,
	@Remark												VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM MissingBook WHERE MissingBookID = @MissingBookID)
		BEGIN
			INSERT INTO
				MissingBook(BookBarcodeID, Remark, CreatedBy)
			VALUES
				(@BookBarcodeID, @Remark, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				MissingBook
			SET
				BookBarcodeID		= @BookBarcodeID,
				Remark				= @Remark,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				MissingBookID		= @MissingBookID
			SET
				@ID = @MissingBookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SavePublisher]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save publisher
-- =============================================
CREATE PROC [dbo].[SavePublisher]
	@PublisherID										INT				= NULL,
	@Name												NVARCHAR(100),
	@ContactNumber										VARCHAR(15)		= NULL,
	@AlternateContactNumber								VARCHAR(15)		= NULL,
	@EmailID											VARCHAR(200)	= NULL,
	@Fax												VARCHAR(15)		= NULL,
	@Website											VARCHAR(200)	= NULL,
	@Address											VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Publisher WHERE PublisherID = @PublisherID)
		BEGIN
			INSERT INTO
				Publisher([Name], ContactNumber, AlternateContactNumber, EmailID, Fax, Website, [Address], CreatedBy)
			VALUES
				(@Name, @ContactNumber, @AlternateContactNumber, @EmailID, @Fax, @Website, @Address, @UserID);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				Publisher
			SET
				Name					= @Name,
				ContactNumber			= @ContactNumber,
				AlternateContactNumber	= @AlternateContactNumber,
				EmailID					= @EmailID,
				Fax						= @Fax,
				Website					= @Website,
				[Address]				= @Address
			WHERE
				PublisherID		= @PublisherID
			SET
				@ID = @PublisherID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveRenewalBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save renewal book detail
-- =============================================
CREATE PROC [dbo].[SaveRenewalBook]
	@IssueBookID										INT,
	@BookBarcodeID										INT,
	@CandidateID										INT,
	@RenewalOn											DATE,
	@ReturnDate											DATE,
	@Remark												VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN
			DECLARE	@NoOfTimeRenewal	INT		= 0;
			SELECT
				@NoOfTimeRenewal = NoOfTimeRenewal From IssueBook WHERE IssueBookID = @IssueBookID; 

			UPDATE
				IssueBook
			SET
				LastRenewaledOn		= @RenewalOn,
				ReturnDate			= @ReturnDate,
				NoOfTimeRenewal		= @NoOfTimeRenewal + 1,
				Remark				= @Remark,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE()
			WHERE
				IssueBookID			= @IssueBookID

			INSERT INTO 
				BookHistory(BookBarcodeID, CandidateID, [Date], [Status], CreatedBy)
			VALUES
				(@BookBarcodeID, @CandidateID, @RenewalOn, 'RENEWAL', @UserID)

			SET
				@ID = @IssueBookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
		
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveReturnBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save return book detail
-- =============================================
CREATE PROC [dbo].[SaveReturnBook]
	@IssueBookID										INT,
	@BookBarcodeID										INT,
	@CandidateID										INT,
	@ReturnedOn											DATE,
	@Remark												VARCHAR(MAX)	= NULL,
	@UserID												INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN
			UPDATE
				IssueBook
			SET
				ReturnedOn			= @ReturnedOn,
				Remark				= @Remark,
				UpdatedBy			= @UserID,
				UpdatedOn			= GETDATE(),
				IsActive			= 0
			WHERE
				IssueBookID			= @IssueBookID

			INSERT INTO 
				BookHistory(BookBarcodeID, CandidateID, [Date], [Status], CreatedBy)
			VALUES
				(@BookBarcodeID, @CandidateID, @ReturnedOn, 'RETURN', @UserID)

			SET
				@ID = @IssueBookID;
		END

		SET
			@OutputMessage = 'SUCCESS';
		
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SaveUser]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to save user
-- =============================================
CREATE PROC [dbo].[SaveUser]
	@UserID												INT				= NULL,
	@Name												VARCHAR(50),
	@ContactNumber										VARCHAR(15)		= NULL,
	@Email												VARCHAR(200)	= NULL,
	@UserName											VARCHAR(50)		= NULL,
	@Password											VARCHAR(50)		= NULL,
	@ThumbImpression									VARCHAR(MAX)	= NULL,
	@UID												VARCHAR(50)		= NULL,
	@Role												VARCHAR(10),
	@CreatedBy											INT,
	@ID													INT				OUT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM [User] WHERE UserID = @UserID)
		BEGIN
			INSERT INTO
				[User]([Name], ContactNumber, Email, UserName, [Password], ThumbImpression, [UID], [Role], CreatedBy)
			VALUES
				(@Name, @ContactNumber, @Email, @UserName, @Password, @ThumbImpression, @UID, @Role, @CreatedBy);

			SET
				@ID = SCOPE_IDENTITY();
		END

		ELSE
		BEGIN
			UPDATE
				[User]
			SET
				[Name]				= @Name,
				ContactNumber		= @ContactNumber,
				Email				= @Email,
				UserName			= @UserName,
				[Password]			= @Password,
				ThumbImpression		= @ThumbImpression,
				[UID]				= @UID,
				[Role]				= @Role,
				UpdatedBy			= @CreatedBy,
				UpdatedOn			= GETDATE()
			WHERE
				UserID			= @UserID
			SET
				@ID = @UserID;
		END

		SET
			@OutputMessage = 'SUCCESS';
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[ShowAlert]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 04/03/2020
-- Description:	Used to show alert
-- Execution:	EXEC ShowAlert
-- =============================================
CREATE PROC [dbo].[ShowAlert]
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		IB.IssueBookID									AS IssueBookID,
		IB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,
		BB.BookID										AS BookID,
		B.[Name]										AS BookName,
		IB.CandidateID									AS CandidateID,
		IB.IssuedOn										AS IssuedOn,
		IB.ReturnDate									AS ReturnDate,
		IB.ReturnedOn									AS ReturnedOn,
		IB.LastRenewaledOn								AS LastRenewaledOn,
		IB.NoOfTimeRenewal								AS NoOfTimeRenewal,
		IB.Remark										AS Remark,
		C.[Name]										AS CandidateNames
	FROM
		IssueBook										AS IB
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = IB.BookBarcodeID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	INNER JOIN
		Candidate										AS C
	ON
		C.CandidateID =  IB.CandidateID
	WHERE
		IB.ReturnedOn IS NULL
	AND
		IB.ReturnDate <= CAST(DATEADD(DAY, 5, GETDATE()) AS DATE)
	AND
		(@SearchValue									IS NULL OR 
		C.[Name]											LIKE '%' + @SearchValue + '%' OR
		B.[Name]											LIKE '%' + @SearchValue + '%' OR
		BB.Barcode											LIKE '%' + @SearchValue + '%')
	AND
		IB.IsActive = 1
	ORDER BY ReturnDate;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowAuthor]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show author
-- Execution:	EXEC ShowAuthor
-- =============================================
CREATE PROC [dbo].[ShowAuthor]
	@AuthorID											INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										NVARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		A.AuthorID										AS AuthorID,
		A.[Name]										AS [Name],
		A.[Description]									AS [Description]
	FROM
		Author											AS A
	WHERE
		(A.AuthorID = @AuthorID OR @AuthorID IS NULL)
	AND
		(A.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		A.Name											LIKE '%' + @SearchValue + '%')
	AND
		A.IsActive = 1
	ORDER By A.AuthorID DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowAvailableBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 01/01/2020
-- Description:	Used to show available book detail
-- Execution:	EXEC ShowAvailableBook
-- =============================================
CREATE PROC [dbo].[ShowAvailableBook]

		@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		B.BookID										AS BookID,
		B.[Name]										AS [Name],
		B.Edition										AS Edition,
		B.Price											AS Price,
		B.ISBN											AS ISBN,
		B.[Description]									AS [Description],
		
		L.LanguageID									AS LanguageID,
		L.[Name]										AS [Language],

		B.AuthorID										AS AuthorID,
		A.[Name]										AS Author,

		B.PublisherID									AS PublisherID,
		P.[Name]										AS Publisher,
		(SELECT COUNT(*) FROM BookBarcode WHERE 
		IsActive = 1 AND BookID = B.BookID)				AS TotalQuantity,
		
		(SELECT COUNT(*) FROM IssueBook	AS IB
		INNER JOIN BookBarcode AS BB ON BB.BookBarcodeID = IB.BookBarcodeID
		INNER JOIN Book	AS Bk ON Bk.BookID = BB.BookID
		WHERE IB.ReturnedOn IS NULL AND IB.IsActive = 1 
		AND BB.IsActive = 1 AND Bk.IsActive = 1
		AND Bk.BookID = B.BookID)						AS TotalIssueBook,

		(SELECT COUNT(*) FROM IssueBook	AS IB
		INNER JOIN BookBarcode AS BB ON BB.BookBarcodeID = IB.BookBarcodeID
		INNER JOIN Book	AS Bk ON Bk.BookID = BB.BookID
		WHERE IB.ReturnedOn IS NOT NULL AND IB.IsActive = 1 
		AND BB.IsActive = 1 AND Bk.IsActive = 1
		AND Bk.BookID = B.BookID)						AS TotalReturnBook		
	FROM
		Book											AS B
	INNER JOIN
		Author											AS A
	ON
		A.AuthorID = B.AuthorID
	INNER JOIN
		Publisher										AS P
	ON
		P.PublisherID = B.PublisherID
	INNER JOIN
		[Language]										AS L
	ON
		L.LanguageID = B.LanguageID	
	WHERE
		(@SearchValue									IS NULL OR 
		B.[Name]										LIKE '%' + @SearchValue + '%' OR
		A.[Name]										LIKE '%' + @SearchValue + '%' )
	AND
		B.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowAvailableBookBarcodeByBookID]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shaikh Rizwan
-- Create date: 01/02/2020
-- Description:	Used to show book barcode detail
-- Execution:	EXEC ShowAvailableBookBarcodeByBookID @BookID = 1
-- =============================================
CREATE PROC [dbo].[ShowAvailableBookBarcodeByBookID]
	@BookBarcodeID										INT				= NULL,
	@BookID												INT				= NULL,
	@SearchValue										VARCHAR(100)	= NULL,
	@UserID												INT				= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		B.[Name]									AS [Name],
		L.LanguageID								AS LanguageID,
		L.[Name]									AS [Language],
		B.ISBN										AS ISBN,
		B.Price										AS Price,
		BB.BookBarcodeID							AS BookBarcodeID,
		BB.BookID									AS BookID,
		BB.Barcode									AS Barcode,
		A.AuthorID									AS AuthorID,
		A.[Name]									AS Author,
		P.PublisherID								AS PublisherID,
		P.[Name]									AS Publisher

	FROM
		Book										AS B
	INNER JOIN 
		BookBarcode									AS BB
	ON
		B.BookID = BB.BookID
	INNER JOIN
		Author										AS A
	ON
		A.AuthorID = B.AuthorID
	INNER JOIN
		Publisher									AS P
	ON
		P.PublisherID = B.PublisherID
	INNER JOIN
		[Language]									AS L
	ON
		L.LanguageID = B.LanguageID
	WHERE
		B.IsActive = 1
	AND
		BB.IsActive = 1
	AND
		B.BookID = @BookID
	AND
		NOT EXISTS(SELECT 1 FROM IssueBook WHERE BookBarcodeID = BB.BookBarcodeID
					AND ReturnedOn IS NULL AND IsActive = 1)
	AND
		(@SearchValue									IS NULL OR 
		B.[Name]										LIKE '%' + @SearchValue + '%' OR
		BB.Barcode										LIKE '%' + @SearchValue + '%');

	--IF NOT EXISTS(SELECT 1 FROM BookBarcode WHERE BookID = @BookID)
	--BEGIN
	--	SELECT
	--		BB.BookBarcodeID							AS BookBarcodeID,
	--		BB.BookID									AS BookID,
	--		BB.Barcode									AS Barcode,
	--		B.[Name]									AS [Name],
	--		B.[Language]								AS [Language]
			
	--	FROM
	--		BookBarcode									AS BB
	--	INNER JOIN
	--		Book										AS B
	--	ON	
	--		B.BookID = BB.BookID
	--	WHERE
	--		(BB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	--	AND
	--		(BB.BookID = @BookID OR @BookID IS NULL)
	--	AND
	--		(BB.CreatedBy = @UserID OR @UserID IS NULL)
	--	AND
	--		BB.IsActive = 1
	--	AND
	--		(@SearchValue								IS NULL OR 
	--			B.[Name]								LIKE '%' + @SearchValue + '%' OR
	--			BB.Barcode								LIKE '%' + @SearchValue + '%');
	--END
END
GO
/****** Object:  StoredProcedure [dbo].[ShowBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show book detail
-- Execution:	EXEC ShowBook @SearchValue = 'Founds'
-- =============================================
CREATE PROC [dbo].[ShowBook]
	@BookID												INT			= NULL,
	@AuthorID											INT			= NULL,
	@PublisherID										INT			= NULL,
	@UserID												INT			= NULL,
	@CategoryID											INT			= NULL,
	@SearchValue										NVARCHAR(100)= NULL,
	@Funds												VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		B.BookID										AS BookID,
		B.[Name]										AS [Name],
		B.Edition										AS Edition,
		B.Price											AS Price,
		B.ISBN											AS ISBN,
		B.[Description]									AS [Description],
		B.TotalQuantity									AS TotalQuantity,
		B.Funds											AS Funds,
		B.IsRestricted									AS IsRestricted,

		C.CategoryID									AS CategoryID,
		C.[Name]										AS Category,

		L.LanguageID									AS LanguageID,
		L.[Name]										AS [Language],								

		B.AuthorID										AS AuthorID,
		A.[Name]										AS Author,

		B.PublisherID									AS PublisherID,
		P.[Name]										AS Publisher
	FROM
		Book											AS B
	INNER JOIN
		Author											AS A
	ON
		A.AuthorID = B.AuthorID
	INNER JOIN
		Publisher										AS P
	ON
		P.PublisherID = B.PublisherID
	INNER JOIN
		[Language]										AS L
	ON
		L.LanguageID = B.LanguageID
	INNER JOIN
		Category										AS C
	ON
		C.CategoryID = B.CategoryID
	WHERE
		(B.BookID = @BookID OR @BookID IS NULL)
	AND
		(B.AuthorID = @AuthorID OR @AuthorID IS NULL)
	AND
		(B.PublisherID = @PublisherID OR @PublisherID IS NULL)
	AND
		(B.CategoryID = @CategoryID OR @CategoryID IS NULL)
	AND
		(B.Funds = @Funds OR @Funds IS NULL)
	AND
		(B.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		B.Name											LIKE '%' + @SearchValue + '%' OR
		B.Edition										LIKE '%' + @SearchValue + '%' OR
		L.[Name]										LIKE '%' + @SearchValue + '%' OR
		B.Price											LIKE '%' + @SearchValue + '%' OR
		B.ISBN											LIKE '%' + @SearchValue + '%' OR
		B.Funds											LIKE '%' + @SearchValue + '%' OR
		B.[Description]									LIKE '%' + @SearchValue + '%')
	AND
		B.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowBookBarcode]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show book barcode detail
-- Execution:	EXEC ShowBookBarcode @BookID = 1
-- =============================================
CREATE PROC [dbo].[ShowBookBarcode]
	@BookBarcodeID										INT				= NULL,
	@BookID												INT				= NULL,
	@SearchValue										VARCHAR(100)	= NULL,
	@UserID												INT				= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		BB.BookBarcodeID								AS BookBarcodeID,
		BB.BookID										AS BookID,
		BB.Barcode										AS Barcode,
		B.[Name]										AS [Name],
		L.LanguageID									AS LanguageID,
		L.[Name]										AS [Language],
		B.[Price]										AS [Price],
		B.ISBN											AS ISBN,
		A.AuthorID										AS AuthorID,
		A.[Name]										AS Author,
		P.PublisherID									AS PublisherID,
		P.[Name]										AS Publisher
	FROM
		BookBarcode										AS BB
	INNER JOIN
		Book											AS B
	ON	
		B.BookID = BB.BookID
	INNER JOIN
		Author											AS A
	ON
		A.AuthorID = B.AuthorID
	INNER JOIN
		Publisher										AS P
	ON
		P.PublisherID = B.PublisherID
	INNER JOIN
		[Language]										AS L
	ON
		L.LanguageID = B.LanguageID 
	WHERE
		(BB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(BB.BookID = @BookID OR @BookID IS NULL)
	AND
		(BB.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue										IS NULL OR 
			B.[Name]										LIKE '%' + @SearchValue + '%' OR
			BB.Barcode										LIKE '%' + @SearchValue + '%')
	AND
		BB.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowBookHistory]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show book history detail
-- Execution:	EXEC ShowBookHistory @BookBarcodeID = 15
-- =============================================
CREATE PROC [dbo].[ShowBookHistory]
	@BookHistoryID										INT			= NULL,
	@BookBarcodeID										INT			= NULL,
	@CandidateID										INT			= NULL,
	@Barcode											VARCHAR(50)	= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT
		BH.BookHistoryID								AS BookHistoryID,
		BH.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,				
		BH.CandidateID									AS CandidateID,
		BH.[Date]										AS [Date],
		BH.[Status]										AS [Status],
		C.[Name]										AS [Name],
		C.[Role]										AS [Role],
		C.ContactNumber									AS ContactNumber,
		C.Unit											AS Unit,
		B.[Name]										AS BookName,
		B.Price											AS Price,
		L.LanguageID									AS LanguageID,
		L.[Name]										AS [Language]
	FROM
		BookHistory										AS BH
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = BH.BookBarcodeID
	INNER JOIN
		Candidate										AS C
	ON
		C.CandidateID = BH.CandidateID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	--INNER JOIN
	--	IssueBook										AS IB
	--ON
	--	IB.BookBarcodeID = BB.BookBarcodeID
	--AND
	--	IB.CandidateID = U.UserID
	INNER JOIN
		[Language]										AS L
	ON
		L.LanguageID = B.LanguageID
	WHERE
		(BH.BookHistoryID = @BookHistoryID OR @BookHistoryID IS NULL)
	AND
		(BH.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(BH.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(BB.Barcode = @Barcode OR @Barcode IS NULL)
	AND
		(BH.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		BH.[Status]										LIKE '%' + @SearchValue + '%' OR
		BH.[Date]										LIKE '%' + @SearchValue + '%' OR
		B.[Name]										LIKE '%' + @SearchValue + '%' OR
		C.[Name]										LIKE '%' + @SearchValue + '%')
	AND
		BH.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowCandidate]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 26/02/2020
-- Description:	Used to show candidate detail
-- Execution:	EXEC ShowCandidate 
-- =============================================
CREATE PROC [dbo].[ShowCandidate]
	@CandidateID										INT				= NULL,
	@CourseID											INT				= NULL,
	@Role												VARCHAR(20)		= NULL,
	@ThumbImpression									VARCHAR(MAX)	= NULL,
	@Barcode											VARCHAR(50)		= NULL,
	@UserID												INT				= NULL,
	@SearchValue										NVARCHAR(100)	= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		C.CandidateID									AS CandidateID,
		C.Barcode										AS Barcode,
		C.[Role]										AS [Role],
		C.[Name]										AS [Name],
		C.ContactNumber									AS ContactNumber,
		C.ServiceNo										AS ServiceNo,
		C.CourseID										AS CourseID,
		Cour.[Name]										AS CourseName,
		Cour.[Description]								AS CourseDescription,
		CONVERT(VARCHAR, C.FromDate, 105)				AS FromDate,
		CONVERT(VARCHAR, C.ToDate, 105)					AS ToDate,
		C.Battalion										AS Battalion,
		CONVERT(VARCHAR, C.TOSDate, 105)				AS TOSDate,
		CONVERT(VARCHAR, C.SOSDate, 105)				AS SOSDate,
		C.ThumbImpression								AS ThumbImpression
	FROM
		Candidate										AS C
	LEFT JOIN
		Course											AS Cour
	ON
		Cour.CourseID = C.CourseID
	WHERE
		(C.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(C.CourseID = @CourseID OR @CourseID IS NULL)
	AND
		(C.[Role] = @Role OR @Role IS NULL)
	AND
		(C.ThumbImpression = @ThumbImpression OR @ThumbImpression IS NULL)
	AND
		(C.Barcode = @Barcode OR @Barcode IS NULL)
	AND
		(@SearchValue								IS NULL OR 
		C.[Name]									LIKE '%' + @SearchValue + '%' OR
		C.ContactNumber								LIKE '%' + @SearchValue + '%' OR
		C.ServiceNo									LIKE '%' + @SearchValue + '%' OR
		C.TOSDate									LIKE '%' + @SearchValue + '%' OR
		C.SOSDate									LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowCandidateDue]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show candidate due detail
-- Execution:	EXEC ShowCandidateDue
-- =============================================
CREATE PROC [dbo].[ShowCandidateDue]
	@CandidateDueID										INT			= NULL,
	@BookHistoryID										INT			= NULL,
	@CandidateID										INT			= NULL,
	@UserID												INT			= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		CD.CandidateDueID								AS CandidateDueID,
		CD.BookBarcodeID								AS BookBarcodeID,
		CD.CandidateID									AS CandidateID,
		CD.DueAmount									AS DueAmount,
		CD.Remark										AS Remark
	FROM
		CandidateDue									AS CD
	WHERE
		(CD.CandidateDueID = @CandidateDueID OR @CandidateDueID IS NULL)
	AND
		(CD.BookBarcodeID = @BookHistoryID OR @BookHistoryID IS NULL)
	AND
		(CD.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(CD.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		CD.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowCategory]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid khan
-- Create date: 05/11/2019
-- Description:	Used to show categories list
-- Execution:	EXEC ShowCategory @CategoryID = 7, @ParentID = 2
-- =============================================
CREATE PROC [dbo].[ShowCategory]
	@CategoryID											INT			= NULL,
	@ParentID											INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		C.CategoryID									AS CategoryID,
		C.[Name]										AS [Name],
		C.ParentID										AS ParentID
	FROM
		Category										AS C
	WHERE
		(C.ParentID IS NULL OR @CategoryID IS NOT NULL OR @ParentID IS NOT NULL)
	AND
		(C.CategoryID = @CategoryID OR @CategoryID IS NULL)
	AND
		(C.ParentID = @ParentID OR @ParentID IS NULL)
	AND
		(C.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		C.[Name]										LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowCategoryByName]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid khan
-- Create date: 05/11/2019
-- Description:	Used to show categories list
-- Execution:	EXEC ShowCategory @SearchValue = 'Magazine'
-- =============================================
CREATE PROC [dbo].[ShowCategoryByName]
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		C.CategoryID									AS CategoryID,
		C.[Name]										AS [Name],
		C.ParentID										AS ParentID
	FROM
		Category										AS C
	WHERE
		(@SearchValue									IS NULL OR 
		C.[Name]										LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowCountry]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 26/02/2020
-- Description:	Used to show country
-- Execution:	EXEC ShowCountry
-- =============================================
CREATE PROC [dbo].[ShowCountry]
	@CountryID											INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		C.CountryID										AS CountryID,
		C.[Name]										AS [Name]
	FROM
		Country											AS C
	WHERE
		(C.CountryID = @CountryID OR @CountryID IS NULL)
	AND
		(C.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		C.[Name]										LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowCourse]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 26/02/2020
-- Description:	Used to show course
-- Execution:	EXEC ShowCourse
-- =============================================
CREATE PROC [dbo].[ShowCourse]
	@CourseID											INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		C.CourseID										AS CourseID,
		C.[Name]										AS [Name],
		C.FromDate										AS FromDate,
		C.ToDate										AS ToDate,
		C.[Description]									AS [Description]
	FROM
		Course											AS C
	WHERE
		(C.CourseID = @CourseID OR @CourseID IS NULL)
	AND
		(C.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		C.[Name]										LIKE '%' + @SearchValue + '%' OR
		C.[Description]									LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowDashboard]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid khan
-- Create date: 20/12/2019
-- Description:	Used to show dashboard details
-- Execution:	EXEC ShowDashboard
-- =============================================
CREATE PROC [dbo].[ShowDashboard]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		(SELECT COUNT(*) FROM Author
		WHERE IsActive = 1)									AS	TotalAuthor,

		(SELECT COUNT(*) FROM Publisher 
		WHERE IsActive = 1)									AS	TotalPublisher,

		(SELECT COUNT(*) FROM [User] 
		WHERE [Role] = 'LIBRARIAN' AND IsActive = 1)		AS	TotalLibrarian,

		(SELECT COUNT(*) FROM Candidate 
		WHERE IsActive = 1)									AS	TotalCandidate,

		ISNULL((SELECT SUM(TotalQuantity) FROM Book
		WHERE IsActive = 1), 0)								AS	TotalBook,

		(SELECT COUNT(*) FROM IssueBook
		WHERE ReturnedOn IS NULL 
		AND IsActive = 1)									AS	TotalIssueBook,

		(SELECT COUNT(*) FROM IssueBook
		WHERE ReturnedOn IS NOT NULL 
		AND IsActive = 1)									AS	TotalReturnBook,

		(SELECT COUNT(*) FROM IssueBook
		WHERE LastRenewaledOn IS NOT NULL
		AND IsActive = 1)									AS	TotalRenewalBook,

		(SELECT COUNT(*) FROM IssueBook AS IB
		WHERE IB.ReturnedOn IS NULL AND
		IB.ReturnDate <= CAST(DATEADD(DAY, 5, GETDATE()) AS DATE)
		AND IB.IsActive = 1)								AS TotalPendingBook

END
GO
/****** Object:  StoredProcedure [dbo].[ShowFunds]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Arshad Ali	
-- Create date: 04/03/2020
-- Description:	Used to show Funds
-- Execution:	EXEC ShowFunds
-- =============================================
CREATE PROC [dbo].[ShowFunds]
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		B.BookID										AS BookID,
		B.Funds											AS Funds
	FROM
		Book											AS B
	WHERE
		(@SearchValue									IS NULL OR 
		B.Funds											LIKE '%' + @SearchValue + '%')
	AND
		B.IsActive = 1
	ORDER By B.CreatedOn DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowIssueBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 20/12/2019
-- Description:	Used to show issue book
-- Execution:	EXEC ShowIssueBook @StartDate = '2020-02-17', @EndDate = '2020-02-17'
-- =============================================
CREATE PROC [dbo].[ShowIssueBook]
	@IssueBookID										INT				= NULL,
	@BookBarcodeID										INT				= NULL,
	@CandidateID										INT				= NULL,
	@UserID												INT				= NULL,
	@Barcode											VARCHAR(50)		= NULL,
	@SearchValue										VARCHAR(100)	= NULL,
	@StartDate											DATE			= NULL,
	@EndDate											DATE			= NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF(@StartDate IS NULL)
	BEGIN
		SELECT
			@StartDate = CAST(MIN(IssuedOn) AS DATE)  FROM IssueBook WHERE IsActive = 1;
	END

	IF(@EndDate IS NULL)
	BEGIN
		SELECT
			@EndDate = CAST(MAX(IssuedOn) AS DATE) FROM IssueBook WHERE IsActive = 1;
	END

	SELECT
		IB.IssueBookID									AS IssueBookID,
		IB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,
		BB.BookID										AS BookID,
		B.[Name]										AS BookName,
		IB.CandidateID									AS CandidateID,
		IB.IssuedOn										AS IssuedOn,
		IB.ReturnDate									AS ReturnDate,
		IB.ReturnedOn									AS ReturnedOn,
		IB.LastRenewaledOn								AS LastRenewaledOn,
		IB.NoOfTimeRenewal								AS NoOfTimeRenewal,
		IB.Remark										AS Remark,
		C.[Name]										AS CandidateNames
	FROM
		IssueBook										AS IB
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = IB.BookBarcodeID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	INNER JOIN
		Candidate										AS C
	ON
		C.CandidateID =  IB.CandidateID
	WHERE
		IB.ReturnedOn IS NULL
	--AND
	--	IB.LastRenewaledOn IS  NULL
	AND
		(IB.IssueBookID = @IssueBookID OR @IssueBookID IS NULL)
	AND
		(IB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(IB.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(IB.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(BB.Barcode = @Barcode OR @Barcode IS NULL)
	AND
		CAST(IB.IssuedOn AS DATE) BETWEEN @StartDate AND @EndDate
	AND
		IB.IsActive = 1
	AND
		(@SearchValue									IS NULL OR 
		IB.IssuedOn										LIKE '%' + @SearchValue + '%' OR
		IB.ReturnDate									LIKE '%' + @SearchValue + '%' OR
		IB.ReturnedOn									LIKE '%' + @SearchValue + '%' OR
		IB.LastRenewaledOn								LIKE '%' + @SearchValue + '%' OR
		B.[Name]										LIKE '%' + @SearchValue + '%')
END
GO
/****** Object:  StoredProcedure [dbo].[ShowLanguage]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Shaikh Rizwan	
-- Create date: 18/12/2019
-- Description:	Used to show Language
-- Execution:	EXEC ShowLanguage
-- =============================================
CREATE PROC [dbo].[ShowLanguage]
	@LanguageID											INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		L.LanguageID									AS LanguageID,
		L.[Name]										AS [Name]
	FROM
		[Language]										AS L
	WHERE
		(L.LanguageID = @LanguageID OR @LanguageID IS NULL)
	AND
		(L.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		L.[Name]										LIKE '%' + @SearchValue + '%')
	AND
		L.IsActive = 1
	ORDER By L.LanguageID DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowMissingBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 19/12/2019
-- Description:	Used to show missing book detail
-- Execution:	EXEC ShowMissingBook
-- =============================================
CREATE PROC [dbo].[ShowMissingBook]
	@MissingBookID										INT			= NULL,
	@BookBarcodeID										INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		MB.MissingBookID								AS MissingBookID,
		MB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,
		B.BookID										AS BookID,
		B.[Name]										AS [Name],
		MB.Remark										AS Remark
	FROM
		MissingBook										AS MB
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = MB.BookBarcodeID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	WHERE
		(MB.MissingBookID = @MissingBookID OR @MissingBookID IS NULL)
	AND
		(MB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(MB.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		MB.BookBarcodeID								LIKE '%' + @SearchValue + '%' OR
		MB.Remark										LIKE '%' + @SearchValue + '%')
	AND
		MB.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowPublisher]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show publisher
-- Execution:	EXEC ShowPublisher
-- =============================================
CREATE PROC [dbo].[ShowPublisher]
	@PublisherID										INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										NVARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		P.PublisherID									AS PublisherID,
		P.[Name]										AS [Name],
		P.ContactNumber									AS ContactNumber,
		P.AlternateContactNumber						AS AlternateContactNumber,
		P.EmailID										AS EmailID,
		P.Fax											AS Fax,
		P.Website										AS Website,
		P.[Address]										AS [Address]
	FROM
		Publisher										AS P
	WHERE
		(P.PublisherID = @PublisherID OR @PublisherID IS NULL)
	AND
		(P.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		P.Name											LIKE '%' + @SearchValue + '%')
	AND
		P.IsActive = 1
	ORDER BY P.PublisherID DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowRank]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Arshad Ali
-- Create date: 02/03/2020
-- Description:	Used to show rank
-- Execution:	EXEC ShowRank
-- =============================================
CREATE PROC [dbo].[ShowRank]
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT
		C.[Rank]										AS [Rank]
	FROM
		Candidate										AS C
	WHERE
		(@SearchValue									IS NULL OR 
		C.[Rank]										LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowRenewalBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 20/12/2019
-- Description:	Used to show renewal book
-- Execution:	EXEC ShowRenewalBook @StartDate = '2020-01-01', @EndDate = '2020-01-09'
-- =============================================
CREATE PROC [dbo].[ShowRenewalBook]
	@IssueBookID										INT			= NULL,
	@BookBarcodeID										INT			= NULL,
	@CandidateID										INT			= NULL,
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL,
	@StartDate											DATE		= NULL,
	@EndDate											DATE		= NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF(@StartDate IS NULL)
	BEGIN
		SELECT
			@StartDate = CAST(MIN(LastRenewaledOn) AS DATE)  FROM IssueBook WHERE IsActive = 1;
	END
	
	IF(@EndDate IS NULL)
	BEGIN
		SELECT
			@EndDate = CAST(MAX(LastRenewaledOn) AS DATE) FROM IssueBook WHERE IsActive = 1;
	END

	SELECT
		IB.IssueBookID									AS IssueBookID,
		IB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,
		BB.BookID										AS BookID,
		B.[Name]										AS BookName,
		IB.CandidateID									AS CandidateID,
		IB.IssuedOn										AS IssuedOn,
		IB.ReturnDate									AS ReturnDate,
		IB.ReturnedOn									AS ReturnedOn,
		IB.LastRenewaledOn								AS LastRenewaledOn,
		IB.NoOfTimeRenewal								AS NoOfTimeRenewal,
		IB.Remark										AS Remark,
		C.[Name]										AS CandidateName
	FROM
		IssueBook										AS IB
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = IB.BookBarcodeID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	INNER JOIN
		Candidate										AS C
	ON
		C.CandidateID = IB.CandidateID
	WHERE
		IB.LastRenewaledOn IS NOT NULL 
	AND
		IB.ReturnedOn IS NULL
	AND
		(IB.IssueBookID = @IssueBookID OR @IssueBookID IS NULL)
	AND
		(IB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(IB.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(IB.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		(@SearchValue									IS NULL OR 
		IB.IssuedOn										LIKE '%' + @SearchValue + '%' OR
		IB.ReturnDate									LIKE '%' + @SearchValue + '%' OR
		IB.ReturnedOn									LIKE '%' + @SearchValue + '%' OR
		IB.LastRenewaledOn								LIKE '%' + @SearchValue + '%' OR
		B.[Name]										LIKE '%' + @SearchValue + '%' OR
		C.[Name]										LIKE '%' + @SearchValue + '%' )
	AND
		IB.IsActive = 1
	AND
		CAST(IB.LastRenewaledOn AS DATE) BETWEEN @StartDate AND @EndDate
END
GO
/****** Object:  StoredProcedure [dbo].[ShowReturnBook]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 20/12/2019
-- Description:	Used to show return book
-- Execution:	EXEC ShowReturnBook @StartDate = '11-01-2020', @EndDate = '11-01-2020'
-- =============================================
CREATE PROC [dbo].[ShowReturnBook]
	@IssueBookID										INT				= NULL,
	@BookBarcodeID										INT				= NULL,
	@CandidateID										INT				= NULL,
	@UserID												INT				= NULL,
	@SearchValue										VARCHAR(100)	= NULL,
	@StartDate											DATE			= NULL,
	@EndDate											DATE			= NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF(@StartDate IS NULL)
	BEGIN
		SELECT
			@StartDate = MIN(ReturnedOn) FROM IssueBook WHERE IsActive = 1;
	END

	IF(@EndDate IS NULL)
	BEGIN
		SELECT
			@EndDate = MAX(ReturnedOn) FROM IssueBook WHERE IsActive = 1;
	END

	SELECT
		IB.IssueBookID									AS IssueBookID,
		IB.BookBarcodeID								AS BookBarcodeID,
		BB.Barcode										AS BookBarcode,
		BB.BookID										AS BookID,
		B.[Name]										AS BookName,
		IB.CandidateID									AS CandidateID,
		IB.IssuedOn										AS IssuedOn,
		IB.ReturnDate									AS ReturnDate,
		IB.ReturnedOn									AS ReturnedOn,
		IB.LastRenewaledOn								AS LastRenewaledOn,
		IB.NoOfTimeRenewal								AS NoOfTimeRenewal,
		IB.Remark										AS Remark,
		C.[Name]										AS CandidateName
	FROM
		IssueBook										AS IB
	INNER JOIN
		BookBarcode										AS BB
	ON
		BB.BookBarcodeID = IB.BookBarcodeID
	INNER JOIN
		Book											AS B
	ON
		B.BookID = BB.BookID
	INNER JOIN
		Candidate										AS C
	ON
		C.CandidateID = IB.CandidateID
	WHERE
		IB.ReturnedOn IS NOT NULL
	AND
		(IB.IssueBookID = @IssueBookID OR @IssueBookID IS NULL)
	AND
		(IB.BookBarcodeID = @BookBarcodeID OR @BookBarcodeID IS NULL)
	AND
		(IB.CandidateID = @CandidateID OR @CandidateID IS NULL)
	AND
		(IB.CreatedBy = @UserID OR @UserID IS NULL)
	AND
		IB.ReturnedOn BETWEEN @StartDate AND @EndDate
	AND
		(@SearchValue									IS NULL OR 
		IB.IssuedOn										LIKE '%' + @SearchValue + '%' OR
		IB.ReturnDate									LIKE '%' + @SearchValue + '%' OR
		IB.ReturnedOn									LIKE '%' + @SearchValue + '%' OR
		IB.LastRenewaledOn								LIKE '%' + @SearchValue + '%' OR
		C.[Name]										LIKE '%' + @SearchValue + '%' OR
		B.[Name]										LIKE '%' + @SearchValue + '%' );
END
GO
/****** Object:  StoredProcedure [dbo].[ShowUnit]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Arshad Ali
-- Create date: 02/03/2020
-- Description:	Used to show unit
-- Execution:	EXEC ShowUnit
-- =============================================
CREATE PROC [dbo].[ShowUnit]
	@UserID												INT			= NULL,
	@SearchValue										VARCHAR(100)= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT
		C.Unit											AS Unit
	FROM
		Candidate										AS C
	WHERE
		(@SearchValue									IS NULL OR 
		C.[Rank]										LIKE '%' + @SearchValue + '%')
	AND
		C.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[ShowUser]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to show user
-- Execution:	EXEC ShowUser @SearchValue = 'ah'
-- =============================================
CREATE PROC [dbo].[ShowUser]
	@UserID												INT				= NULL,
	@Role												VARCHAR(10)		= NULL,
	@ThumbImpression									VARCHAR(MAX)	= NULL,
	@CreatedBy											INT				= NULL,
	@SearchValue										VARCHAR(100)	= NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		U.UserID										AS UserID,
		U.[Name]										AS [Name],
		U.ContactNumber									AS ContactNumber,
		U.Email											AS Email,
		U.UserName										AS UserName,
		U.[Password]									AS [Password],
		U.ThumbImpression								AS ThumbImpression,
		U.[UID]											AS [UID],
		U.[Role]										AS [Role]
	FROM
		[User]											AS U
	WHERE
		(U.UserID = @UserID OR @UserID IS NULL)
	AND
		(U.[Role] = @Role OR @Role IS NULL)
	AND
		(U.ThumbImpression = @ThumbImpression OR @ThumbImpression IS NULL)
	AND
		(@SearchValue								IS NULL OR 
		U.[Name]									LIKE '%' + @SearchValue + '%' OR
		U.[UID]										LIKE '%' + @SearchValue + '%' )
	AND
		U.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUserProfile]    Script Date: 23-08-2024 11:11:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Junaid Khan
-- Create date: 18/12/2019
-- Description:	Used to update the user profile
-- =============================================
CREATE PROC [dbo].[UpdateUserProfile]
	@UserID												INT,
	@Name												VARCHAR(50),
	@ContactNumber										VARCHAR(15)		= NULL,
	@Email												VARCHAR(200)	= NULL,
	@UserName											VARCHAR(50)		= NULL,
	@Password											VARCHAR(50)		= NULL,
	@ThumbImpression									VARCHAR(MAX)	= NULL,
	@UID												VARCHAR(50)		= NULL,
	@Role												VARCHAR(10),
	@CreatedBy											INT,
	@OutputMessage										VARCHAR(MAX)	OUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF EXISTS(SELECT 1 FROM [User] WHERE UserID = @UserID)
		BEGIN
			UPDATE
				[User]
			SET
				[Name]				= @Name,
				ContactNumber		= @ContactNumber,
				Email				= @Email,
				UserName			= @UserName,
				[Password]			= @Password,
				ThumbImpression		= @ThumbImpression,
				[UID]				= @UID,
				[Role]				= @Role,
				UpdatedBy			= @CreatedBy,
				UpdatedOn			= GETDATE()
			WHERE
				UserID				= @UserID
			SET
				@OutputMessage = 'SUCCESS';
		END
		ELSE
		BEGIN
			SET
				@OutputMessage = 'Invalid';
		END
		
	END TRY

	BEGIN CATCH
		DECLARE @ErrorNumber			INT
		DECLARE @ErrorSeverity			INT
		DECLARE @ErrorState				INT
		DECLARE @ErrorProcedure			NVARCHAR(126)
		DECLARE @ErrorLine				INT
		DECLARE @ErrorMessage			NVARCHAR(MAX)
		
		SELECT
			@ErrorNumber				= ERROR_NUMBER(),
			@ErrorSeverity				= ERROR_SEVERITY(),
			@ErrorState					= ERROR_STATE(),
			@ErrorProcedure				= ERROR_PROCEDURE(),
			@ErrorLine					= ERROR_LINE(),
			@ErrorMessage				= ERROR_MESSAGE();

		SET
			 @OutputMessage = @ErrorMessage

		 RAISERROR(' Error #: %d in %s . Message: %s', @ErrorSeverity, @ErrorState, 
		 @ErrorProcedure, @ErrorMessage);
	END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [LibrarySystem-Army] SET  READ_WRITE 
GO
