import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;


public class test {

	public static void main(String[] args) throws IOException {
		
		int n = 2;
		
		// Lecture du fichier chiffré et de la clé
		String chiffre = new String(Files.readAllBytes(Paths.get("data/challenge"+n+".txt")));
		Lorentz L = new Lorentz("data/key"+n+".txt");

		String clair = "";
		Baudot b;
		File p = new File ("data/process"+n+".txt");
		FileWriter fwp = new FileWriter (p);		
		fwp.write("Step \tInput \tOutput \tK1 \tK2 \tK3 \tK4 \tK5 \tM1 \tM2 \tS1 \tS2 \tS3 \tS4 \tS5 \tChi \tPsi \tM1 \tM2 \tTM \n");

		for(int i=0;i<chiffre.length();i++)
		{
			b = new Baudot(chiffre.charAt(i));
			clair += L.encrypt(b, fwp).getChar();
		}
		
		File f = new File ("data/clair"+n+".txt");
		FileWriter fw = new FileWriter (f);
		fw.write (clair);
	    fw.close();
	    fwp.close();

	}

}
