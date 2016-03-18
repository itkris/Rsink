#install.packages("stringdist")
# define requried libraries and master data
library(xlsx)
library(dplyr)
library(tidyr)
library(stringdist)

masProdCat = data.frame( product_code = c("p", "v", "x", "q"), product_category = c('Smartphone', 'TV', 'Laptop', 'Tablet'), truth = c(1,1,1,1), stringsAsFactors = F)
masCompany = data.frame( company = c('philips', 'akzo', 'van_houten', 'unilever'))

print(masCompany)

# 0. load the data into R
data <-tbl_df(read.xlsx("data/refine.xlsx", sheetIndex=1))

# 1. clean up brand names

dist <- adist(masCompany[1], data$company, counts=T, fixed=F, partial=T, ignore.case=T)
print(dist)

# 2. separate product code and number
data <- separate(data, Product.code...number., into=c("product_code", "product_number"), sep='-')

# 3. add product categories

data <- inner_join(data, masProdCat)

# 4. add full address for geocoding
data <- data %>% unite(full_address, address, city, country, sep=", ")

# 5. create dummy variables for company and product category
data <- data %>% mutate(product_category = paste("product_", tolower(product_category), sep="")) %>% spread(product_category, truth, is.na(0)) 

# 6. write to CSV file
View(data)
# write.table(data, file="data/refine_clean.csv",sep=',', append=F, row.names=F)
