package Enigma;

public class Couple {
   private int e1;
   private int e2;

   Couple(char c1, char c2)
   {
	   this.e1 = Encodage.char_to_int(c1);
	   this.e2 = Encodage.char_to_int(c2);
   }
   
   Couple(int i1, int i2) {
      this.e1 = i1;
      this.e2 = i2;
   }

   public int get1() {
      return this.e1;
   }

   public int get2() {
      return this.e2;
   }

}