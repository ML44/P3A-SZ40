package Enigma;
import java.util.LinkedList;
import java.util.Queue;

public class Enigma {
	
	int taille;
	int compteur;
	String s0 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	String s1 = "EKMFLGDQVZNTOWYHXUSPAIBRCJ";
	String s2 = "AJDKSIRUXBLHWTMCQGZNPYFVOE";
	String s3 = "BDFHJLCPRTXVZNYEIWGAKMUSQO";
	String r = "EJMZALYXVBWFCRQUONTSPIKHGD";

	
	Tableau tab;
	Rotor r1;
	Rotor r2;
	Rotor r3;
	Rotor ref;
			
	Enigma(int i1, int i2, int i3, Couple c1, Couple c2, Couple c3){
		compteur = 0;
		taille = 26;
		Queue<Couple> q = new LinkedList<Couple>();
		q.add(c1);
		q.add(c2);
		q.add(c3);
		tab = new Tableau(26, q);
		r1 = new Rotor(26,s1,i1);
		r2 = new Rotor(26,s2,i2);
		r3 = new Rotor(26,s3,i3);
		ref = new Rotor(26,r,0);
	}
	
	private void increment()
	{
		compteur++;
		r1.increment();
		if(compteur%taille==0)
		{
			r2.increment();
		}
		if(compteur%(taille*taille)==0)
		{
			r3.increment();
		}
	}
	
	public String encodage(String s){
		int[] t = Encodage.string_to_tab(s);
		int[] t2 = t;
		for(int i=0;i<t.length;i++)
		{
				System.out.println("Compteur = " + compteur + " ; R1 = " + r1.position + " ; R2 = " + r2.position + " ; R3 = " + r3.position);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = tab.get(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = r1.get(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = r2.get(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = r3.get(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = ref.get(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = r3.get_rev(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = r2.get_rev(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = r1.get_rev(t2[i]);
				System.out.print(Encodage.int_to_char(t2[i]) + " -> ");
				t2[i] = tab.get(t2[i]);
				System.out.println(Encodage.int_to_char(t2[i]) + "");
				increment();
				System.out.println("Compteur = " + compteur + " ; R1 = " + r1.position + " ; R2 = " + r2.position + " ; R3 = " + r3.position);
				System.out.println("---");
		}
		return Encodage.tab_to_string(t2);
	}
	
	
}