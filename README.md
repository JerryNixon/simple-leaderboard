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

## Some explanation of that query

The `INTO` keyword specifies the destination table for the data. For example, `[dbo].[game]`, `[dbo].[gamer]`, and `[dbo].[score]` are the target tables here.

The parentheses following `INTO` hold the columns to be populated, such as `(id, name)` for the `game` table or `(id, gamer_id, game_id, date, score)` for the `score` table. This ensures that the values specified in the `VALUES` clause go into the correct columns.

The `VALUES` keyword is followed by sets of data in parentheses. For example, `(1, 'John', 'john@email.com')` inserts a new row into the `gamer` table. Multiple rows can be inserted at once by separating each set of values with a comma.

The `GETDATE()` function in the `score` table's `VALUES` clause generates the current date and time, a common practice when you want to timestamp data.

The `GO` keyword signals the end of a batch of SQL statements, prompting the SQL Server to execute the preceding statements.

# Our First Query: Top 10 Space Invaders Gamers

Now that your tables are populated with sample data, let's move on to querying. The first query we'll tackle is identifying the top 10 leaders for the game "Space Invaders."

## High-Level Steps:

1. **Open SQL Environment**: Resume your SQL workspace.

2. **SQL Query Window**: Make sure it's active & you're connected to your database.

3. **Run the Query**: Copy the SQL query below & execute it.

4. **Examine Output**: Understand the resulting leaderboard.

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

## Explanation of the Query Sytnax

1. **SELECT TOP 10**: The `TOP 10` limits the output to only the first 10 records based on the criteria in the `ORDER BY` clause. Think of it as picking the 10 richest people in a room full of millionaires.

2. **SELECT Projection**: `gamer.name AS GamerName` renames the `name` column from the `gamer` table to "GamerName" in the output. Likewise, `score.score AS Score` renames the `score` column as "Score."

3. **FROM [dbo].[score] AS score**: The `AS` keyword allows us to alias the table name to something shorter or more convenient.

4. **JOIN ON**: These clauses assemble our tables together like interlocking puzzle pieces. They tie the `score` table to the `gamer` & `game` tables by matching `gamer_id` & `game_id`.

5. **WHERE game.id = 1**: The predicate now focuses on filtering scores based on the `id` of the game, not its name. This makes the query more efficient, as integers are quicker to compare than strings.

6. **ORDER BY score.score DESC**: Orders the scores in descending order, putting the highest scores at the top of the output. Imagine arranging a bookshelf with the biggest books at the top.

7. **Semicolon**: The semicolon is like a period in a sentence; it marks the end of the SQL query, indicating to the SQL server that this is where the command concludes.

There you have it. This explanation should provide the knowledge you need to understand how this query retrieves the top 10 gamers for Space Invaders. Keep querying, the treasure trove of insights awaits!

# Creating a View: Top10SpaceInvaders

## Goal
To encapsulate the query logic for retrieving the top 10 Space Invaders gamers into a view. This way, you can simply reference the view instead of writing out the full query each time you need this data.

## What is a view?

A SQL view is akin to a virtual table that doesn't store data but projects it from existing tables based on specific queries. You interact with a view just as you would with a table, simplifying data retrieval while encapsulating complex SQL logic. For example, querying a table typically looks like this: `SELECT * FROM [YourTableName]`. Querying a view is strikingly similar: `SELECT * FROM [YourViewName]`. The syntax is nearly identical, reinforcing how views are not tables per se but are treated like tables in your SQL queries. This feature offers a seamless experience, allowing you to use intricate queries as easily as you would a single table.

###  The asterisk symbol

When you encounter the asterisk symbol `*` in a `SELECT *` statement, think of it as a wildcard that stands for "all columns." This tells SQL to fetch every column in the table or view you're querying. While it's a convenient way to quickly see all data, be cautious using it in production. Now that you know what `*` means, you **must** understand this: it's generally better to specify exactly which columns you need for improved performance and easier code maintenance. Using the `*` when youare playing around is fine, but not when your application is ready for production.

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

## Explanation for Creating the View Syntax

1. **CREATE VIEW Top10SpaceInvaders**: The `CREATE VIEW` command followed by the view name (`Top10SpaceInvaders`) establishes a new view. Think of a view as a saved SQL query, like a shortcut on your desktop.

