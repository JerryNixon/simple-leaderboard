# cornell-leaderboard
You will create both a client and a database. The client is a simple snake game. It is sophisticated enough to help teach you basic C# skills. The database is SQL. With it, you will learn schema and structure as well as some of the basic skills needed to query the data for building a leaderboard. In the end, this project will let you have a game with a leaderboard that is more than just the "top 10" but also analyzes gameplay in a way that makes it fun and potentially predictive.  

# Database

Let's start by looking at the database. This diagram shows our three tables. 

![image](https://github.com/JerryNixon/cornell-leaderboard/assets/1749983/da005c24-f88a-41dc-a630-fcc9bf1835ce)

# Create

To bring this database schema to life, you'll execute the provided SQL script in your Azure SQL Database environment. Each `CREATE TABLE` statement defines a table—`game`, `gamer`, & `score`. Following each table definition, the `GO` command signals the end of a batch of SQL statements, essentially saying, "Execute what came before me."

Here are some steps & pointers for flawless execution:

1. **Open your SQL environment**: This could be Azure Data Studio, SQL Server Management Studio, or even a query window in the Azure portal.

2. **Connect to Your Database**: Make sure you're connected to the Azure SQL Database where you wish to create these tables.

3. **Run the Script**: Copy & paste the entire SQL script into the query window and execute it.

4. **Commit**: If your environment requires explicit transaction control, don't forget to commit the transaction.

5. **Verify**: After execution, refresh your object explorer or equivalent, & navigate to the Tables section. You should see the new tables listed there.

The script sets up the foundation on which your C# application & your SQL queries will operate. So, make sure to run it carefully. Once the tables are created, you can proceed to interact with them as you develop your game & build analytical views.

````SQL
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
````

# A closer look

Let's take a closer look at the columns, defaults and constraints in these tables.

### The Tables

1. **Game Table**: Think of this as the stage where all the action happens. It has two columns:
   - `id`: The unique identifier for each game.
   - `name`: The name of the game.

2. **Gamer Table**: This is your cast of characters. Again, two vital columns:
   - `id`: The unique identifier for each gamer.
   - `name` & `email`: The name and email of the gamer.

3. **Score Table**: This is the chronicle, the record book, capturing each gamer's achievements in various games over time.
   - `id`: The unique identifier for each score entry.
   - `gamer_id`: Links to the gamer who scored. 
   - `game_id`: Links to the game where the score was achieved.
   - `date`: The date & time of the score. It defaults to the current date & time.
   - `score`: The score itself, defaulting to 0.

### The Constraints & Defaults

- **Primary Keys (PK)**: These are the linchpins holding each table together. Each table has a primary key ensuring all records are unique.
  - `PK_game`, `PK_gamer`, `PK_score`: Ensures uniqueness for game, gamer, & score tables, respectively.

- **Foreign Keys (FK)**: These are the sinews connecting our tables.
  - `FK_score_game`: Ensures that the `game_id` in the Score table matches an `id` in the Game table.
  - `FK_score_gamer`: Makes sure the `gamer_id` in the Score table corresponds to an `id` in the Gamer table.

- **Defaults**: These are our safety nets.
  - `date`: Defaults to the current date & time via `getdate()`.
  - `score`: Defaults to 0, just to have a value there from the get-go.

### The Big Picture

Imagine you're crafting an intricate narrative that tracks each gamer's journey through various games. The 'Score' table is your evolving storyline. It's continuously updated with each gamer's exploits (their scores), time-stamped for analysis.

Students, as you create your client game in C#, you'll interact with this schema. You'll need to insert new records into the 'Score' table every time a game is played. Likewise, for your data analysis, you could craft SQL queries or views to find out who the top players are, or who excels during nocturnal hours. 

# Inserting Sample Data into Tables

Now that your tables are up & running, the next step is to populate them with some sample data. This will give you some realistic records to work with as you develop queries & build your game logic in C#.

## High-Level Steps:

1. **Open your SQL environment**: If you've closed it, reopen your SQL tool of choice.

2. **Connect to Your Database**: Double-check that you're operating within the correct Azure SQL Database.

3. **Run the Script**: You'll find a sample data script below. Copy & paste it into your SQL environment, then execute it.

## Sample Data SQL Script

```SQL
-- Inserting sample data into game table
INSERT INTO [dbo].[game] (id, name)
VALUES (1, 'Space Invaders'), (2, 'Pac-Man'), (3, 'Asteroids');

-- Inserting sample data into gamer table
INSERT INTO [dbo].[gamer] (id, name, email)
VALUES (1, 'John', 'john@email.com'), (2, 'Sara', 'sara@email.com'), (3, 'Mike', 'mike@email.com');

-- Inserting sample data into score table
INSERT INTO [dbo].[score] (id, gamer_id, game_id, date, score)
VALUES (1, 1, 1, GETDATE(), 5000), (2, 2, 1, GETDATE(), 4200), (3, 3, 2, GETDATE(), 3800), 
       (4, 1, 3, GETDATE(), 6000), (5, 2, 3, GETDATE(), 5600);

GO
```

With this sample data, you'll have a rudimentary leaderboard, featuring gamers John, Sara, & Mike, who've scored points in Space Invaders, Pac-Man, & Asteroids. Now we can start crafting queries & game logic, analyzing trends like who's the top scorer in Space Invaders or what's the average score for Asteroids. 

# Our First Query: Top 10 Space Invaders Gamers

Now that your tables are populated with sample data, let's move on to querying. The first query we'll tackle is identifying the top 10 leaders for the game "Space Invaders."

## High-Level Steps:

1. **Open SQL Environment**: Resume your SQL workspace.

2. **SQL Query Window**: Make sure it's active & you're connected to your database.

3. **Run the Query**: Copy the SQL query below & execute it.

4. **Examine Output**: Understand the resulting leaderboard.

# Our First Query: Top 10 Space Invaders Gamers

## SQL Query
```SQL
SELECT TOP 10 
    gamer.name AS GamerName,
    score.score AS Score
FROM [dbo].[score] AS score
JOIN [dbo].[gamer] AS gamer ON score.gamer_id = gamer.id
JOIN [dbo].[game] AS game ON score.game_id = game.id
WHERE game.id = 1
ORDER BY score.score DESC;
```

## Query Explanation

1. **SELECT TOP 10**: The `TOP 10` limits the output to only the first 10 records based on the criteria in the `ORDER BY` clause. Think of it as picking the 10 richest people in a room full of millionaires.

2. **SELECT Projection**: `gamer.name AS GamerName` renames the `name` column from the `gamer` table to "GamerName" in the output. Likewise, `score.score AS Score` renames the `score` column as "Score."

3. **FROM [dbo].[score] AS score**: The `AS` keyword allows us to alias the table name to something shorter or more convenient.

4. **JOIN ON**: These clauses assemble our tables together like interlocking puzzle pieces. They tie the `score` table to the `gamer` & `game` tables by matching `gamer_id` & `game_id`.

5. **WHERE game.id = 1**: The predicate now focuses on filtering scores based on the `id` of the game, not its name. This makes the query more efficient, as integers are quicker to compare than strings.

6. **ORDER BY score.score DESC**: Orders the scores in descending order, putting the highest scores at the top of the output. Imagine arranging a bookshelf with the biggest books at the top.

7. **Semicolon**: The semicolon is like a period in a sentence; it marks the end of the SQL query, indicating to the SQL server that this is where the command concludes.

There you have it. This explanation should provide the knowledge you need to understand how this query retrieves the top 10 gamers for Space Invaders. Keep querying, the treasure trove of insights awaits!

### Creating a View: Top10SpaceInvaders

## Goal
To encapsulate the query logic for retrieving the top 10 Space Invaders gamers into a view. This way, you can simply reference the view instead of writing out the full query each time you need this data.

## SQL Query for Creating the View
```SQL
CREATE VIEW Top10SpaceInvaders AS
SELECT TOP 10
    gamer.name AS GamerName,
    score.score AS Score
FROM [dbo].[score] AS score
JOIN [dbo].[gamer] AS gamer ON score.gamer_id = gamer.id
JOIN [dbo].[game] AS game ON score.game_id = game.id
WHERE game.id = 1;
```

This query creates the view and is referred to as DDL (Data Definition Language) because it shapes the structure of the database rather than manipulating the data within it. In other words, DDL commands define "what we talk about" when we refer to a database, laying out the tables, views, or indexes—essentially setting the stage for the data drama to unfold. In contrast, Data Manipulation Language (DML) commands like `SELECT`, `INSERT`, or `UPDATE` interact with the data that resides in these structures. Think of DDL as the grammar rules of a language, setting the foundation, while DML is like the sentences we construct using those rules.

## Further Explanation

1. **CREATE VIEW Top10SpaceInvaders**: The `CREATE VIEW` command followed by the view name (`Top10SpaceInvaders`) establishes a new view. Think of a view as a saved SQL query, like a shortcut on your desktop.

2. **AS**: The `AS` keyword signifies the beginning of the SQL query that the view encapsulates. This is akin to the ribbon cutting in an inauguration ceremony—it marks the start of something important.

## Subsection: Altering the View to Include ORDER BY
Here, we'll modify the view to include the `ORDER BY` clause so that the top scores are sorted.

## SQL Query for Altering the View
```SQL
ALTER VIEW Top10SpaceInvaders AS
SELECT TOP 10
    gamer.name AS GamerName,
    score.score AS Score
FROM [dbo].[score] AS score
JOIN [dbo].[gamer] AS gamer ON score.gamer_id = gamer.id
JOIN [dbo].[game] AS game ON score.game_id = game.id
WHERE game.id = 1
ORDER BY score.score DESC;
```

## Explanation for Altering the View
1. **ALTER VIEW**: The `ALTER VIEW` command updates an existing view. This is much like editing a saved document—you don't create a new one, you refine what's already there.

2. **ORDER BY score.score DESC**: Unlike in the initial `CREATE VIEW`, we've now added the `ORDER BY` clause to sort scores in descending order.

By now, you should have a solid grasp of how to create and alter views in SQL. These techniques make querying more convenient and your SQL environment more organized.
