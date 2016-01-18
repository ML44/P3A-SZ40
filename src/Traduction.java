
public class Traduction {

	// carte reprise de https://github.com/TonyWhite/Baudot
	
    private String[][] map = new String[3][32];
    public void initialise(){
        map[0][0]  = "00000";     map[1][0]  = "{NULL}";    map[2][0]  = "{NULL}"; 
        map[0][1]  = "00001";     map[1][1]  = "E";         map[2][1]  = "3";
        map[0][2]  = "00010";     map[1][2]  = "{LF}";      map[2][2]  = "{LF}";  
        map[0][3]  = "00011";     map[1][3]  = "A";         map[2][3]  = "-";
        map[0][4]  = "00100";     map[1][4]  = " ";         map[2][4]  = " ";
        map[0][5]  = "00101";     map[1][5]  = "S";         map[2][5]  = "'";
        map[0][6]  = "00110";     map[1][6]  = "I";         map[2][6]  = "8";
        map[0][7]  = "00111";     map[1][7]  = "U";         map[2][7]  = "7";
        map[0][8]  = "01000";     map[1][8]  = "{CR}";      map[2][8]  = "{CR}";    
        map[0][9]  = "01001";     map[1][9]  = "D";         map[2][9]  = "{ENQ}";   
        map[0][10] = "01010";     map[1][10] = "R";         map[2][10] = "4";
        map[0][11] = "01011";     map[1][11] = "J";         map[2][11] = "{BELL}";  
        map[0][12] = "01100";     map[1][12] = "N";         map[2][12] = ",";
        map[0][13] = "01101";     map[1][13] = "F";         map[2][13] = "!";
        map[0][14] = "01110";     map[1][14] = "C";         map[2][14] = ":";
        map[0][15] = "01111";     map[1][15] = "K";         map[2][15] = "(";
        map[0][16] = "10000";     map[1][16] = "T";         map[2][16] = "5";
        map[0][17] = "10001";     map[1][17] = "Z";         map[2][17] = "+";
        map[0][18] = "10010";     map[1][18] = "L";         map[2][18] = ")";
        map[0][19] = "10011";     map[1][19] = "W";         map[2][19] = "2";
        map[0][20] = "10100";     map[1][20] = "H";         map[2][20] = "£";
        map[0][21] = "10101";     map[1][21] = "Y";         map[2][21] = "6";
        map[0][22] = "10110";     map[1][22] = "P";         map[2][22] = "0";
        map[0][23] = "10111";     map[1][23] = "Q";         map[2][23] = "1";
        map[0][24] = "11000";     map[1][24] = "O";         map[2][24] = "9";
        map[0][25] = "11001";     map[1][25] = "B";         map[2][25] = "?";
        map[0][26] = "11010";     map[1][26] = "G";         map[2][26] = "&";
        map[0][27] = "11011";     map[1][27] = "{FIGS}";    map[2][27] = "{FIGS}"; // Passer en caractères spéciaux
        map[0][28] = "11100";     map[1][28] = "M";         map[2][28] = ".";
        map[0][29] = "11101";     map[1][29] = "X";         map[2][29] = "/";
        map[0][30] = "11110";     map[1][30] = "V";         map[2][30] = ";";
        map[0][31] = "11111";     map[1][31] = "{LTRS}";    map[2][31] = "{LTRS}";    // Passer aux caractères alphabetiques
    }	
    
	
	public String baudotToLetter(Baudot b) {
		String s = "";
		for(int k=0;k<5;k++)
		{
			if(b.get(k))
			{
				s += '1';
			}
			else
			{
				s += '0';
			}
		}
		int n = 0;
		while(map[0][n]!=s)
		{
			n+=1;
		}
		return map[1][n];
	}
	
	public Baudot letterToBaudot(String s) {
		int n = 0;
		while(n<32 && map[1][n]!=s)
		{
			n+=1;
		}
		if (n==32)
		{
		}
		String s2 = map[0][n];
		boolean[] b = new boolean[5];
		for(int k=0;k<5;k++){
			if (s2.charAt(k)=='0')
			{
				b[k]=false;
			}
			else
			{
				b[k]=true;
			}
		}
		return new Baudot(b);		
	}
}
