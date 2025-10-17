import pandas as pd 

df = pd.read_csv('anonymized_enrollment_data.csv.csv', encoding='latin1')
#print(cars_df.head(10))

# All objects - no nulls
print(df.info())

# Identifying  numerical columns
print(df.describe())

# Count nbr of missing values (Missing values in CC/Battery Capacity - 3, Performance - 6, Torque - 1) 
print(df.isnull().sum())