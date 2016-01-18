/**
 * Questa è la GUI principale
 * 
 * @author Bianco Antonio
 * @version 1.2
 */
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class GUI extends JFrame implements ActionListener, FocusListener, WindowListener
{
    private JTextArea txtTesto = new JTextArea("", 10, 50);
    private JTextArea txtCodice = new JTextArea("", 10, 50);
    private JButton btnCodifica = new JButton("Codifica");
    private JButton btnDecodifica = new JButton("Decodifica");
    private JButton btnEsci = new JButton("Esci");
    
    private CodificaBaudot baudot = new CodificaBaudot();
    
    public GUI()
    {
        super("Codice Baudot");
        System.out.print("Costruisco la finestra...");
        JPanel pnlPrincipale = new JPanel(new BorderLayout());
        // Inserisci le aree di testo
        JPanel pnlAreeTesto = new JPanel(new GridLayout(2, 1));
        
        // Area di testo normale
        JPanel pnlAreaTestoNormale = new JPanel(new BorderLayout());
        pnlAreaTestoNormale.add(new JLabel("Testo normale:"), "North");
        txtTesto.setLineWrap(true);
        txtTesto.setWrapStyleWord(true);
        txtTesto.addFocusListener(this);
        pnlAreaTestoNormale.add(new JScrollPane(txtTesto), "Center");
        
        // Area di testo Baudot
        JPanel pnlAreaTestoBaudot = new JPanel(new BorderLayout());
        pnlAreaTestoBaudot.add(new JLabel("Testo baudot:"), "North");
        txtCodice.setLineWrap(true);
        txtCodice.setWrapStyleWord(true);
        txtCodice.addFocusListener(this);
        pnlAreaTestoBaudot.add(new JScrollPane(txtCodice), "Center");
        
        pnlAreeTesto.add(pnlAreaTestoNormale);
        pnlAreeTesto.add(pnlAreaTestoBaudot);
        pnlPrincipale.add(pnlAreeTesto, "Center");
        
        // Inserisci i bottoni
        JPanel pnlBottoni = new JPanel(new BorderLayout());
        JPanel pnlBtnSinistra = new JPanel(new GridLayout(1, 2));
        
        // Bottone codifica
        JPanel pnlBtnCodifica = new JPanel();
        btnCodifica.addActionListener(this);
        pnlBtnCodifica.add(btnCodifica);
        
        // Bottone decodifica
        JPanel pnlBtnDecodifica = new JPanel();
        btnDecodifica.addActionListener(this);
        pnlBtnDecodifica.add(btnDecodifica);
        
        // Bottone esci
        JPanel pnlBtnEsci = new JPanel();
        btnEsci.addActionListener(this);
        pnlBtnEsci.add(btnEsci);
        
        pnlBtnSinistra.add(pnlBtnCodifica);
        pnlBtnSinistra.add(pnlBtnDecodifica);
        pnlBottoni.add(pnlBtnSinistra, "West");
        pnlBottoni.add(pnlBtnEsci, "East");
        
        pnlPrincipale.add(pnlBottoni, "South");
        add(pnlPrincipale);
        addWindowListener(this);
        pack();
        System.out.println("OK");
        Dimension dimensioniSchermo = Toolkit.getDefaultToolkit().getScreenSize();  // Legge le dimensioni dello schermo
        setLocation((dimensioniSchermo.width - getWidth()) / 2, (dimensioniSchermo.height - getHeight()) / 2);
        setVisible(true);
    }
    
    public void actionPerformed(ActionEvent ae)
    {
        if (ae.getSource().equals(btnCodifica))
        {
            txtCodice.setText(baudot.codifica(txtTesto.getText()));
        }
        else if (ae.getSource().equals(btnDecodifica))
        {
            txtTesto.setText(baudot.decodifica(txtCodice.getText()));
        }
        else if (ae.getSource().equals(btnEsci))
        {
            System.exit(0);
        }
        else
        {
            System.out.println("Ascoltatore dei bottoni: un oggetto non identificato è impostato su questo evento");
        }
    }
    
    public void focusGained(FocusEvent e)
    {
        if (txtTesto.hasFocus())
        {
            txtTesto.selectAll();
        }
        else if (txtCodice.hasFocus())
        {
            txtCodice.selectAll();
        }
        else
        {
            System.out.println("Ascoltatore delle selezioni: un oggetto non identificato è impostato su questo evento");
        }
    }
    
    public void focusLost(FocusEvent e){}
    
    public void windowActivated(WindowEvent e){}
    
    public void windowClosed(WindowEvent e){}
    public void windowClosing(WindowEvent e) { System.exit(0); }
    public void windowDeactivated(WindowEvent e){}

    public void windowDeiconified(WindowEvent e){}
    public void windowIconified(WindowEvent e){}
    public void windowOpened(WindowEvent e){}
}