class Shellman extends Creature{
 LSystem behaviour; 
      int currentCharIndex;
    float moveDistance = 40;
 float currentRot = PI/2;
 float rotRate = PI/6;  
 Stack goal;
 
 //boolean actioning;
 Shellman(float x, float y, float m, PVector c){
    super(x,y,m,c);

    //Build body using Box2D
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    
    body = box2d.createBody(bd);
    body.setUserData(this);
    
    //Gooey inside
    CircleShape inside = new CircleShape();
    inside.m_radius = box2d.scalarPixelsToWorld(20);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = inside;
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 1f;
    
    body.createFixture(fd);
    
    
    //Build tentacles
        //Leg creation
    appendages = new Appendage[8];
    
    float startAngle = PI/11;
    float legLength = 30;
    for(int i = 0; i < 8; i++){
      appendages[i] = new Appendage(box2d.getBodyPixelCoord(body), (i+2)*startAngle, 20, legLength+random(-10,10), 0, 3);
      appendages[i].angle = -PI/2;
    }
    
    //Behaviour
    Rule[] ruleset = new Rule[1];
    ruleset[0] = new Rule('F', "F+F++[----FF++F--FFF]+FF-");
    behaviour = new LSystem("F", ruleset);
    
    goal = new Stack();
    
 }
 void drawShell(PVector center, float len){
  if(len < 1)
    return;
  pushMatrix();
  float hLen = len/2;
  translate(center.x,center.y);
  triangle(-hLen,-len,hLen,-len,0, 0);
  
  popMatrix();
  
  center.y = center.y-len;
  drawShell(center.get(), hLen);
  
  center.x = center.x-hLen;
  center.y = center.y+len;
  drawShell(center.get(), hLen);
  
  center.x = center.x+len;
  drawShell(center.get(), hLen);
  
  }

  void update(){
   super.update();
   int dirSwitch = 1;
    for(Appendage a : appendages){
      a.rate = dirSwitch*0.007*box2d.vectorWorldToPixels(body.getLinearVelocity()).length();
      a.pos = box2d.getBodyPixelCoord(body);
      a.angle = getAngle()-PI/2;
      a.update();
      
      dirSwitch = dirSwitch*-1;
    }
    
    
    //Behaviour
    
    if(!goal.isEmpty() && !arrive((Vec2)goal.peek())){
      println("HAH");
      point(((Vec2)goal.peek()).x,((Vec2)goal.peek()).y);
      return;
    }
    
    float distanceRate = 0.95;
    boolean ended = false;
    println("B");
    Vec2 bodyPos = getPos();
    while(!ended){
      String sentence = behaviour.getSentence();
      if(currentCharIndex >= sentence.length()){
        behaviour.generate();
        currentCharIndex = 0;
        goal.clear();
        //return;
      }  
      println("A");
      char task = behaviour.getSentence().charAt(currentCharIndex);
      switch (task) {
            case 'F':Vec2 goalPos = new Vec2(bodyPos.x + moveDistance*cos(currentRot),
                         bodyPos.y + moveDistance*sin(currentRot));
                     if(!goal.isEmpty())
                       goal.pop();
                           println("F");
                     goal.push(goalPos);
                     //actioning = true;
                     ended = true;
                     break;
            case '[':goal.push(bodyPos);
                     moveDistance *=distanceRate; 
                     break;
            case ']':goal.pop();
                     moveDistance *=1/distanceRate;
                     break;
            case '+':currentRot += rotRate;
                     break;
            case '-':currentRot -= rotRate;
                     break;
            default:ended = true;
                    break;
      }
    currentCharIndex++;
    }
  }

   void display(){
   
   Vec2 pos = getPos();
    pushMatrix();
    noStroke();
    translate(pos.x, pos.y);
    rotate(getAngle()-PI/2);
   
     fill(200);
      drawShell(new PVector(), 25);
    fill(221,160,221);
  arc(0,0, 40, 40, 0, PI);
  pushMatrix();
  translate(-8, 5);
  rotate(-PI/7);
  fill(0);
  ellipse(0,0, 13, 5);
  popMatrix();
    pushMatrix();
  translate(8, 5);
  rotate(-PI+PI/7);
  fill(0);
  ellipse(0,0, 13, 5);
  popMatrix();
  popMatrix();
  stroke(221,160,221);
      fill(221,160,221);   
   for(Appendage a : appendages)
      a.display();
  }
}