2. **AS**: The `AS` keyword signifies the beginning of the SQL query that the view encapsulates. This is akin to the ribbon cutting in an inauguration ceremony—it marks the start of something important.

## High-Level Steps for View Creation, Alteration, & Testing:

1. **Open SQL Environment**: Resume your SQL workspace where the magic happens.

2. **SQL Query Window**: Ensure it's activated & your database connection is alive & well.

3. **Create the View**: Copy & paste the initial SQL query for creating the view, then execute it.

4. **Verify Creation**: Refresh your object explorer, navigate to the Views section, & confirm the new view is listed. If it's a no-show, retrace your steps.

Good. Now, before we start using the view, let's look at how we would change it.

# Altering the View to Include ORDER BY
Here, we'll modify the view to include the `ORDER BY` clause so that the top scores are sorted. We left this out of the previous step on purpose so we could see and practice altering an existing view. 

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

## Explanation for Altering the View Syntax

1. **ALTER VIEW**: The `ALTER VIEW` command updates an existing view. This is much like editing a saved document—you don't create a new one, you refine what's already there.

2. **ORDER BY score.score DESC**: Unlike in the initial `CREATE VIEW`, we've now added the `ORDER BY` clause to sort scores in descending order.

By now, you should have a solid grasp of how to create and alter views in SQL. These techniques make querying more convenient and your SQL environment more organized.

## High-Level Steps for View Creation, Alteration, & Testing:

1. **Open SQL Environment**: Resume your SQL workspace where the magic happens.

2. **SQL Query Window**: Ensure it's activated & your database connection is alive & well.

3. **Alter the View**: Use an `ALTER VIEW` SQL statement to modify the existing view. This is where we'll add the `ORDER BY` clause. Execute this update script (above).

4. **Verify Alteration**: Run a `SELECT * FROM [Top10SpaceInvaders]` query to ensure the changes took effect & the data appears in the expected order.

5. **Test the View**: Now run some ad-hoc queries against the view to validate it is operating as desired. This is the litmus test for your SQL craftsmanship.

6. **Examine Output**: Look at the query results & match them against your expectations. If discrepancies arise, retrace your SQL steps.

### Square brackets in SQL

When you encounter square brackets [ ] in SQL Server, understand that they're particularly useful when your table or view name includes spaces or special characters. In such cases, the brackets are not just optional; they're essential. For example, if you have a table name Game Scores with a space in between, you would refer to it as [Game Scores] in your SQL queries. Likewise, if a table name contains a special character like a hyphen, such as Game-Scores, you'd have to use [Game-Scores]. These brackets allow SQL Server to correctly interpret the name as a single object. They're also useful to avoid ambiguity when a table or column name coincides with a SQL keyword. So, if you had a table named `Order`, you could refer to it as `[Order]` to distinguish it from the SQL `ORDER` keyword.

# Verifying Your Query Results: A Look Inside

After executing the SQL query for the top 10 Space Invaders gamers, you'll likely want to understand the resulting output. So, what should you expect to see? Below is a breakdown of the data you should observe.

## Sample Data for Verification

Here's a sample data table based on fictitious scores & gamers:

| Gamer Name | Score  |
|------------|--------|
| John       | 5000   |
| Sara       | 4200   |

Note: there are only two entries or rows or results, given that `Mike` never played "Space Invaders" in our sample data.

## Understanding the Results

1. **GamerName**: This column lists the names of the gamers. These are fetched from the `gamer` table based on the `gamer_id` in the `score` table, thanks to the JOIN clause in our SQL query.

2. **Score**: This column presents the scores for each gamer for the game "Space Invaders." These are drawn from the `score` table where the `game_id` corresponds to "Space Invaders."

## How Did We Get These Results?

The query joins three tables—`game`, `gamer`, & `score`—based on common IDs. Then, it filters out the records that are specific to the game "Space Invaders" via the WHERE clause. Finally, the SELECT projection fetches the name from the `gamer` table & the score from the `score` table, presenting them in a neat leaderboard format.

# Troubleshooting Common SQL Query Errors

Running into errors while writing SQL queries is par for the course. Here's a dive into some of the common issues, complete with code snippets.

