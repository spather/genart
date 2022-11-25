void setup() {
  size(150, 100, P2D);
}

void drawBlueYellowQuad() {
  background(51, 204, 255);
  
  stroke(0, 0, 0);
  fill(255, 255, 0);
  
  quad(100, 25, 120, 25, 130, 70, 40, 80);
}

void drawOrangePinkCircle() {
  background(255, 153, 0);
  
  stroke(0, 0, 0);
  fill(255, 204, 204);
  
  circle(85, 50, 40);
}

void drawGreenPinkSquare() {
  background(0, 180, 80);

  stroke(0, 0, 0);
  fill(255, 204, 204);

  square(25, 40, 40);
}

void drawBluePinkEllipse() {
  background(51, 204, 255);
  
  stroke(0, 0, 0);
  fill(255, 204, 204);

  ellipse(75, 50, 40, 20);
}

void drawGreenPinkRectangle() {
  background(0, 180, 80);

  stroke(0, 0, 0);
  fill(255, 204, 204);

  pushMatrix();

  translate(width/2, height/2);
  
  float angle = 25;
  
  rotate(radians(angle));
  
  int x1 = 20;
  int y1 = 40;
  int w = 70;
  int h = 30;
  
  rect(x1, y1, w, h);
  popMatrix();
}

void draw() {
  if (frameCount == 1) {
    drawBlueYellowQuad();
    saveFrame("odd-quad-###.png");
  }
  if (frameCount == 2) {
    drawOrangePinkCircle();
    saveFrame("odd-quad-###.png");
  }
  
  if (frameCount == 3) {
    drawGreenPinkSquare();
    saveFrame("odd-quad-###.png");
  }

  if (frameCount == 4) {
    drawBluePinkEllipse();
    saveFrame("odd-quad-###.png");
  }

  if (frameCount == 5) {
    drawGreenPinkRectangle();
    saveFrame("odd-quad-###.png");
  }

}
