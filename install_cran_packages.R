install.packages('pak')

packages <- read.csv('settings/cran_packages.csv')$package

pak::pkg_install(packages)