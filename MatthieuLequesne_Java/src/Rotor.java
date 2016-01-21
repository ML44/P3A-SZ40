
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
		
		boolean[] v = new boolean[s.length()];
		for(int k=0;k<s.length();k++)
		{
			v[k]=(s.charAt(k)=='x');
		}
				length = v.length;
		value = v;
		position = (p-1) % length;
	}
	
	public boolean getValue(){
		return value[position];
	}

	public boolean getPreviousValue(){
		return value[(position-1)%length];
	}
	
	public char printValue(){
		if(value[position]) 
			return 'x'; 
		else 
			return '.';
	}
	
	public int getPosition(){
		return position+1;
	}
	
	public void increment(){
		position = (position+1)%length;
	}
}
