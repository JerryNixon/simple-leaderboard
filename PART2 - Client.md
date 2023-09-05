
# Part 2 | Client

Let's turn our attention to the client. 

## Game Objects

### **Canvas**
- **Summary**: The canvas is the playing field where all game elements interact.
- **Properties**: 40 x 20 grid
- **Behaviors**: None
- **Rules**: All game elements must stay within these dimensions.

### **Snake Head**
- **Summary**: The snake head is the core of the gameplay, controlling movement and dictating the pace.
- **Properties**: Character changes based on direction (`'▲', '▼', '◄', '►', '█'`).
- **Behaviors**: Advances on a drum beat, every 100ms.
- **Rules**: 
  - Starts immobile (`'█'`).
  - Can't reverse direction 180 degrees.
  - Wraps around canvas edges.

### **Snake Tail**
- **Summary**: The tail follows the snake head and grows when fruits are consumed.
- **Properties**: Length increases by one block for each fruit eaten.
- **Behaviors**: Follows the head, occupying spaces the head vacated.
- **Rules**: 
  - Starts at zero length.
  - Cannot intersect with the head.

### **Fruit**
- **Summary**: Fruits serve as rewards that extend the snake and add to the player's score.
- **Properties**: Random location; Value between 1 and 9.
- **Behaviors**: Spawns a new fruit after being consumed; triggers a sound effect.
- **Rules**: 
  - Never spawns on top of the snake.
  - Adds time to the game timer based on its value.

### **Scoreboard**
- **Summary**: The scoreboard displays real-time game data including current and high scores.
- **Properties**: Displays current score, high score, and high score list.
- **Behaviors**: Updates in real-time; saves scores at the end of the game.
- **Rules**: 
  - High scores and current score are displayed next to the canvas.
  - High score list fetched asynchronously before game start.

## Game Mechanics & Rules

### **Controls & Movement**
- **Arrow Keys**: Control the snake's direction.
- **No Pause**: Once started, the game cannot be paused.
- **Buffering**: If multiple directions are pressed within a single beat, the snake executes them in sequence on subsequent beats.

### **Game Timer**
- A 60-second countdown starts at game launch. Time is added based on the value of consumed fruits.

### **Game Termination**
- The game ends either when the timer reaches zero or when the snake's head collides with its tail.

### **Game Restart**
- The game can be restarted by pressing 'r', with the last score being saved before the reset.

![image](https://github.com/JerryNixon/cornell-leaderboard/assets/1749983/b8cda001-9a60-4824-a1d7-99e12cf12282)

### **Service Class**
The Service Class in C# is essential for managing scores and user verification, creating a seamless bridge between gameplay and data storage.

- **Properties**: 
  - `CurrentUser`: Stores the username of the player currently engaged in the game session.

- **Methods**: 
  - `(int Score, string Name) GetHighScore(int gameId)`
    - **Return**: Tuple containing highest score and name associated with a given game ID.
    - **Arguments**: `gameId` - Identifier for the game.
  - `(int Score, string Name)[] GetHighScores(int gameId)`
    - **Return**: Array of tuples containing high scores and names for a given game ID.
    - **Arguments**: `gameId` - Identifier for the game.
  - `void SaveScore(int gameId, string user, int score)`
    - **Return**: None.
    - **Arguments**: `gameId` - Identifier for the game; `user` - Username; `score` - Current score.
  - `int GetHighScore(int gameId, string user)`
    - **Return**: Highest score for a given game ID and specific user.
    - **Arguments**: `gameId` - Identifier for the game; `user` - Specific username.
  - `Boolean AddUser(string user)`
    - **Return**: True if the user is successfully added, false otherwise.
    - **Arguments**: `user` - Username to be added.
  - `Boolean VerifyUser(string user)`
    - **Return**: True if the user exists and is verified, false otherwise.
    - **Arguments**: `user` - Username to be verified.

- **Events**: None

- **Intended Rules**: 
  - `GetHighScore` & `GetHighScores`: Called asynchronously before the game starts to populate the high-score list and display the current high score.
  - `SaveScore`: Invoked at the end of each game session to save the player’s current score.
  - `GetHighScore(int gameId, string user)`: Utilized when needed to fetch a specific user's high score.
  - `AddUser` & `VerifyUser`: Called at the start of a game session to ensure the player is recognized and authenticated.

The Service Class is a cornerstone in the game's architecture. With functionalities spanning from score management to user verification, it ensures an integrated and engaging gameplay experience.
