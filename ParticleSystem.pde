//Particles
class ParticleSystem{
 ArrayList<Particle> particles;
 PVector origin;
 boolean paused;
 
 ParticleSystem(){
  particles = new ArrayList<Particle>(); 
  origin = new PVector();
 }
 
 void addParticle(){
   particles.add(new Particle(origin));
 }
 
 void run(){
  Iterator<Particle> it = particles.iterator();
  
  while(it.hasNext()){
    Particle p = it.next();
    if(paused){
      p.display();
      continue;
    }
    p.run();
    if(p.isDead())
      it.remove();
  }
 }
 
 boolean isEmpty(){
   if(particles.size() == 0)
     return true;
   return false;
 }
 
   void applyForce(PVector force){
    if(!paused)
      for(Particle p : particles){
        p.applyForce(force);
      }
  }

}

class Particle{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass = 1;
  float lifespan;
  
  Particle(PVector l){
   location = new PVector(l.x,l.y);
   acceleration = new PVector();
   velocity = new PVector(random(-1,1),random(-1,1));
   lifespan = 255;
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    
    acceleration.mult(0);
    
    lifespan -= 8.0f;
  }
  
  void display(){
   pushMatrix();
   translate(location.x,location.y);
   stroke(255,lifespan);
   fill(255, lifespan);
   ellipse(0,0,0.5,0.5);
   popMatrix();
  }
  
  void run(){
    update();
    display();
  }
  
  void applyForce(PVector force){
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }
  
  boolean isDead(){
   if(lifespan < 0.0)
     return true;
   else
     return false;
  }
}