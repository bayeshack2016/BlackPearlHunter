setwd('/Users/ranand/Desktop/bayeshack/opioid/')

library(ggplot2)
library(data.table)
library(directlabels)
library(shiny)

source(file = 'src/functions.R')

#agg_state <- fread('data/state_agg_data.tsv')
#agg_county <- fread('data/county_agg_data.tsv')
#agg_zipcode <- fread('data/zipcode_agg_data.tsv')

#death_demographics <- fread('data/oos_by_cause_of_death_demographics_nationwide.txt')
#death_state <- fread('data/oos_by_cause_of_death_state_level.txt')
#demographics_state <- fread('data/oos_by_demographics_state_level.txt')

#clean_death_demographics()
#clean_death_state()
clean_demographics_state()

states <- sort(append('ALL',unique(demographics_state$State)))
gender <- sort(append('ALL',unique(demographics_state$Gender)))
ageGroups <- sort(append('ALL',unique(demographics_state$age_grp)))
race <- sort(append('ALL',unique(demographics_state$Race)))

shinyUI(navbarPage("Black Pearl Hunter",
                   tabPanel("Analysis",
                            sidebarLayout(
                              sidebarPanel(
                                width = 3,
                                selectInput(inputId = 'state', 
                                            label = 'Select State', 
                                            choices = states, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'gender', 
                                            label = 'Select Gender', 
                                            choices = gender, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'age', 
                                            label = 'Select Age-Group', 
                                            choices = ageGroups, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'race', 
                                            label = 'Select Race', 
                                            choices = race, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'group_compare', 
                                            label = 'Group Compare', 
                                            choices = c('State', 'Gender', 'age_grp', 'Race'),
                                            selected = 'gender'),
                                
                                numericInput(inputId = 'n',
                                            label = '# of DataPoints',
                                            value = 6
                                            )
                                
                                #actionButton('predPlot',"Predictions")
                                
                              ),
                              
                              mainPanel(
                                width = 9,
                                tableOutput('sampleData'),
                                plotOutput('plot1')
                              )
                            ))
                   ))






