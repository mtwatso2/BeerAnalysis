Beer Analysis

For our project we will look at how alcohol percentage in beer varies by type of beer and region the beer is brewed in. The main issue was that there is no application to be able to look up beer by region that can be categorized by style of beer. 

This will be an interesting project because it will allow our audience to learn about different types of beers and how they might vary from region to region. We also thought it would be interesting to learn more about beers since we have not been exposed to alcohol for very long in our lives. If you used our shiny application when traveling to a different part of the world, you could see which beers are available based on category of the brew.

The data comes from five “.csv” files and we will need to clean and remove all missing values. After cleaning the files we will have to merge the data sets together to add variable to the main data set, as well as to be able to create a clean and usable dataset. One important thing to note is that there are a lot of observations, around 2,000, with a value of “0” for abv. We decided not to remove these observations from the data, as there many non-alcoholic beers included. To accommodate this, we set the default for the abv slider to show percentages ranging from 0.5 to 32. The slider can be adjusted to include 0%, but this makes the graphs less nice.

beers.csv is the original data, which can be found at: https://data.world/too-root/openbeerdb
The other .csv files were used to create new variables in the main data set, which after being cleaned was named as: Beers_cleaned.csv. The variables contained in the data set are listed below

Beers_cleaned.csv:
-brewery_id
-cat_id
-style_id
-id
-name
-abv
-style_name
-country
-cat_name
-latitude
-longitude
