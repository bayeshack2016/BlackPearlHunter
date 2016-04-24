#setwd('/Users/ranand/Desktop/bayeshack/opioid/src/BlackPearlHunter/')

library(ggplot2)
library(data.table)
library(directlabels)
library(shiny)
library(TTR)

source(file = 'functions.R')
source(file = 'maps_out.R')

#agg_state <- fread('state_agg_data.tsv')
#agg_county <- fread('county_agg_data.tsv')
#agg_zipcode <- fread('zipcode_agg_data.tsv')

#death_demographics <- fread('oos_by_cause_of_death_demographics_nationwide.txt')
#death_state <- fread('oos_by_cause_of_death_state_level.txt')
#demographics_state <- fread('oos_by_demographics_state_level.txt')

#clean_death_demographics()
#clean_death_state()
clean_demographics_state()

states <- sort(append('ALL',unique(demographics_state$State)))
gender <- sort(append('ALL',unique(demographics_state$Gender)))
ageGroups <- sort(append('ALL',unique(demographics_state$age_grp)))
race <- sort(append('ALL',unique(demographics_state$Race)))

shinyUI(navbarPage("Black Pearl Hunter",
                   tabPanel("Analyze",
                            sidebarLayout(
                              sidebarPanel(
                                width = 3,
                                selectInput(inputId = 'state', 
                                            label = 'Select State', 
                                            choices = states, 
                                            selected = c('California', 'Texas', 'Florida', 'New York', 'Illinois'),
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
                                            choices = c('State', 'Gender', 'age_group', 'Race'),
                                            selected = 'gender'),
                                
                                numericInput(inputId = 'n',
                                            label = '# of DataPoints',
                                            value = 2
                                            ),
                                
                                actionButton('getAggData',"Get Data")
                                
                              ),
                              
                              mainPanel(
                                width = 9,
                                plotOutput('plot1'),
                                tableOutput('sampleData'),
                                tableOutput('aggData')
                              )
                            )),
                   
                   tabPanel("Forecast",
                            sidebarLayout(
                              sidebarPanel(
                                width = 3,
                                selectInput(inputId = 'stateF', 
                                            label = 'Select State', 
                                            choices = states, 
                                            selected = c('California', 'Texas', 'Florida', 'New York', 'Illinois'),
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'genderF', 
                                            label = 'Select Gender', 
                                            choices = gender, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'ageF', 
                                            label = 'Select Age-Group', 
                                            choices = ageGroups, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                selectInput(inputId = 'raceF', 
                                            label = 'Select Race', 
                                            choices = race, 
                                            selected = 'ALL',
                                            multiple = TRUE),
                                
                                numericInput(inputId = 'n_pred',
                                             label = '# Predictions',
                                             value = 2),
                                
                                actionButton('predPlot',"Predictions")
                                
                              ),
                              
                              mainPanel(
                                width = 9,
                                plotOutput('plot2')
                                #plotOutput('plot3')
                                #tableOutput('outputDataF')
                              )
                            )),
                   tabPanel("Actionize",
                            sidebarLayout(
                              sidebarPanel(
                                width = 3,
                                selectInput(inputId = 'stateP', 
                                            label = 'Select State', 
                                            choices = states, 
                                            selected = 'ALL'),
                                
                                sliderInput(inputId = 'yearP', 
                                            label = 'Select Year',
                                            min = 1999,
                                            max = 2020,
                                            value = 2010),
                                
                                sliderInput(inputId = 'alphaP', 
                                            label = 'Select Agg Density',
                                            min = 0,
                                            max = 1,
                                            value = 0.5)
                                
                              ),
                              
                              mainPanel(
                                width = 9,
                                plotOutput('plot4'),
                                plotOutput('plot5')
                              )
                            ))
                   ))






