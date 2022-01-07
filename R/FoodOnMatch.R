#' Food Ontology Match
#'
#' Match food terms to the FoodOn Ontology
#'
#' @param food_terms a vector of food terms to classify
#' @param onto_terms a vector of OBO ontology terms to be included in the mapping (ie, `BFO_0000001`)
#' @return a `tibble` of food term ontology mappings and third-party classifications
#'
#' @export

FoodOnMatch <- function(food_terms, onto_terms)
{
    check_image()

    # create temp-dir
    options(TEMPDIR = uuid::UUIDgenerate())
    dir.create(getOption('TEMPDIR'))


    # create input file
    create_input(food_terms)

    # create config file
    create_config(onto_terms)

    # create docker command & run

    mount_path <- paste0(getwd(), '/', getOption('TEMPDIR'))

    container_nane <- uuid::UUIDgenerate()
    container_nane_sp <- strsplit(container_nane, '-')[[1]][1]

    docker_cmd <-
        paste0(
            'docker run --name ',
            container_nane_sp,
            ' -v ',
            mount_path,
            ':/data wilsontom/lexmapr-docker'
        )

    system(docker_cmd, intern = FALSE)

    lexmapr_results <-
        readr::read_tsv(paste0(getOption('TEMPDIR'), '/output.tsv'), col_types = readr::cols())


    matched_components <- lexmapr_results$Matched_Components

    matched_components <- gsub('\\[', '', matched_components)
    matched_components <- gsub('\\]', '', matched_components)
    matched_components <- gsub("'", '', matched_components)

    matched_components <- gsub(',', ' //', matched_components)


    third_party_classification <-
        lexmapr_results$`Third Party Classification`

    third_party_classification <-
        gsub('\\[', '', third_party_classification)
    third_party_classification <-
        gsub('\\]', '', third_party_classification)
    third_party_classification <-
        gsub("'", '', third_party_classification)


    cleaned_up_tibble <- tibble::tibble(
        Input = food_terms,
        OntologyMatch = matched_components,
        Classification = third_party_classification
    )


    # clean up temp dir
    tempfiles <- list.files(getOption('TEMPDIR'), full.names = TRUE)
    for (i in seq_along(tempfiles)) {
        file.remove(tempfiles[i])
    }
    file.remove(getOption('TEMPDIR'))

    # remove docker container
    docker_container_remove <- paste0('docker rm ', container_nane_sp)

    system(docker_container_remove, intern = FALSE)

    return(cleaned_up_tibble)

}
