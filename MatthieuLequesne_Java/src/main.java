import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;



public class main {

	public static void main(String[] args) throws IOException {
		
		int n = 3;
		
		String chiffre = new String(Files.readAllBytes(Paths.get("data/challenge"+n+".txt")));
		String clair = "";
		Baudot b;
						
		Lorentz L = new Lorentz("data/key"+n+".txt");
		System.out.println("Step \tInput \tOutput \tK1 \tK2 \tK3 \tK4 \tK5 \tM1 \tM2 \tS1 \tS2 \tS3 \tS4 \tS5 \tChi \tPsi \tM1 \tM2 \tTM");

		for(int i=0;i<chiffre.length();i++)
		{
			b = new Baudot(chiffre.charAt(i));
			clair += L.encrypt(b).getChar();
		}
		
		File f = new File ("data/clair"+n+".txt");
		FileWriter fw = new FileWriter (f);
		fw.write (clair);
	    fw.close();

	}

}
