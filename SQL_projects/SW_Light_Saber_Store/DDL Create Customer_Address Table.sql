USE [SWLightSaberStore]
GO

/****** Object:  Table [dbo].[Customer_Address]    Script Date: 1/12/2025 4:02:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customer_Address](
	[Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Address_Line1] [varchar](100) NOT NULL,
	[Address_Line2] [varchar](100) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [char](2) NOT NULL,
 CONSTRAINT [PK_Customer_Address] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customer_Address]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Address_Customer_Id] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[Customer] ([Id])
GO

ALTER TABLE [dbo].[Customer_Address] CHECK CONSTRAINT [FK_Customer_Address_Customer_Id]
GO


