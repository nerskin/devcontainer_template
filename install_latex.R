arch <- system('uname -m',intern=TRUE)

if (arch == "amd64"){
	system('quarto install --quiet tinytex')
} else {
	system('dnf install -y texlive')
}
