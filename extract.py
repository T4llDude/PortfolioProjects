from homeharvest import scrape_property 

def get_property_dataframe(date_from, date_to):
    properties_df = scrape_property(
        location="Baltimore, MD",
        listing_type=['for_sale'],
        property_type=['single_family'],
        date_from=date_from,
        date_to=date_to,
        return_type='pandas'
    )
    return properties_df

# Testing data profile to determine data model
# print(properties.info())
# print(properties.head(10))
# properties.to_csv("test_outputs/properties_raw.csv", index=False)