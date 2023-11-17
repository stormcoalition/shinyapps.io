
main.txt <- reactiveVal()

output$main <- renderUI({
  
  
  print(main.txt)
  shiny::includeMarkdown("md/2023/Hwy400Expansion.md")
  # shiny::includeMarkdown("md/Hwy400Expansion.md")  "md/King-Bathurst.md"
  # HTML(markdown::markdownToHTML(knit("./md/Hwy400Expansion.md", quiet = TRUE)))
  
})