## Common Errors, Causes, & Solutions

### Syntax Errors

## Example Error:
```SQL
SELECT name score 
FROM [score]
```

## Debug & Solution
- **Debug**: Syntax highlighting usually indicates something's amiss.
- **Solution**: Include a comma to separate the column names.

## Corrected Query:
```SQL
SELECT name, score 
FROM [score]
```
In this example, the error was a missing comma between the column names. By adding the comma, the syntax error is resolved.

### Incorrect Joins

## Example Error:
```SQL
SELECT g.name, s.score 
FROM [score] s 
JOIN [gamer] g ON s.gamer_id = g.gamer_id;
```

## Debug & Solution
- **Debug**: Double-check table schemas.
- **Solution**: Modify the `ON` statement.

## Corrected Query:
```SQL
SELECT g.name, s.score 
FROM [score] s 
JOIN [gamer] g ON s.gamer_id = g.id;
```
Here, the error was a mismatched `ON` condition in the `JOIN` clause. The fix entailed updating the `gamer_id` to simply `id`, aligning with the `gamer` table schema.

### Logical Errors in WHERE Clause

## Example Error:
```SQL
SELECT * 
FROM [score] 
WHERE score > 1000 
  AND score < 500;
```

## Debug & Solution
- **Debug**: Run parts of your query to validate logic.
- **Solution**: Correct the logical conditions.

## Corrected Query:
```SQL
SELECT * 
FROM [score] 
WHERE score > 500 
  AND score < 1000;
```
In this case, the logical conditions in the `WHERE` clause were self-contradictory. Correcting the conditions to a sensible range eliminates the problem.

### Missing Data

## Example Error:
```SQL
SELECT g.name, s.score 
FROM [score] s 
JOIN [gamer] g ON s.gamer_id = g.id 
WHERE g.name = 'John';
```

## Debug & Solution
- **Debug**: Validate assumptions about data in the table.
- **Solution**: Correct your WHERE clause or JOIN conditions.

## Corrected Query:
```SQL
SELECT g.name, s.score 
FROM [score] s 
JOIN [gamer] g ON s.gamer_id = g.id 
WHERE g.name = 'Jane';
```
The error here stemmed from a `WHERE` clause that queried non-existent data. Changing the name to one that actually exists in the table solves this issue.

This should assist you in pinpointing & resolving some of the typical SQL query errors you may encounter.

## Assignment: Crafting Views for Snake Leaderboards

### Objective:

Your task is to create two distinct views for the Snake game leaderboard: one showcasing the top 10 players and another revealing the bottom 10. You've learned valuable SQL querying techniques; now's the time to put them to work.

### Detailed Steps:

## 1. Design Your Query for Top 10

Think about the fundamental elements you need, likely the gamer's name and score. Your query will need an `ORDER BY` clause, but what should you sort by? How do you limit the result set?

## 2. Create Your Top 10 View

Once you've sorted out your SQL query, the next step is to transform it into a view. Remember, you'll use the `CREATE VIEW` syntax for this. How does this syntax look again?

## 3. Add Sample Data

Let's make sure you have some data to work with. Insert sample records for Snake into your existing `gamer` and `score` tables:

```SQL
-- Insert Snake game into the game table
INSERT INTO [dbo].[game] (id, name, description)
VALUES (4, 'Snake', 'A classic arcade game.');

-- Insert fake score data for existing gamers for the Snake game
INSERT INTO [dbo].[score] (gamer_id, game_id, score)
VALUES (1, 4, 100), (2, 4, 200), (3, 4, 150);
```

**Remember** In a nutshell, the `INSERT INTO [Table] (columns)` part specifies where & into which columns the data will go, while `VALUES (data)` provides the actual data.

You've already added Snake to your `game` table, so no need to insert it again. Look how the game id is `4`. This will be useful to know as you insert values into `score`. The focus now is to populate the `score` table with sample scores for that game. This way, you can effectively test your queries. Don't sweat it if you're only inserting three scores for now; remember, real-world applications often have to work with varying amounts of data - sometimes there is too little, sometimes there is too much. It's great practice to plan for and account for both.

## 4. Test Your Top 10 View

