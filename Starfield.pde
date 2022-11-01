class Particle {
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
    myV += myV/64;
    mySize += mySize/64;
  }

  public void show() {
    stroke(myColor);
    strokeWeight(mySize);
    point(myX, myY);
  }
  
  public float getR() {
    return myR;
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
    line(myX,myY,oldX,oldY);
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
    arc(myX,myY,myR,myR,(float)myT,(float)myArc);
  }
  
  public void move() {
    myR += myV;
    myT += 0.01;
    myArc -= 0.01;
    myV += myV/16;
    mySize += mySize/64;
  }  
}

//swirl goes into vortex
class Swirl extends Light {
  Swirl() {
 
    myV = (float)Math.random()-1;
    myColor = color((int)(Math.random()*25)+230, (int)(Math.random()*25)+230, (int)(Math.random()*256));
    
    myR = (float)(Math.random()*width/4)+width;
    myT = Math.random()*2*PI;    
    
    myX = (float)Math.cos(myT)*myR;
    myY = (float)Math.sin(myT)*myR;
    
    mySize = (float)Math.random()+5;
  }
  public void move() {
    oldX = myX;
    oldY = myY;
    myX = width/2 + (float)(Math.cos(myT)*myR);
    myY = height/2 + (float)(Math.sin(myT)*myR);
    myR--;
    myT += radians(1);
    //myV += 0.1;
    System.out.println(myX + " " + myY + "\n");
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

void setup() {
  
  size(600, 600);
  
  newPoint();
  for (int i = 0; i < particles.length; i++) {
    newRandomParticle(i);
  }
  particles[0] = new Swirl();
}

float pointX,pointY;
float pointDur;
float curX = width/2, curY = height/2;
float wavyTheta = 0;

float mouseAnchorX = width/2, mouseAnchorY = height/2;

void draw() {
  
  //background, trail effect
  fill(0,100);
  rect(-width,-height,width*3,height*3);
  
  if (dist(pointX,pointY,curX,curY) < 1) {
    newPoint();
  } else {
    curX += (pointX-curX)/pointDur;
    curY += (pointY-curY)/pointDur;  
  }
  translate(curX,curY);
  translate(-width/2,-height/2);

  
  //mouse panning, deprecated for now
  mouseAnchorX = -(cos(radians(wavyTheta))*80-width/2)/10;
  mouseAnchorY = -(sin(radians(wavyTheta))*80-height/2)/10;
  
  translate(mouseAnchorX,mouseAnchorY);
  
  //animating particles
  for (int i = 0; i < particles.length; i++) {
    
    particles[i].move();
    particles[i].show();
    
    //remaking new particles of ones off-screen
    if (particles[i] instanceof Wave && particles[i].getR() > dist(0,0,width,height)) {
      newRandomParticle(i);
    } else if (particles[i].myX > width*2 || particles[i].myX < -height || particles[i].myY > height*2 || particles[i].myX < -width ) {
      newRandomParticle(i);
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
    } else if (luck < 0.4){
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
