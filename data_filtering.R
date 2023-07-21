library(tidyverse)

setwd("/home/ryan/Documents/github/CollegeSwimMap/")

institution_data <- read_csv("data/Institution.csv")

# these are mostly super detailed data for debt, repayment rates by year, status

institution_data_2 <- institution_data %>% 
  select(-starts_with("BBRR"))

institution_data_3 <- institution_data_2 %>%
  select(-starts_with("DBRR"))

# completion and other measures for students with or without loans

institution_data_4 <- institution_data_3 %>%
  select(-starts_with("LOAN"))

institution_data_5 <- institution_data_4 %>%
  select(-starts_with("NOLOAN"))

# detailed (too detailed) outcome/completion measures

institution_data_6 <- institution_data_5 %>%
  select(-starts_with("OMEN"))

# removing independent students (no parental participation)

institution_data_7 <- institution_data_6 %>%
  select(-starts_with("IND"))

# many completion stats report students transferring out, crossing over many other categories

institution_data_8 <- institution_data_7 %>%
  select(-contains("_TRANS_"))

# filter for bachelor's degrees and higher

institution_data_9 <- institution_data_8 %>%
  filter(HIGHDEG>2)

# filter out grad only

institution_data_10 <- institution_data_9 %>%
  filter(CCSIZSET!=18)

# remove detailed program variables

institution_data_11 <- institution_data_10 %>%
  select(-starts_with("CIP"))

# remove dependent students breakdowns

institution_data_12 <- institution_data_11 %>%
  select(-starts_with("DEP_"))

# remove adjusted cohort counts

institution_data_13 <- institution_data_12 %>%
  select(-starts_with("OMACH"))

# remove pool years

institution_data_14 <- institution_data_13 %>%
  select(-starts_with("POOL"))

# remove PLUS and PPLUS debt

institution_data_15 <- institution_data_14 %>%
  select(-starts_with("PLUS"))

institution_data_16 <- institution_data_15 %>%
  select(-starts_with("PPLUS"))

# remove other program level information

institution_data_17 <- institution_data_16 %>%
  select(-starts_with("MTH"))

institution_data_18 <- institution_data_17 %>%
  select(-starts_with("PCI"))

institution_data_19 <- institution_data_18 %>%
  select(-starts_with("PRGMOFR"))

# remove counts of students for earnings

institution_data_20 <- institution_data_19 %>%
  select(-starts_with("COUNT"))

# export output (2381 obs of 983 variables)

write_csv(institution_data_20, "data/college_data.csv")


# recoding regions

fiftystates <- read_csv("fiftystatesCAN.csv")

fifty_states_revised <- fiftystates %>%
  mutate(
    REGION_CODE = case_when(
    GeoRegion == "NewEngland" ~ '1',
    GeoRegion == "MidAtlantic" ~ '2',
    GeoRegion == "MidWest" ~ '3',
    GeoRegion == "Plains" ~ '4',
    GeoRegion == "South" ~ '5',
    GeoRegion == "SouthWest" ~ '6',
    GeoRegion == "West" ~ '7',
    GeoRegion == "Pacific" ~ '8',
    )
  )

# ifelse(fiftystates$GeoRegion=="NewEngland", fiftystates$REGION_CODE<-1,
#       ifelse(fiftystates$GeoRegion=="MidAtlantic", fiftystates$REGION_CODE<-2,
#       ifelse(fiftystates$GeoRegion=="MidWest", fiftystates$REGION_CODE<-3,
#       ifelse(fiftystates$GeoRegion=="Plains", fiftystates$REGION_CODE<-4,
#      ifelse(fiftystates$GeoRegion=="South", fiftystates$REGION_CODE<-5,
#      ifelse(fiftystates$GeoRegion=="SouthWest", fiftystates$REGION_CODE<-6,
#      ifelse(fiftystates$GeoRegion=="West", fiftystates$REGION_CODE<-7,
#      ifelse(fiftystates$GeoRegion=="Pacific", fiftystates$REGION_CODE<-8,
#      fiftystates$REGION_CODE<-"NA"
#      ))))))))

write_csv(fifty_states_revised, "fiftystates.csv")
