class Modulo {
  float tiempo; 
  boolean [] relee= new boolean[8];
  
  // Constructor
  Modulo(float t) {
    tiempo = t;
    for (int a=0;a<8;a++)
     {relee[a]=false;}
    }


  void leer(String[] pieces) {
    tiempo = float(pieces[0]);
   for (int a=0;a<8;a++)
    relee[a] = boolean(pieces[a+1]);
   }
   
  void set_relee(int n) { 
   relee[n]=true;
 }
   void des_relee(int n) { 
   relee[n]=false;
 }
  
  
  boolean relee(int a) { 
   return relee[a];
 }
 
 float time(){
 return tiempo;
 }
  void borrar(){
    for (int a=0;a<8;a++)
     {relee[a]=false;}
   
   }
 
 }