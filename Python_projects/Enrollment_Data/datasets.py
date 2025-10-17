import pandas as pd 

df = pd.read_csv('anonymized_enrollment_data.csv')

# Setup individual datasets to preview enrollment counts
## Enrollment Count by Year
df['Year'] = df['Academic Year'].str.slice(0, 4)
df_count_by_year = df[['Year', 'Enrollment Date']]
year_counts = df_count_by_year.groupby('Year').size().reset_index(name='Enrollment_Count_by_Year')

## Enrollment Count by Program and Year
df_count_by_program_year = df[['Year', 'Enrollment Date', 'Program Type']]
grouped_counts = df_count_by_program_year.groupby(['Year', 'Program Type']).size().reset_index(name='Enrollment_Count_by_Grade_and_Year')


print(year_counts)
print(grouped_counts)