data = read.csv('NYC_clean.csv')
library(dplyr)
library(ggplot2)

summarised_drugs <- data %>% 
  group_by(DRUG_NAME, year = lubridate::year(data$TRANSACTION_DATE)) %>%
  summarise(MME = sum(MME_Conversion_Factor*CALC_BASE_WT_IN_GM), 
            num_transactions=n(), num_pills=sum(DOSAGE_UNIT))

write.csv(summarised_drugs, file='summarised_data.csv', row.names=F)

#summarised_drugs %>% ggplot(aes(x=year,y=MME)) +
#  geom_line(aes(color=DRUG_NAME))

#summarised_drugs %>% ggplot(aes(x=year,y=num_pills)) +
#  geom_line(aes(color=DRUG_NAME))

#summarised_drugs %>% ggplot(aes(x=year,y=num_transactions)) +
#  geom_line(aes(color=DRUG_NAME))

big_reporters <- data %>% group_by(Reporter_family) %>% summarise(size=n()) %>%
  arrange(desc(size)) %>% head(10)

big_reporters <- big_reporters$Reporter_family

summarised_reporters <- data %>% filter(., Reporter_family %in% big_reporters) 
summarised_reporters <- summarised_reporters %>%
  group_by(Buyer = Reporter_family, DRUG_NAME, 
           year = lubridate::year(summarised_reporters$TRANSACTION_DATE)) %>%
  summarise(MME = sum(MME_Conversion_Factor*CALC_BASE_WT_IN_GM), 
            num_transactions=n(), num_pills=sum(DOSAGE_UNIT))

#summarised_reporters %>% ggplot(aes(x=year, y=MME)) + geom_line(aes(color=Reporter_family)) +
#  facet_wrap(~ DRUG_NAME)

write.csv(summarised_reporters, "major_drug_buyers.csv", row.names=F)

big_pharmas <- data %>% group_by(Combined_Labeler_Name) %>% summarise(size=n()) %>%
  arrange(desc(size)) %>% head(10)

big_pharmas <- big_pharmas$Combined_Labeler_Name

summarised_pharmas  <- data %>% filter(., Combined_Labeler_Name %in% big_pharmas)
summarised_pharmas <- summarised_pharmas %>%
  group_by(Pharma_Company = Combined_Labeler_Name, DRUG_NAME, 
           year = lubridate::year(summarised_pharmas$TRANSACTION_DATE)) %>%
  summarise(MME = sum(MME_Conversion_Factor*CALC_BASE_WT_IN_GM), 
            num_transactions=n(), num_pills=sum(DOSAGE_UNIT))

#summarised_pharmas %>% ggplot(aes(x=year, y=MME)) + geom_line(aes(color=Pharma_Company)) +
#  facet_wrap(~ DRUG_NAME, scales="free")

write.csv(summarised_pharmas, "major_pharma_companies.csv", row.names=F)

dose_strengths <- data %>% group_by(dos_str, DRUG_NAME, year = lubridate::year(data$TRANSACTION_DATE)) %>%
  summarise(count=n()) 
#dose_strengths$dos_str = as.factor(dose_strengths$dos_str)
#dose_strengths %>% 
#  ggplot(aes(x=year,y=count)) + geom_line(aes(color=dos_str)) +
#  facet_wrap(~ DRUG_NAME, scales="free", ncol=1, nrow=2)

write.csv(dose_strengths, "dose_strengths.csv", row.names=F)





