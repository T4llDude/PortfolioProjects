import json as js 
import pandas as pd 

json_file = 'pythontraining/Scripts/ExampleJson.json'

with open(json_file, 'r') as file:
   json_data = js.load(file)

#Grab Person Info
person_tuple = (
   json_data["name"]["first"]
   ,json_data["name"]["last"]
   ,json_data["name"]["full"]
   ,json_data["gender"]
)

#Grab Household Info
household_tuple = (
   json_data["household"]["familyInfo"]["householdSize"]
   ,json_data["household"]["familyInfo"]["numberOfAdults"]
   ,json_data["household"]["familyInfo"]["numberOfChildren"]
   ,json_data["household"]["homeInfo"]["housingType"]
   ,json_data["household"]["homeInfo"]["householdEducation"]
   ,json_data["household"]["homeInfo"]["householdOccupation"]
)

#Grab Finance Info
finance_tuple = (
   json_data["household"]["finance"]["income"]
   ,json_data["household"]["finance"]["netWorth"]

)

## Check Output
# print(person_tuple)
# print(household_tuple)
# print(finance_tuple)

# Combine Tuples
combined_data = [person_tuple + household_tuple + finance_tuple]

#Set columns for combined_data
column_names = [
   "First_Name", "Last_Name", "Full_Name", "Gender" #person_tuple
   ,"Household_Size", "Number_of_Adults", "Number_of_Children", "House_Type","Education_Level", "Occupation" #household_tuple
   ,"Income", "Net_Worth" #finance_tuple
   ]

#Put combined_data into Dataframe
combined_df = pd.DataFrame(combined_data, columns=column_names)

#Result
print(combined_df)