#' Subset to non-metadata output files
#'
#' @import AnVILGCP
#'
#' @param workflowOutputs A data frame of workflow outputs with four 
#' columns: file, workflow, task, and path. Returned value 
#' from \code{\link[AnVIL]{avworkflow_files}}.
#'
#' @return A character vector containing the names of non-metadata output files
#'
#' @keywords internal
.nonMetadataOutputs <- function(workflowOutputs) {
    filenames <- workflowOutputs$file

    ind1 <- which(filenames %in% c("stderr","stdout","rc","script","output"))
    ind2 <- grep(".sh$", filenames)   # bash files
    ind3 <- grep(".log$", filenames)   # log files

    meta_ind <- c(ind1, ind2, ind3)
    res <- workflowOutputs[-meta_ind,]
    return(res)
}

#' Stop the execution without error messages
#' 
#' @return Stop the function call without warning/error messages.
#' 
#' @keywords internal
.stop_quietly <- function() {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    stop()
}


#' Get the fullname of the workspace
#' 
#' @importFrom utils tail
#' @param workspaceName Character(1). Name of the template workspace name you 
#' want to clone. You can provide \code{name} or \code{namespace/name}.
#' 
#' @return Character(1) of \code{workspaceNamespace/workspaceName}
#' 
#' @examples 
#' library(AnVILBase)
#' if (
#'     gcloud_exists() && identical(avplatform_namespace(), "AnVILGCP") &&
#'     nzchar(avworkspace_name())
#' ) {
#' .get_workspace_fullname(workspaceName = "Bioconductor-Workflow-DESeq2")
#' }
#' 
#' @keywords internal
.get_workspace_fullname <- function(workspaceName) {
    
    ## In case `namespace/name` is provided as workspacename
    ws_name_split <- unlist(strsplit(workspaceName, "/")) 
    
    ## Get all the workspace
    all_ws <- avworkspaces(platform = "gcp") # gcloud_account should be already set for this.
    ind <- which(all_ws$name == utils::tail(ws_name_split, 1))
    fullnames <- paste(all_ws$namespace[ind], all_ws$name[ind], sep = "/")
    
    ## Use the provided `namespace/name` if it is correct
    if (workspaceName %in% fullnames) {
        return(workspaceName)
        .stop_quietly()
    }
    
    ## Check whether the template workspace exist
    if (length(ind) == 0) {
        stop("Workspace doesn't exit or you don't have access to it.")
    } else if (length(ind) == 1) {
        ws_namespace <- all_ws$namespace[ind]
        ws_name <- all_ws$name[ind]
    } 
    
    if (length(ind) > 1) {
        if (length(ws_name_split) != 2) { # many workspaces with the same name
            message("Please specify the workspaceName from the following:")
            show(fullnames)
            .stop_quietly()
        } else {
            if (!workspaceName %in% fullnames) {
                stop("Workspace doesn't exit or you don't have access to it.")
            } else {
                ws_namespace <- ws_name_split[1]
                ws_name <- ws_name_split[2]
            }
        }
    }
    
    ## Return workspaceNamespace/workspaceName
    res <- paste(ws_namespace, ws_name, sep = "/")
    return(res)
}


#' Get the workflow namespace and name
#' 
#' Use this internally when \code{\link{setCloudEnv}} is already run.
#' 
#' @param workspaceName A character. Name of the workspace to use. 
#' @param workflowName A character. Name of the workflow to run. If a single
#' workflow is available under the selected workspace, this function will
#' check the input of that workflow under the default (\code{NULL}). If there
#' are multiple workflows available, you should specify the workflow. 
#' 
#' @return A character of \code{workflow_namespace/workflow_name}
#'
#' @keywords internal
.get_workflow_fullname <- function(workspaceName,
                                   workflowName = NULL) {
    
    ws_fullname <- .get_workspace_fullname(workspaceName = workspaceName)
    
    ## Get all the available workflow
    res <- avworkflows(namespace = unlist(strsplit(ws_fullname,split = "/"))[1],
                       name = unlist(strsplit(ws_fullname,split = "/"))[2])
    
    ## Select a workflow
    if (nrow(res) == 0) {
        stop("This workspace does not have any workflow.")
    } else if (nrow(res) == 1) {
        wf_fullname <- paste(res$namespace, res$name, sep = "/")
    } else if (is.null(workflowName)) {
        message("Please specify the workflowName from the following:")
        show(res)
        .stop_quietly()
    } else {
        ind <- which(res$name == workflowName)
        if (length(ind) == 0) { # In case wrong environment variable is used
            message("Please specify the workflowName from the following:")
            show(res)
            .stop_quietly()
        }
        wf_fullname <- paste(res$namespace[ind], res$name[ind], sep = "/")
    }
    
    return(wf_fullname)
}
