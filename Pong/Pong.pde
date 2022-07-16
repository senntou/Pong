enum GameMode{
    HOLD,
    ACTIVE
};

int playerBarY = 0;
int enemyBarY = 0;
float ballx = 0;
float bally = 0;
int ballr = 5;

float ballSpeedX = 0;
float ballSpeedY = 0;
float ballSpeedMax = 7 * 7;

int barLength = 80;
int margin = 50;
int barSideMargin = 5;
int playerSpeed = 10;
int playerLowSpeed = playerSpeed / 2;
int enemySpeed = 5;
int textSize = 50;
boolean key_UP = false;
boolean key_DOWN = false;
boolean key_SPACE = false;
boolean key_SHIFT = false;

GameMode mode = GameMode.HOLD;

PFont defaultFont;


void keyPressed() {
    if (keyCode == UP) key_UP = true;
    if (keyCode == DOWN) key_DOWN = true;
    if (keyCode == ' ') key_SPACE = true;
    if (keyCode == SHIFT) key_SHIFT = true;
}
void keyReleased() {
    if (keyCode == UP) key_UP = false;
    if (keyCode == DOWN) key_DOWN = false;
    if (keyCode == ' ') key_SPACE = false;
    if (keyCode == SHIFT) key_SHIFT = false;
}
void drawBar(int x,int y) {
    stroke(0);
    strokeWeight(5);
    line(x,y - barLength / 2,x,y + barLength / 2);
}
void movePlayerBar() {
    int temSpeed = key_SHIFT ? playerLowSpeed : playerSpeed;
    if (key_UP) {
        playerBarY -= temSpeed;
    }
    if (key_DOWN) {
        playerBarY += temSpeed;
    }
    playerBarY = constrain(playerBarY,
        barSideMargin + barLength / 2,height - (barSideMargin + barLength / 2));
}
void moveEnemyBar() {
    if (ballSpeedX <= 0) {
        if (bally > enemyBarY) {
            enemyBarY += enemySpeed;
        } else if (bally < enemyBarY) {
            enemyBarY -= enemySpeed;
        }
    } else {
        if (enemyBarY < height / 2) {
            enemyBarY += enemySpeed;
        } else if (enemyBarY > height / 2) {
            enemyBarY -= enemySpeed;
        }
    }
    enemyBarY = constrain(enemyBarY,
        barSideMargin + barLength / 2,height - (barSideMargin + barLength / 2));
}
void drawBall(float x,float y) {
    stroke(255,0,0);
    strokeWeight(5);
    fill(255);
    ellipse(x, y,2 * ballr,2 * ballr);
}
void moveBall() {
    ballx += ballSpeedX;
    bally += ballSpeedY;
}
void wallBound() {
    if (bally < ballr) {
        bally += (ballr - bally) * 2;
        ballSpeedY *= -1;
    } else if (bally > height - ballr) {
        bally -= (bally - (height - ballr)) * 2;
        ballSpeedY *= -1;
    }
}
void barBound() {
    //ボールとバーの当たり判定が複雑になるため、1frame前のボールの位置と
    //現在のボールの位置の中心のy座標で判定する
    float ballMidY = (bally + bally - ballSpeedY) / 2;
    float K = 0;
    float dir = 1;
    
    if (enemyBarY - (barLength / 2 + ballr) <= ballMidY 
        && ballMidY <= enemyBarY + (barLength / 2 + ballr)
        && ballx - ballSpeedX >=  margin + ballr
        && margin + ballr >= ballx) {
        if (ballx < margin + ballr) {
            ballx += (margin + ballr - ballx) * 2;
            ballSpeedX *= -1;
            K = ballMidY - enemyBarY;
            dir = 1;
        }
    }
    if (playerBarY - (barLength / 2 + ballr) <= ballMidY 
        && ballMidY <= playerBarY + (barLength / 2 + ballr)
        && ballx - ballSpeedX <= width - margin - ballr
        && width - margin - ballr <= ballx) {
        if (ballx > width - margin - ballr) {
            ballx -= (ballx - (width - margin - ballr)) * 2;
            ballSpeedX *= -1;
            K = ballMidY - playerBarY;
            dir = -1;
        }
    }
    if (K != 0) {
        float maxy = sqrt(ballSpeedMax * 3.0 / 4.0);
        K /= barLength / 2.0;
        ballSpeedY += K * maxy;
        ballSpeedY = constrain(ballSpeedY, -maxy,maxy);
        
        ballSpeedX = dir * sqrt(ballSpeedMax - ballSpeedY * ballSpeedY);
    }
}
void ballOut() {
    if (ballx < 0 || width < ballx) {
        mode = GameMode.HOLD;
    }
}
void holdBall() {
    ballx = width - margin - ballr;
    bally = playerBarY;
    
    
    String HoldingMessage = "Press \"space key\" to start";
    fill(0);
    
    textFont(defaultFont,textSize);
    textAlign(CENTER,CENTER);
    text(HoldingMessage,width / 2,height / 4);
    if (key_SPACE) {
        mode = GameMode.ACTIVE;
        float maxy = sqrt(ballSpeedMax * 1 / 2);
        ballSpeedY = 0;
        if (key_UP)ballSpeedY -= playerSpeed;
        if (key_DOWN)ballSpeedY += playerSpeed;
        ballSpeedY = constrain(ballSpeedY, -maxy,maxy);
        ballSpeedX = -1 * sqrt(ballSpeedMax - ballSpeedY * ballSpeedY);
    }
}
void setup() {
    size(800,600);
    //background(200,200,255);
    playerBarY = height / 2;
    enemyBarY = height / 2;
    ballx = width / 2;
    bally = height / 2;
    defaultFont = createFont("Arial",textSize);
}
void draw() {
    background(200,200,255);
    
    movePlayerBar();
    switch(mode) {
        case HOLD:
            holdBall();
            break;
        case ACTIVE:
            moveEnemyBar();
            moveBall();
            wallBound();
            barBound();
            ballOut();
            break;
    }
    
    drawBar(margin,enemyBarY);
    drawBar(width - margin,playerBarY);
    drawBall(ballx,bally);
    
    
}