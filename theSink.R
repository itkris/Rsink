

wreplace <- function (keyword, searchString) {
  return(ifelse(agrepl(keyword, searchString, ignore.case=T), keyword,searchString))
}

#cleanCompany <- greplace(masCompany$company, data$company)
print(data)
#print(cleanCompany)

#data <- left_join(data, cleanCompany, by="company")

#print(cleanCompany)
