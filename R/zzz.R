.onAttach <-
    function(...)
    {
        if (stevedore::docker_available() == FALSE) {
            packageStartupMessage(crayon::bold(
                crayon::yellow('docker must be installed before using lexmapR')
            ),
            appendLF = TRUE)
            packageStartupMessage(crayon::yellow(
                'visit https://docs.docker.com/install for more details'
            ))
        } else{
            docker_env <- stevedore::docker_client()

            image_list <- data.frame(docker_env$image$list())

            len_check <- purrr::map_dbl(image_list$repo_tags, length) == 0

            if(any(len_check) == 'TRUE') {
                idx_zero <- which(len_check == TRUE)
                image_list$repo_tags[idx_zero][[1]] <- 'none'
            }


            if (TRUE %in%
                stringr::str_detect(image_list$repo_tags,
                                    'wilsontom/lexmapr-docker', negate = FALSE)) {
                message(crayon::green(
                    crayon::bold(
                        clisymbols::symbol$tick,
                        'lexmapr container found'
                    )
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

        }

    }
