import pandas as pd

NYC = pd.read_csv('NYC.csv')
## convert the transaction date to a datetime object
NYC['TRANSACTION_DATE'] = pd.to_datetime(NYC['TRANSACTION_DATE'], \
	format='%m%d%Y')

## dropping redundant/repetitive columns
#NYC = NYC.drop(labels=["Ingredient_Name", "UNIT", "MME_Conversion_Factor", \
#	'DRUG_CODE','Measure', 'BUYER_STATE'], axis=1)
NYC = NYC[['Reporter_family', "REPORTER_STATE", "REPORTER_ZIP", 'DRUG_NAME', 
	'TRANSACTION_DATE', 'BUYER_NAME', 'MME_Conversion_Factor', 'dos_str', 
	"BUYER_ZIP", "CALC_BASE_WT_IN_GM","DOSAGE_UNIT", 'Combined_Labeler_Name']]

NYC.to_csv('NYC_clean.csv', index=False)

## different years
for year in range(2006,2015):
	NYC.loc[pd.DatetimeIndex(NYC['TRANSACTION_DATE']).year ==year].\
		to_csv('NYC%d.csv' %year, index=False)

quit()

## the two drugs
oxycodone = NYC.loc[NYC['DRUG_NAME'] == 'OXYCODONE']
hydrocodone = NYC.loc[NYC['DRUG_NAME'] == 'HYDROCODONE']
oxycodone.to_csv('oxycodone.csv', index=False)
hydrocodone.to_csv('hydrocodone.csv', index=False)

## top 30 NYC reporters and buyers
NYCreporters = NYC.groupby('REPORTER_NAME').filter(lambda x: x.shape[0] > \
	1000)
NYCbuyers = NYC.groupby('BUYER_NAME').filter(lambda x: x.shape[0]>7000)
NYCreporters.to_csv('NYCreporters.csv', index=False)
NYCbuyers.to_csv('NYCbuyers.csv', index=False)

