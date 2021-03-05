# lexmapR

[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable) [![R build status](https://github.com/wilsontom/lexmapR/workflows/R-CMD-check/badge.svg)](https://github.com/wilsontom/lexmapR/actions) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0")


**R Interface to LexMapr (via docker)**

lexmapR is a R interafce to the python tool [Lexmapr](https://github.com/Public-Health-Bioinformatics/LexMapr). **LexMapr** is a _Lexicon and Rule-Based Tool for Translating Short Biomedical Specimen Descriptions into Semantic Web Ontology Terms_. 

In order to use LexMapr from within a R session. the python tool was first containerised using docker, available [here](https://github.com/wilsontom/lexmapr-docker). This container is the used within the **lexmapR** R package. The end result is that the LexMapr tool can be easily used within R and without having to install anything. 

#### Installation

To use `lexmapR` you must have a working installation of [Docker](https://www.docker.com/). [See here](https://docs.docker.com/install/) for details on how to install.

Once Docker is installed; `lexmapR` can be installed directly from GitHub

```r
remotes::install_github('wilsontom/lexmapR')

```
