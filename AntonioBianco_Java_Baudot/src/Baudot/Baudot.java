/**
 * Questa è la classe con cui parte il progetto
 * 
 * @author Bianco Antonio
 * @version 1.2
 */
import javax.swing.UIManager;
import javax.swing.UIManager.LookAndFeelInfo;

public class Baudot
{
    public static void main(String[] args)
    {
        try
        {
            for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels())
            {
                if ("Nimbus".equals(info.getName()))
                {
                    UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        }
        catch (Exception e)
        {
        }
        
        System.out.println("Baudot 1.2\nProgramma creato da: Antonio Bianco \nLicenza: GNU/GPL");
        GUI gui = new GUI();
    }
}