Once the sample data is in place, it's time to put your Top 10 view to the test. Run a query against the view, much like you would query a table. Compare the results with what you expect to confirm your view is functioning as intended. Here's how your output table might look:

| Gamer Name | Score |
|------------|-------|
| Sara       | 300   |
| Mike       | 150   |
| John       | 100   |

Does the view produce results similar to this sample output? If yes, you're on the right track. If not, revisit your view definition and debugging tips.

## 5. Design Your Query for Bottom 10

Now, it's time for the bottom 10. SQL Server doesn't provide a `BOTTOM` keyword. But can you think of a way around this limitation?

## 6. Create Your Bottom 10 View

Having decided how to query for the bottom 10, go ahead and transform this query into your second view. Once more, you'll use `CREATE VIEW`.

## 7. Test Your Bottom 10 View

Run your Bottom 10 view `SELECT * FROM Bottom10Snake` to make sure it works. Here's what you should see:

| Gamer Name | Score |
|------------|-------|
| John       | 100   |
| Mike       | 150   |
| Sara       | 300   |

With the data we have, the Bottom 10 should look like the Top 10, but flipped. When you add more gamers and scores, the top and bottom lists will probably have different names. Keep that in mind when writing your queries.

## 8. Purge Sample Data

After you're sure your views are working, it's time to clean up. Use the `DELETE` command to remove only the sample scores:

```SQL
DELETE FROM [dbo].[score]
WHERE gamer_id IN (1, 2, 3);
```

This will clear out the test scores but leave the fake gamers in the table. If you want to wipe the slate clean and remove all the fake data, you can also run:

```SQL
DELETE FROM [dbo].[gamer]
WHERE id IN (1, 2, 3);
```

The `IN` keyword in SQL is used to match any value in a list. When you use `WHERE gamer_id IN (1, 2, 3);`, it filters the records to only those where the `gamer_id` is either 1, 2, or 3. Think of it as a shorthand for writing `WHERE gamer_id = 1 OR gamer_id = 2 OR gamer_id = 3`. It's a much cleaner & compact way to filter rows based on multiple values.

## Notes & Hints:

- For top and bottom leaderboards, pay special attention to the `ORDER BY` clause. Your `ORDER BY` will determine the sorting of the leaderboard. And remember that there is a `TOP` keyword, but there is no `BOTTOM` keyword. So you will need to be clever.
- If you encounter errors, don't forget the debugging techniques we've covered. Step-by-step debugging can save you much time and frustration. The best debugging tip is to remove parts of your query and run it, then slowly add more back in.

## Guidance & Advice:

For the top 10, your `ORDER BY` clause should sort scores in descending order (largest to smallest). On the flip side, the bottom 10 should have scores sorted in ascending order (smallest to largest). Deleting specific records demands precision, so focus on the `WHERE` clause in your `DELETE` statement. The learning is in the doing, so take these hints and get cracking on those SQL views.

Great, I've read the existing lesson plan. Let's augment it with the needed sections: a checklist for deliverables & a rubric for assessment.

# Deliverables Checklist

1. **Objects in the Database**: Create all necessary tables, views, & stored procedures.
2. **SQL File**: Save all your SQL queries & commands in a single SQL file.
3. **Folder Structure**: Commit this SQL file to your project repository under `/Assignments/01.sql`.
4. **Executable**: Ensure the SQL file runs from beginning to end without any errors.
5. **Idempotency**: The SQL file must be able to run multiple times without causing errors.
6. **No Sample Data**: The SQL script should first clear any existing sample data.
7. **Creation & Execution**: After clearing the sample data, the script should create the database objects & populate them.
8. **Clean-Up**: Finally, clear the sample data once again.

Idempotency, in the context of databases & SQL, refers to the property where running a particular operation multiple times produces the same result as running it just once. An idempotent SQL script can be executed repeatedly without causing errors or unintended side effects. This is crucial for ensuring that your database remains in a consistent state, even if the script is run more than once.

For instance, if your SQL script creates a table, it should first check whether the table already exists. If it does, the script should either skip the creation step or delete the existing table before creating a new one. This ensures that running the script multiple times won't throw errors like "Table already exists."

