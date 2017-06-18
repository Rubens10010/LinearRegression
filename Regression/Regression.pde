float factorx;
float factory;

float[] xaxis_p;   // contains the numbers showing on screen on the x axis
float[] yaxis_p;
float[] xaxis_n;  // contains the number showing on screen on the negative x axis
float[] yaxis_n;
float[] origin = new float[2];  // origin of coordinates on screen

int numXPoints_p;  // size of xaxis_p
int numXPoints_n;
int numYPoints_p;
int numYPoints_n;

float distance = 1;  // distance between points
PFont f;
float textSize;  // size of numbers on screen
float err_x;  // err from xaxis to numbers down
float err_y;  //err from yaxis to numbers on left

Regression_m model;
float[] result_vector;
boolean locked = true;

float alpha = 0.0003;

void setup()
{
  factorx = 20;  // pixels per point
  factory = 20;

  size(600,400);
  //size(1024,860);
  
  /*origin[0] = width/2;
  origin[1] = height/2;*/
  origin[0] = 50;
  origin[1] = 350;
  update();
  //textFont(f,36);
  
  model = new Regression_m();
  model.loadFromFile("data.txt");
  model.setParameters(alpha, 0.01);  // learning Rate , umbral
  result_vector = model.theta;      // first theta vector
  print_vector(result_vector);
}

void draw()
{
   background(250);
   stroke(20,80,255);
   drawlines();
   drawaxis();
   
   for(int i = 0; i < model.number_examples; i++)
   {
       draw2DPoint(model.x.getValue(i,1), model.y[i]);    
   }
   
  textFont(f,textSize+10);
  fill(0);
  
  // Text shouldn't appear when user cleans screen
  //textAlign(CENTER);
  text(result_vector[0] + " + ",abs((width/2 + 40) - origin[0]),40);
  text(result_vector[1] + "x",abs((width/2+160) - origin[0]),40);
  
   if(!locked)
   {
     drawRect(result_vector[0], result_vector[1]);
     if(!model.ready)
     {
         model.do_learning_step();
         result_vector = model.theta;
     }
   }
   //noLoop();
}

void print_vector(float[] vector)
{
  for(int i = 0; i < vector.length; i++)
  {
      print(vector[i] + "+");
  }
  println("\n");
}

void draw2DPoint(float a, float b)
{
  float x = getXposition(a);
  float y = getYposition(b);
  stroke(255,149,0);
  ellipse(x,y,factorx/3,factory/3);
}

void drawRect(float thetha_0, float thetha_1)
{
   stroke(55);
   float y0 = thetha_0; // ax +b -> x = 0
   float y1 = thetha_1*(numXPoints_p*distance) + thetha_0;

   line(origin[0],getYposition(y0),getXposition(numXPoints_p*distance),getYposition(y1));
}

void update()
{
  float widthxp = width - origin[0];
  float widthxn = abs(0 - origin[0]);
  float heightyn = height- origin[1];
  float heightyp = abs(0 - origin[1]);
  
  numXPoints_p = int(widthxp/factorx);
  numXPoints_n = int(widthxn/factorx);
  numYPoints_p = int(heightyp/factory);
  numYPoints_n = int(heightyn/factory);
  
  xaxis_p = new float[numXPoints_p];   // contains the numbers showing on screen on the x axis
  yaxis_p = new float[numYPoints_p];
  xaxis_n = new float[numXPoints_n];  // contains the number showing on screen on the negative x axis
  yaxis_n = new float[numYPoints_n];
  
  fillaxis();
  
  f = createFont("Arial",16,true);
  textSize = abs(factorx - 2)%10;
  err_x = textSize;
  err_y = textSize;
}

void mouseClicked()  //cambiar por teclas, click es para colocar un punto
{
    float newx = getXnumber(mouseX);
    float newy = getYnumber(mouseY);
    println("added: " + newx + ","+newy);
    stroke(255,0,0);
    ellipse(mouseX, mouseY, factorx/3,factory/3);
    model.addExample(newx, newy);    // makes the model not ready
    locked = true;        // lock graphic 
}

void keyPressed()
{
  if(key == 'z')
  {
    factorx += 10;
    factory += 10;
  }else if(key == 'm')// crashea cuando factor x o y == 0
  {
    factorx -= 10;
    factory -= 10;
    if(factorx < 10 || factory < 10)
    {
       factorx = 10;
       factory = 10;
       return;
    }
  }else if(key == ENTER)
  {
    println("Learning Process started...");
    model.restart(alpha, 0.01);  // checks Wheter or not model is usable and unlocks graphics
    locked = false;
    result_vector = model.theta;
  }
  else if(key == 'c')  // clean points screen
  {
    model.clean();
    locked = true;
    
    // 2d
    result_vector[0] = 1;
    result_vector[1] = 1;
  }
  else{
    return;
  }
  
  update();  
}

void fillaxis()    // fill the number in vector axis to show on screen
{
  int x = 0;
  for(int i = 0; i < numXPoints_p;i++)
  {
    x+=distance;
    xaxis_p[i] = x;
  }

  x = 0;
  for(int i = 0; i < numXPoints_n; i++)
  {
    x-=distance;
    xaxis_n[i] = x;
  }
  
  int y = 0;
  for(int i = 0; i < numYPoints_p; i++)
  {
    y+=distance;
    yaxis_p[i] = y;
  }
  
  y = 0;
  for(int i = 0; i < numYPoints_n; i++)
  {
    y-=distance;
    yaxis_n[i] = y;
  }
}

void drawlines()
{
  stroke(55,33,233);
  strokeWeight(2);
  line(0,origin[1],width,origin[1]);
  line(origin[0],0,origin[0],height);
}

void drawaxis()
{ 
  textFont(f,textSize);
  fill(0);
  //textAlign(CENTER);
  text("0",origin[0] - err_y,origin[1] + err_x);
  
  float x0 = origin[0];
  
  for(int i = 0; i < numXPoints_p;i++)
  {
    x0 += factorx;
    text(str(int(xaxis_p[i])),x0 - err_y,origin[1]+err_x);
  }
  
  x0 = origin[0];
  for(int i = 0; i < numXPoints_n;i++)
  {
    x0 -= factorx;
    text(str(int(xaxis_n[i])),x0 - err_y,origin[1]+err_x);
  }
  
  x0 = origin[1];

  for(int i = 0; i < numYPoints_p;i++)
  {
    x0 -= factory;
    text(str(int(yaxis_p[i])),origin[0]- err_y,x0 + err_x);
  }
  
  x0 = origin[1];
  for(int i = 0; i < numYPoints_n;i++)
  {
    x0 += factory;
    text(str(int(yaxis_n[i])),origin[0] - err_y,x0 + err_x);
  }
}

float getXposition(float a)  // get the position on screen of the a point on x coordinates
{
  return (origin[0] + (a*factorx)/distance) - err_y/2;
}

float getYposition(float b)
{
  return (origin[1] - (b*factory)/distance) + err_x/2;  // Talvez comentar
}

float getXnumber(float xposition)
{
   return ((xposition + err_y/2 - origin[0])/factorx)*distance;
}

float getYnumber(float yposition)
{
  return ((yposition - err_x/2 - origin[1])/(-factory))*distance;
}