# Example R script with plots

# Load necessary libraries
# If ggplot2 isn't installed, uncomment the install.packages line below
# install.packages("ggplot2")
library(ggplot2)

# ----------------------------------------
# Base R Plotting Example
# ----------------------------------------

# Generate sample data
set.seed(123)
x <- rnorm(100, mean = 10, sd = 2)
y <- 2.5 * x + rnorm(100, mean = 0, sd = 3)

# Create a basic scatter plot using base plotting system
plot(x, y,
     main = "Base R Scatter Plot",
     xlab = "X Values",
     ylab = "Y Values",
     pch = 19,   # solid circle
     col = "blue")

# Add a linear regression line to the plot
model <- lm(y ~ x)
abline(model, col = "red", lwd = 2)

# ----------------------------------------
# ggplot2 Plotting Example
# ----------------------------------------

# Create a data frame for ggplot2
data <- data.frame(x = x, y = y)

# Create a ggplot2 scatter plot with a regression line
p <- ggplot(data, aes(x = x, y = y)) +
  geom_point(color = "darkgreen", size = 2) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  labs(title = "ggplot2 Scatter Plot with Regression Line",
       x = "X Values",
       y = "Y Values") +
  theme_minimal()

# Print the ggplot object to produce the plot
print(p)

# ----------------------------------------
# Multiple Plots in a Single Window (Base R)
# ----------------------------------------

# Set up the plotting area to display 2 plots side by side
par(mfrow = c(1, 2))

# Plot 1: Histogram of X
hist(x,
     main = "Histogram of X",
     xlab = "X Values",
     col = "lightblue",
     border = "black")

# Plot 2: Boxplot of Y
boxplot(y,
        main = "Boxplot of Y",
        ylab = "Y Values",
        col = "orange")

# Reset plotting parameters to default (1 plot per window)
par(mfrow = c(1, 1))

# ----------------------------------------
# Save Plots to Files
# ----------------------------------------

# Save the ggplot2 plot to a file
ggsave("ggplot_scatter.png", plot = p, width = 6, height = 4)

# Save the base R plot (scatter plot with regression line) to a file
png(filename = "base_scatter_regression.png", width = 600, height = 400)
plot(x, y,
     main = "Base R Scatter Plot (Saved)",
     xlab = "X Values",
     ylab = "Y Values",
     pch = 19,   
     col = "blue")
abline(model, col = "red", lwd = 2)
dev.off()

# End of script
