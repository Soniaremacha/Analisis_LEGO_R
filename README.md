# 🧱 Análisis LEGO con R
Código en R que analiza un data frame sobre sets de LEGO.  

## Página Web
Puedes explorar este análisis sin necesidad de instalar nada clicando [aquí](https://soniaremacha.github.io/Analisis_LEGO_R/Analisis_LEGO.html).

## 🧹 Limpieza de datos
Este dataset presenta muchos problemas de limpieza. Gran parte del código se dedica a la decisión de eliminar según qué NA, decidir qué puede ser relevante para el estudio y discernir información veraz de un dataset conflictivo.

## 📊 Análisis de datos
Una vez limpia nuestra fuente de datos, podemos empezar a analizar. En este análisis, no podremos estudiar el precio de los sets, ya que las filas que contenían precio (tanto en la columna Item_Number como la Amazon_Price) no iban asociadas a nada más, el resto de columnas no contenían datos relevantes. Por lo tanto, el análisis se hará resolviendo a otro tipo de preguntas no monetarias:

- Distribución de sets por año
- Cantidad de sets por temática
- Tipos de empaques más comunes
- Número de piezas por set
- Relación número de piezas con número de minifiguras
- Edad del público de LEGO y su relación con el número de piezas
- Relación peso con tamaño
- Disponibilidad de los sets

