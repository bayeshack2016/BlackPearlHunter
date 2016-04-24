#State Data

plot_by_zip <- function(final_zip, state, yr, alpha)
{
  all_states <- map_data("state")
  state_data = all_states[tolower(all_states$region)==tolower(state),]
  by_zipcode = final_zip[final_zip$year==yr,]
  data(zipcode)
  Total <- merge(by_zipcode, zipcode, by.x="ZIP.Code",by.y="zip")
  state_zipcode = Total[tolower(Total$State)==tolower(state),]
  p <- ggplot()
  p <- p + geom_polygon(data=state_data, aes(x=long, y=lat,group=group),col="black", fill='white')
  p <- p +geom_point(aes(x = longitude, y = latitude,col=Percent.Opioid.Claims), data = state_zipcode,alpha=alpha)+ scale_colour_gradient(limits=c(0, 40), low="blue", high="red")
  p + theme_bw()
}

get_locality_data <-function(county_date, state,yr)
{
  colors = c("#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77","#980043")
  county_data <- county_date[county_date$year==yr,]
  data(county.fips)
  out = merge(county_data,county.fips,by.x='FIPS',by.y='fips')
  state_data = out[tolower(out$State)==tolower(state),]
  state_data$colorBuckets <- as.numeric(cut(state_data$Percent.Opioid.Claims, c(0, 2, 4, 6, 8, 
                                                                                10, 100)))
  map("county", state,col = colors[state_data$colorBuckets], fill = TRUE, resolution = 0, 
      lty = 0, projection = "polyconic")
  title("Percent Opioid Claims")
  
  leg.txt <- c("<2%", "2-4%", "4-6%", "6-8%", "8-10%", ">10%")
  legend("right",leg.txt, horiz = FALSE, fill = colors)
}

plot_maps <- function(final_states, yr)
{
  all_states <- map_data("state")
  state = final_states[final_states$year==yr,]
  Total <- merge(all_states, state, by="region")
  p <- ggplot()
  p <- p + geom_polygon(data=Total, aes(x=long, y=lat,group = group, fill=Total$Percent.Opioid.Claim),colour="white")
  p <- p + scale_fill_continuous(low = "green", high = "red", guide="colorbar")
  p <- p + theme_bw() + labs(fill = "Percentage Opioid Claim Rate" 
                               ,title = "Percentage Opioid Claim Rate by State", x="", y="")
  p <- p + scale_y_continuous(breaks=c()) + scale_x_continuous(breaks=c()) + theme(panel.border =  element_blank())
  p <- p + coord_equal(ratio = 1)
  p
}

create_data <- function(input_data,column='Percent.Opioid.Claims') {
  out_data = data.frame()
  c = 1999:2020
  n = nrow(input_data)
  new_data = input_data
  new_data['year']=c[1]
  out_data = rbind(out_data,new_data)
  for(i in 2:length(c))
  {
    new_data = input_data
    new_data['year']=c[i]
    new_data['Percent.Opioid.Claims'] = runif(n,0,10)
    out_data = rbind(out_data,new_data)
  } 
  return(out_data)
}




