class Particle {
  float myR;
  
  float myX, myY;
  double myT;
  color myColor;
  float myV, mySize;
  float oldX, oldY;
  Particle() {
    myX = width/2;
    myY = height/2;
    myV = (float)Math.random()*4+1;
    myT = Math.random()*2*PI;
    myColor = color((int)(Math.random()*25)+201, (int)(Math.random()*25)+201, (int)(Math.random()*256));
    mySize = (float)Math.random()*2+0.5;
  }

  void move() {
    oldX = myX;
    oldY = myY;
    myX += Math.cos(myT)*myV;
    myY += Math.sin(myT)*myV;
    myT += 0.01;
    myV += myV/64;
    mySize += mySize/64;
  }

  void show() {
    stroke(myColor);
    strokeWeight(mySize);
    point(myX, myY);
  }
}
class Light extends Particle {
  
  Light() {
    myX = width/2;
    myY = height/2;
    myV = (float)Math.random()*6+2;
    myT = Math.random()*2*PI;
    myColor = color((int)(Math.random()*25)+101, (int)(Math.random()*25)+101, (int)(Math.random()*156));
    mySize = (float)Math.random()*1+0.25;  
  }
  
  void show() {
    stroke(myColor);
    strokeWeight(mySize);
    line(myX,myY,oldX,oldY);
  }
}

class Wave extends Particle {
  double myArc;
  
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
    
    myColor = color((int)(Math.random()*25)+51, (int)(Math.random()*25)+51, (int)(Math.random()*106));
    mySize = (float)Math.random()*1+0.25;    
  }
  
  void show() {
    stroke(myColor);
    noFill();
    strokeWeight(mySize);
    arc(myX,myY,myR,myR,(float)myT,(float)myArc);
  }
  
  void move() {
    myR += myV;
    myT += 0.01;
    myArc -= 0.01;
    myV += myV/16;
    mySize += mySize/64;
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
  
  
  for (int i = 0; i < particles.length; i++) {
    newRandomParticle(i);
  }
}

float pointRot,pointX,pointY;
float mouseAnchorX = width/2, mouseAnchorY = height/2;

void draw() {
  //mouse panning, deprecated for now
  mouseAnchorX = -(mouseX-width/2)/10;
  mouseAnchorY = -(mouseY-height/2)/10;
  
  //background, trail effect
  fill(0,90);
  rect(-width,-height,width*3,height*3);
  
  //animating particles
  for (int i = 0; i < particles.length; i++) {
    
    particles[i].move();
    particles[i].show();
    
    //remaking new particles of ones off-screen
    if (particles[i] instanceof Wave && particles[i].myR > dist(0,0,width,height)) {
      newRandomParticle(i);
    } else if (particles[i].myX > width*2 || particles[i].myX < -height || particles[i].myY > height*2 || particles[i].myX < -width ) {
      newRandomParticle(i);
    }
  }
}

//determining variant of new particle
void newRandomParticle(int index) {
  double luck = Math.random();
    if (luck < 0.2) {
      particles[index] = new Light();
    } else if (luck < 0.25){
      particles[index] = new Wave();      
    } else {
      particles[index] = new Particle();
    }
};

//making new warp-point
void newPoint() {
  pointRot = (float)(Math.random()*2*PI);
  pointX = (float)((Math.random()-0.5)*width/1.9);
  pointY = (float)((Math.random()-0.5)*height/1.9);
}

//make a burst mode?
