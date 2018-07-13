# This app 
#


library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Convert Chunked Txt Files Into Captions"),
  
  # Sidebar   
  sidebarLayout(
    sidebarPanel(
      
      h6("This app accepts multiple .txt files (chunked) - the output from the storyboard app
         when 'audio' is checked."),
      h6("It is critical that the txt files are from the storyboard app- because it orders them
         based on the number appended to it, i.e. each txt file should start with
         #-blahblah.  Where # is 1,2,3,...."),
      h6("it creates two .csv files which can be easily read in excel. The first is 
         a list of each slide name and the number of captions it has. The second is 
         all the caption chunks in a column for inserting into html code."),
      ## Select a file --- ,
      fileInput("the.files","Select all of your txt files",
                multiple = TRUE,
                accept = ".txt",
                buttonLabel = "Browse"),
      
      actionButton(inputId = "submit",label = "Run Program")
      ),
    
    # Main Panel
    mainPanel(
      textOutput("done")
    )
      )
))
