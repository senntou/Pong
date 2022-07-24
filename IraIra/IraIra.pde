int[] linex1 = new int[100];
int[] linex2 = new int[100];
int[] liney1 = new int[100];
int[] liney2 = new int[100];
int index = 0;
int margin = 50;
int mazeWidth = 50;

color startPointColor = color(255,50,80);
color goalPointColor = color(80,50,255);
color defaultBack = color(230);
color colorGameover = color(20,20,150);
color colorGoal = color(130,150,180);

GameMode mode = GameMode.FIRST;

enum GameMode{
    FIRST,
    START,
    ACTIVE,
    GAMEOVER,
    GOAL,
};

//線分と点の距離の”二乗”を求める関数
double distLinePoint(int x1,int y1,int x2,int y2,int x0,int y0) {
    long a = x2 - x1;
    long b = y2 - y1;
    long a2 = a * a;
    long b2 = b * b;
    long  r2 = a2 + b2;
    long t = -(a * (x1 - x0) + b * (y1 - y0));
    if (t < 0) {
        return(x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0);
    } else if (t > r2) {
        return(x2 - x0) * (x2 - x0) + (y2 - y0) * (y2 - y0);  
    }
    long f1 = a * (y1 - y0) - b * (x1 - x0);
    return(f1 * f1) / r2;
}
float getMinDist(float x,float y){
    double ans = 1000000;
    for(int i = 0;i < 100;i++){
        if(linex1[i] == 0) break;
        double tem = distLinePoint(linex1[i],liney1[i],linex2[i],liney2[i],
                (int)x,(int)y);
        if(tem < ans){
            ans = tem;
        }
    }
    return sqrt((float)ans);
}
void drawLine() {
    strokeWeight(3);
    stroke(0);
    for (int i = 0;i < 100;i++) {
        if (linex1[i] + linex2[i] + liney1[i] + liney2[i] == 0) break;
        line(linex1[i],liney1[i],linex2[i],liney2[i]);
    }
}
void addLine(int x1,int y1,int x2,int y2) {
    linex1[index] = x1;
    liney1[index] = y1;
    linex2[index] = x2;
    liney2[index++] = y2;
}
void setup() {
    size(800,600);
    addLine(margin,margin,margin,height - margin);
    addLine(margin,margin,width - margin,margin);
    addLine(margin,height - margin,width - margin,height - margin);
    addLine(width - margin, margin + mazeWidth,width - margin,height - margin - mazeWidth);
    for (int i = 0;i * mazeWidth < (height - 2 * margin);i++) {
        int x1 = margin;
        int x2 = width - margin;
        if (i % 2 == 0) {
            x1 += mazeWidth;
        } else {
            x2 -= mazeWidth;
        }
        int y = margin + (i + 1) * mazeWidth;
        addLine(x1,y,x2,y); 
    }
}
void drawSG() {
    noStroke();
    pushMatrix();
    fill(startPointColor);
    translate(width - margin - mazeWidth,margin);
    rect(0,0,mazeWidth,mazeWidth);
    fill(goalPointColor);
    translate(0,height - 2 * margin - mazeWidth);
    rect(0,0,mazeWidth,mazeWidth);
    popMatrix();
}
boolean inStartPoint() {
    if (width - margin - mazeWidth <= mouseX && 
        mouseX <= width - margin && 
        margin <= mouseY && mouseY <= margin + mazeWidth) {
        return true;
    }
    return false;
}
boolean inGoalPoint(){
    if(width - margin - mazeWidth <= mouseX&&
        mouseX <= width - margin && 
        height - margin - mazeWidth <= mouseY && 
        mouseY <= height - margin) return true;
    return false;
}
void drawMessage(String msg) {
    textSize(50);
    textAlign(CENTER,TOP);
    text(msg,width / 2,0);
}
//線分と線分(マウス移動）の交差判定
boolean intersect(int x1,int y1,int x2,int y2){
    double s,t;
    s = (x1 - x2) * (pmouseX - y1) - (y1 - y2) * (pmouseX - x1);
    t = (x1 - x2) * (mouseY - y1) - (y1 - y2) * (mouseX - x1);
    if (s * t > 0)
        return false;
    s = (pmouseX - mouseX) * (y1 - pmouseY) - (pmouseY - mouseY) * (x1 - pmouseX);
    t = (pmouseX - mouseX) * (y2 - pmouseY) - (pmouseY - mouseY) * (x2 - pmouseX);
    if (s * t > 0)
        return false;
    return true;
}
boolean overLine(){
    float accuracy = 100;
    for(int i = 0;i <= accuracy;i++){
        float x,y;
        x = mouseX * i /accuracy + pmouseX * (accuracy - i) / accuracy;
        y = mouseY * i /accuracy + pmouseY * (accuracy - i) / accuracy;
        if(getMinDist(x,y) <= 2) return true;
    }
    if(mouseX < margin || width - margin < mouseX ||
        mouseY < margin || height - margin < mouseY ) return true;
    return false;
}


void draw() {
    switch(mode) {
        case FIRST:
            background(defaultBack);
            drawMessage("Go to red area");
            if (inStartPoint()) mode = GameMode.START;
            break;
        case START:
            background(defaultBack);
            if(!(inStartPoint())){
                if(margin <= mouseY && mouseY <= margin + mazeWidth && mouseX < width - margin - mazeWidth){
                    mode = GameMode.ACTIVE;
                } else {
                    mode = GameMode.FIRST;
                }
            }
            break;
        case ACTIVE:
            float R;
            R = getMinDist(mouseX,mouseY) * 5;
            background(255 - R,R,R);
            if(overLine()) mode = GameMode.GAMEOVER;
            if(inStartPoint()) mode = GameMode.START;
            if(inGoalPoint())mode = GameMode.GOAL;
            break;
        case GAMEOVER:
            background(colorGameover);
            drawMessage("GAMEOVER");
            if(inStartPoint()) mode = GameMode.START;
            break;
        case GOAL:
            background(colorGoal);
            drawMessage("GOAL!!");
            break;  
    }
    drawSG(); 
    drawLine();
    
    
}
