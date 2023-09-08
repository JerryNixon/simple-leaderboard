CREATE TABLE [dbo].[game](
	[id] [int] PRIMARY KEY,
	[name] [varchar](500) NOT NULL
);
GO

CREATE TABLE [dbo].[gamer](
	[email] [varchar](500) PRIMARY KEY,
	[name] [varchar](500) NOT NULL
);
GO

CREATE TABLE [dbo].[score](
	[id] [int] PRIMARY KEY,
	[gamer_email] [varchar](500) NOT NULL,
	[game_id] [int] NOT NULL,
	[date] [datetime] NOT NULL DEFAULT (getdate()),
	[score] [bigint] NOT NULL DEFAULT (0),
	CONSTRAINT [FK_score_game] FOREIGN KEY([game_id]) REFERENCES [dbo].[game] ([id]),
	CONSTRAINT [FK_score_gamer] FOREIGN KEY([gamer_email]) REFERENCES [dbo].[gamer] ([email])
);
GO
