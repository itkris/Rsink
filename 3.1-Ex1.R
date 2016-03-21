#install.packages("stringdist")
# define requried libraries and master data
library(xlsx)
library(dplyr)
library(tidyr)
library(stringdist)

masProdCat = data.frame( product_code = c("p", "v", "x", "q"), product_category = c('Smartphone', 'TV', 'Laptop', 'Tablet'), truth = c(1,1,1,1), stringsAsFactors = F)
masCompany = data.frame( company = c('philips', 'akzo', 'van_houten', 'unilever'), stringsAsFactors=F)

greplace <- function(keyWords, searchVector) {
  output <- data.frame(company = character(), match = logical(), value = character())
  for(stri in keyWords) {
    output <- rbind(output, data.frame(company = searchVector, match = agrepl(stri, searchVector, ignore.case=T)) %>% filter(match==T) %>%  mutate(value=stri))
  }
  return(output);
}

wreplace <- function (keywords, searchString) {
  for(keywrd in keywords) {
      if(agrepl(keywrd, searchString, ignore.case=T)) {
        return (keywrd)
      }
  }
  return (searchString)
}

# 0. load the data into R
df_data <- tbl_df(read.xlsx("data/refine.xlsx", sheetIndex=1))

# 1. clean up brand names
df_data <- mutate(df_data, cleanCompany = wreplace(masCompany$company, company))

# 2. separate product code and number
df_data <- separate(df_data, Product.code...number., into=c("product_code", "product_number"), sep='-')

# 3. add product categories
df_data <- inner_join(df_data, masProdCat)

# 4. add full address for geocoding
df_data <- df_data %>% unite(full_address, address, city, country, sep=", ")

# 5. create dummy variables for company and product category
df_data <- df_data %>% mutate(product_category = paste("product_", tolower(product_category), sep="")) %>% spread(product_category, truth, is.na(0)) 

# 6. write to CSV file
#View(df_data)
# write.table(df_data, file="data/refine_clean.csv",sep=',', append=F, row.names=F)
