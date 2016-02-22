import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;


public class Cassage {

	public static void main(String[] args) throws IOException{
		//difference("cassage/fm_out", "cassage/fm2_out", "cassage/difference");
		//compare("cassage/difference","GENDARME"); 
		analyse("cassage/texte1", "cassage/difference", Integer.parseInt(args[0]), Integer.parseInt(args[1]));
	}

	
	public static void analyse(String text, String dif, int n, int k) throws IOException {
		FileInputStream t1 = new FileInputStream("data/"+text+".txt");
		FileInputStream diff = new FileInputStream("data/"+dif+".txt");
		
		String b1;
		String d;

		for(int j=0;j<k;j++)
		{
			
			b1 = "";
			d = "";
			while(b1.length()<n)
			{
				b1 += (char) (t1.read());
				d += (char) (diff.read());
			}


			System.out.print("T1-TXT : ");
			System.out.println(b1);
			System.out.print("T2-DIF : ");
			for(int i=0; i<n; i++){
				System.out.print(add(b1.charAt(i),d.charAt(i)));
			}
			System.out.println();
			System.out.println("----------");
		}
	}
	
	
	public static void compare(String diff, String mot) throws IOException {
		FileInputStream in = new FileInputStream("data/"+diff+".txt");
		int n = mot.length();
		String buffer = "";
		while(buffer.length()<n)
		{
			buffer += (char) (in.read());
		}
		
		int next;
		while((next = in.read())!=-1)
		{
			String resultat = "";
			for(int i=0;i<n;i++)
			{
				resultat += add(buffer.charAt(i),mot.charAt(i));
			}
			System.out.println(mot + " + " + buffer + " = " + resultat);
			
			buffer = buffer.substring(1) + (char) next;
		}

	}
	
	public static void difference(String file1, String file2, String outFile) throws IOException {
		FileInputStream f1 = new FileInputStream("data/"+file1+".txt");
		FileInputStream f2 = new FileInputStream("data/"+file2+".txt");
		FileOutputStream out = new FileOutputStream("data/"+outFile+".txt");
		int r1, r2;
		while (((r1 = f1.read()) != -1)&&((r2 = f2.read()) != -1)) {
		   char c1 = (char) r1;
		   char c2 = (char) r2;
		   char c = add(c1,c2);
		   //System.out.println(c1 + " - " + c2 + " = " + c);
		   out.write(c);
		}
		f1.close();
		f2.close();
		out.close();
	}
	
	static char add(char c1, char c2){
		boolean[] b1 =  (new Baudot(c1)).getBoolTab();
		boolean[] b2 =  (new Baudot(c2)).getBoolTab();
		boolean[] d = new boolean[5];
		for(int i=0;i<5;i++){
			d[i] = (b1[i])^(b2[i]);
		}

		Baudot b = new Baudot(d);
		return b.getChar();
	}
	
}
