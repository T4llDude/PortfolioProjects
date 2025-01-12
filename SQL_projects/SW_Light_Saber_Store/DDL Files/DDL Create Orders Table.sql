USE [SWLightSaberStore]
GO

/****** Object:  Table [dbo].[Orders]    Script Date: 1/12/2025 4:03:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Orders](
	[Id] [int] NOT NULL,
	[Order_Date] [date] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Address_Id] [int] NOT NULL,
	[Product_Id] [int] NOT NULL,
	[Product_Color_Id] [int] NOT NULL,
	[Order_Total] [money] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Address_Id] FOREIGN KEY([Address_Id])
REFERENCES [dbo].[Customer_Address] ([Id])
GO

ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Address_Id]
GO

ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customer_Id] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[Customer] ([Id])
GO

ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customer_Id]
GO

ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Product_Color_Id] FOREIGN KEY([Product_Color_Id])
REFERENCES [dbo].[Product_Color] ([Id])
GO

ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Product_Color_Id]
GO

ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Product_Id] FOREIGN KEY([Product_Id])
REFERENCES [dbo].[Products] ([Id])
GO

ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Product_Id]
GO


