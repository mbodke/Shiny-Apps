library('shiny')
library('leaflet')
library('shinydashboard')



test = read.csv("Sacramentorealestatetransactions.csv")

max_sq_ft = max( test$sq__ft, na.rm = T)
max_price = max(test$price, na.rm = T)
temp = 24

#View(test)

header = dashboardHeader(
                          dropdownMenu(type = 'messages', 
                                      messageItem(from = 'Mansi',
                                                  message = 'Hello welcome to my first app'     ))
)
sidebar = dashboardSidebar(
                            sliderInput( 
                                          inputId = 'num',
                                          label = 'Scroll to see the third box react!',
                                          min = 0,
                                          max = 100,
                                          value = 10)
)
body = dashboardBody(
                      fluidRow(
                                valueBox(value = max_sq_ft , 
                                         subtitle = 'Biggest house in Sac' , 
                                         icon = icon('fire'))
                                ,
                                valueBox(value = max_price , 
                                        subtitle = 'Most expensive house in Sac' , 
                                        icon = icon('money'))
                                ,
                                valueBoxOutput('x')
                               )
                                ,
                      box(title = 'Sacremento Map marked with real-estate prices and sized by square footage',
                          #status = 'primary',
                          width = 13 ),
                                
                      fluidRow(
                                  leafletOutput('plot')      
                        
                                
                              )
                    

)


ui = dashboardPage(skin= 'green', header,sidebar, body)

server = function(input, output) {
                                    output$plot = renderLeaflet({
                                      leaflet()%>% 
                                                  addTiles() %>%
                                                                addCircleMarkers(
                                                                                  lng = test$longitude,
                                                                                  lat = test$latitude, 
                                                                                  radius = log(test$sq__ft), 
                                                                                  label = test$price, 
                                                                                  weight = 2
                                                                                )
                                      
                                    })
                                                                
                                    
                                    
                                    output$x = renderValueBox({
                                                              valueBox(value = temp,
                                                               subtitle = 'Trying reactive box with slider',
                                                               icon = icon('bulb'),
                                                               color = if(input$num < temp ){
                                                                                                 'blue'
                                                                                              }
                                                                       else{
                                                                                                 'green'
                                                                                               }
                                                                      )
                                                             })
                                    
                                                                    
                                                                  
                                   
                                      
                                    
}

shiny::shinyApp(ui, server)
