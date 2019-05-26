sed -n '1,100p' recortada/estacion1.csv > estacion1.csv #Genero la muestra de la estación 1
sed -n '1,100p' recortada/estacion2.csv > estacion2.csv #Genero la muestra de la estación 2
sed -n '1,100p' recortada/estacion3.csv > estacion3.csv #Genero la muestra de la estación 3
sed -n '1,100p' recortada/estacion4.csv > estacion4.csv #Genero la muestra de la estación 4
ls estaciones > lista.txt #Genero un txt con los nombres de las estaciones
x=( `cat "lista.txt" `) #Genero un vector con el listado de las estaciones
for n in ${x[*]} #Aquí n toma los valores
do sed 's%/%-%g' estaciones/$n > val$n #Se reemplazan / por guiones
done #Se ejecuta
for n in ${x[*]} #Aquí n toma los valores
do sed -i 's/^/;/g' val$n #Aquí se agrega un punto y coma al inicio de cada fila
done #Se ejecuta
for n in ${x[*]} #Aquí n toma los valores
do sed 's/;\([0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\);/;0\1-\2-\3;/' val$n > val1$n #Aquí se etiqueta la estación para los archivos que tiene dos dígitos en el día
done #Se ejecuta
for n in ${x[*]} #Aquí n toma los valores
do sed 's/;\([0-9][0-9]\)-\([0-9][0-9]\)-\([0-9][0-9]\);/'$n';\1-\2-\3;\1;\2;\3;/' val1$n > val2$n #Aquí se etiqueta la estación para los archivos que tienen un dígito en el día
done #Se ejecuta
echo 'estacion;fecha;day;month;year;hora;direccion;velocidad' > title.csv #Se crea el encabezado con los títulos
for n in ${x[*]} #Aquí n toma los valores
do tail -n +2 val3$n > val4$n #Aquí se elimina el encabezado de cada archivo
done #Se ejecuta
for n in ${x[*]} #Aquí no toma los valores
do cat val4$n >> title.csv #Aquí concateno los archivos con el título
done

for n in ${x[*]} # Aquí n toma los valores
do sed 's/,/./g' val4$n > val5$n #Se reemplazan la separación decimal de comas por puntos
done #Se ejecuta
for n in ${x[*]} # Aquí n toma los valores
do sed 's/;/,/g' val5$n > val6$n #Se reemplazan los punto y comas por comas
done #Se ejecuta
for n in ${x[*]} #Aquí no toma los valores
do cat val6$n >> title.csv #Aquí concateno los archivos con el título
done #Se ejecuta
