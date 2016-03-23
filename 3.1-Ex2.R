
library(dplyr)
library(tidyr)

# 0: Load the data in RStudio
df_data2 <- data.frame(read.csv("data/titanic_original.csv"))


# 1: Port of embarkation: The embarked column has one missing value, which is known to correspond to a passenger who actually embarked at Southampton. Find the missing value and replace it with S.
# A: There are 2 blanks... not 1. 
df_data2$embarked[!(df_data2$embarked %in% c('S', 'C', 'Q'))] <- 'S'


# 2: Age
# You’ll notice that a lot of the values in the Age column are missing. While there are many ways to fill these missing values, using the mean or median of the rest of the values is quite common in such cases.
# Calculate the mean of the Age column and use that value to populate the missing values
ageMean <- summarise(df_data2, m = mean(age, na.rm = T))
df_data2$age[is.na(df_data2$age)] <- ageMean

# Think about other ways you could have populated the missing values in the age column. Why would you pick any of those over the mean (or not)?
# There are much better ways to do this - 
# Sibsp > 3 and parch > 0 are under 20. So all records with that statistic can be updated with the corresponding average

# the following are other two groups that show some pattern(by class, gender and sibsp + parch)
# print(df_data2 %>% filter(age>0, sibsp>=3) %>% group_by(pclass, sibsp, parch) %>% summarise(meen = mean(age, na.rm = T), n= n()))
# print(df_data2 %>% filter(age>0, sibsp + parch == 0) %>% group_by(sex, pclass, sibsp, parch) %>% summarise(meen = mean(age, na.rm = T), n= n()))
#View(df_data2 %>% group_by(survived, sex, pclass, sibsp, parch) %>% summarise( mage = mean(age,na.rm =T), dage = mode(age), n= n()))
# df_data2 <- separate(df_data2, name, into=c("fName", "lName"), sep=',')

#View(df_data2)


# 3: Lifeboat
# You’re interested in looking at the distribution of passengers in different lifeboats, but as we know, many passengers did not make it to a boat :-( This means that there are a lot of missing values in the boat column. Fill these empty slots with a dummy value e.g. NA
df_data2$boat[df_data2$boat == ""] <- NA


# 4: Cabin
# You notice that many passengers don’t have a cabin number associated with them.
# Does it make sense to fill missing cabin numbers with a value?
# A: No these seem to be unique values (room numbers). We cannot apply an aggregate value here.
df_data2$cabin[df_data2$cabin == ""] <- NA
# Q: What does a missing value here mean?
# A: There seems to be no correlation between the cabin number and any other factor???

# You have a hunch that the fact that the cabin number is missing might be a useful indicator of survival. Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.
df_data2 <- mutate(df_data2, has_cabin_number = ifelse(is.na(cabin), 0, 1))
# A: really? there seems to be a stronger correlation between gender and survival than cabin number and survival.

# 
# 6: Submit the project on Github
# Include your code, the original data as a CSV file titanic_original.csv, and the cleaned up data as a CSV file called titanic_clean.csv.
write.table(df_data, file="data/titanic_clean.csv",sep=',', append=F, row.names=F)