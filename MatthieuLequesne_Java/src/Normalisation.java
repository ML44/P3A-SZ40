import java.text.Normalizer;
import java.io.*;

public class Normalisation {

	static void normalise(String s) throws IOException{
		
	// 1e étape : lecture ligne par ligne pour enlever les accents
		
		BufferedReader in = new BufferedReader(new FileReader("data/"+s+".txt"));
		PrintWriter out =  new PrintWriter(new BufferedWriter (new FileWriter("data/"+s+".tmp")));
		
		String line;
		
		while(in.ready())	
		{
			line = in.readLine();
		    line = Normalizer.normalize(line, Normalizer.Form.NFD);
		    line = line.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
		    out.write(line);
		}
		
		in.close();
		out.close();
		
	// 2e étape : lecture caractère par caractère pour mettre en majuscule et enlever la ponctuation sauf les espaces

		int k=0;
		char c;
		FileInputStream in2 = new FileInputStream("data/"+s+".tmp");
		FileOutputStream out2 = new FileOutputStream("data/"+s+".norm");

		while(k!=-1){
			k = in2.read();
			if(k>='a'&&k<='z'){k = (k+'A'-'a');}
			c = (char) k;
			if(c == ' '){c = '/';}
			if(Baudot.alphabet.contains(c+""))
			{
				out2.write(c);
			}
		}

		in2.close();
		out2.close();
		
	// supprimer le fichier .tmp
		new File ("data/"+s+".tmp").delete();
	}
}
