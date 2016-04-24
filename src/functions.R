clean_demographics_state <- function(){
  demographics_state <- fread('data/oos_by_demographics_state_level.txt')
  demographics_state$Notes <- NULL
  demographics_state$`State Code` <- NULL
  demographics_state$`Year Code` <- NULL
  demographics_state$`Ten-Year Age Groups` <- NULL
  demographics_state$age_grp <- demographics_state$`Ten-Year Age Groups Code`
  demographics_state$`Ten-Year Age Groups Code` <- NULL
  death_demographics$Race <- gsub(" ","_",death_demographics$Race)
  demographics_state$Gender <- demographics_state$`Gender Code`
  demographics_state$`Gender Code` <- NULL
  demographics_state$`Race Code` <- NULL
  demographics_state$`Crude Rate` <- NULL  
  demographics_state$deathPerMilli <- demographics_state$Deaths * 1000000 / demographics_state$Population
  demographics_state <<- demographics_state
}

clean_death_state <- function(){
  death_state <- fread('data/oos_by_cause_of_death_state_level.txt')
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
  death_state$deathPerMilli <- death_state$Deaths * 1000000 / death_state$Population
  death_state <<- death_state
}

clean_death_demographics <- function(){
  death_demographics <- fread('data/oos_by_cause_of_death_demographics_nationwide.txt')
  death_demographics$Notes <- NULL
  death_demographics$`Year Code` <- NULL
  death_demographics$`Multiple Cause of death Code` <- NULL
  death_demographics$`Ten-Year Age Groups` <- NULL
  death_demographics$`Race Code` <- NULL
  death_demographics$`% of Total Deaths` <- NULL
  death_demographics$`Crude Rate` <- NULL
  death_demographics$Race <- gsub(" ","_",death_demographics$Race)
  death_demographics$mcd <- death_demographics$`Multiple Cause of death`
  death_demographics$age_grp <- death_demographics$`Ten-Year Age Groups Code`
  death_demographics$Gender <- death_demographics$`Gender Code`
  death_demographics$`Gender Code` <- NULL
  death_demographics$`Multiple Cause of death` <- NULL
  death_demographics$`Ten-Year Age Groups Code` <- NULL
  death_demographics$mcd <- gsub(" ","_",death_demographics$mcd)
  death_demographics$Population <- as.numeric(death_demographics$Population)
  death_demographics$deathPerMilli <- death_demographics$Deaths * 1000000 / death_demographics$Population
  death_demographics <<- death_demographics
}





# death_demographics$combi <- gsub(" ", "", paste(death_demographics$Gender,
#                                   #death_demographics$Race,
#                                   death_demographics$mcd,
#                                   #death_demographics$age_grp,
#                                   sep = '_'))

# agg <- aggregate(cbind(death_demographics$Deaths, death_demographics$Population), 
#           by=list(year = death_demographics$Year, combi = death_demographics$combi), 
#           FUN = function(x){sum(x, na.rm=TRUE)})
# agg$deathperMillion <- agg$V1*1000000 / agg$V2

# p <- ggplot(data = agg, aes(x = year, y=deathperMillion, group=combi))
# p <- p + geom_line(aes(color = combi))
# p <- p + theme(legend.position="none")
# p <- p + theme(axis.text.x = element_text(angle = 45))
# p <- p + geom_dl(aes(label=combi),method=list(dl.trans(x=x+0.01), "last.qp", cex=0.6, rot=45))
# p <- p + theme(axis.title.y = element_blank()) + guides(color=TRUE)
# p + scale_x_discrete(expand=c(0,1))

