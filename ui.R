ui <- fluidPage(
  tags$head(tags$style("#c_typing{color: blue;
                                 font-size: 40px;
                                 font-style: bold;
                                 }
                       #c_title{color: black;
                                 font-size: 40px;
                                 font-style: bold;
                                 }
                       #c_typing2{color: grey;
                       font-size:  40px
                       font-style: bold
                       }"
  )
  ),
  tags$script('
    $(document).on("keypress", function (e) {
       Shiny.onInputChange("letterpress", e.which);
    });
  '),
  # Application title
  br(),
  column(4, offset = 4, align = "center", titlePanel("Name that country!")),
  
  # plot and other parts
  plotOutput("map"),
  br(),
  br(),
  br(),
  br(),
  column(6, offset = 3, align = "center",   h1(strong(textOutput("c_title")))),
  column(6, offset = 3, align = "center",   h1(strong(textOutput("c_typing")))),
  # column(6, offset = 3, align = "center",   h1(strong(textOutput("c_typing2")))),
  column(4, offset = 4, align = "center", actionButton("update", "Next")),
  column(4, offset = 4, align = "center", checkboxInput(inputId = "hard", label = "Hard Mode", value = FALSE))
)

