void setup() {
  size(150, 100, P2D);
}

void drawTriangle() {
  background(51, 204, 255);
  
  stroke(0, 0, 0);
  fill(255, 255, 0);
  
  int x1 = int(random(width/3, 2*width/3));
  int y1 = int(random(0, height/2));
  int x2 = int(random(0, width/3));
  int y2 = int(random(height/2, height));
  int x3 = int(random(2*width/3, width));
  
  triangle(x1, y1, x2, y2, x3, y2);
}

void drawRectangle() {
  background(255, 153, 0);
  
  stroke(0, 0, 0);
  fill(255, 204, 204);
  
  pushMatrix();

  translate(width/2, height/2);
  
  float angle = random(0, 180);

  int x1 = int(random(-width/3, width/3));
  int y1 = int(random(-height/2, 0));
  int w = int(random(10, width/4));
  int h = int(random(10, height/4));
  print(x1, y1, w, h, "\n"); 
  print(angle, "\n");
  rotate(radians(angle));
  
  rect(x1, y1, w, h);
  popMatrix();
}

void draw() {
  if (frameCount < 10) {
    drawTriangle();
    saveFrame("triangle-###.png");
  }
 
  if (frameCount >= 10 && frameCount < 20) {
    drawRectangle();
    saveFrame("rectangle-###.png");
  }
  
}
