library(gt)
library(tidyverse)

films <- read_csv("https://data.sfgov.org/resource/yitu-d5am.csv?$limit=999999")

set.seed(2)
my_films <- films |> 
  select(1:11, -fun_facts, -locations, -distributor) |>
  filter(if_all(starts_with("actor"), \(x) !is.na(x))) |> 
  distinct() |> 
  mutate(gross = sample(100000:999999, size = n())) |> 
  group_by(production_company) |> 
  filter(n() >= 3) |> 
  slice_sample(n = 3) |> 
  ungroup() |> 
  arrange(production_company, release_year) |> 
  slice_tail(n = 12) |> 
  mutate(title_year = glue::glue("{title} ({release_year})")) |> 
  select(-release_year, -title)

glimpse(my_films)

my_films |> 
  gt()

# Add groups and rows
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year")

# Add header and source note
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))
  

# Add 'spanners'
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))

# Formatters
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))

# Rename columns
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross"
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))

# Add style
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross"
  ) |> 
  tab_style(
    style = list(
      cell_text(
        style = "italic",
        align = "right"
      )
    ),
    locations = cells_stub()
  ) |> 
  tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = cells_row_groups()
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))

# Conditional formatting
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross"
  ) |> 
  tab_style(
    style = list(
      cell_text(
        style = "italic",
        align = "right"
      )
    ),
    locations = cells_stub()
  ) |> 
  tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = cells_row_groups()
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))


