# Analisis_LEGO_R
Código en R que analiza un data frame sobre sets de LEGO. Realizamos primero una limpieza de los datos y una vez limpia nuestra fuente de datos, podemos empezar a analizar. 


## Limpieza de datos
Columna por columna, vemos los siguientes problemas y peculiaridades:

- 1- Column1 (X): No sirve para nada, se puede obviar.
- 2- Item_Number: En algunas filas tiene "-", en otras un número identificatorio, y en otras un precio. Debido a su ambigüedad, puede obviarse.
- 3- Set_Name: Muchas filas con NA, pero el resto parece que se refiere al nombre del set de LEGO. Tratamos NA como nombre desconocido.
- 4- Amazon_price: El formato no está normalizado y no permite estudiarlo bien. Sobran el "€" y ocasional "*". Tratamos "-" como NA, precio de Amazon desconocido. Además, Hay muy pocos datos relevantes así que no nos sirve para el estudio.
- 5- Year: Año de salida del set.
- 6- Pages: Solo contiene NA, puede obviarse.
- 7- unique_pieces: Número de piezas únicas en cada set. 
- 8- Theme: Tema del set.
- 9- Pieces: Número de piezas de cada set.
- 10- Price: Solo contiene NA, puede obviarse.
- 11- Ages: Edad recomendada del set, los desconocidos en vez de nombrarlos NA, los nombra "Ages_NA".
- 12- Minifigures: Número de minifiguras de cada se.
- 13- Packaging: Material de la caja donde viene el set.
- 14- Weight: El formato no está normalizado y no permite estudiarlo bien. Incluye una conversión a libras, que obviaremos.
- 15- Availability: Dónde se puede conseguir el set.
- 16- Size: Tamaño del set.

Conversión tipos de variable y eliminación de columnas:

- 1- Column1 (X): Eliminar
- 2- Item_number: Eliminar
- 3- Set_name: Categórica
- 4- Amazon_price: Eliminar
- 5- Year: Categórica
- 6- Pages: Eliminar
- 7- unique_pieces: Numérica
- 8- Theme: Categórica
- 9- Pieces: Numérica
- 10- Price: Eliminar
- 11- Ages: Categórica
- 12- Minifigures: Numérica
- 13- Packaging: Categórica
- 14- Weight: Numérica
- 15- Availability: Categórica
- 16- Size: Categórica


## Análisis de datos
En este análisis, no podremos estudiar el precio de los sets, ya que las filas que contenían precio (tanto en la columna Item_Number como la Amazon_Price) no iban asociadas a nada más, el resto de columnas no contenían datos relevantes. Por lo tanto, el análisis se hará resolviendo a otro tipo de preguntas no monetarias:

- Distribución de sets por año
- Cantidad de sets por temática
- Tipos de empaques más comunes
- Número de piezas por set
- Relación número de piezas con número de minifiguras
- Edad del público de LEGO y su relación con el número de piezas
- Relación peso con tamaño
- Disponibilidad de los sets

