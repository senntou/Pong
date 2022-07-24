float firstGearAngle = 0;
float secondGearAngle = 360 / 16;

void drawGear(int x,int y,int r,float angle) {
    int rectWidth = r * 3 / 10;
    pushMatrix();
    translate(x,y);
    rotate(radians(angle));
    ellipse(0,0,r * 3 / 2,r * 3 / 2);
    for (int i = 0;i < 8;i++) {
        rect( - rectWidth / 2,0,rectWidth, - r);
        rotate(PI / 4);
    }
    popMatrix();
}

void setup() {
    size(800,600);
    noStroke();
    fill(100);
}
void draw() {
    background(240);
    int r = 150;
    translate(width/3,height/2);
    drawGear(0,0,r,firstGearAngle);
    drawGear(r*3/4 + r,0,r,secondGearAngle);
    firstGearAngle++;   secondGearAngle--;
}
