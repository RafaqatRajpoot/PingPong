import processing.core.*;
import ddf.minim.*;

// Ball variables
private float ballX;
private float ballY;
private float ballSpeedX;
private float ballSpeedY;
private float ballSize = 20;

// Paddle variables
private float paddleX;
private float paddleY;
private float paddleWidth = 100;
private float paddleHeight = 20;
private float paddleSpeed = 8;

// Key variables
private boolean isMovingLeft;
private boolean isMovingRight;

// Game variables
private int playerScore;
private int incrementScore;
private boolean isGameOver;
private boolean isRestarted=false;

// Sound Variables
private Minim minim;
private AudioPlayer collisionSound;
private AudioPlayer gameoverSound;
private boolean hasPlayedGameOverSound;

// Background image
private PImage backgroundImage;
private PImage paddleImage;

public void settings() {
  size(800, 400);
}

public void setup() {
  do{
    resetGame();
  }while(isRestarted);

  // Initialize Minim audio library
  minim = new Minim(this);
  
  // Load audio files
  collisionSound = minim.loadFile("./public/collisionSound.mp3");
  gameoverSound = minim.loadFile("./public/gameOver.mp3");
  
  // Load images
  backgroundImage = loadImage("./public/background.jpg");
  paddleImage = loadImage("./public/paddle.jpg");
}

public void draw() {
  // Draw background image
  image(backgroundImage, 0, 0, width, height);
  
  // Move the ball and the paddle
  moveBall();
  movePaddle();
  
  // Check for collisions between ball and paddle
  checkCollision();
  
  // Draw the ball and the paddle
  drawBall();
  drawPaddle();
  
  // Display player score
  displayScores();
  
  // Check if the game is over
  checkGameOver();
}

public void keyPressed() {
  if (!isGameOver) {
    // Handle movement keys when the game is not over
    if (keyCode == LEFT) {
      isMovingLeft = true;
    } else if (keyCode == RIGHT) {
      isMovingRight = true;
    }
  } else {
    // Restart the game when the game is over and the Enter key is pressed
    if (keyCode == ENTER) {
      resetGame();
       isRestarted = true; // 
    }
  }
}

public void keyReleased() {
  if (!isGameOver) {
    // Stop the movement when the movement keys are released
    if (keyCode == LEFT) {
      isMovingLeft = false;
    } else if (keyCode == RIGHT) {
      isMovingRight = false;
    }
  }
}

private void moveBall() {
  if (!isGameOver) {
    // Move the ball only if the game is not over
    ballX += ballSpeedX;
    ballY += ballSpeedY;
  }

  // Reverse the ball's horizontal direction if it reaches the left or right edge
  if (ballX < 0 || ballX > width) {
    ballSpeedX *= -1;
  }

  // Reverse the ball's vertical direction if it reaches the top edge
  if (ballY < 0) {
    ballSpeedY *= -1;
  }
  
  // End the game if the ball reaches the bottom edge
  if (ballY > height) {
    endGame();
  }
}

private void movePaddle() {
  if (!isGameOver) {
    // Move the paddle only if the game is not over
    if (isMovingLeft) {
      paddleX -= paddleSpeed;
    } else if (isMovingRight) {
      paddleX += paddleSpeed;
    }

    // Constrain the paddle within the screen boundaries
    paddleX = constrain(paddleX, 0, width - paddleWidth);
  }
}


private void checkCollision() {
  if (ballY + ballSize / 2 >= paddleY && ballY - ballSize / 2 <= paddleY + paddleHeight) {
    if (ballX + ballSize / 2 >= paddleX && ballX - ballSize / 2 <= paddleX + paddleWidth) {
      if (ballSpeedY > 0) {
        // Reverse the ball's vertical direction upon collision with the paddle
        ballSpeedY *= -1;
        
        // Increase player score
        updatePlayerScore();
        
        // Play the collision sound
        collisionSound.rewind();
        collisionSound.play();
      }
    }
  }
}

private void drawBall() {
  // Draw the ball as an ellipse
  ellipse(ballX, ballY, ballSize, ballSize);
}

private void drawPaddle() {
  // Draw the paddle as a rectangle
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
  image(paddleImage, paddleX, paddleY, paddleWidth, paddleHeight);
}


// Manage player Score
private void updatePlayerScore() {
 playerScore=playerScore+incrementScore;
}
private int getPlayerScore() {
  return playerScore;
}

private void displayScores() {
  // Display the player's score on the screen
  fill(255);
  textSize(24);
  text("Score: " + getPlayerScore(), 50, 30);
}

private void checkGameOver() {
  if (isGameOver) {
    if (!hasPlayedGameOverSound) {
      // Play the game over sound only once
      gameoverSound.rewind();
      gameoverSound.play();
      hasPlayedGameOverSound = true;
    }
    
    // Add a delay to show "Game Over" message for 3 seconds
    delay(3000);
    
    // Display the "Game Over" message at the center of the screen
    fill(255);
    textSize(44);
    textAlign(CENTER);
    text("Game Over", width / 2, height / 2);
     textSize(24);
    text("Press Enter to Restart Game", width / 2, height / 2 + 40);
  }
}


private void endGame() {
  // Set the game over flag to true
  isGameOver = true;
}

private void resetGame() {
  // Reset all game variables to their initial values
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = random(3, 5);
  ballSpeedY = random(3, 5);
  paddleX = width / 2 - paddleWidth / 2;
  paddleY = height - 40;
  playerScore = 0;
  isGameOver = false;
  hasPlayedGameOverSound = false;
  incrementScore=1; 
  isRestarted=false;
}
