package Enigma;

public class Rotor {

	private int[] alphabet;
	private int[] alphabet_reverse;
	
	public int position;
	
	public int taille;
	
	public void increment() { // incrémentation
		position = ((position + 1) % taille);
	};
	
	public int get(int n){ // encodage de [0,taille[ dans [0,taille[
		int m = alphabet[(n % taille)];
		return (m + position) % taille;
	}
	
	public int get_rev(int n){
		int m = alphabet_reverse[((n-position+taille) % taille)];
		return m;	}
	
	
	public static boolean is_rotor(int[] t){ // verifie qu'on a bien une bijection
		int l = t.length;
		boolean[] test = new boolean[l];
		for(int i=0;i<l;i++)
		{
			test[i]=false;
		}
		for(int i=0;i<l;i++){
			test[t[i]]=true;
		}
		boolean b = true;
		for(int i=0;i<l;i++){
			b = b&&test[i];
		}
		return b;
	}

	Rotor(int size, String s, int p){
		int[] t = Encodage.string_to_tab(s);
		if(t.length == size &&is_rotor(t))
		{
			taille = t.length;
			position = (p%taille);
			alphabet = t;
			alphabet_reverse = new int[taille];
			for(int i=0;i<taille;i++)
			{
				alphabet_reverse[alphabet[i]] = i;
			}
		}
		else
		{
			System.out.println(s + "n'est pas une bijection !");
		}
	}

}
