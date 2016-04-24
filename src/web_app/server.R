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

i_states <- unique(demographics_state$State)
i_gender <- unique(demographics_state$Gender)
i_ageGroups <- unique(demographics_state$age_grp)
i_race <- unique(demographics_state$Race)

shinyServer(function(input, output) {
    
  subset_data <- reactive({
    
    c_states <- c(input$state)
    c_gender <- c(input$gender)
    c_ageGroups <- c(input$age)
    c_race <- c(input$race)
    
    if('ALL' %in% c(input$state)) c_states <- i_states
    if('ALL' %in% c(input$gender)) c_gender <- i_gender
    if('ALL' %in% c(input$age)) c_ageGroups <- i_ageGroups
    if('ALL' %in% c(input$race)) c_race <- i_race
    
    subset_data <- demographics_state[State %in% c_states
                                      & Gender %in% c_gender
                                      & age_grp %in% c_ageGroups
                                      & Race %in% c_race
                                      ]
  })
  
  agg_data <- reactive({
  output$sampleData <- renderTable({head(subset_data(), input$n)})

  raw_data <- subset_data()
  
  agg_data <- aggregate(cbind(raw_data$Deaths, raw_data$Population),
                        by = list(raw_data[['Year']], raw_data[[input$group_compare]]),
                        FUN = function(x){sum(x, na.rm=TRUE)})
  
  names(agg_data) <- c('year','agg_column','deaths', 'population')
  agg_data$deathPerMilli <- agg_data$deaths * 1000000 / agg_data$population
  agg_data
  
  })
  
  output$plot1 <- renderPlot({
    p <- ggplot(data = agg_data(), aes(x = year, y=deathPerMilli, group=agg_column))
    p <- p + geom_line(aes(color = agg_column))
    p <- p + theme(legend.position="none")
    p <- p + theme(axis.text.x = element_text(angle = 45))
    p <- p + geom_dl(aes(label=agg_column), 
                     method=list(dl.trans(x=x+0.01), "last.qp", cex=0.6, rot=45))
    p <- p + theme(axis.title.y = element_blank()) + guides(color=TRUE)
    plot(p) #+ scale_x_discrete(expand=c(0,1))
  
  })
  
})




