public class Baudot {

	private boolean[] valeur = new boolean[5];
	static String alphabet = "/E4A.SIU3DRJNFCKTZLWHYPQOBG+MXV-";

	
	public int getInt()
	{
		int n=0;
		for(int k=4;k>=0;k--)
		{
			n += n;
			if(valeur[k])
			{
				n += 1;
			}
		}
		return n;
	}
	
	public String getStringX()
	{
		String s = "";
		for(int k=0;k<5;k++)
		{
			if(valeur[k])
			{
				s+='x';
			}
			else
			{
				s+='.';
			}
		}
		return s;
	}
	
	public String getStringBin()
	{
		String s = "";
		for(int k=0;k<5;k++)
		{
			if(valeur[k])
			{
				s+='1';
			}
			else
			{
				s+='0';
			}
		}
		return s;
	}
	
	public boolean[] getBoolTab()
	{
		return valeur;
	}
	
	Baudot(boolean[] v) {
		if(v.length!=5)
		{
			System.out.println("Problème d'initialisation Baudot");
			boolean[] v2 = {false, false, false, false, false};
			valeur = v2;
		}
		else
		{
			valeur = v;
		}
	}
	
	Baudot(int n){
		if(n>31)
		{
			System.out.println("Attention ...");
		}
		for(int k=0;k<5;k++){
			valeur[k]=((n%2)==1);
			n = n/2;
		}
	}
	
	Baudot(String s){
		if(s.length()!=5)
		{
			System.out.println("Attention erreur d'initialisation");
			boolean[] v2 = {false, false, false, false, false};
			valeur = v2;
		}
		else
		{
			for(int k=0;k<5;k++)
			{
				if((s.charAt(k)=='1')||(s.charAt(k)=='x'))
				{
					valeur[k] = true;
				}
				else if((s.charAt(k)=='0')||(s.charAt(k)=='.'))
				{
					valeur[k] = false;
				}
				else
				{
					System.out.println("problème au caractère "+k);
					valeur[k] = false;
				}
			}
		}
	}
	
	Baudot(char c){
		int n = alphabet.indexOf(""+c);
		if(n>31)
		{
			System.out.println("Attention ...");
		}
		for(int k=0;k<5;k++){
			valeur[k]=((n%2)==1);
			n = n/2;
		}
	}
	
	public char getChar(){
		return alphabet.charAt(getInt());
	}
	
	public boolean get(int k) {
		if(0<=k && k<5)
		{
			return valeur[k];			
		}
		else
		{
			System.out.println("Indice du tableau != 5");
			return false;
		}
	}
	
	public Baudot add(Baudot b){
		boolean[] n = new boolean[5];
		for(int k=0;k<5;k++)
		{
			n[k] = this.get(k) ^ b.get(k);
		}
		Baudot r = new Baudot(n);
		return r;
	}
	
	public String boolTabToString(){
		String s = "[ ";
		for(int k=0;k<5;k++){
			if(valeur[k]){s+="true ; ";}
			else{s+="false ; ";}
		}
		s = s.substring(0, s.length() - 2) + "]";
		return s;
	}
	public void print(){
		System.out.println("int = "+this.getInt()+" ; bin = "+this.getStringBin() + " ; crossdots = "+ this.getStringX() + " ; boolTab = " + this.boolTabToString() + " ; char = " + this.getChar());
	}
}
