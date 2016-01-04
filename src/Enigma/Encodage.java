package Enigma;

public class Encodage {

	public static int char_to_int (char c){
		return ((int) c) - 65;
	}
	
	public static char int_to_char (int n){
		return  (char) ('A' + n);
	}
	
	public static int[] string_to_tab (String s){
		s = s.toUpperCase();
		String s2 = "";
		for(int i=0;i<s.length();i++)
		{
			if(s.charAt(i)>= (int) 'A' && s.charAt(i)<= (int) 'Z')
			{
				s2 = s2 + s.charAt(i);
			}
		}
		
		
		int l = s2.length();
		int[] t = new int[l];
		for(int i=0;i<l;i++){
			t[i] = char_to_int(s2.charAt(i));
		}
		return t;
	}
	
	public static String tab_to_string (int[] t){
		int l = t.length;
		String s = "";
		for(int i=0;i<l;i++){
			s = s + int_to_char(t[i]);
		}
		return s;
	}

}
