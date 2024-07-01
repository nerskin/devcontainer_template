FROM rocker/r-ver:4.4

ARG QUART0_VER="1.4.554"

RUN apt update
RUN apt install -y git vim libcurl4-openssl-dev

RUN apt install -y python3 python3-pip

RUN mkdir settings
RUN apt install -y wget sudo #used in the install_quarto script
COPY setup_julia.jl install_quarto.sh install_cmdstanr.R cran_packages.csv install_cran_packages.R requirements.txt ./settings/
RUN bash ./settings/install_quarto.sh 1.4.554
RUN Rscript ./settings/install_cran_packages.R
RUN Rscript ./settings/install_cmdstanr.R
RUN pip install -r ./settings/requirements.txt

RUN quarto install --quiet tinytex

RUN apt install -y cargo
RUN cargo install juliaup
RUN echo "export PATH=\$PATH:/root/.cargo/bin" >> ~/.bashrc 
RUN /root/.cargo/bin/julia --version #make sure the setup completes 

RUN /root/.cargo/bin/julia ./settings/setup_julia.jl