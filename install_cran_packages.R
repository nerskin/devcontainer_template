install.packages('pak',repos = 'cran.csiro.au')

packages <- read.csv('settings/cran_packages.csv')$package

pak::pkg_install(packages)
