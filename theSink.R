greplace <- function(keyWords, searchVector) {
  output <- data.frame(company = character(), match = logical(), value = character())
  for(stri in keyWords) {
    output <- rbind(output, data.frame(company = searchVector, match = agrepl(stri, searchVector, ignore.case=T)) %>% filter(match==T) %>%  mutate(value=stri))
  }
  return(output);
}

wreplace <- function (keyword, searchString) {
  return(ifelse(agrepl(keyword, searchString, ignore.case=T), keyword,searchString))
}

#cleanCompany <- greplace(masCompany$company, data$company)
print(data)
#print(cleanCompany)

#data <- left_join(data, cleanCompany, by="company")

#print(cleanCompany)
