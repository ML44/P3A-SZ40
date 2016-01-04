package Enigma;
import java.util.Queue;


public class Tableau {

	private int[] alphabet;
		
	public int taille;
	
	private void swap(int a, int b){
		a = (a % taille);
		b = (b % taille);
		int t = alphabet[a];
		alphabet[a] = alphabet[b];
		alphabet[b] = t;
	}
	
	private void swap(Couple c){
		swap(c.get1(),c.get2());
	}
	
	public int get(int n){ // encodage de [0,taille[ dans [0,taille[
		int m = alphabet[((n+taille) % taille)];
		return m % taille;
	}
	
	Tableau(int size) {
		taille = size;
		alphabet = new int[taille];
		for(int i=0;i<taille;i++)
		{
			alphabet[i] = i;
		}
	}
	
	Tableau(int size, Queue<Couple> l) {
		taille = size;
		alphabet = new int[taille];
		for(int i=0;i<taille;i++)
		{
			alphabet[i] = i;
		}
		while(!l.isEmpty())
		{
			Couple c = l.poll();
			swap(c);
		}
	}
	
}
