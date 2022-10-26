class Particle {
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

class Wave extends Light {
  float myR; 
  double myArc;
  
  Wave() {
    myX = width/2;
    myY = height/2;
    myV = (float)Math.random()*6+2;
    myT = Math.random()*2*PI;
    myArc = myT + Math.random() * PI;
    myColor = color((int)(Math.random()*25)+101, (int)(Math.random()*25)+101, (int)(Math.random()*156));
    mySize = (float)Math.random()*1+0.25;    
  }
  
  void show() {
    stroke(myColor);
    strokeWeight(mySize);
    arc(0,0,myR,myR,(float)myT,(float)myArc);
  }
  
  void move() {
    myR++;
    myT += 0.01;
    myV += myV/64;
    mySize += mySize/64;
  }  
}

Particle[] particles = new Particle[200];
void setup() {
  size(600, 600);
  
  for (int i = 0; i < particles.length; i++) {
    if (Math.random() < 0.2) {
      particles[i] = new Light();
    } else {
      particles[i] = new Particle();      
    }
  }
  
  particles[0] = new Wave();
}

float rot;

void draw() {
  background(0);
  translate(cos(radians(rot))*50,sin(radians(rot+30))*50);
  
  for (int i = 0; i < particles.length; i++) {
    particles[i].move();
    particles[i].show();
 
    
    
    if (particles[i].myX > width || particles[i].myX < 0 || particles[i].myY > height || particles[i].myX < 0 ) {
      if (particles[i] instanceof Light) {
        particles[i] = new Light();        
      } else if (particles[i] instanceof Wave) {
        particles[i] = new Wave();
      } else {
        particles[i] = new Particle();
      }

    }
  }
  resetMatrix();
  rot++;
}
