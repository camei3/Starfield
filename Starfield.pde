class Particle {
  //for subclass Swirl
  protected float myRotV = radians(5); 
  
  //for Wave & Swirl
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
    oldX = myX;
    oldY = myY;    
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

    myT += myRotV;    
    oldX = myX;
    oldY = myY;
    myX = width/2 + (float)(Math.cos(myT))*myR*myV;
    myY = height/2 + (float)(Math.sin(myT))*myR*myV;
    mySize = myR/50;
  }
}

//extras particles
Light[] lights = new Light[100];
//all other particles
Particle[] particles = new Particle[200];

void setup() {
  size(800, 800);

  newPoint();
  for (int i = 0; i < particles.length; i++) {
    newRandomParticle(i);
  }
  
  //the Oddball particles
  particles[0] = new Swirl();
  particles[1] = new Swirl();   

  //extras particles
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

  //spawnpoint reaches objective point
  if (dist(pointX, pointY, curX, curY) < 1) {
    newPoint();
  } else {
    curX += (pointX-curX)/pointDur;
    curY += (pointY-curY)/pointDur;
  }

  //move closer to objective point
  translate(curX, curY);
  translate(-width/2, -height/2);
  //bob a little
  translate(cos(radians(wavyTheta/5))*10,sin(radians(wavyTheta/5))*10);
  
  //animating particles
  for (int i = 0; i < particles.length; i++) {

    particles[i].move();
    particles[i].show();

    //remaking new particles of ones off-screen
     //--Oddball particle respawn condition
    if (particles[i] instanceof Swirl && particles[i].getR() < 5) {
      newRandomParticle(i);
     //--Wave particle respawn condition
    } else if (particles[i] instanceof Wave && particles[i].getR() > dist(0, 0, width, height)) {
      newRandomParticle(i);
     //--Light or Particle respawn condition
    } else if (particles[i].myX > width*2 || particles[i].myX < -height || particles[i].myY > height*2 || particles[i].myX < -width ) {
      newRandomParticle(i);
    }
  }
  
  //handling the extras particles
  for (int i = 0; i < lights.length; i++) {
    lights[i].move();
    lights[i].show();
    if (lights[i].myX > width*2 || lights[i].myX < -height || lights[i].myY > height*2 || lights[i].myX < -width ) {
      lights[i] = new Light();
    }
  }
  
  //ship
  //---head
  stroke(176,198,220,200);    
  strokeWeight( abs(40 * cos(dist(width*47/32-curX*31/16,height*47/32-curY*31/16,width-curX,height-curY) * (PI/( sqrt(2)*1.5*width)) )));  
  point(width*47/32-curX*31/16,height*47/32-curY*31/16); 
  //--neck
  stroke(204,230,255);   
  strokeWeight( abs(50 * cos(dist(width*3/2-curX*2,height*3/2-curY*2,width-curX,height-curY) * (PI/( sqrt(2)*1.5*width)) )));    
  point(width*3/2-curX*2,height*3/2-curY*2);
  //--pole
  stroke(60,68,75);  
  strokeWeight(10);  
  line(width*3/2-curX*2,height*3/2-curY*2,width*7/4-curX*5/2,height*7/4-curY*5/2);
  //--tank
  stroke(184,207,230);  
  strokeWeight( abs( 50 * cos(dist(width*7/4-curX*5/2,height*7/4-curY*5/2,width-curX,height-curY) * (PI/( sqrt(2) *1.5*width)) )));   
  line(width*7/4-curX*5/2,height*7/4-curY*5/2,width*15/8-curX*11/4,height*15/8-curY*11/4);
  stroke(180,203,225);
  point(width*15/8-curX*11/4,height*15/8-curY*11/4);
  
  resetMatrix();
  wavyTheta += 8;
}

//determining variant of new particle
void newRandomParticle(int index) {
  double luck = Math.random();
  
  if (particles[index] instanceof Swirl) {
    particles[index] = new Swirl();
        //make one of Oddball move opposite
    if (luck < 0.5) {
      particles[index].setRotV(particles[index].getRotV()*-1);
    }
    return;
  }


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
