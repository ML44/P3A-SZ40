/**
 * Questa classe codifica e decodifica il Baudot
 * 
 * @author Bianco Antonio
 * @version 1.2
 */
public class CodificaBaudot
{
    private String[][] mappa = new String[3][32];
    private boolean errore = false; // true se l'ultima codifica/decodifica contiene errori
    
    public CodificaBaudot()
    {
        // codice binario           caratteri alfabetici        caratteri speciali          caratteri funzione
        mappa[0][0]  = "00000";     mappa[1][0]  = "{NULL}";    mappa[2][0]  = "{NULL}";    // Carattere nullo
        mappa[0][1]  = "00001";     mappa[1][1]  = "E";         mappa[2][1]  = "3";
        mappa[0][2]  = "00010";     mappa[1][2]  = "{LF}";      mappa[2][2]  = "{LF}";      // Avanzamento di una linea
        mappa[0][3]  = "00011";     mappa[1][3]  = "A";         mappa[2][3]  = "-";
        mappa[0][4]  = "00100";     mappa[1][4]  = " ";         mappa[2][4]  = " ";
        mappa[0][5]  = "00101";     mappa[1][5]  = "S";         mappa[2][5]  = "'";
        mappa[0][6]  = "00110";     mappa[1][6]  = "I";         mappa[2][6]  = "8";
        mappa[0][7]  = "00111";     mappa[1][7]  = "U";         mappa[2][7]  = "7";
        mappa[0][8]  = "01000";     mappa[1][8]  = "{CR}";      mappa[2][8]  = "{CR}";      // Sposta il cursore a inizio riga
        mappa[0][9]  = "01001";     mappa[1][9]  = "D";         mappa[2][9]  = "{ENQ}";     // Richiesta di identificazione
        mappa[0][10] = "01010";     mappa[1][10] = "R";         mappa[2][10] = "4";
        mappa[0][11] = "01011";     mappa[1][11] = "J";         mappa[2][11] = "{BELL}";    // Suona un campanello per avvisare l'operatore
        mappa[0][12] = "01100";     mappa[1][12] = "N";         mappa[2][12] = ",";
        mappa[0][13] = "01101";     mappa[1][13] = "F";         mappa[2][13] = "!";
        mappa[0][14] = "01110";     mappa[1][14] = "C";         mappa[2][14] = ":";
        mappa[0][15] = "01111";     mappa[1][15] = "K";         mappa[2][15] = "(";
        mappa[0][16] = "10000";     mappa[1][16] = "T";         mappa[2][16] = "5";
        mappa[0][17] = "10001";     mappa[1][17] = "Z";         mappa[2][17] = "+";
        mappa[0][18] = "10010";     mappa[1][18] = "L";         mappa[2][18] = ")";
        mappa[0][19] = "10011";     mappa[1][19] = "W";         mappa[2][19] = "2";
        mappa[0][20] = "10100";     mappa[1][20] = "H";         mappa[2][20] = "£";
        mappa[0][21] = "10101";     mappa[1][21] = "Y";         mappa[2][21] = "6";
        mappa[0][22] = "10110";     mappa[1][22] = "P";         mappa[2][22] = "0";
        mappa[0][23] = "10111";     mappa[1][23] = "Q";         mappa[2][23] = "1";
        mappa[0][24] = "11000";     mappa[1][24] = "O";         mappa[2][24] = "9";
        mappa[0][25] = "11001";     mappa[1][25] = "B";         mappa[2][25] = "?";
        mappa[0][26] = "11010";     mappa[1][26] = "G";         mappa[2][26] = "&";
        mappa[0][27] = "11011";     mappa[1][27] = "{FIGS}";    mappa[2][27] = "{FIGS}";    // Passa ai caratteri speciali
        mappa[0][28] = "11100";     mappa[1][28] = "M";         mappa[2][28] = ".";
        mappa[0][29] = "11101";     mappa[1][29] = "X";         mappa[2][29] = "/";
        mappa[0][30] = "11110";     mappa[1][30] = "V";         mappa[2][30] = ";";
        mappa[0][31] = "11111";     mappa[1][31] = "{LTRS}";    mappa[2][31] = "{LTRS}";    // Passa ai caratteri alfabetici
    }
    
