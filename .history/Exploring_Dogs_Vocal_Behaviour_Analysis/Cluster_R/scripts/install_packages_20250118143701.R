# Install required packages if they're not already installed
required_packages <- c(
  "tidyverse",
  "cluster",
  "factoextra",
  "readxl",
  "hopkins",
  "gridExtra",
  "knitr"
)

# Function to install missing packages
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    install.packages(new_packages, repos = "https://cloud.r-project.org")
  }
}

# Install missing packages
install_if_missing(required_packages)

# Print confirmation
cat("Package installation complete!\n")
cat("The following packages are now available:\n")
for(pkg in required_packages) {
