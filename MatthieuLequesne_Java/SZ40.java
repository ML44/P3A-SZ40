import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;


public class SZ40 {

	public static void main(String[] args) throws IOException {

		// Lecture du fichier et de la clé
		if(args.length==0)
		{
			erreurEntree();
		}
		else
		{
			
		String todo = (String) args[0];
		
		

		if(todo.contains("encrypt") && args.length == 3)
		{
			String file = args[1];
			String key = args[2];
			Traduction.normalisation(file);
			Traduction.traduction(file);

			Lorentz L = new Lorentz(new Key(key));

			FileInputStream in = new FileInputStream("data/"+file+".trad");
			FileOutputStream out = new FileOutputStream("data/"+file+"_chiffre.txt");

			File p = new File ("data/"+file+".process");
			FileWriter fw = new FileWriter (p);
			fw.write("Step \tInput \tOutput\tK1 \tK2 \tK3 \tK4 \tK5 \tM1 \tM2 \tS1 \tS2 \tS3 \tS4 \tS5 \tChi \tPsi \tM1 \tM2 \tTM \n");
			Baudot b;
			int k=in.read();
			char c;
			while(k!=-1){
				c = (char) k;
				b = new Baudot(c);
				out.write(L.encrypt(b, fw).getChar());
				k = in.read();
			}

			in.close();
			out.close();
		  fw.close();
		}
		else if (todo.contains("decrypt") && args.length==3)
		{
			String file = args[1];
			String key = args[2];
			Lorentz L = new Lorentz(new Key(key));

			FileInputStream in = new FileInputStream("data/"+file+".txt");
			FileOutputStream out = new FileOutputStream("data/"+file+".tmp");

			File p = new File ("data/"+file+".process");
			FileWriter fw = new FileWriter (p);
			fw.write("Step \tInput \tOutput\tK1 \tK2 \tK3 \tK4 \tK5 \tM1 \tM2 \tS1 \tS2 \tS3 \tS4 \tS5 \tChi \tPsi \tM1 \tM2 \tTM \n");
			Baudot b;
			int k=in.read();
			char c;
			while(k!=-1){
				c = (char) k;
				b = new Baudot(c);
				out.write(L.encrypt(b, fw).getChar());
				k = in.read();
			}

			in.close();
			out.close();
		  fw.close();

		  Traduction.retrotraduction(file);
		}
		else if (todo.contains("keygen") && args.length==2)
		{
			String k = args[1];
			File p = new File ("data/"+k+".cle");
			FileWriter fw = new FileWriter (p);
			int n = 0;
			for(int i=0;i<12;i++)
			{
				n = 1 + (int)(Math.random() * Key.cle_max[i]); 
				fw.write(n+"\n");
			}
			fw.close();
			
		}
		else
		{
			erreurEntree();
		}

		}

	}

	public static void erreurEntree(){
		System.out.println();
		System.out.println("----- ERREUR D'ENTREE -----");
		System.out.println();
		System.out.println("Si vous souhaitez générer une clé :");
		System.out.println("Vous devez appeler le programme avec 2 arguments :");
		System.out.println("1 : \"keygen\"");
		System.out.println("2 : le nom que vous souhaitez donner à la clé");		
		System.out.println("EXEMPLE : \"keygen my_key\" génère une clé dans le fichier data/my_key.cle");
		System.out.println();
		System.out.println("Si vous souhaitez chiffrer un fichier avec un clé :");
		System.out.println("Vous devez appeler votre programme avec 3 arguments :");
		System.out.println("1 : \"encrypt\"");
		System.out.println("2 : le nom du fichier à chiffrer");
		System.out.println("3 : le nom de la clé");
		System.out.println("EXEMPLE : \"encrypt my_text my_key\" permet de chiffrer data/my_text.txt avec la clé data/my_key.cle.");
		System.out.println("Le fichier chiffré se trouve dans le fichier data/my_text_chiffre.txt.");
		System.out.println();
		System.out.println("Si vous souhaitez déchiffrer un fichier avec un clé :");
		System.out.println("Vous devez appeler votre programme avec 3 arguments :");
		System.out.println("1 : \"decrypt\"");
		System.out.println("2 : le nom du fichier à déchiffrer");
		System.out.println("3 : le nom de la clé");
		System.out.println("EXEMPLE : \"decrypt my_text my_key\" permet de déchiffrer data/my_text.txt avec la clé data/my_key.cle.");
		System.out.println("Le fichier déchiffré se trouve dans le fichier data/my_text_dechiffre.txt.");
		System.out.println();
	}

}
