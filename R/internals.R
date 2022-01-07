#' Create Confif (.json) File
#'
#' Create a `config.json` file and output to the temporary directory
#'
#' @param onto_terms a character string of the IRI prefixes to use for mapping (ie, FOODON_00001283, BFO_0000001)
#' @keywords internal

create_config <- function(onto_terms)
{
    # create list for json conversion

    string_base <- 'http://purl.obolibrary.org/obo/'
    onto_string <- paste0(string_base, onto_terms)


    onto_list <- list()
    for (i in seq_along(onto_string)) {
        onto_list[[i]] <-
            onto_string[[i]]
    }
    names(onto_list) <-
        rep('http://purl.obolibrary.org/obo/foodon.owl',
            length(onto_list))

    json_tmp <- rjson::toJSON(onto_list)

    clean_json <- paste0('[', jsonlite::prettify(json_tmp), ']')

    config_path <- paste0(getOption('TEMPDIR'), '/', 'config.json')

    writeLines(jsonlite::prettify(clean_json), config_path)

    return(invisible(NULL))
}

#' Create Input
#'
#' Create an `input.csv` file andoutput to the temporary directory
#'
#' @param food_terms a character string of the food terms you want to map against the FoodOn Ontology
#' @keywords internal

create_input <- function(food_terms)
{
    input_tibble <- tibble::tibble(SampleID = seq(1:length(food_terms)),
                                   SampleDesc = food_terms)

    readr::write_csv(input_tibble, path = paste0(getOption('TEMPDIR'), '/', 'input.csv'))

    return(invisible(NULL))

}

#' Check for docker image
#'
#' Check if the lexmapr-dokcer image is available

check_image <- function()
{
    docker_env <-
        stevedore::docker_client(api_version = 1.39, quiet = TRUE)

    image_list <- data.frame(docker_env$image$list())

    len_check <- purrr::map_dbl(image_list$repo_tags, length) == 0

    if (any(len_check) == 'TRUE') {
        idx_zero <- which(len_check == TRUE)
        image_list$repo_tags[idx_zero][[1]] <- 'none'
    }

    if (TRUE %in%
        stringr::str_detect(image_list$repo_tags,
                            'wilsontom/lexmapr-docker',
                            negate = FALSE)) {
        message(crayon::green(
            crayon::bold(clisymbols::symbol$tick,
                         'lexmapr container found')
        ))
    } else{
        message(crayon::red(
            crayon::bold(
                clisymbols::symbol$cross,
                'lexmapr container not found'
            )
        ))
        cat('\n')
        message(crayon::yellow(
            crayon::bold(
                clisymbols::symbol$ellipsis,
                'Pulling container from docker hub'
            )
        ))
        docker_env$image$pull('wilsontom/lexmapr-docker')
    }
    return(invisible(NULL))
}
