
## traer todos los resultados de la categoria MLV91410 en un dataframe
url_final <- 'https://api.mercadolibre.com/sites/MLV/search?q=&category=MLV91410'
correas <- traer_data(url_final) ### solo trae los primeros 10047

url_mangueras <- 'https://api.mercadolibre.com/sites/MLV/search?q=&category=MLV91396'
mangueras <- traer_data(url_mangueras)


### lista de vendedores
vendedores_de_correas <- data.frame(table(correas$seller_id))

### valor de item promedio en busqueda correas 
correa_promedio <- calcular_item_promedio(correas)

### vendedores ordenados segun numero de listings de la muestra
correa_sellers_listings <-vendedores_de_correas[order(vendedores_de_correas$Freq, decreasing=TRUE),]

## ver los primeros 6 
head(correa_sellers_listings)

## ver los primeros 10
correa_sellers_listings[1:10,]

### vendedores con mas ventas segun las publicaciones de la muestra 
total_items_sold <- vector(mode='numeric', length=length(vendedores_de_correas[,1]))
for(i in 1:length(vendedores_de_correas[,1])){
	total_items_sold[i] <- sum(correas[correas$seller_id == vendedores_de_correas[i,1], 3])
}

## unir el vector al data frame 
vendedores_de_correas <- data.frame(vendedores_de_correas, total_items_sold)

## vendedores con mas items sold 
correas_x_items_sold_x_seller_order <- vendedores_de_correas[order(vendedores_de_correas$total_items_sold, decreasing = TRUE),]


### como saber cuanto tiempo va a tardar una operacion 

# 1) Correr con un sample 
# 2) Guardar el tiempo de inicio 
# 3) Calcular al final cuanto tardo
# 4) Hacer regla de tres (es un aproximado)

nicknames_ <- vector(mode='character', length=length(vendedores_de_correas[,1]))
strt <- Sys.time()
for(i in 1:10){
	nicknames[i] <- traer_nicknames(vendedores_de_correas[i,1])
}
print(Sys.time() - strt) ## Time difference of 1.315929 secs

## cuantos seller_id hay? 
length(vendedores_de_correas[,1]) ## 3626

(3626/10) * 1.3156 ## segs 
## da 477.04 segundos... unos 8 minutos


### CALCULAR 

## traer los nicknames de los sellers  DEBERIA TARDAR UNOS 8 minutos
nicknames <- vector(mode='character', length=length(vendedores_de_correas[,1]))
strt <- Sys.time()
for(i in 1:length(vendedores_de_correas[,1])){
	nicknames[i] <- traer_nicknames(vendedores_de_correas[i,1])
}
print(Sys.time() - strt) ## Time difference of 10.89306 mins 

## unir al data frame 
vendedores_de_correas <- data.frame(vendedores_de_correas, nicknames)

### ver nombres de las columnas 
names(vendedores_de_correas)

## cambiar nombres 
names(vendedores_de_correas)[1] <- "seller_id"
names(vendedores_de_correas)[2] <- "listings_number"

## exportar a archivo csv para abrirlo en excel 

write.csv(file = "vendedores_de_correas.csv", vendedores_de_correas, row.names=FALSE)

### limpiar la memoria
rm(list=ls()) ## despues de esto debemos ejecutar de nuevo funciones.R para poder usar las funciones


### cargar el archivo csv que generamos (util para cuando queremos cerrar
###  y volver en un futuro a usar la data)

## recuerda fijar el working directory para poder abrir el archivo 

## donde estoy ? 
getwd()
## retorna "/Users/adolfoyanes" pero mi archivo esta en Downloads
setwd("/Users/adolfoyanes/Downloads")

## leer el archivo csv
vendedores_de_correas <- read.csv("vendedores_de_correas.csv", header=TRUE, sep=",")

### otras herramientas utiles 

## ver la distribucion de total_items_sold
summary(vendedores_de_correas$total_items_sold)

## histograma de la distribucion
hist(vendedores_de_correas$total_items_sold)

## exlcuir los que tienen cero ventas 
hist(vendedores_de_correas$total_items_sold[vendedores_de_correas$total_items_sold > 0 ])

## excluir los mayores de 100
hist(vendedores_de_correas$total_items_sold[(vendedores_de_correas$total_items_sold > 0) & (vendedores_de_correas$total_items_sold <= 100)])

## de 0 a 10
hist(vendedores_de_correas$total_items_sold[vendedores_de_correas$total_items_sold <= 10 ])







