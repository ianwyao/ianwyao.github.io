##install.packages('plyr')
##install.packages('altair')
library("altair")
library("tibble")
library("dplyr")
library("tidyr")
library("jsonlite")
df1 = read.csv('./04_plugs/2012-06-30-01.csv',header = FALSE)
df2 <- cbind(time = rownames(df1), df1)
rownames(df2) <- 1:nrow(df2)
df2$Type = 'Fridge'

df3 = read.csv('./04_plugs/2012-06-30-02.csv',header = FALSE)
df4 <- cbind(time = rownames(df3), df3)
rownames(df4) <- 1:nrow(df4)
df4$Type = 'Kitchen_appliances'

df5 = read.csv('./04_plugs/2012-06-30-03.csv',header = FALSE)
df6 <- cbind(time = rownames(df5), df5)
rownames(df6) <- 1:nrow(df6)
df6$Type = 'Lamp'

df7 = read.csv('./04_plugs/2012-06-30-04.csv',header = FALSE)
df8 <- cbind(time = rownames(df7), df7)
rownames(df8) <- 1:nrow(df8)
df8$Type = 'Stereo_laptop'

df_f = do.call("rbind", list(df2, df4, df6, df8))

df_final = df_f[seq(1, nrow(df_f), 300), ]
df_final$Time = as.numeric(df_final$time)/3600
# Create a selection that chooses the nearest point & selects based on x-value
nearest <- alt$selection(
  type = "single", 
  nearest = TRUE, 
  on = "mouseover",
  fields = list("Time"), 
  empty = "none"
)

# The basic line
line <- 
  alt$Chart(data = df_final)$
  mark_line(interpolate = "basis")$
  encode(
    x = "Time:Q",
    y = "V1:Q",
    color = "Type:N"
  )

# Transparent selectors across the chart. This is what tells us
# the x-value of the cursor
selectors <- 
  alt$Chart(data = df_final)$
  mark_point()$
  encode(
    x = "Time:Q",
    opacity = alt$value(0)
  )$
  properties(selection = nearest)$
  copy()

# Draw points on the line, and highlight based on selection
points <-
  line$
  mark_point()$
  encode(
    opacity = alt$condition(nearest, alt$value(1), alt$value(0))
  )

# Draw text labels near the points, and highlight based on selection
text <- 
  line$
  mark_text(align = "left", dx = 5, dy = -5)$
  encode(
    text = alt$condition(nearest, "V1:Q", alt$value(" "))
  )

# Draw a rule at the location of the selection
rules <- 
  alt$Chart(data = df_final)$
  mark_rule(color = "gray")$
  encode(
    x = "Time:Q"
  )$
  transform_filter(nearest$ref())

# Put the five layers into a chart and bind the data
chart <-  
  (line + selectors + points + rules + text)$
  properties( width = 600, height = 300,title = 'Real power consumption by different electric appliances')

chart

