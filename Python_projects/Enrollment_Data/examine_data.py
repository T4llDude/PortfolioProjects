import pandas as pd 

df = pd.read_csv('anonymized_enrollment_data.csv')

# Examine data to be sure columns are coming through
print(df.head(5))
#   Academic Year       Program Type Enrollment Date
# 0     2020-2021  Elementary School       4/18/2021
# 1     2020-2021  Elementary School       6/26/2021
# 2     2020-2021  Elementary School       4/17/2021
# 3     2020-2021  Elementary School        5/3/2021
# 4     2020-2021  Elementary School      11/21/2020
# 5     2020-2021  Elementary School       3/10/2021
# 6     2020-2021  Elementary School       1/16/2021
# 7     2020-2021        High School       5/21/2021
# 8     2020-2021        High School       5/27/2021
# 9     2020-2021  Elementary School        4/9/2021

# See basic information about the dataset
print(df.describe())
#        Academic Year       Program Type Enrollment Date
# count         540000             540000          540000
# unique             6                  3            2016
# top        2024-2025  Elementary School       5/28/2025
# freq          115000             270654            1099