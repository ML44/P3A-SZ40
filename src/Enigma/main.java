package Enigma;

public class main {

	public static void main(String[] args) {
				
		String s = "OJYUJML";
		Enigma e = new Enigma(0,0,0,new Couple('A','B'),new Couple('C','D'),new Couple('E','F'));
		System.out.println(e.encodage(s));
	}

}
