import java.text.Normalizer;
import java.io.*;

public class Traduction {
	static String baudot = "/9HTOMN3RCVGLPI4AUQW+-KJDFXBZYSE";
	static String alpha =  "i HTOMNrRCVGLPInAUQWiiKJDFXBZYSE";
	static String num =    "i £59.,r4:=@)08n-712ii(ii%/?+6'3";

	static void normalisation(String file) throws IOException{

	// 1e étape : lecture ligne par ligne pour enlever les accents

		BufferedReader in = new BufferedReader(new FileReader("data/"+file+".txt"));
		PrintWriter out =  new PrintWriter(new BufferedWriter (new FileWriter("data/"+file+".norm")));

		String line;

		while(in.ready())
		{
			line = in.readLine();
		    line = Normalizer.normalize(line, Normalizer.Form.NFD);
		    line = line.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
		    line = line.replaceAll(" !", ".");
		    line = line.replaceAll(" ;", ",");
		    out.write(line.toUpperCase());
		    if(in.ready()){out.write("\n");}
		}
		in.close();
		out.close();
	}

	// 2e étape : lecture caractère par caractère pour mettre en majuscule et enlever la ponctuation sauf les espaces

	static void traduction(String file) throws IOException{
		int k=0;
		char c;
		FileInputStream in = new FileInputStream("data/"+file+".norm");
		FileOutputStream out = new FileOutputStream("data/"+file+".trad");
		boolean shift = false;

		while(k!=-1){
			k = in.read();
			if(k==10) {c = 'n';}
			else{c = (char) k;}
			if(alpha.contains(c+""))
			{
				if(shift)
				{
					out.write((int) '-');
					out.write((int) '-');
					shift=false;
				}
				out.write(baudot.charAt(alpha.indexOf(c+"")));
			}
			else if(num.contains(c+""))
			{
				if(!shift)
				{
					out.write((int) '+');
					out.write((int) '+');
					shift=true;
				}
				out.write(baudot.charAt(num.indexOf(c+"")));
			}
		}

		in.close();
		out.close();

	// supprimer le fichier .norm
	//	new File ("data/"+file+".norm").delete();
	}

	static void retrotraduction(String file) throws IOException{
		int k=0;
		char c;
		FileInputStream in = new FileInputStream("data/"+file+".tmp");
		FileOutputStream out = new FileOutputStream("data/"+file+"_dechiffre.txt");
		boolean shift = false;

		while(k!=-1){
			k = in.read();
			c = (char) k;
			if(baudot.contains(c+""))
			{
				if		(c == '+')	{shift = true;}
				else if	(c == '-')	{shift = false;}
				else if	(c == '4')	{out.write('\n');}
				else if	(c == '3')	{out.write('\r');}
				else if	(c == '9')	{out.write(' ');}
				else if	(shift)		{out.write(num.charAt(baudot.indexOf(c+"")));}
				else 				{out.write(alpha.charAt(baudot.indexOf(c+"")));}
			}
		}

		in.close();
		out.close();

	// supprimer le fichier .tmp
	//	new File ("data/"+file+".tmp").delete();
	}

}