The idempotency requirement in your deliverables list (#5) essentially mandates that the SQL file should be designed such that it can be run multiple times without causing any errors or inconsistencies in the database. This is often accomplished by including checks, conditionals, or cleanup steps at appropriate places in the script.

### How to cautiously drop (delete) a view before creating it.

To ensure idempotency, you'd want to first check if the view `Top10Snake` exists before attempting to drop it. In SQL Server, objects are not deleted, they are dropped. However, data in tables is delted, not dropped. In this way, the verd indicates the type of object. 

Here's the SQL query that achieves this:

```sql
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Top10Snake]'))
BEGIN
    DROP VIEW [dbo].[Top10Snake]
END
GO

-- Your code to recreate the view goes here.
CREATE VIEW [dbo].[Top10Snake] AS
-- View definition
...
```

This SQL snippet uses the `sys.views` catalog view to check if the view `Top10Snake` exists in the database. If it does, the `DROP VIEW` statement is executed to remove it. After that, you can proceed to recreate the view with your new definition. This makes the script idempotent, fulfilling the requirement.

**An explanation of new syntax in that query:**

1. **`OBJECT_ID()` Function**: This built-in function in SQL Server returns the database object identification number for a schema-scoped object. It's useful for checking if an object (table, view, stored procedure, etc.) exists in the database. If the object does exist, `OBJECT_ID()` returns its ID; otherwise, it returns `NULL`.

2. **`N` Prefix**: The `N` prefix stands for National Language Support (NLS), and it's used to specify that the subsequent string is in Unicode. This is particularly useful when the database has to accommodate characters from multiple languages. By prefixing a string with `N`, you're telling SQL Server to treat the string as a Unicode constant.

Here's how they're used in the script:

- `OBJECT_ID(N'[dbo].[gamers]')`: Here, `OBJECT_ID()` is used to get the object ID of the table `[dbo].[gamers]`. The `N` prefix indicates that the table name is a Unicode string.

Combining these, the expression `OBJECT_ID(N'[dbo].[Top10Snake]')` fetches the object ID for a view named `Top10Snake` in the `dbo` schema, enabling the script to check whether this table exists in the database.

> Want to learn more about schemas? https://www.bing.com/search?q=what+is+a+schema+in+SQL+Server

**This word for Tables, too**

For a table like `gamers`, you'd check its existence similarly but handle it differently since you don't want to drop the table. Here's the SQL query:

```sql
IF NOT EXISTS (SELECT * FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[gamers]'))
BEGIN
    -- Your code to create the table goes here if it doesn't already exist.
    CREATE TABLE [dbo].[gamers] (
        -- Table definition
        ...
    )
END
ELSE
BEGIN
    -- Optionally, code to alter the table or log a message can go here.
    PRINT 'Table [dbo].[gamers] already exists. Not recreating.'
END
GO
```

In this script, the `IF NOT EXISTS` condition checks for the table's existence using the `sys.tables` catalog view. If the table doesn't exist, it gets created. If it does exist, a message is printed & no destructive actions are taken. This ensures idempotency without risking loss of valuable data.

### Rubric

A rubric is a set of criteria used to evaluate or assess a particular work, skill, or product. It serves as a standardized framework for grading or scoring, providing both the evaluator & the one being evaluated with clear expectations. In educational settings, a rubric often breaks down the qualities of an assignment into various components, detailing what constitutes excellent, good, & subpar performance for each.

For example, in a writing assignment, criteria might include grammar, structure, argument clarity, & use of evidence. Each criterion will have varying levels of achievement, often described with adjectives like "Excellent," "Good," or "Needs Improvement."

A well-designed rubric not only aids in objective & consistent assessment but also provides students with actionable feedback, helping them understand what they did well & where they can improve.

| Criteria                        | Excellent | Good      | Needs Improvement |
|---------------------------------|-----------|-----------|-------------------|
| SQL File Execution              | No errors & runs multiple times | Runs with minor errors | Fails to execute  |
| Database Object Creation        | All objects created successfully | Objects created improperly | Missing objects |
| Code Structure & Commenting     | Well-organized & fully commented | Some organization & comments | Disorganized & no comments |
| Repository Organization         | Follows exact folder structure | Incorrect folder structure | Missing files
| Business Logic Implementation   | Perfectly implements all logic | Implements most logic | Fails in logic implementation |