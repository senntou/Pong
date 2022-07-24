
color blu = color(0,0,255);
color grass = color(150,255,150);
color red = color(255,50,50);

boolean mapLine = false;

float snaker = 10;
float snakex[] = new float[1000];
float snakey[] = new float[1000];
float psnakex[] = new float[1000];
float psnakey[] = new float[1000];
int snakeDir = 2;
int psnakeDir = 2;
float food[] = {0,0};
boolean eatFlag = false;
int snakeLength;
int extraFrame = 4;
int framerate = 60;
int frame = 0;
float dir[][] = {
    { - 1,0} ,
    {0, -1} ,
    {1,0} ,
    {0,1}
};
void keyPressed() {
    if (keyCode == LEFT && psnakeDir != 2) snakeDir = 0;
    if (keyCode == UP && psnakeDir != 3) snakeDir = 1;
    if (keyCode == RIGHT && psnakeDir != 0) snakeDir = 2;
    if (keyCode == DOWN && psnakeDir  != 1) snakeDir = 3;
    if (key == 'p') noLoop();
    if (key == 'r') {
        loop();
        restart();
    }
}
void keyReleased() {
    if (key == 'p') loop();
}
void drawPoint() {
    noStroke();
    fill(0);
    textAlign(LEFT,TOP);
    textSize(7);
    for (int x = 0;x < width / 20;x++) {
        for (int y = 0;y < height / 20;y++) {
            text((x + 1) + "," + (y + 1),x * 20,y * 20);
        }
    }
}
void drawSnake() {
    noStroke();
    fill(blu);
    float zoom = (frame % extraFrame) / (float)extraFrame;
    for (int i = 0;i < snakeLength;i++) {
        pushMatrix();
        translate(snakex[i] * 20 * zoom + psnakex[i] * 20 * (1 - zoom),
            snakey[i] * 20 * zoom + psnakey[i] * 20 * (1 - zoom));
        ellipse(snaker,snaker,snaker * 2,snaker * 2);
        popMatrix();
    }
}
void resetFood() {
    int x,y;
    x = (int)random(40);
    y = (int)random(30);
    food[0] = x;
    food[1] = y;
}
void drawFood() {
    pushMatrix();
    translate(food[0] * 20,food[1] * 20);
    noStroke();
    fill(red);
    ellipse(snaker,snaker,snaker,snaker);
    popMatrix();
}
void gameover() {
    textAlign(CENTER);
    textSize(100);
    text("GameOver",width / 2,height / 2);
    noLoop();
}
void updateSnake() {
    psnakeDir = snakeDir;
    if (eatFlag) {
        snakex[snakeLength] = snakex[0];
        snakey[snakeLength] = snakey[0];
        snakeLength++;
    }
    for (int i = snakeLength - 1;i > 0;i--) {
        psnakex[i] = snakex[i];
        psnakey[i] = snakey[i];
        snakex[i] = snakex[i - 1];
        snakey[i] = snakey[i - 1];
    }
    psnakex[0] = snakex[0];
    psnakey[0] = snakey[0];
    snakex[0] = snakex[0] + dir[snakeDir][0];
    snakey[0] = snakey[0] + dir[snakeDir][1];
    for (int i = 1;i < snakeLength;i++) {
        if (snakex[0] == snakex[i] && snakey[0] == snakey[i]) {
            gameover();
        }
    }
    if (snakex[0] == food[0] && snakey[0] == food[1]) {
        eatFlag = true;
        resetFood();
    } else {
        eatFlag = false;
    }
}
void restart() {
    int firstLength = 3;
    snakeLength = firstLength;
    snakeDir = 2;
    snakex[0] = 10;
    snakey[0] = 10;
    for (int i = 1;i < 3;i++) {
        snakex[i] = snakex[i - 1] - dir[snakeDir][0];
        snakey[i] = snakey[i - 1] - dir[snakeDir][1];
    }
    frameRate(framerate);
    resetFood();
}
void gameoverCheck() {
    for (int i = 1;i < snakeLength;i++) {
        if (snakex[0] == snakex[i] && snakey[0] == snakey[i]) {
            gameover();
        }
    }
    if (snakex[0] * snakey[0] < 0 || snakex[0] > 39 || snakey[0] > 39) {
        gameover();
    }
}
void setup() {
    size(800,600);
    
    restart();
}
void draw() {
    background(grass);
    
    if (mapLine) {
        stroke(0);
        for (int i = 0;i < width / 20;i++) {
            line(i * 20,0,i * 20,height);
        }
        for (int i = 0;i < height / 20;i++) {
            line(0,i * 20,width,i * 20);
        }
    }
    
    if (frame % extraFrame == 0) {
        updateSnake();
    }
    drawSnake();
    drawFood();
    
    gameoverCheck();
    
    frame++;
    frame %= framerate;
}
