class Regression_m
{
  Matrix x;    // Matrix containing the samples
  float[] theta;  // Vector of weights
  float[] y;  // Real outputs of samples

  int number_examples;
  int number_characteristics;
  
  float umbral;
  float alpha;

  int iteration;
  boolean ready;
  
  float err;
  
  Regression_m()
  {
     alpha = 0.5;
     umbral = 1;
     iteration = 0;
     ready = false;
  }
  
  void setParameters(float a, float b)
  {
      alpha = a;
      umbral = b;
  }
  
  boolean loadFromFile(String file)
  {
      BufferedReader reader;
      String line;
      
      reader = createReader(file);
      try{
        line = reader.readLine();
        String[] pieces = split(line,TAB);
        
        number_examples = int(pieces[0]);
        number_characteristics = int(pieces[1]);
        
        x = new Matrix(number_examples, number_characteristics+1);        
        y = new float[number_examples];
        
        for(int i  = 0; i < number_examples; i++)
        {
            line = reader.readLine();
            pieces = split(line,';');
            
            for(int j = 0; j < number_characteristics + 1; j++)
            {
                if(j == 0)
                {
                    x.setValue(i,j,1);
                    continue;
                }
                
                x.setValue(i,j,float(pieces[j-1]));
            }
            
            
            y[i] = float(pieces[number_characteristics]);
        }
      }
      catch(IOException e)
      {
        e.printStackTrace();
        line = null;
        return false;
      }
      
      // initiate first state of model
      initialize();
      return true;
  }
  
  /*void load_data(Matrix input, float[] y)
  {
     this.x = input;
     for(int i = 0; i < number_examples; i++)
     {
       for(int j = 0; j < number_characteristics + 1; j++)
       {
           if(j == 0)
           {
             this.x.setValue(i,j,1);
             continue;
           }
           
           this.x.setValue(i,j,input.getValue(i,j));
       }
     }
     
     output = y;
  }*/
  
  void initialize()
  {
     ready = false;        // when new data arrives, also clean theta vectors
     //int thsize = number_characteristics + 1;
     iteration = 0;
     
     theta = new float[number_characteristics + 1];  // first characteristic is alwas 1
     
     // Fill theta with random values
     for(int i = 0; i < theta.length; i++)
     {
        theta[i] = random(0,10);
     }
     
     // Calculate first time error
     err  = 0;
     for(int i = 0; i < number_examples; i++)
     {  
        float temp = y[i] - dot_product(theta, x.getRow(i), theta.length);
        err += temp*temp;
     }
     
     err /= float(number_examples);
  }
  
  void do_learning_step()
  {
     println("error: " + err);
     float[] temp = new float[theta.length];
        
     float learning = 0;
      
      // Learning for theta_0
     for(int j = 0; j < number_examples; j++)
     {
        learning += -(2/float(number_examples))*(x.getValue(j,0)*(y[j] - dot_product(theta, x.getRow(j),theta.length)));
     }
     
    
     temp[0] = theta[0] - alpha*learning;
        
      // Calculate parcial derivates for theta_i ; i > 0

      for(int i = 1; i < theta.length; i++)
      {
         learning = 0;
         for(int j = 0; j < number_examples; j++)
         {
            learning += -(2/float(number_examples))*(x.getValue(j,i)*(y[j] - dot_product(theta, x.getRow(j),theta.length)));
         }
         temp[i] = theta[i] - alpha*learning;
      }
      
      /*if(alpha>0.00000000001)
        alpha -= 0.01;
       */ 
      theta = temp;
      
      // recalulate error
      err  = 0;
      for(int i = 0; i < number_examples; i++)
      {
         float t = y[i] - dot_product(theta, x.getRow(i), theta.length);
         err += t*t;
      }
       
      err = err/float(number_examples);
      
      if(err < umbral || iteration > 5000)
      {
        ready = true;    // ready for predictions!!!
        println("Model ready to use!!!");
      }
      iteration++;      // count new iteration 
  }
   
  /*float[] fit_weights(Matrix x, float[] y)
  {
      
     int thsize = number_characteristics + 1;
     float err;
     
     theta = new float[thsize];  // first characteristic is alwas 1
     
     // Fill theta with random values
     for(int i = 0; i < thsize; i++)
     {
        theta[i] = random(0,1);
     }
     
     // Calculate first time error
     err  = 0;
     for(int i = 0; i < number_examples; i++)
     {  
        float temp = y[i] - dot_product(theta, x.getRow(i), thsize);
        err += temp*temp;
     }
     
     err /= float(number_examples);
     int iter = 0;
     while(err > umbral && iter < 10000)
     {
        println("error: " + err);
        float[] temp = new float[thsize];
        // Calculate derivate for Theta_0
        //temp[0] = 0;
        
        float learning = 0;

        for(int j = 0; j < number_examples; j++)
        {
           learning += -(2/float(number_examples))*(x.getValue(j,0)*(y[j] - dot_product(theta, x.getRow(j),thsize)));
        }
        //println(learning);
        
        temp[0] = theta[0] - alpha*learning;
        
        // Calculate parcial derivates for theta_i ; i > 0

        for(int i = 1; i < thsize; i++)
        {
           learning = 0;
           for(int j = 0; j < number_examples; j++)
           {
              learning += -(2/float(number_examples))*(x.getValue(j,i)*(y[j] - dot_product(theta, x.getRow(j),thsize)));
           }
           temp[i] = theta[i] - alpha*learning;
        }
        
        //alpha -= 0.01;
        
        theta = temp;
        // calulate new error
        err  = 0;
        for(int i = 0; i < number_examples; i++)
        {
           float t = y[i] - dot_product(theta, x.getRow(i), thsize);
           err += t*t;
        }
       
        err = err/float(number_examples);
        iter++;
     }
     
     return theta;
  }*/
  
  /*float[] getWeightVector()
  {
     return fit_weights(x,output);
  }*/
  
  // 2d only
  boolean addExample(float newx, float newy)
  {
      ready = false;
      
      number_examples++;
      Matrix temp_x = x;
      float[] temp_y = y;
      x = new Matrix(number_examples,number_characteristics+1);
      y = new float[number_examples];
        
      for(int i  = 0; i < number_examples-1; i++)
      {   
          for(int j = 0; j < number_characteristics + 1; j++)
          {
              x.setValue(i,j,temp_x.getValue(i,j));
          }

          y[i] = temp_y[i];
      }
      
      x.setValue(number_examples-1,0,1);
      x.setValue(number_examples-1,1,newx);
      y[number_examples-1] = newy;
      return true;
  }
  
  void restart(float alp, float umb)
  {
    if(number_examples != x.rows || number_examples != y.length)
    {
      println("ERROR");
      return;
    }
    
    alpha = alp;
    umbral = umb;
    initialize();
  }
  
  void clean()
  {
      number_examples = 0;
      //number_characteristics = 0;      // initializze needs this variable
      x = null;
      y = null;
      theta = null;
      alpha = 0;
      umbral = 0;
  }
}