# Add summary rows
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross"
  ) |> 
  tab_style(
    style = list(
      cell_text(
        style = "italic",
        align = "right"
      )
    ),
    locations = cells_stub()
  ) |> 
  tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = cells_row_groups()
  ) |> 
  summary_rows(
    columns = gross,
    fns = list(Total = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  grand_summary_rows(
    columns = gross,
    fns = list(`Grand Total` = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))

# Conditional coloring 
my_films |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross"
  ) |> 
  tab_style(
    style = list(
      cell_text(
        style = "italic",
        align = "right"
      )
    ),
    locations = cells_stub()
  ) |> 
  tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = cells_row_groups()
  ) |> 
  summary_rows(
    columns = gross,
    fns = list(Total = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  grand_summary_rows(
    columns = gross,
    fns = list(`Grand Total` = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  data_color(
    columns = gross,
    palette = "Greens"
  ) |> 
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)"))

# gtExtras bars
films_table <- my_films |> 
  mutate(gross2 = gross, .after = gross) |> 
  group_by(production_company) |> 
  gt(rowname_col = "title_year") |> 
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |>
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross",
    gross2 = ""
  ) |> 
  tab_style(
    style = list(
      cell_text(
        style = "italic",
        align = "right"
      )
    ),
    locations = cells_stub()
  ) |> 
  tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = cells_row_groups()
  ) |> 
  summary_rows(
    columns = gross,
    fns = list(Total = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  grand_summary_rows(
    columns = gross,
    fns = list(`Grand Total` = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  gtExtras::gt_plt_bar_pct(
    column = gross2,
    fill = "darkgreen",
    width = 1900
  ) 

# themes
films_table |> 
  gtExtras::gt_theme_538()

#images
my_films |> 
  head(3) |>
  mutate(film_img = c(
    "https://upload.wikimedia.org/wikipedia/commons/a/a7/All_About_Eve_%281950_poster_-_retouch%29.jpg",
    "https://upload.wikimedia.org/wikipedia/en/5/5e/The_House_on_Telegraph_Hill_Poster.jpg",
    "https://upload.wikimedia.org/wikipedia/en/e/ed/The-internship-poster.jpg"
    )
  ) |>
  relocate(film_img, .before = director) |>
  mutate(gross2 = gross) |> 
  group_by(production_company) |>
  gt(rowname_col = "title_year") |> # rowname_col = "title_year"
  tab_header(
    md("**A Sprinkle of San Francisco Cinema**"),
    "Three Films from Three Production Companies"
  ) |> 
  tab_spanner(
    "Cast",
    columns = starts_with("actor")
  ) |> 
  tab_spanner(
    "Staff",
    columns = c(director, writer)
  ) |> 
  fmt_currency(
    columns = gross,
    decimals = 0
  ) |> 
  gtExtras::gt_plt_bar_pct(
    column = gross2,
    fill = "darkgreen"
  ) %>%
  cols_label(
    starts_with("actor") ~ "",
    director = "Director",
    writer = "Writer",
    gross = "Gross",
    gross2 = "",
    film_img = ""
  ) |> 
  tab_style(
    style = list(
      cell_text(
        style = "italic",
        align = "right"
        )
    ),
    locations = cells_stub()
  ) |> 
  tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = cells_row_groups()
  ) |> 
  summary_rows(
    columns = gross,
    fns = list(Total = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  grand_summary_rows(
    columns = gross,
    fns = list(`Grand Total` = ~sum(.)),
    formatter = fmt_currency,
    decimals = 0
  ) |> 
  gtExtras::gt_img_rows(
    columns = film_img,
    height = 200
    ) |>
  tab_source_note(md("Source: ['Film Locations in San Francisco', DataSF | Open Data Portal](https://data.sfgov.org/Culture-and-Recreation/Film-Locations-in-San-Francisco/yitu-d5am/about_data)")) |> 
  gtExtras::gt_theme_538()

# ChatGPT

# Prepare and slightly modify the dataset
mtcars_tbl <- mtcars %>%
  rownames_to_column(var = "car") %>%
  mutate(
    cyl = factor(cyl),
    mpg_rating = case_when(
      mpg >= 25 ~ "Excellent",
      mpg >= 20 ~ "Good",
      TRUE ~ "Average"
    )
  )

# Create the fancy gt table
mtcars_tbl %>%
  select(car, mpg, mpg_rating, cyl, hp, wt, qsec) %>%
  gt(rowname_col = "car") %>%
  
  # Add title and subtitle
  tab_header(
    title = md("**Fuel Efficiency and Performance: mtcars Dataset**"),
    subtitle = md("A showcase of `gt` package features")
  ) %>%
  
  # Add source note
  tab_source_note(
    source_note = md("Data from R's built-in `mtcars` dataset.")
  ) %>%
  
  # Format numbers
  fmt_number(
    columns = c(mpg, hp, wt, qsec),
    decimals = 2
  ) %>%
  
  # Add color scale to mpg
  data_color(
    columns = mpg,
    colors = scales::col_numeric(
      palette = c("lightblue", "darkblue"),
      domain = NULL
    )
  ) %>%
  
  # Add bar plots inside columns
  gtExtras::gt_plt_bar_pct(
    column = hp,
    scaled = TRUE,
    fill = "darkgreen"
  ) %>%
  
  # Format categorical column
  text_transform(
    locations = cells_body(columns = mpg_rating),
    fn = function(x) {
      dplyr::case_when(
        x == "Excellent" ~ glue::glue("<span style='color:green;'>{x}</span>"),
        x == "Good" ~ glue::glue("<span style='color:orange;'>{x}</span>"),
        TRUE ~ glue::glue("<span style='color:red;'>{x}</span>")
      )
    }
  ) %>%
  
  # Rename column labels
  cols_label(
    mpg = "Miles/Gallon",
    mpg_rating = "MPG Rating",
    cyl = "Cylinders",
    hp = "Horsepower",
    wt = "Weight",
    qsec = "1/4 mile time"
  ) %>%
  
  # Add column spanner
  tab_spanner(
    label = "Performance Metrics",
    columns = c(hp, qsec)
  ) %>%
  
  # Highlight specific rows
  tab_style(
    style = cell_fill(color = "lightyellow"),
    locations = cells_body(rows = mpg > 30)
  ) %>%
  
  # Align text
  cols_align(
    align = "center",
    columns = everything()
  ) %>%
  
  # Style the table
  # opt_table_font(font = list(
  #   google_font(name = "Roboto Mono"),
  #   default_fonts()
  # )) %>%
  opt_row_striping() %>%
  opt_stylize(style = 3) # Apply a built-in GT theme


# gtsummary for regression tables
library(gtsummary)
m <- lm(mpg ~ wt + factor(cyl), data = mtcars)
tbl_regression(m)

