## la primera vez instalar los paquetes
install.packages("httr")
install.packages("jsonlite")


### si ya estan instalados arranca aqui 

require(httr)
require(jsonlite)



### de aqui para abajo es q vale

## funcion para traer lo q viste en la pagina del api y hacer una tabla con listing_id, seller_id, total_units_sold y price

traer_data<-function(url_final){
	### hacer el request al api de meli
	data <- GET(url_final)
	## parsear el response
	data_parse <- jsonlite::fromJSON(content(data, "text"), simplifyVector = FALSE)

	## guardar el numero de total de listings que resultaron de esta busqueda
	total = as.numeric(data_parse$paging$total)
	## saber cuantas veces voy a tener que traer data de 50 resultados
	tandas = round(total/50) -2
	# tandas = 100
	## creamos los vectores donde vamos a guardar la data
	seller_id <- vector(mode='character', length=0)
	total_units_sold <- vector(mode='numeric', length=0)
	price <-  vector(mode='numeric', length=0)
	listing_id <- vector(mode="numeric", length=0)

	### hacemos un loop para cada request que hagamos al api
	for (i in c(0:tandas)){
		### con cada loop varia i y el offset sera i * 50 
		url_mas_final <- paste(url_final, "&offset=", i*50, sep="", collapse=NULL)
		### hacemos el request
		data <- GET(url_mas_final)
		### parseamos el response
		data_parse <- jsonlite::fromJSON(content(data, "text"), simplifyVector = FALSE)
		for(f in c(1:length(data_parse$results))){
			## cada uno de los 50 resultados los vamos guardando
			seller_id <- c(seller_id, data_parse$results[[f]]$seller$id)
			total_units_sold <-c(total_units_sold, data_parse$results[[f]]$sold_quantity)
			price <- c(price, data_parse$results[[f]]$price)
			listing_id <- c(listing_id, data_parse$results[[f]]$id)
		}
		
	}

	### hacemos un dataframe con los 4 vectores
	salida <- data.frame(listing_id, seller_id, total_units_sold, price)
	### mandar el resultado	
	return(salida)

} ## cierra la funcion traer data 

calcular_item_promedio <- function(df){
	item_promedio <- sum(df$total_units_sold * df$price)/ sum(df$total_units_sold)
}
	
