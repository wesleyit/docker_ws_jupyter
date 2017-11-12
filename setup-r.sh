#!/bin/bash
cat | R --no-save <<EOF

install.packages('devtools', repos='http://cran.us.r-project.org')
devtools::install_github('IRkernel/IRkernel')

EOF