/* Customer_Address */
USE SWLightSaberStore
GO

INSERT INTO dbo.Customer_Address
(Id,
Customer_Id,
AddressLine1,
AddressLine2,
City,
State) 
VALUES 
(1,1,'123 Main St','N/A','Wantabagel','CA'),
(2,2,'123 Main St','N/A','Denver','CO'),
(3,4,'123 Main st','N/A','Atlanta','GA'),
(4,3,'123 Main St','N/A','Seattle','WA'),
(5,6,'123 Dune St','N/A','Tatooine','NC'),
(6,7,'123 Goo St','N/A','Gleneg','MD'),
(7,8,'123 Read St','N/A','Washington','DC'),
(8,9,'456 Doo St','N/A','Washington','DC'),
(9,10,'546 Boo St','N/A','San Francisco','CA'),
(10,12,'765 Freak Dr','N/A','West End','NC'),
(11,11,'321 Boomer Ct','N/A','West END','NC'),
(12,13,'671 Yolka Ln','N/A','Boston','MA'),
(13,14,'659 Poo ln','N/A','New York','NY'),
(14,15,'1 Treato lane','N/A','Camden','NJ'),
(15,16,'453 Spooner St','N/A','SpringField','KS'),
(16,18,'561 Spoink St','N/A','Baltimore','MD'),
(17,17,'563 Spoink ST','N/A','Baltimore','MD'),
(18,19,'783 Giggity Rd','N/A','Columbia','MD'),
(19,20,'654 Oh No Dr','N/A','Columbia','MD'),
(20,21,'1 Your My Hope Dr','N/A','Omaha','ND'),
(21,22,'53 Bounty Dr','N/A','New Orleans','LA'),
(22,24,'7 Fett Rd','N/A','Miami','FL'),
(23,23,'8 Fett Rd','N/A','Miami','FL'),
(24,5,'159 Fink Lane','N/A','Omaha','ND')