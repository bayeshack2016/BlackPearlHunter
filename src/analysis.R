rm(list = ls())
setwd('/Users/ranand/Desktop/bayeshack/opioid/')

library(ggplot2)
library(data.table)
library(directlabels)

source(file = 'src/functions.R')

#agg_state <- fread('data/state_agg_data.tsv')
#agg_county <- fread('data/county_agg_data.tsv')
#agg_zipcode <- fread('data/zipcode_agg_data.tsv')

death_state <- fread('data/oos_by_cause_of_death_state_level.txt')
demographics_state <- fread('data/oos_by_demographics_state_level.txt')

clean_death_demographics()
clean_death_state()
clean_demographics_state()

demographics_state









