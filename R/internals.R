#' Create Confif (.json) File
#'
#' Create a `config.json` file and output to the temporary directory
#'
#' @param onto_terms a character string of the IRI prefixes to use for mapping (ie, FOODON:00001283, BFO_0000001)
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

