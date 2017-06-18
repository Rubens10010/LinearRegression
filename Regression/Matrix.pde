class Matrix{    // Definition of static matrix
  int rows;
  int cols;
  
  float[][] m;
  
  Matrix(int a, int b){
     rows = a;
     cols = b;
     m = new float[a][b];
  }
  
  float[] getRow(int a)
  {
    return m[a];
  }
  
  float[] getCol(int b)
  {
    float[] r = new float[rows];
    
    for(int i = 0; i < rows; i++)
    {
       r[i] = m[i][b];
    }
    
    return r;
  }
  
  float getValue(int x, int y)
  {
     return m[x][y]; 
  }
  
  void setValue(int x, int y, float v)
  {
      m[x][y] = v;
  }
}

float dot_product(float[] a, float[] b, int s)
{
   float answ = 0;
   for(int i = 0; i < s; i++)
   {
     answ += a[i]*b[i];
   }
   return answ;
}