
public class Lorentz {
	
	Rotor chi1, chi2, chi3, chi4, chi5, mu1, mu2, psi1, psi2, psi3, psi4, psi5;
	boolean BM;
	boolean old_chi2 = true;
	boolean L;
	boolean TM;
	int step = 0;
	
	Lorentz(int c1, int c2, int c3, int c4, int c5, int m1, int m2, int p1, int p2, int p3, int p4, int p5)
	{
		chi1 = new Rotor(c1, "...xxxx....xx....x.xx..x..xx.x.xx.x.xxxx.");
		chi2 = new Rotor(c2, "xx..xxx.xx...x.x.xx...x....xxx.");
		chi3 = new Rotor(c3,"..xxx.xx..x....xxx..xx.xx..xx");
		chi4 = new Rotor(c4,"..xx..x.xx..x..xx..x..xxxx");
		chi5 = new Rotor(c5,".x...x.xx..x...xxx.xxx.");
		
		mu1 = new Rotor(m1,"xxxx.x.xx..xx..xx...xxxx.x.xx.xx...xx....xxxx.xx..xx...xx....");
		mu2 = new Rotor(m2,"x.xxx.x.x.x.x..x.x.xxx.x.x.x.x.x.x.x.");
		
		psi1 = new Rotor(p1,"..x.x.x.x.x..x..x.xx.xx.x.x..xx.xxx..xxx...");
		psi2 = new Rotor(p2,"..x.xx.x.x.x.x.x.xx..xx.x..x.xxxx.....xxx..x.xx");
		psi3 = new Rotor(p3,"x.x.x.x.x.x.x..x..xx.x.x.xxxx....xxx...xxx.xx..x..x");
		psi4 = new Rotor(p4,"x.x..xx.x.x.x.x.x.xx.x....xx..xx..xx.xxxxx.x..x....x.");
		psi5 = new Rotor(p5,".x.x.x.x.xx...x.x..xxx.xxxx.xx.x....x...x..xx.xx..xx..x.x.x");
	}
	
	private Baudot chi(){
		boolean[] v = new boolean[5];
		v[0] = chi1.getValue();
		v[1] = chi2.getValue();
		v[2] = chi3.getValue();
		v[3] = chi4.getValue();
		v[4] = chi5.getValue();
		return new Baudot(v);
	}
	
	private Baudot psi(){
		boolean[] v = new boolean[5];
		v[0] = psi1.getValue();
		v[1] = psi2.getValue();
		v[2] = psi3.getValue();
		v[3] = psi4.getValue();
		v[4] = psi5.getValue();
		return new Baudot(v);
	}
	
	public Baudot encrypt(Baudot b){
		Baudot chi = this.chi();
		Baudot psi = this.psi();
		Baudot chiffre = b.add(chi.add(psi));
		BM = mu2.getValue();
		L = old_chi2 ; // Definition may change
		old_chi2 = chi2.getValue(); 
		TM = (BM||(!L)); 
		chi1.increment();
		chi2.increment();
		chi3.increment();
		chi4.increment();
		chi5.increment();
		if(mu1.getValue())
		{
			mu2.increment();
		}
		mu1.increment();
		if(TM)
		{
			psi1.increment();
			psi2.increment();
			psi3.increment();
			psi4.increment();
			psi5.increment();
		}
		// ajouter les MAJ de M2 et TM
		step+=1;
		this.printState(b, chiffre, chi, psi);
		return chiffre;
	}
	
	private char printBool(boolean b)
	{
		if(b) return 'x'; else return '.';
	}
	
	public void printState(Baudot b_old, Baudot b_new, Baudot c, Baudot p){
		System.out.println(
				step + " : \t"+
				b_old.getChar() + " " + b_old.getStringX() + "\t" +
				b_new.getChar() + " " + b_new.getStringX() + "\t" +
				chi1.getPosition() + "\t" +
				chi2.getPosition() + "\t" +
				chi3.getPosition() + "\t" +
				chi4.getPosition() + "\t" +
				chi5.getPosition() + "\t" +
				mu1.getPosition() + "\t" +
				mu2.getPosition() + "\t" +
				psi1.getPosition() + "\t" +
				psi2.getPosition() + "\t" +
				psi3.getPosition() + "\t" +
				psi4.getPosition() + "\t" +
				psi5.getPosition() + "\t" +
				c.getStringX() + "\t" +
				p.getStringX() + "\t" +
				this.printBool(BM) + "\t" +
				this.printBool(TM)
				);
	}
}
