import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;


public class test {

	public static void main(String[] args) throws IOException {
				
		
		// Lecture du fichier et de la clé
		String s = args[0];
		
		Normalisation.normalise(s);
		Lorentz L = new Lorentz("data/"+s+".cle");

		FileInputStream in = new FileInputStream("data/"+s+".norm");
		FileOutputStream out = new FileOutputStream("data/"+s+"_out.txt");

		File p = new File ("data/"+s+".process");
		FileWriter fw = new FileWriter (p);		
		fw.write("Step \tInput \tOutput\tK1 \tK2 \tK3 \tK4 \tK5 \tM1 \tM2 \tS1 \tS2 \tS3 \tS4 \tS5 \tChi \tPsi \tM1 \tM2 \tTM \n");
		Baudot b;
		int k=0;
		char c;
		while(k!=-1){
			k = in.read();
			c = (char) k;
			b = new Baudot(c);
			out.write(L.encrypt(b, fw).getChar());
		}
		
		in.close();
		out.close();
	    fw.close();

	}

}
