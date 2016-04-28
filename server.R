#setwd('/Users/ranand/Desktop/bayeshack/opioid/src/BlackPearlHunter/')

library(plotly)
library(maps)
library(zipcode)
library(mapproj)
library(ggplot2)
library(data.table)
library(directlabels)
library(shiny)
library(TTR)
library(forecast)

source(file = 'functions.R')
source(file = 'maps_out.R')

zip_data <- read.table("zipcode_agg_data.tsv",sep='\t',header=TRUE)
state <- read.table("state_agg_data.tsv",sep='\t',header=TRUE)
county_data <- read.table("county_agg_data.tsv",sep='\t',header=TRUE)

state['region'] <- sapply(state$State,tolower)

final_states <- create_data(state)
county_date <- create_data(county_data)
final_zip <- create_data(zip_data)

#agg_state <- fread('state_agg_data.tsv')
#agg_county <- fread('county_agg_data.tsv')
#agg_zipcode <- fread('zipcode_agg_data.tsv')

#death_demographics <- fread('oos_by_cause_of_death_demographics_nationwide.txt')
#death_state <- fread('oos_by_cause_of_death_state_level.txt')
#demographics_state <- fread('oos_by_demographics_state_level.txt')

#clean_death_demographics()
#clean_death_state()
clean_demographics_state()

i_states <- unique(demographics_state$State)
i_gender <- unique(demographics_state$Gender)
i_ageGroups <- unique(demographics_state$age_group)
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
                                      & age_group %in% c_ageGroups
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
    agg_data$deathPerMillion <- agg_data$deaths * 1000000 / agg_data$population
    agg_data
  
  })
  
  # observeEvent(input$getAggData, {
  #   output$aggData <- agg_data()
  # })
  
  output$plot1 <- renderPlotly({
    p <- ggplot(data = agg_data(), aes(x = year, y=deathPerMillion, group=agg_column))
    p <- p + geom_line(aes(color = agg_column))
    #p <- p + theme(legend.position="none") + 
    p <- p + ylab("Death Per Million")
    p <- p + theme(axis.text.x = element_text(angle = 45))
    # p <- p + geom_dl(aes(label=agg_column),method=list(dl.trans(x=x+0.01), "last.qp", cex=0.6, rot=45))
    #p <- p + guides(color=TRUE)
    #plot(p) #+ scale_x_discrete(expand=c(0,1))
    gg <- ggplotly(p)
    gg
  })
  
  forecast_data <- reactive({
    
    c_states <- c(input$stateF)
    c_gender <- c(input$genderF)
    c_ageGroups <- c(input$ageF)
    c_race <- c(input$raceF)
    
    if('ALL' %in% c(input$stateF)) c_states <- i_states
    if('ALL' %in% c(input$genderF)) c_gender <- i_gender
    if('ALL' %in% c(input$ageF)) c_ageGroups <- i_ageGroups
    if('ALL' %in% c(input$raceF)) c_race <- i_race
    
    subset_data <- demographics_state[State %in% c_states
                                      & Gender %in% c_gender
                                      & age_group %in% c_ageGroups
                                      & Race %in% c_race
                                      ]
    subset_data
  })
  
  
  agg_data_F <- reactive({
    raw_data <- forecast_data()
    
    agg_data <- aggregate(cbind(raw_data$Deaths, raw_data$Population),
                          by = list(raw_data[['Year']]),
                          FUN = function(x){sum(x, na.rm=TRUE)})
    
    names(agg_data) <- c('year','deaths', 'population')
    agg_data$deathPerMillion <- agg_data$deaths * 1000000 / agg_data$population
    agg_data
  })
  
  observeEvent(input$predPlot,{
    
    model_data <- agg_data_F()
    
    # len_data <- nrow(model_data)
    # 
    # sma_death <- SMA(model_data$deaths, 3)
    # sma_population <- SMA(model_data$population, 3)
    # deathPerMilli <- sma_death[len_data] * 1000000 / sma_population[len_data]
    # 
    # new_pred <- as.data.frame(t(as.data.frame(c('2015', deathPerMilli))))
    # names(new_pred) <- c('year', 'deathPerMilli')
    # old_data <- subset(model_data, select = c('year', 'deathPerMilli'))
    # 
    # point <- deathPerMilli
    # 
    # new_data <- as.data.frame(rbind(old_data, new_pred))
    # new_data$deathPerMilli <- as.numeric(new_data$deathPerMilli)
    # #output$outputDataF <- renderTable({new_data})
    # output$plot2 <- renderPlot({
    #   p <- ggplot(data = new_data, aes(x = year, y=deathPerMilli, group=1))
    #   p <- p + geom_line(aes(col='red'))
    #   p <- p + geom_point(aes(x = '2015', y = point), size = 3, col = 'blue')
    #   p
    # })
    
    ts_data <- ts(model_data$deaths * 1000000 / model_data$population)
    ts_model <- HoltWinters(ts_data, gamma=FALSE)
    
    new_model <- forecast.HoltWinters(ts_model, h=input$n_pred)
    
    output$plot2 <- renderPlot({
      #plot(ts_model)
      plot.forecast(new_model)
      })
    
  })
  
  plot_data <- reactive({
    
    if(input$stateP == 'ALL'){
      subset_data <- demographics_state[Year == input$yearP]
    }
  
    else{
      subset_data <- demographics_state[Year == input$yearP
                                        & State == input$stateP]
    }
    subset_data
  })
  
  observeEvent(input$stateP,{
    source('maps_out.R')
    
    if(input$stateP == 'ALL'){
      output$plot4 <- renderPlot({plot_maps(final_states,input$yearP)})
      output$plot5 <- renderPlot({NULL})
    }
    
    else{
      output$plot4 <- renderPlot({get_locality_data(county_date,input$stateP, input$yearP)})
      output$plot5 <- renderPlot({plot_by_zip(final_zip,input$stateP,input$yearP,input$alphaP)})
    }
  })
  
  
})




