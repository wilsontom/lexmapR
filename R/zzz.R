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
        }

        return(invisible(NULL))
    }
