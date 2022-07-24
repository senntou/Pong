
int space = 30;
int r = 5;
int base_theta = 0;
int rotx = 0;
int roty = 0;
int clickCount = 0;
int cmousex;
int cmousey;
int base_rotx;
int base_roty;
float mouseWheelDirection = 0;
int zoom = 500;
void  mouseWheel(  MouseEvent  event  ){
    mouseWheelDirection = event.getAmount();
    zoom += (mouseWheelDirection * 50);
}
void update(){
    if(mousePressed){
        if(clickCount == 0){
            clickCount++;
            cmousex = mouseX;
            cmousey = mouseY;
            base_rotx = rotx;
            base_roty = roty;
        } else {
            roty = base_roty + (cmousex - mouseX) /2;
            rotx = base_rotx + (cmousey - mouseY) /2;
            rotx %= 360;
            roty %= 360;
        }
    } else clickCount = 0;
}
void setup() {
    size(800,600,P3D);
    noStroke();
}
void draw() {
    background(255);
    noStroke();
    camera(0,0,zoom,0,0,0,0,1,0);
    update();
    pushMatrix();
    float rotationX = map(rotx, 0, 360, -PI, PI);
    float rotationY = map(roty, 0, 360, -PI, PI);
    rotateX(rotationX);
    rotateY(rotationY);
    int depth = 100;
    translate((space + 2 * r) * ( - 5) - space / 2,(space + 2 * r) * ( - 5) - space / 2,0);
    int theta = base_theta;
    fill(0);
    for (int i = 0;i < 12;i++) {
        
        pushMatrix();
        translate(0,0,sin(radians(theta)) * depth);
        for (int j = 0;j < 12;j++) {
            sphere(2 * r);
            translate(0,space + 2 * r,0);
        }
        theta += 360 / 12;
        popMatrix();
        translate(space + 2 * r,0,0);
        
        
    }
    base_theta = (base_theta + 2) % 360;
    popMatrix();
    
}