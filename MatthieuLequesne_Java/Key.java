import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;


public class Key {
	public int[] cle;
	public static int[] cle_max = new int[] {41,31,29,26,23,37,61,43,47,51,53,59};


	Key(String k){
		try{ 
			FileReader f = new FileReader("data/"+k+".cle"); 

			BufferedReader br = new BufferedReader(f);
			int[] t = new int[12];
			String s ;
			
			boolean b = true;
			
			for(int i = 0;i<12;i++){
				s = br.readLine();
				if (s==null || s=="") {b=false; throw new IOException();}
				else {
					t[i] = Integer.parseInt(s);
				}
			}
			
			br.close();
			
			for(int i = 0;i<12;i++){
				if(b){
					b = b && (t[i]>0) && (t[i]<=cle_max[i]);
				}
			}

			if(!b)
			{
				erreurCle("Une des positions de votre clé n'est pas dans le bon intervale !");
				cle = cle_max;
			}
			else
			{
				cle = t;						
			}

		
		
		
		}
		catch (FileNotFoundException e) {
		    erreurCle("Fichier clé non trouvé !");
		}
		catch (IOException e) {
		    erreurCle("La clé doit contenir douze nombres !");
		}
		catch (NumberFormatException e) {
			erreurCle("La clé ne doit contenir que des nombres !");
		}
		
	}
		
	static void erreurCle(String s){
		System.out.println();
		System.out.println("----- ERREUR DE CLE -----");		
		System.out.println("La clé doit être un fichier .cle dans le dossier /data.");
		System.out.println("Elle doit contenir 12 nombres (un par ligne) qui correspondent aux positions initiales des rotors, dans l'ordre suivant.");
		System.out.println("0 < chi1 <= 41");
		System.out.println("0 < chi2 <= 31");
		System.out.println("0 < chi3 <= 29");
		System.out.println("0 < chi4 <= 26");
		System.out.println("0 < chi5 <= 23");
		System.out.println("0 < mu1 <= 37");
		System.out.println("0 < mu2 <= 61");
		System.out.println("0 < psi1 <= 43");
		System.out.println("0 < psi2 <= 47");
		System.out.println("0 < psi3 <= 51");
		System.out.println("0 < psi4 <= 53");
		System.out.println("0 < psi5 <= 59");
		System.out.println();
		System.out.println("ATTENTION : " + s);
		System.out.println();
	}
}
