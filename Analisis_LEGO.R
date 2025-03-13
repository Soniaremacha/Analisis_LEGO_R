## ----setup, include=FALSE---------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----message=FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------------
# Lista de librerías de CRAN necesarias
cran_libraries <- c("readr", "data.table", "ggplot2", "rmarkdown")

# Comprobar e instalar librerías de CRAN
for (lib in cran_libraries) {
  if (!requireNamespace(lib, quietly = TRUE)) {
    install.packages(lib)
  }
}

# Comprobar si devtools está instalado, si no, instalarlo
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Instalar la librería desde GitHub si no está instalada
if (!requireNamespace("tidytable", quietly = TRUE)) {
  devtools::install_github("markfairbanks/tidytable")
}

# Cargar todas las librerías
library(readr)
library(data.table)
library(ggplot2)
library(rmarkdown)
library(tidytable)



## ---------------------------------------------------------------------------------------------------------------------------------------------------
lego_data<- read.csv("lego_population_cof.csv")
str(lego_data)
summary(lego_data)



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Conversión a tidytable

lego_data_clean <- as_tidytable(lego_data)



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Eliminamos columnas irrelevantes o con muy poca información

lego_data_clean <- tidytable(
  lego_data_clean %>% select (-c("X", "Item_Number", "Pages", "Price", "Amazon_Price"))
)

head(lego_data_clean)


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Antes de cambiar el tipo de variable de Weight, quitamos lo sobrante de sus datos (kg, lb...)
lego_data_clean <- lego_data_clean %>%
  mutate(Weight = parse_number(Weight)) 



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Conversión tipos de variable
lego_data_clean <- lego_data_clean %>%
  mutate(
    Set_Name = factor(Set_Name),
    Year = factor(Year),
    Theme = factor(Theme),
    Ages = factor(Ages),
    Packaging = factor(Packaging),
    Availability = factor(Availability),
    Size = factor(Size),
    
    unique_pieces = as.numeric(unique_pieces),
    Pieces = as.numeric(Pieces),
    Minifigures = as.numeric(Minifigures),
    Weight = as.numeric(Weight)
  )

str(lego_data_clean)



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Conteo de sets por año
lego_count_year <- lego_data_clean |>
  filter(!is.na(Year)) |>
  count(Year, sort = TRUE) |>
  arrange(Year) |>
  mutate(freq_rel = n / sum(n)*100)

lego_count_year


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Diagrama de barras
ggplot(lego_count_year, aes(x = factor(Year), y = n, fill = factor(Year))) +
  geom_bar(stat = "identity") 
  labs(title = "Distribución de Sets por Año",
       x = "Año",
       y = "Frecuencia")


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Conteo de líneas
lego_count_theme <- lego_data_clean |>
  filter(!is.na(Theme)) |>
  count(Theme, sort = TRUE) |>
  mutate(freq_rel = n / sum(n)*100)

lego_count_theme



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Top 10 líneas
lego_count_theme_top10 <- lego_count_theme |>
  top_n(10, wt = n) |>
  arrange(desc(n)) 

lego_count_theme_top10

lego_count_theme_top10$Theme <- factor(
  lego_count_theme_top10$Theme,
  levels = lego_count_theme_top10$Theme[order(lego_count_theme_top10$n)]
)



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Diagrama de barras
ggplot(lego_count_theme_top10, aes(x = Theme, y = n, fill = Theme)) +
  geom_bar(stat = "identity") +  
  coord_flip()+
  labs(title = "Top 10 Temas en Sets LEGO",
       x = "Línea",
       y = "Número de sets") +
  theme(legend.position = "none")



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Conteo de tipo de empaque
lego_count_packaging <- lego_data_clean |>
  filter(!is.na(Packaging)) |>
  count(Packaging, sort = TRUE) |>
  mutate(freq_rel = n / sum(n)*100) |>
  arrange(desc(n))

lego_count_packaging


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Mostrar sólo el número de los 2 mayores tipos de empaque en el diagrama
etiquetas_seleccionadas <- lego_count_packaging |>
  slice(1:2)

