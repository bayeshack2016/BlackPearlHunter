clean_demographics_state <- function(){
  demographics_state <- fread('oos_by_demographics_state_level.txt')
  demographics_state$Notes <- NULL
  demographics_state$`State Code` <- NULL
  demographics_state$`Year Code` <- NULL
  demographics_state$`Ten-Year Age Groups` <- NULL
  demographics_state$age_group <- demographics_state$`Ten-Year Age Groups Code`
  demographics_state$`Ten-Year Age Groups Code` <- NULL
  demographics_state$Race <- gsub(" ","_",demographics_state$Race)
  demographics_state$Gender <- demographics_state$`Gender Code`
  demographics_state$`Gender Code` <- NULL
  demographics_state$`Race Code` <- NULL
  demographics_state$`Crude Rate` <- NULL  
  demographics_state$deathPerMillion <- demographics_state$Deaths * 1000000 / demographics_state$Population
  demographics_state <<- demographics_state
}

clean_death_state <- function(){
  death_state <- fread('oos_by_cause_of_death_state_level.txt')
  death_state$Notes <- NULL
  death_state$`State Code` <- NULL
  death_state$`Year Code` <- NULL
  death_state$ucd <- death_state$`Underlying Cause of death`
  death_state$`Underlying Cause of death` <- NULL
  death_state$`Underlying Cause of death Code` <- NULL
  death_state$`Multiple Cause of death Code` <- NULL
  death_state$`Crude Rate` <- NULL
  death_state$mcd <- death_state$`Multiple Cause of death`
  death_state$`Multiple Cause of death` <- NULL
  death_state$mcd <- gsub(" ","_",death_state$mcd)
  death_state$deathPerMillion <- death_state$Deaths * 1000000 / death_state$Population
  death_state <<- death_state
}

clean_death_demographics <- function(){
  death_demographics <- fread('oos_by_cause_of_death_demographics_nationwide.txt')
  death_demographics$Notes <- NULL
  death_demographics$`Year Code` <- NULL
  death_demographics$`Multiple Cause of death Code` <- NULL
  death_demographics$`Ten-Year Age Groups` <- NULL
  death_demographics$`Race Code` <- NULL
  death_demographics$`% of Total Deaths` <- NULL
  death_demographics$`Crude Rate` <- NULL
  death_demographics$Race <- gsub(" ","_",death_demographics$Race)
  death_demographics$mcd <- death_demographics$`Multiple Cause of death`
  death_demographics$age_group <- death_demographics$`Ten-Year Age Groups Code`
  death_demographics$Gender <- death_demographics$`Gender Code`
  death_demographics$`Gender Code` <- NULL
  death_demographics$`Multiple Cause of death` <- NULL
  death_demographics$`Ten-Year Age Groups Code` <- NULL
  death_demographics$mcd <- gsub(" ","_",death_demographics$mcd)
  death_demographics$Population <- as.numeric(death_demographics$Population)
  death_demographics$deathPerMillion <- death_demographics$Deaths * 1000000 / death_demographics$Population
  death_demographics <<- death_demographics
}

