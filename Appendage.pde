class Appendage{
  
  float angle, pAngle;
  float radius;
  float length;
  float t, tt; 
  float joints;
  float rate = 0.1;
  
  Vec2 pos;
  
  VerletParticle2D[] particles;
  
  //Radius = Starting radius away from body
  Appendage(Vec2 pos, float angle, float radius,float length, float t, int joints){
    
    this.pos = pos;
    this.pAngle = angle;
    this.radius = radius;
    this.joints = joints;
    this.t = t;
    this.length = length;
    
    particles = new VerletParticle2D[int(joints)];
    
    for(int i = 0; i < joints; i++){
      VerletParticle2D particle = new VerletParticle2D(pos.x+cos(pAngle)*(radius+((i+1)*length/joints)),
        pos.y+sin(pAngle)*(radius+((i+1)*length/joints)));
      particles[i] = particle;
      physics.addParticle(particle);
    }
  }
  
  void update(){
  
    for(int i = 0; i < joints; i++){
      //particles[i].lock();
      particles[i].x = pos.x+cos(pAngle+angle)*(radius+((i+1)*length/joints))+(i+1)*cos(pAngle+angle+PI/2)*sin(t+tt);
      particles[i].y = pos.y+sin(pAngle+angle)*(radius+((i+1)*length/joints))+(i+1)*sin(pAngle+angle+PI/2)*sin(t+tt);
    } 
    tt+=rate;
  }
  
  void display(){
    
    line(pos.x + cos(pAngle+angle)*radius, pos.y + sin(pAngle+angle)*radius, particles[0].x, particles[0].y);
    for(int i = 1; i < joints; i++){
      line(particles[i-1].x, particles[i-1].y, particles[i].x, particles[i].y);
    }
  }
  
  void destroy(){
    for(VerletParticle2D p : particles){
      physics.removeParticle(p);
    }
  }
}