# Diagrama de sectores
ggplot(lego_count_packaging, aes(x = "", y = n, fill = Packaging)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  theme_void() +
  labs(title = "Distribución de los tipos de Packaging en LEGO",
       fill = "Tipo de Packaging") +
  geom_text(data = etiquetas_seleccionadas,  
            aes(label = paste0(round(n/sum(n) * 100, 1), "%")), 
            position = position_stack(vjust = 0.5), 
            size = 4, color = "white", fontface = "bold")



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Máximo de piezas
lego_max_pieces <- lego_data_clean %>%
  select(Set_Name, Year, Pieces) %>%  
  filter(!is.na(Pieces)) %>%
  filter(Pieces == max(Pieces))  

lego_max_pieces



## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Correlación piezas y minifiguras
correlation_pieces_minifigures <- lego_data_clean %>% 
      summarise(correlacion = cor(lego_data_clean$Pieces, lego_data_clean$Minifigures, use="complete.obs"))

correlation_pieces_minifigures


## ----warning=FALSE----------------------------------------------------------------------------------------------------------------------------------

# Diagrama de puntos
ggplot(lego_data_clean, aes(x = Pieces, y = Minifigures)) +
  geom_point(color = "blue", size = 3) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(title = "Relación entre piezas y minifiguras",
       x = "Piezas",
       y = "Minifiguras")


## ---------------------------------------------------------------------------------------------------------------------------------------------------

setDT(lego_data_clean)
lego_data_clean[, Ages := as.character(Ages)]

# Eliminación de NA y "Ages_NA"
lego_data_clean <- lego_data_clean[!is.na(Ages) & Ages != "Ages_NA"]

# Reagrupación para facilitar el estudio
lego_data_clean[, new_age_group := fifelse(
  Ages %in% c("Ages_1+", "Ages_2+", "Ages_1 - 3", "Ages_2 - 5", "Ages_4 - 99", "Ages_2 - 6", 
              "Ages_5 - 99", "Ages_4+", "Ages_3+", "Ages_5 - 12", "Ages_5+", "Ages_3 - 6", 
              "Ages_4 - 6", "Ages_5 - 10"), 
  "Ages 1 - 5",
  fifelse(
    Ages %in% c("Ages_6+", "Ages_7+", "Ages_6 - 12", "Ages_4 - 7", "Ages_6 - 14", "Ages_11+", 
                "Ages_7 - 14", "Ages_6 - 10", "Ages_8+", "Ages_9+", "Ages_7 - 12", "Ages_8 - 12", 
                "Ages_9 - 14", "Ages_9 - 12", "Ages_8 - 14"), 
    "Ages 6 - 12",
    fifelse(
      Ages %in% c("Ages_13+", "Ages_12+", "Ages_14+", "Ages_16+", "Ages_10+"), 
      "Ages 13 - 17",
      fifelse(Ages %in% c("Ages_18+"), "Ages 18+", "Otro")
    )
  )
)]

# Conteo y media
lego_count_ages <- lego_data_clean[, .(
  mean_pieces = mean(Pieces, na.rm = TRUE),
  set_count = .N
), by = new_age_group]

# Frecuencia relativa
lego_count_ages[, set_count_freq := (set_count / sum(set_count)) * 100]

# Ordenar por media de piezas en orden descendiente
setorder(lego_count_ages, -mean_pieces)

lego_count_ages


## ---------------------------------------------------------------------------------------------------------------------------------------------------

# Diagrama de sectores

ggplot(lego_count_ages, aes(x = "", y = set_count_freq, fill = new_age_group)) +
  geom_bar(stat = "identity", width = 1) +  
  coord_polar(theta = "y") +  
  theme_void() +  
  labs(title = "Distribución de sets por grupo de edad") +  
  theme(legend.title = element_blank())+
  geom_text(aes(label = paste0(round(set_count_freq, 1), "%")),  
            position = position_stack(vjust = 0.5))




## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Conversión Ages a números 
lego_data_clean[, Age_numeric := as.numeric(gsub("\\D", "", substr(Ages, 6, 7)))]


# Calcular la correlación entre la edad mínima y Pieces, excluyendo NA
correlation_ages_pieces <- cor(lego_data_clean$Age_numeric, lego_data_clean$Pieces, use = "complete.obs")

correlation_ages_pieces



## ----warning=FALSE----------------------------------------------------------------------------------------------------------------------------------

# Diagrama de puntos
ggplot(lego_data_clean, aes(x = Pieces, y = Age_numeric)) +
  geom_point(color = "blue", size = 3) +  
  geom_smooth(method = "lm", color = "red", se = FALSE) +  
  labs(title = "Relación entre piezas y edad",
       x = "Piezas",
       y = "Edad")


## ----warning=FALSE----------------------------------------------------------------------------------------------------------------------------------
# Correlación

lego_data_clean <- lego_data_clean %>%
  mutate(Size_numeric = ifelse(Size == "Small", 1, ifelse(Size == "Large", 2, NA)))

correlation_weight_size <- cor(lego_data_clean$Size_numeric, lego_data_clean$Weight, use = "complete.obs")
correlation_weight_size



## ----warning=FALSE----------------------------------------------------------------------------------------------------------------------------------
# Diagrama de caja
ggplot(lego_data_clean, aes(x = Size, y = Weight)) +
  geom_boxplot() +
  labs(title = "Distribución del peso por tamaño", x = "Size", y = "Weight")



## ----warning=FALSE----------------------------------------------------------------------------------------------------------------------------------
setDT(lego_data_clean)

# Conteo y eliminación de NA
availability_count <- lego_data_clean[!is.na(Availability), .N, by = .(Availability)]
availability_count[, freq_relative := N / sum(N)*100]

availability_by_year <- lego_data_clean[!is.na(Availability), .N, by = .(Year, Availability)]

availability_count


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Diagrama de barras apiladas
ggplot(availability_by_year, aes(x = Year, y = N, fill = Availability)) +
  geom_bar(stat = "identity") +
  labs(title = "Disponibilidad por año", x = "Año", y = "Frecuencia") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3") 

