PVector [] pos, vel, acc;//Position & Velocity & Acceleration
float [] diam;//Diameter
color [] c, cOptions;
int count = 1000;
boolean recording = false;

void setup() {
  size(720, 720);
  smooth(8);

  //Color options
  cOptions = new color[]{#9cafc9, #668caf, #306598, #1d4179, #0c2557, #e8d7bc};

  //Initialize all arrays;
  pos = new PVector[count];
  vel = new PVector[count];
  acc = new PVector[count];
  diam = new float[count];
  c = new color[count];

  for (int i=0; i<count; i++) {
    pos[i] = new PVector(random(width), random(height));
    diam[i] = random(1, 5);
    vel[i] = PVector.random2D();
    float scalar = map(diam[i], 1, 5, 5, .2);
    vel[i].mult(scalar);
    acc[i] = new PVector();
    c[i] = cOptions[floor(random(cOptions.length))];
  }
}

//recording export
void keyPressed() {
  if (key == 'r') {
    recording = !recording;
  }
}

void draw() {

  //Update an array of balls;
  for (int i=0; i<count; i++) {

    //Press button(use mousepress here)
    if (mousePressed) {
      acc[i].set(height*0.5-pos[i].x, width*0.5-pos[i].y);

      float d = acc[i].mag();
      //d = constrain(d, 0, 360);

      acc[i].normalize();
      acc[i].rotate(map(d, 0, 360, PI*.5, 0));
      acc[i].mult(map(diam[i], 1, 5, .5, .05));
    } else {
      acc[i].set(0, 0);
    }

    vel[i].add(acc[i]);

    //Boundary check horizontal
    if (pos[i].x<diam[i]*.5) {//Boundary Left
      pos[i].x = diam[i]*.5;
      vel[i].x *= -1;
    } else if (pos[i].x>width-diam[i]*.5) {//Boundary Right
      pos[i].x = width-diam[i]*.5;
      vel[i].x *= -1;
    }
    //Boundary check vertical
    if (pos[i].y<diam[i]*.5) {//Boundary Top
      pos[i].y = diam[i]*.5;
      vel[i].y *= -1;
    } else if (pos[i].y>height-diam[i]*.5) {//Boundary Bottom
      pos[i].y = height-diam[i]*.5;
      vel[i].y *= -1;
    }

    vel[i].mult(.99);

    pos[i].add(vel[i]);//Move (Add velocity to each ball's current position)
  }

  //Display an array of balls;
  background(0);
  for (int i=0; i<count; i++) {
    stroke(c[i]);
    strokeWeight(diam[i]);
    point(pos[i].x, pos[i].y);
  }

  if (recording) {
    saveFrame("output2/export_####.png");
    fill(255, 0, 0);
  } else {
    fill(0, 255, 0);
  }
  //ellipse(width/2, height-50, 20, 20);
}
