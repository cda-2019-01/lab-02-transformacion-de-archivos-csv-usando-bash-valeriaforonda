echo 'estacion;fecha;day;month;year;hora;direccion;velocidad' > title.csv
ls estaciones > lista.txt
x=( `cat "lista.txt" `)
for n in ${x[*]} 
do      sed 's%/%-%g' estaciones/$n > val$n
perl -pe 's/(^\d)\'-'/0$1-/' val$n > val1$n
sed 's/\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\);/'$n';\1-\2-\3;\1;\2;20\3;/' val1$n > val2$n
tail -n +2 val2$n > val3$n
cat val3$n >> title.csv
done
sed 's/;\([0-9]\),\([0-9]\)\([a-zA-Z]\)/;\1,\2\n\3/' title.csv > retorn.csv
sed 's/,/./g' retorn.csv > out1.csv
sed 's/;/,/g' out1.csv > out2.csv
sed 's/,\([0-9]\):/,0\1:/' out2.csv > out3.csv
sed 's/,\([0-9][0-9]\):\([0-9][0-9]\):\([0-9][0-9]\),/,\1,/' out3.csv > out4.csv
sed 's/\([a-zA-Z][0-9]\).\([a-zA-Z]*\),/\1,/' out4.csv > out5.csv
mkdir salidas
csvsql --query 'select estacion, month, avg(velocidad) as vel_prom from out5 group by estacion, month' out5.csv > salidas/velocidad-por-mes.csv
csvsql --query 'select estacion, year, avg(velocidad) as vel_prom from out5 group by estacion, year' out5.csv > salidas/velocidad-por-ano.csv
csvsql --query 'select estacion, hora, avg(velocidad) as vel_prom from out5 group by estacion, hora' out5.csv > salidas/velocidad-por-hora.csv
rm *.csv ; rm *.txt
mv salidas/*.csv /vagrant/lab-02-transformacion-de-archivos-csv-usando-bash-segiraldoma/
rmdir salidas
