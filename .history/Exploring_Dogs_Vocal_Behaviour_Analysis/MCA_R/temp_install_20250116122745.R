# Function to install and load required packages
install_and_load <- function(package_name) {
    if (!require(package_name, character.only = TRUE)) {
        install.packages(package_name, repos = "https://cran.rstudio.com/")
        library(package_name, character.only = TRUE)
    }
}

# Install and load required packages
install_and_load("ggplot2")
install_and_load("factoextra")
install_and_load("gridExtra")

cat("Package installation completed.\n")
