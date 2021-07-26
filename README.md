# Context

Nielsen receives transaction level scanning data (POS Data) from its partner stores on a regular basis. Stores sharing POS data include bigger format store types such as supermarkets, hypermarkets as well as smaller traditional trade grocery stores (Kirana stores), medical stores etc. using a POS machine.

While in a bigger format store, all items for all transactions are scanned using a POS machine, smaller and more localized shops do not have a 100% compliance rate in terms of scanning and inputting information into the POS machine for all transactions.

A transaction involving a single packet of chips or a single piece of candy may not be scanned and recorded to spare customer the inconvenience or during rush hours when the store is crowded with customers.

Thus, the data received from such stores is often incomplete and lacks complete information of all transactions completed within a day.

Additionally, apart from incomplete transaction data in a day, it is observed that certain stores do not share data for all active days. Stores share data ranging from 2 to 28 days in a month. While it is possible to impute/extrapolate data for 2 days of a month using 28 days of actual historical data, the vice versa is not recommended.

Nielsen encourages you to create a model which can help impute/extrapolate data to fill in the missing data gaps in the store level POS data currently received.

# Content

You are provided with the dataset that contains store level data by brands and categories for select stores-

Hackathon_ Ideal_Data - The file contains brand level data for 10 stores for the last 3 months. This can be referred to as the ideal data.

HackathonWorkingData - This contains data for selected stores which are missing and/or incomplete.

HackathonMappingFile - This file is provided to help understand the column names in the data set.

HackathonValidationData - This file contains the data stores and product groups for which you have to predict the Total_VALUE.

Sample Submission - This file represents what needs to be uploaded as output by candidate in the same format. The sample data is provided in the file to help understand the columns and values required.

# Acknowledgements

Nielsen Holdings plc (NYSE: NLSN) is a global measurement and data analytics company that provides the most complete and trusted view available of consumers and markets worldwide. Nielsen is divided into two business units. Nielsen Global Media, the arbiter of truth for media markets, provides media and advertising industries with unbiased and reliable metrics that create a shared understanding of the industry required for markets to function. Nielsen Global Connect provides consumer packaged goods manufacturers and retailers with accurate, actionable information and insights and a complete picture of the complex and changing marketplace that companies need to innovate and grow. Our approach marries proprietary Nielsen data with other data sources to help clients around the world understand what’s happening now, what’s happening next, and how to best act on this knowledge. An S&P 500 company, Nielsen has operations in over 100 countries, covering more than 90% of the world’s population.

Know more: https://www.nielsen.com/us/en/

# Inspiration

Build an imputation and/or extrapolation model to fill the missing data gaps for select stores by analyzing the data and determine which factors/variables/features can help best predict the store sales.