    /**
     * Codifica la stringa in baudot
     */
    public String codifica(String testo)
    {
        errore = false;
        testo = testo.toUpperCase();    // Rendiamo il testo maiuscolo
        String risultatoBinario = "";
        
        if (testo.length() > 0)
        {
            boolean codAlfabeto;    // Mantiene il valore true se si stanno codificando caratteri alfabetici
            /**
             * Controlla con che carattere inizia la stringa da convertire.
             * Si invertono i risultati di codAlfabeto dichiarando il contrario, perchè
             * il primo carattere ad essere processato dichiari una diversa codifica e quindi
             * si avrà come primo dato binario l'informazione necessaria per la decodifica
             */
            if (èCarattereAlfabetico(testo.substring(0, 1)))
            {
                codAlfabeto = false;
            }
            else
            {
                codAlfabeto = true;
            }
            
            for (int i = 0; i < testo.length(); i++)
            {
                // Legge il primo carattere per sapere se è alfabetico, speciale o funzione
                String carattere = testo.substring(i, i + 1);
                
                // Codifica il primo carattere e inizializza la variabile codAlfabeto
                if (èCarattereAlfabetico(carattere))
                {
                    if (!codAlfabeto)
                    {
                        codAlfabeto = true;
                        risultatoBinario = risultatoBinario + mappa[0][31] + " ";
                    }
                    risultatoBinario = risultatoBinario + getBinario(carattere) + " ";
                }
                else if (èCarattereSpeciale(carattere))
                {
                    if (codAlfabeto)
                    {
                        codAlfabeto = false;
                        risultatoBinario = risultatoBinario + mappa[0][27] + " ";
                    }
                    risultatoBinario = risultatoBinario + getBinario(carattere) + " ";
                }
                else
                {
                    try
                    {
                        String probENQ = testo.substring(i, i + 5);
                        if (probENQ.equals("{ENQ}"))
                        {
                            if (codAlfabeto)
                            {
                                codAlfabeto = false;
                                risultatoBinario = risultatoBinario + mappa[0][27] + " ";
                            }
                            risultatoBinario = risultatoBinario + mappa[0][9] + " ";
                            i += 4;
                        }
                        else
                        {
                            String probBELL = testo.substring(i, i + 6);
                            if (probBELL.equals("{BELL}"))
                            {
                                if (codAlfabeto)
                                {
                                    codAlfabeto = false;
                                    risultatoBinario = risultatoBinario + mappa[0][27] + " ";
                                }
                                risultatoBinario = risultatoBinario + mappa[0][11] + " ";
                                i += 5;
                            }
                            else
                            {
                                String probAccapo = testo.substring(i, i + 8);
                                if (probAccapo.equals("{CR}{LF}"))
                                {
                                    if (codAlfabeto)
                                    {
                                        codAlfabeto = false;
                                        risultatoBinario = risultatoBinario + mappa[0][27] + " ";
                                    }
                                    risultatoBinario = risultatoBinario + mappa[0][8] + " " + mappa[0][2] + " ";
                                }
                                else
                                {
                                    errore = true;
                                    System.out.println("Il carattere " + carattere + " non è presente nel codice Baudot");
                                }   
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        errore = true;
                        System.out.println("Errore: " + e.getMessage());
                    }
                }
            }
        }
        else
        {
            // Non esiste alcun dato da convertire
        }
        return risultatoBinario;
    }
    
    
    /**
     * Decodifica la stringa in baudot
     */
    public String decodifica(String binario)
    {
        errore = false;
        String risultatoTesto = "";
        
        if (binario.length() > 4)
        {
            //           binario = codice alfabetico                    binario = codice speciale
            //  (binario.substring(0,5).equals(mappa[0][31]))  (binario.substring(0,5).equals(mappa[0][27]))
            if ((binario.substring(0,5).equals(mappa[0][31]))||(binario.substring(0,5).equals(mappa[0][27])))
            {
                boolean codAlfabetico;
                if (binario.substring(0, 5).equals(mappa[0][31]))
                {
                    // È un codice alfabetico
                    codAlfabetico = true;
                }
                else
                {
                    // È un codice speciale
                    codAlfabetico = false;
                }
                for (int i = 0; i < binario.length(); i += 6)
                {
                    // Legge 5 bit ogni ciclo
                    String codice = binario.substring(i, i + 5);
                    String risultato = getCarattere(codice, codAlfabetico);
                    if (codice.equals(mappa[0][31]))
                    {
                        codAlfabetico = true;
                    }
                    else if (codice.equals(mappa[0][27]))
                    {
                        codAlfabetico = false;
                    }
                    else if (codice.equals(mappa[0][8]))
                    {
                        // Si converte pure il rigo a capo con CR LF
                        try
                        {
                            // Se il carattere trovato è CR, si verifica la presenza di LF nei prossimi 5 bit
                            if (binario.substring(i + 6, i + 11).equals(mappa[0][2]))
                            {
                                risultatoTesto = risultatoTesto + "\n";
                                i += 6;
                            }
                            else
                            {
                                System.out.println("Il carattere LF deve SEMPRE seguire il carattere CR");
                            }
                        }
                        catch (Exception e)
                        {
                            System.out.println("Il carattere LF deve SEMPRE seguire il carattere CR");
                        }
                    }
                    else
                    {
                        risultatoTesto = risultatoTesto + risultato;
                    }
                }
            }
            else
            {
                errore = true;
                System.out.println("La stringa deve iniziare con LTRS(11111) o FIGS(11011)");
            }
        }
        else
        {
            // La stringa non è un binario Baudot valido
        }
        return risultatoTesto;
    }
    
    /**
     * Ritorna true se il carattere è alfabetico
     */
    private boolean èCarattereAlfabetico(String carattere)
    {
        boolean risultato = false;
        for (int i = 1; i < 31; i++)
        {
            if ((i != 2) || (i != 8) || (i != 27))  // Escludi i caratteri funzione
            {
                if (carattere.equals(mappa[1][i]))
                {
                    risultato = true;
                    break;
                }
            }
        }
        return risultato;
    }
    
    /**
     * Ritorna true se il carattere è speciale
     */
    private boolean èCarattereSpeciale(String carattere)
    {
        boolean risultato = false;
        for (int i = 1; i < 31; i++)
        {
            if ((i != 2) || (i != 8) || (i != 9) || (i != 11) || (i != 27)) // Escludi tutti i caratteri funzione
            {
                if (carattere.equals(mappa[2][i]))
                {
                    risultato = true;
                    break;
                }
            }
        }
        if (carattere.equals("\n"))
        {
            risultato = true;
        }
        return risultato;
    }
    
    /**
     * Ritorna la stringa che rappresenta il valore binario del carattere da codificare
     */
    private String getBinario(String carattere)
    {
        String risultato = "";
        for (int i = 1; i < 31; i++)
        {
            if ((carattere.equals(mappa[1][i])) || (carattere.equals(mappa[2][i])))
            {
                risultato = mappa[0][i];
                break;
            }
        }
        if (carattere.equals("\n"))
        {
            risultato = mappa[0][8] + " " + mappa[0][2];
        }
        return risultato;
    }
    
    /**
     * Ritorna il carattere associato dalla combinazione binaria
     */
    private String getCarattere(String binario, boolean alfabetico)
    {
        String carattere = "";
        boolean èBinario = true;
        for (int i = 0; i < 5; i++)
        {
            if ((!binario.substring(i, i + 1).equals("0")) && (!binario.substring(i, i + 1).equals("1")))
            {
                èBinario = false;
            }
        }
        if (binario.length() == 5)
        {
            // È un binario baudot
            for (int i = 0; i < 32; i++)
            {
                if (mappa[0][i].equals(binario))
                {
                    if (alfabetico)
                    {
                        carattere = mappa[1][i]; break;
                    }
                    carattere = mappa[2][i];
                    break;
                }
            }
        }
        else
        {
            errore = true;
        }
        return carattere;
    }
}