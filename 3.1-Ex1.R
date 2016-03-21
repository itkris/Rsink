#install.packages("stringdist")
# define requried libraries and master data
library(xlsx)
library(dplyr)
library(tidyr)
library(stringdist)

masProdCat = data.frame( product_code = c("p", "v", "x", "q"), product_category = c('Smartphone', 'TV', 'Laptop', 'Tablet'), truth = c(1,1,1,1), stringsAsFactors = F)
masCompany = data.frame( company = c('philips', 'akzo', 'van_houten', 'unilever'), truth = c(1,1,1,1), stringsAsFactors=F)

greplace <- function(keyWords, searchVector) {
  output <- data.frame(company = character(), match = logical(), Company = character())
  searchVector <- unique(searchVector)
  for(stri in keyWords) {
    output <- rbind(output, data.frame(company = searchVector, match = agrepl(stri, searchVector, ignore.case=T)) %>% filter(match==T) %>%  mutate(Company=stri) )
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
df_cleancomps = unique(greplace(masCompany$company, df_data$company))
df_data <- left_join(df_data, df_cleancomps, by="company") %>% select(-match, -company) # we dont need the match column 
df_data$Company[is.na(df_data$Company)] <- "philips" #cleaning that one last outlier

# 2. separate product code and number
df_data <- separate(df_data, Product.code...number., into=c("product_code", "product_number"), sep='-')

# 3. add product categories
df_data <- inner_join(df_data, masProdCat, by="product_code")

# 4. add full address for geocoding
df_data <- df_data %>% unite(full_address, address, city, country, sep=", ")

# 5. create dummy variables for company and product category
df_data <- df_data %>% mutate(product_category = paste("product_", tolower(product_category), sep="")) %>% spread(product_category, truth, is.na(0)) 

# 6. write to CSV file
#View(df_data)
write.table(df_data, file="data/refine_clean.csv",sep=',', append=F, row.names=F)
