# Setting an R environment from scratch 
# Step 1 - Import base image
FROM rocker/r-ver:4.4.0

# Step 2 - Set arguments and environment variables
# Define arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG CRAN_MIRROR=https://cran.rstudio.com/
ARG QUARTO_VER="1.4.554"

# Define environment variables
ENV VENV_NAME="r-reticulate"
ENV QUARTO_VER=$QUARTO_VER
ENV CONFIGURE_OPTIONS="--with-cairo --with-jpeglib --enable-R-shlib --with-blas --with-lapack"
ENV TZ=UTC
ENV CRAN_MIRROR=$CRAN_MIRROR

# Step 3 - Install R dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-launchpadlib \
    python3.10-dev \
    python3.10-venv \
    python3-pip \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libudunits2-dev \
    wget \
    libtiff-dev \
    libfontconfig1-dev \
    sudo \
    libcairo2-dev \
    openssl \
    libgdal-dev \
    libcairo2-dev \
    cmake

    # Step 4 - Install R

WORKDIR /root

RUN mkdir settings

RUN apt install -y git libgit2-dev

RUN R -e "install.packages(c('duckdb','arrow'),Ncpu=parallel::detectCores())"
RUN R -e "install.packages('sf',Ncpu=parallel::detectCores())"
RUN R -e "install.packages('tidyverse',Ncpu=parallel::detectCores())"
RUN R -e "install.packages('ggmap')"
RUN R -e "install.packages('jsonlite',Ncpu=parallel::detectCores())"
RUN R -e "install.packages(c('dlm','KFAS','reticulate'))"
RUN R -e "install.packages(c('httpgd','languageserver','tidygeocoder','janitor','RJSONIO','remotes','healthyAddress','furrr','bench','remotes'),Ncpu=parallel::detectCores())"
RUN R -e "remotes::install_github('wfmackey/absmapsdata')"
RUN R -e "remotes::install_github('runapp-aus/strayr')"
RUN R -e "Sys.setenv(RETICULATE_PYTHON='/usr/bin/python3')" #just use the system python

COPY install_quarto.sh ./settings/

# Installing Quarto
RUN bash ./settings/install_quarto.sh $QUARTO_VER
COPY .Rprofile /root/


COPY requirements.txt ./settings
RUN pip3 install -r ./settings/requirements.txt