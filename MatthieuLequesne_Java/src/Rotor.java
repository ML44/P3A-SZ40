
public class Rotor {
	private int length;
	private int position;
	private boolean[] value;
	
	Rotor(int p, boolean[] v)
	{
		length = v.length;
		value = v;
		position = (p-1) % length;
	}

	Rotor(int p, String s)
	{
		boolean[] v = convert(s);
		length = v.length;
		value = v;
		position = (p-1) % length;
	}

	boolean[] convert(String s)
	{
		boolean[] b = new boolean[s.length()];
		for(int k=0;k<s.length();k++)
		{
			b[k]=(s.charAt(k)=='x');
		}
		return b;
	}
	
	public boolean getValue(){
		return value[position];
	}
	
	public char printValue(){
		if(value[position]) 
			return '1'; 
		else 
			return '0';
	}
	
	public int getPosition(){
		return position+1;
	}
	
	public void increment(){
		position = (position+1)%length;
	}
}
