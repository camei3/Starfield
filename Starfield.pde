class Particle {
  protected float myRotV = radians(5);  


  protected float myR;

  protected float myX, myY;
  protected double myT;
  protected color myColor;
  protected float myV, mySize;
  protected float oldX, oldY;
  Particle() {
    myX = width/2;
    myY = height/2;
    myV = (float)Math.random()*2+1;
    myT = Math.random()*2*PI;
    myColor = color((int)(Math.random()*25)+201, (int)(Math.random()*25)+201, (int)(Math.random()*256));
    mySize = (float)Math.random()*2+0.5;
  }

  public void move() {
    oldX = myX;
    oldY = myY;
    myX += Math.cos(myT)*myV;
    myY += Math.sin(myT)*myV;
    myT += 0.0075;
    myV *= 1.02;
    mySize *= 1.01;
  }

  public void show() {
    stroke(myColor);
    strokeWeight(mySize);
    point(myX, myY);
  }

  public float getR() {
    return myR;
  }

  public float getRotV() {
    return myRotV;
  }

  public void setRotV(float v) {
    myRotV = v;
  }
}
class Light extends Particle {

  Light() {
    myX = width/2;
    myY = height/2;
    myV = (float)Math.random()*6+2;
    myT = Math.random()*2*PI;
    myColor = color((int)(Math.random()*25)+151, (int)(Math.random()*25)+151, (int)(Math.random()*206));
    mySize = (float)Math.random()*1+0.5;
  }

  public void show() {
    stroke(myColor);
    strokeWeight(mySize);
    line(myX, myY, oldX, oldY);
  }

  public void move() {
    super.move();
    myV *= 1.01;
    mySize *= .95;
  }
}

class Wave extends Particle {
  private double myArc;

  Wave() {
    myX = width/2;
    myY = height/2;
    myV = (float)Math.random()*4+4;

    myT = Math.random()*PI;
    myArc = myT + Math.random() * PI;
    if (Math.random() < 0.5) {
      myT += PI;
      myArc += PI;
    };

    myColor = color((int)(Math.random()*25)+61, (int)(Math.random()*25)+61, (int)(Math.random()*116));
    mySize = (float)Math.random()*1+0.25;
  }

  public void show() {
    stroke(myColor);
    noFill();
    strokeWeight(mySize);
    arc(myX, myY, myR, myR, (float)myT, (float)myArc);
  }

  public void move() {
    myR += myV;
    myT *= 1.005;
    myArc *= 0.995;
    myV += myV/16;
    mySize += mySize/64;
  }
}

//swirl goes into vortex
class Swirl extends Light {


  Swirl() {

    myV = -(float)Math.random()-0.5;
    myColor = color((int)(Math.random()*256), (int)(Math.random()*256), (int)(Math.random()*25)+230);

    myR = (float)(Math.random()*width/4)+width*sqrt(2);
    myT = Math.random()*2*PI;    

    myX = (float)Math.cos(myT)*myR;
    myY = (float)Math.sin(myT)*myR;
    oldX = myX;
    oldY = myY;

    mySize = (float)Math.random()+5;

    move();
  }
  public void move() {
    myR*=0.99;

    //myR=50;

    myT += myRotV;    
    oldX = myX;
    oldY = myY;
    myX = width/2 + (float)(Math.cos(myT))*myR*myV;
    myY = height/2 + (float)(Math.sin(myT))*myR*myV;
    mySize = myR/50;
  }
}

class Obstruction {
  float anchorX, anchorY;
  float startX, startY;
  float myTheta;
  Obstruction() {
  }
}

Particle[] particles = new Particle[200];

Light[] lights = new Light[100];

void setup() {

  size(800, 800);

  newPoint();
  for (int i = 0; i < particles.length; i++) {
    newRandomParticle(i);
  }
  particles[0] = new Swirl();
  particles[1] = new Swirl();  
  particles[1].setRotV(particles[1].getRotV()*-1);

  for (int i = 0; i < lights.length; i++) {
    lights[i] = new Light();
  }
}

float pointX, pointY;
float pointDur;
float curX = width/2, curY = height/2;
float wavyTheta = 0;

void draw() {

  //background, trail effect
  fill(0, 255);
  rect(-width, -height, width*3, height*3);

  if (dist(pointX, pointY, curX, curY) < 1) {
    newPoint();
  } else {
    curX += (pointX-curX)/pointDur;
    curY += (pointY-curY)/pointDur;
  }
  translate(curX, curY);
  translate(-width/2, -height/2);
  //line(width*3/2-2*curX,height*3/2-2*curY,width/2,height/2);
  stroke(128);
  strokeWeight( sqrt(20000/ ( dist((width*5/2-3*curX)/2,(height*5/2-3*curY)/2,width/2,height/2) + 10) ) * 7.5);    
  point(width*5/4-curX*3/2,height*5/4-curY*3/2);
  point(width*11/8-curX*7/4,height*11/8-curY*7/4);  
  point(width*23/16-curX*15/8,height*23/16-curY*15/8);  
  point(width*47/32-curX*31/16,height*47/32-curY*31/16);    
  stroke(255);  
  strokeWeight( sqrt(20000/ ( dist(width*3/2-2*curX,height*3/2-2*curY,width/2,height/2) + 10) ) * 10);  
  point(width*3/2-2*curX,height*3/2-2*curY);
  


  //animating particles
  for (int i = 0; i < particles.length; i++) {

    particles[i].move();
    particles[i].show();

    //remaking new particles of ones off-screen
    if (particles[i] instanceof Swirl && particles[i].getR() < 5) {
      particles[i] = new Swirl();
      if (i == 1) {
        particles[1].setRotV(particles[1].getRotV()*-1);
      }
    } else if (particles[i] instanceof Wave && particles[i].getR() > dist(0, 0, width, height)) {
      newRandomParticle(i);
    } else if (particles[i].myX > width*2 || particles[i].myX < -height || particles[i].myY > height*2 || particles[i].myX < -width ) {
      newRandomParticle(i);
    }
  }

  for (int i = 0; i < lights.length; i++) {
    lights[i].move();
    lights[i].show();
    if (lights[i].myX > width*2 || lights[i].myX < -height || lights[i].myY > height*2 || lights[i].myX < -width ) {
      lights[i] = new Light();
    }
  }
  resetMatrix();
  wavyTheta += 8;
}

//determining variant of new particle
void newRandomParticle(int index) {
  if (particles[index] instanceof Swirl) {
    particles[index] = new Swirl();
    return;
  }


  double luck = Math.random();
  if (luck < 0.25) {
    particles[index] = new Light();
  } else if (luck < 0.4) {
    particles[index] = new Wave();
  } else {
    particles[index] = new Particle();
  }
};

//making new warp-point
void newPoint() {
  pointX = (float)(Math.random()-0.5)*(width/1.8)+(width/2);
  pointY = (float)(Math.random()-0.5)*(height/1.8)+(height/2);

  pointDur = (float)(Math.random()*30)+90;
}

//make a burst mode?
//constant object reflected on vanish point, like a ship
