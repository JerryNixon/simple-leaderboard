CREATE TABLE [dbo].[game](
	[id] [int] NOT NULL,
	[name] [varchar](500) NOT NULL,
	CONSTRAINT [PK_game] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[gamer](
	[id] [int] NOT NULL,
	[name] [varchar](500) NOT NULL,
	[email] [varchar](500) NOT NULL,
	CONSTRAINT [PK_gamer] PRIMARY KEY CLUSTERED ([id] ASC)
);
GO

CREATE TABLE [dbo].[score](
	[id] [int] NOT NULL,
	[gamer_id] [int] NOT NULL,
	[game_id] [int] NOT NULL,
	[date] [datetime] NOT NULL DEFAULT (getdate()),
	[score] [bigint] NOT NULL DEFAULT (0),
	CONSTRAINT [PK_score] PRIMARY KEY CLUSTERED ([id] ASC),
	CONSTRAINT [FK_score_game] FOREIGN KEY([game_id]) REFERENCES [dbo].[game] ([id]),
	CONSTRAINT [FK_score_gamer] FOREIGN KEY([gamer_id]) REFERENCES [dbo].[gamer] ([id])
);
GO
