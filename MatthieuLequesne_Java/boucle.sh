for n in `seq 1 3` 
	do
	java SZ40 decrypt cassage/fm_out keys/$n
	mv data/cassage/fm_out_dechiffre.txt data/cassage/$n.txt
done