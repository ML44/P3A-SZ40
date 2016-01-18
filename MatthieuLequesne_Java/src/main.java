

public class main {

	public static void main(String[] args) {
				
		String s = "iiiiiiiMYSUPPMIAIEEPMGMDiIUTFJVPJBVGQF>EDZSCL>FLJC<NJn>_BBDR_CHBnDrIZTZrG<AHC>PrBWHEIMFrQRUBT<CLSO<Q";
		Baudot b;
		String clair = "";
				
		Lorentz L = new Lorentz(36,27,2,1,23,12,10,4,22,12,17,20);
		System.out.println("Step \tInput \tOutput \tK1 \tK2 \tK3 \tK4 \tK5 \tM1 \tM2 \tS1 \tS2 \tS3 \tS4 \tS5 \tChi \tPsi \tM1 \tM2 \tTM");
		for(int i=0;i<s.length();i++)
		{
			b = new Baudot(s.charAt(i));
			clair += L.encrypt(b).getChar();
		}
		System.out.println();
		System.out.println(clair);
	}

}
