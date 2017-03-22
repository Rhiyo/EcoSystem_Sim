class Web{
  Vec2 pos;
  Vec2 detail;
  float length, sLength;
  float squish;
  float variance;
  
  Vec2[][] ranVar;
  
  Web(){
    pos = new Vec2(width/2,height/2);
    detail = new Vec2(18, 10);
    length = 100;
    squish = 0.9;
    variance = 0.075;
    ranVar = new Vec2[int(detail.y)][int(detail.x)];
    for(int i = 0; i < detail.y;i++){
      for(int j = 0; j < detail.x;j++){
        sLength = (j%2==1) ? length : length*squish; 
        ranVar[i][j] = new Vec2(
          random(-(2*PI/detail.x*variance), 2*PI/detail.x*variance),
          random(-((sLength/detail.y)*variance),(sLength/detail.y)*variance));
      }
    }
  }
  
  void display(){
    stroke(255,255,255);
    Vec2 c;
    float oLength;
    for(int i = 0; i < detail.y;i++){      
      for(int j = 0; j < detail.x;j++){
        if(j%2==1){
          sLength = length*squish;
          oLength = length;
        }
        else{
          oLength = length*squish;
          sLength = length;          
        }
        if(i == 0)
          c = new Vec2(0,0);
        else
          c = ranVar[i-1][j];
        
        line(pos.x+cos((j*2*PI/detail.x)+c.x)*(((i)*sLength/detail.y)+c.y),
          pos.y+sin((j*2*PI/detail.x)+c.x)*(((i)*sLength/detail.y)+c.y),
          pos.x+cos((j*2*PI/detail.x)+ranVar[i][j].x)*((i+1)*(sLength/detail.y)+ranVar[i][j].y),
          pos.y+sin((j*2*PI/detail.x)+ranVar[i][j].x)*((i+1)*(sLength/detail.y)+ranVar[i][j].y));
        
        if(j == detail.x - 1){
          c = ranVar[i][0];
        }else{
          c = ranVar[i][j+1];
        }
        line(pos.x+cos(((j)*2*PI/detail.x)+ranVar[i][j].x)*(((i+1)*sLength/detail.y)+ranVar[i][j].y),
          pos.y+sin(((j)*2*PI/detail.x)+ranVar[i][j].x)*(((i+1)*sLength/detail.y)+ranVar[i][j].y),
          pos.x+cos(((j+1)*2*PI/detail.x)+c.x)*(((i+1)*oLength/detail.y)+c.y),
          pos.y+sin(((j+1)*2*PI/detail.x)+c.x)*(((i+1)*oLength/detail.y)+c.y));                
      }      
    }
  }
  
}