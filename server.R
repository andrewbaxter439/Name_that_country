library(shiny)
library(ggplot2)
library(dplyr)
# library(rnaturalearth)
# library(broom)
library(stringr)
library(gtools)

server <- function(input, output) {
  
  
  # setup dataset ----------------------------------------------------------------------------------------------
  
  # earth <- ne_countries()
  # 
  # tidyearth <- suppressWarnings(tidy(earth))
  # countries <- tibble(id=row.names(earth@data),country=earth$name)
  # 
  # earth_n <- left_join(tidyearth, countries, by = "id")
  earth_n <- read.csv("earth_data.csv", stringsAsFactors = FALSE)
  

# reactive elements ------------------------------------------------------------------------------------------

  n <- eventReactive(input$update, {
    earth_n %>% 
    filter(!grepl(" ", country)) %>%
      select(id) %>% 
      unique() %>% 
      pull() %>% 
      base::sample(., 1)
  }, ignoreNULL = FALSE)
  
  highlight <- reactive({
    earth_n %>% 
      filter(id == n())
  })
  
  c_name <- reactive({
    earth_n %>% 
      filter(id == n()) %>% 
      select(country) %>% 
      unique() %>% 
      pull()
  })
  
  
  letters <- reactive({
    str_split(c_name(), "", simplify = TRUE)[1,]
  })
  
  typedLetters <- reactiveValues(
    text = c("..."),
    letterNum = 1,
    letterguess = ""
  )
  
  observeEvent(input$update, {
      typedLetters$text <- c("...")
      typedLetters$letterNum = 1
  })

  output$c_typing <- renderText({
    typedLetters$letterguess <- ifelse(is.null(chr(input$letterpress)),"",chr(input$letterpress))
    isolate({
      if (typedLetters$letterNum - 1 == length(letters())){
        return(str_flatten(typedLetters$text))
      } else if (str_to_lower(letters()[typedLetters$letterNum]) == str_to_lower(typedLetters$letterguess)){
        if (typedLetters$text[1] == "..."){
          typedLetters$text[1] <- letters()[1]
          typedLetters$letterNum <- typedLetters$letterNum + 1
        } else {
          typedLetters$text <- c(typedLetters$text, letters()[typedLetters$letterNum])
          typedLetters$letterNum <- typedLetters$letterNum + 1
        }
      }
    })
    return(str_flatten(typedLetters$text))
  })
  
  
  output$c_title <- renderText({
    ifelse(input$hard, "...", c_name())
    })
  # output$c_title2 <- renderText(c_name())
  
  focus <- reactive({
    highlight() %>% 
    filter(piece == "1") %>% 
    summarise(lat = mean(lat), long = mean(long)) %>% 
    as.numeric()
  })
    
  output$map <- renderPlot({
    earth_n %>% 
      ggplot(aes(long, lat, group = group)) +
      geom_polygon(fill = "green", col = "white") +
      geom_polygon(data = highlight(), fill = "purple") +
      theme_void() +
      coord_map(projection = "orthographic", orientation = c(focus(), 0),
                xlim = c(focus()[2]-45, focus()[2]+45),
                ylim = c(focus()[1]-45, focus()[1]+45)
                )
  })
}