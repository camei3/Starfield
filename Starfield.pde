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
    myV += myV/16;
    mySize += mySize/64;
  }  
  float getMyR() {
    return myR;
  }
}

Particle[] particles = new Particle[200];
void setup() {
  size(600, 600);
  
  for (int i = 0; i < particles.length; i++) {
    newRandomParticle(i);
  }
}

float rot;
float anchorX = width/2, anchorY = height/2;
void draw() {
  anchorX = -(mouseX-width/2)/16;
  anchorY = -(mouseY-height/2)/16;
  background(0);
  //translate(cos(radians(rot))*50,sin(radians(rot+30))*50);
  //rot++;
  translate(anchorX,anchorY);
  
  
  for (int i = 0; i < particles.length; i++) {
    particles[i].move();
    particles[i].show();
 
    
    if (particles[i] instanceof Wave && particles[i].myR > dist(0,0,width,height)) {
      newRandomParticle(i);
    } else if (particles[i].myX > width*2 || particles[i].myX < -height || particles[i].myY > height*2 || particles[i].myX < -width ) {
      newRandomParticle(i);
    }
  }
  resetMatrix();
}

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
