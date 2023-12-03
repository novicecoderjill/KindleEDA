library(dplyr)

# Read data
# Insert csv file directory
 ratings_df <- read.csv("Dataset/kindle_data-v2.csv")


# Create a clean copy of the dataframe
clean_df <- ratings_df

# Replace empty values with NA across all columns
clean_df <- clean_df %>%
  mutate_all(~ifelse(. == "", NA, .))

# Replace reviews with 0 to NA
clean_df <- clean_df %>%
  mutate(reviews = ifelse(reviews == 0, NA, reviews))

# Remove rows with NA values
clean_df <- clean_df %>%
  na.omit()

# Remove duplicates based on 'asin' column
clean_df <- clean_df %>%
  distinct(asin, .keep_all = TRUE)

#sort dataframe by price
clean_df <- clean_df[order(clean_df$price),]
#clean_df$price

#delete duplicate price
price_v<-unique(clean_df$price)

# Categorize price range
clean_df <- clean_df %>%
  arrange(price) %>%
  mutate(
    priceRange = cut(
      price,
      breaks = c(min(price_v), quantile(price_v, probs = c(0.25, 0.75)), max(price_v)),
      labels = c("Low", "Mid", "High"),
      include.lowest = TRUE
    )
  )

 # Save the cleaned dataframe
 save(clean_df, file = "R/clean_df.RData")


