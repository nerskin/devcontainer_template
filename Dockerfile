FROM fedora:latest

RUN dnf install -y git vim libcurl-devel R python3-pip python3-devel

RUN mkdir settings

COPY install_cran_packages.R cran_packages.csv ./settings/
RUN Rscript ./settings/install_cran_packages.R

ARG QUARTO_VER="1.5.53"
COPY install_quarto.R ./settings/
RUN Rscript ./settings/install_quarto.R "${QUARTO_VER}"

COPY install_latex.R ./settings/
RUN Rscript ./settings/install_latex.R

COPY install_cmdstanr.R ./settings/
RUN Rscript ./settings/install_cmdstanr.R

COPY requirements.txt ./settings/
RUN pip3 install -r ./settings/requirements.txt


COPY setup_julia.jl ./settings/
RUN dnf install -y cargo
RUN cargo install juliaup
RUN echo "test"
ENV PATH="$PATH:/root/.cargo/bin"
RUN echo $PATH
RUN /root/.cargo/bin/julia --version #make sure the setup completes 
RUN /root/.cargo/bin/julia ./settings/setup_julia.jl
