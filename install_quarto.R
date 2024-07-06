library(glue)

quarto_ver <- commandArgs(trailingOnly=TRUE)[1]
arch <- system('uname -m',intern=TRUE)

if (arch %in% c('arm64','aarch64')){
	arch <- "arm64"
} else {
	arch <- "amd64"
}

url <- glue("https://github.com/quarto-dev/quarto-cli/releases/download/v{quarto_ver}/quarto-{quarto_ver}-linux-{arch}.tar.gz")

download.file(url,destfile = "quarto.tar.gz")
system('tar -C /opt -xvzf quarto.tar.gz')
system(glue('ln -fs /opt/quarto-{quarto_ver}/bin/quarto /usr/local/bin/quarto'))
