#' @title Use Shiny toastify
#' @description This function must be called once in your Shiny \code{ui} to
#'   allow to use \code{\link{showToast}}.
#'
#' @return An object of class \code{shiny.tag.list}.
#'
#' @importFrom reactR createReactShinyInput
#' @importFrom htmltools htmlDependency tags
#' @importFrom fontawesome fa_html_dependency
#' @export
useShinyToastify <- function(){
  createReactShinyInput(
    inputId = "ToastContainer-React-Toastify",
    class = "toastify",
    dependencies = list(
      htmlDependency(
        name = "toastify-input",
        version = "1.0.0",
        src = "www/shinyToastify/toastify",
        package = "shinyToastify",
        script = "toastify.js"
      ),
      fa_html_dependency()
    ),
    default = NULL,
    configuration = list(),
    container = tags$div
  )
}

#' @title Show a toast
#' @description Show a toast in a Shiny application.
#'
#' @param session the Shiny \code{session} object
#' @param input the Shiny \code{input} object
#' @param id an id for the toast or \code{NULL} for automatic id; see details
#'   for the use of this id
#' @param text the text displayed in the toast; this can be a character string,
#'   an html element created with the \code{\link[htmltools:HTML]{HTML}}
#'   function, or a \code{shiny.tag} object such as
#'   \code{tags$span(style = "color:lime;", "Message")}
#' @param type toast type, one of \code{"info"}, \code{"success"},
#'   \code{"warning"}, \code{"error"}, \code{"default"} or \code{"dark"}
#' @param position toast position, one of \code{"top-left"},
#'   \code{"top-right"}, \code{"top-center"}, \code{"bottom-left"},
#'   \code{"bottom-right"} or \code{"bottom-center"}
#' @param transition the transition effect, one of \code{"slide"},
#'   \code{"zoom"}, \code{"flip"} or \code{"bounce"}
#' @param autoClose either a number, the time in ms to close the toast, or
#'   \code{FALSE} to close the toast manually
#' @param hideProgressBar Boolean, whether to hide the progress bar
#' @param newestOnTop Boolean, whether to display newest toast on top
#' @param closeOnClick Boolean, whether to dismiss the toast on click
#' @param rtl Boolean, right to left
#' @param pauseOnFocusLoss Boolean, whether to pause the toast on focus loss
#' @param draggable Boolean, ability to drag the toast to remove it
#' @param draggableDirection \code{"x"} or \code{"y"}
#' @param draggablePercent the percentage of the width of the toast needed to
#'   remove it by dragging
#' @param pauseOnHover Boolean, whether to pause the toast on hover
#' @param className name of a CSS class applied to the container
#' @param toastClassName name of a CSS class applied on the toast wrapper
#' @param bodyClassName name of a CSS class applied on the toast body
#' @param progressClassName name of a CSS class applied on the progress bar
#' @param style inline style applied to the container, e.g.
#'   \code{list(boxShadow = "rgba(0, 0, 0, 0.56) 0px 22px 30px 4px")}
#' @param Rcallback a R function without arguments to be executed whenever the
#'   toast is closed; alternatively, use the \code{id} argument (see details)
#' @param JScallback some JavaScript code given as a string to be executed
#'   whenever the toast is closed, e.g. \code{'alert("The toast is closed")'}
#'
#' @return No return value, called for side effect.
#'
#' @export
#' @importFrom utils URLencode
#' @importFrom shiny observeEvent
#' @importFrom htmltools HTML
#'
#' @details \strong{Usage of the \code{id} argument.} If you provide a string
#'   to the \code{id} argument, say \code{"mytoast"}, the application will
#'   send the event \code{input[["mytoast_closed"]]} to the server whenever
#'   the toast closes; therefore you can listen to this event with an observer
#'   to perform an action whenever the toast closes.
#'
#' @examples library(shiny)
#' library(shinyToastify)
#'
#' ui <- fluidPage(
#'   useShinyToastify(),
#'   br(),
#'   actionButton("btn", "Show toast", class = "btn-primary btn-lg")
#' )
#'
#' server <- function(input, output, session){
#'
#'   toastTransitions <- c(
#'     "Zoom", "Bounce", "Flip", "Slide"
#'   )
#'
#'   observeEvent(input[["btn"]], {
#'
#'     toastTransition <- toastTransitions[1L + (input[["btn"]] %% 4L)]
#'
#'     html <- HTML(
#'       '<span style="font-size: 30px; font-family: cursive;">',
#'       paste0(toastTransition, " transition"),
#'       '</span>',
#'     )
#'
#'     showToast(
#'       session,
#'       input,
#'       text = html,
#'       type = "success",
#'       transition = tolower(toastTransition),
#'       autoClose = 3000,
#'       style = list(
#'         border = "4px solid crimson",
#'         boxShadow = "rgba(0, 0, 0, 0.56) 0px 22px 30px 4px"
#'       )
#'     )
#'
#'   })
#'
#' }
#'
#' if(interactive()){
#'   shinyApp(ui, server)
#' }
showToast <- function(
  session,
  input,
  id = NULL,
  text,
  type = "default",
  position = "top-right",
  transition = "slide",
  autoClose = 5000,
  hideProgressBar = FALSE,
  newestOnTop = FALSE,
  closeOnClick = TRUE,
  rtl = FALSE,
  pauseOnFocusLoss = TRUE,
  draggable = TRUE,
  draggableDirection = "x",
  draggablePercent = 80,
  pauseOnHover = TRUE,
  className = NULL,
  toastClassName = NULL,
  bodyClassName = NULL,
  progressClassName = NULL,
  style = NULL,
  Rcallback = function(){NULL},
  JScallback = NULL
){
  stopifnot(is.null(id) || isString(id))
  stopifnot(isString(type))
  stopifnot(isString(position))
  stopifnot(isString(transition))
  stopifnot(isBoolean(hideProgressBar))
  stopifnot(isBoolean(newestOnTop))
  stopifnot(isBoolean(closeOnClick))
  stopifnot(isBoolean(rtl))
  stopifnot(isBoolean(pauseOnFocusLoss))
  stopifnot(isBoolean(draggable))
  stopifnot(isString(draggableDirection))
  stopifnot(isNumber(draggablePercent))
  stopifnot(isBoolean(pauseOnHover))
  stopifnot(isNumber(autoClose) || isFALSE(autoClose))
  stopifnot(is.null(className) || isString(className))
  stopifnot(is.null(toastClassName) || isString(toastClassName))
  stopifnot(is.null(bodyClassName) || isString(bodyClassName))
  stopifnot(is.null(progressClassName) || isString(progressClassName))
  stopifnot(is.null(style) || isNamedList(style))
  stopifnot(isFunction(Rcallback))
  if(!is.null(formals(Rcallback))){
    stop(
      "The `Rcallback` argument must a function without arguments.",
      call. = TRUE
    )
  }
  stopifnot(is.null(JScallback) || isString(JScallback))
  if(inherits(text, "shiny.tag")){
    text <- HTML(as.character(text))
  }
  if(inherits(text, "html")){
    text <- list("__html" = URLencode(as.character(text)))
  }else if(!isString(text)){
    stop(
      "The `text` argument must be either an ordinary character string or ",
      "a html string created with the `HTML` function or a shiny tag.",
      call. = TRUE
    )
  }
  message <- list(
    "text" = text,
    "type" = match.arg(
      type,
      c("info", "success", "warning", "error", "default", "dark")
    ),
    "config" = dropNulls(list(
      "toastId" = id,
      "position" = match.arg(
        position,
        c(
          "top-left", "top-right", "top-center",
          "bottom-left", "bottom-right", "bottom-center"
        )
      ),
      "transition" = match.arg(
        transition,
        c("slide", "zoom", "flip", "bounce")
      ),
      "autoClose" = autoClose,
      "hideProgressBar" = hideProgressBar,
      "newestOnTop" = newestOnTop,
      "closeOnClick" = closeOnClick,
      "rtl" = rtl,
      "pauseOnFocusLoss" = pauseOnFocusLoss,
      "draggable" = draggable,
      "draggableDirection" = match.arg(draggableDirection, c("x", "y")),
      "draggablePercent" = draggablePercent,
      "pauseOnHover" = pauseOnHover,
      "className" = className,
      "toastClassName" = toastClassName,
      "bodyClassName" = bodyClassName,
      "progressClassName" = progressClassName,
      "style" = style
    )),
    "JScallback" = if(!is.null(JScallback)) URLencode(JScallback)
  )
  session$sendCustomMessage("shinyToastify", message)
  observeEvent(input[["shinyToastifyOnClose"]], {
    Rcallback()
  }, once = TRUE)
}

#' @title Update a toast
#' @description Update a toast in a Shiny application. Run
#'   \code{shinyToastifyExample("toastUpdate")} for an example.
#'
#' @param session the Shiny \code{session} object
#' @param toastId the id of the toast to be updated (\code{id} argument)
#' @param text the text displayed in the toast; this can be a character string,
#'   an html element created with the \code{\link[htmltools:HTML]{HTML}}
#'   function, or a \code{shiny.tag} object such as
#'   \code{tags$span(style = "color:lime;", "Message")}
#' @param type toast type, one of \code{"info"}, \code{"success"},
#'   \code{"warning"}, \code{"error"}, \code{"default"} or \code{"dark"}
#' @param position toast position, one of \code{"top-left"},
#'   \code{"top-right"}, \code{"top-center"}, \code{"bottom-left"},
#'   \code{"bottom-right"} or \code{"bottom-center"}
#' @param transition the transition effect, one of \code{"slide"},
#'   \code{"zoom"}, \code{"flip"} or \code{"bounce"}
#' @param autoClose either a number, the time in ms to close the toast, or
#'   \code{FALSE} to close the toast manually
#' @param hideProgressBar Boolean, whether to hide the progress bar
#' @param closeOnClick Boolean, whether to dismiss the toast on click
#' @param rtl Boolean, right to left
#' @param pauseOnFocusLoss Boolean, whether to pause the toast on focus loss
#' @param draggable Boolean, ability to drag the toast to remove it
#' @param draggableDirection \code{"x"} or \code{"y"}
#' @param draggablePercent the percentage of the width of the toast needed to
#'   remove it by dragging
#' @param pauseOnHover Boolean, whether to pause the toast on hover
#' @param className name of a CSS class applied to the container
#' @param toastClassName name of a CSS class applied on the toast wrapper
#' @param bodyClassName name of a CSS class applied on the toast body
#' @param progressClassName name of a CSS class applied on the progress bar
#' @param style inline style applied to the container, e.g.
#'   \code{list(boxShadow = "rgba(0, 0, 0, 0.56) 0px 22px 30px 4px")}
#' @param JScallback some JavaScript code given as a string to be executed
#'   whenever the toast is closed; it will have an effect only if the
#'   \code{position} argument differs from the one of the toast to be
#'   updated
#'
#' @return No return value, called for side effect.
#'
#' @export
#' @importFrom utils URLencode
#' @importFrom htmltools HTML
toastUpdate <- function(
  session,
  # input,
  toastId,
  text,
  type = "default",
  position = "top-right",
  transition = "slide",
  autoClose = 5000,
  hideProgressBar = FALSE,
  # newestOnTop = FALSE,
  closeOnClick = TRUE,
  rtl = FALSE,
  pauseOnFocusLoss = TRUE,
  draggable = TRUE,
  draggableDirection = "x",
  draggablePercent = 80,
  pauseOnHover = TRUE,
  className = NULL,
  toastClassName = NULL,
  bodyClassName = NULL,
  progressClassName = NULL,
  style = NULL,
  # Rcallback = function(){NULL},
  JScallback = NULL
){
  stopifnot(isString(toastId))
  stopifnot(isString(type))
  stopifnot(isString(position))
  stopifnot(isString(transition))
  stopifnot(isBoolean(hideProgressBar))
  # stopifnot(isBoolean(newestOnTop))
  stopifnot(isBoolean(closeOnClick))
  stopifnot(isBoolean(rtl))
  stopifnot(isBoolean(pauseOnFocusLoss))
  stopifnot(isBoolean(draggable))
  stopifnot(isString(draggableDirection))
  stopifnot(isNumber(draggablePercent))
  stopifnot(isBoolean(pauseOnHover))
  stopifnot(isNumber(autoClose) || isFALSE(autoClose))
  stopifnot(is.null(className) || isString(className))
  stopifnot(is.null(toastClassName) || isString(toastClassName))
  stopifnot(is.null(bodyClassName) || isString(bodyClassName))
  stopifnot(is.null(progressClassName) || isString(progressClassName))
  stopifnot(is.null(style) || isNamedList(style))
  # stopifnot(isFunction(Rcallback))
  # if(!is.null(formals(Rcallback))){
  #   stop(
  #     "The `Rcallback` argument must a function without arguments.",
  #     call. = TRUE
  #   )
  # }
  stopifnot(is.null(JScallback) || isString(JScallback))
  if(inherits(text, "shiny.tag")){
    text <- HTML(as.character(text))
  }
  if(inherits(text, "html")){
    text <- list("__html" = URLencode(as.character(text)))
  }else if(!isString(text)){
    stop(
      "The `text` argument must be either an ordinary character string or ",
      "a html string created with the `HTML` function or a shiny tag.",
      call. = TRUE
    )
  }
  message <- list(
    "toastId" = toastId,
    "config" = dropNulls(list(
      "render" = text,
      "type" = match.arg(
        type,
        c("info", "success", "warning", "error", "default", "dark")
      ),
      "position" = match.arg(
        position,
        c(
          "top-left", "top-right", "top-center",
          "bottom-left", "bottom-right", "bottom-center"
        )
      ),
      "transition" = match.arg(
        transition,
        c("slide", "zoom", "flip", "bounce")
      ),
      "autoClose" = autoClose,
      "hideProgressBar" = hideProgressBar,
      # "newestOnTop" = newestOnTop,
      "closeOnClick" = closeOnClick,
      "rtl" = rtl,
      "pauseOnFocusLoss" = pauseOnFocusLoss,
      "draggable" = draggable,
      "draggableDirection" = match.arg(draggableDirection, c("x", "y")),
      "draggablePercent" = draggablePercent,
      "pauseOnHover" = pauseOnHover,
      "className" = className,
      "toastClassName" = toastClassName,
      "bodyClassName" = bodyClassName,
      "progressClassName" = progressClassName,
      "style" = style
    )),
    "JScallback" = if(!is.null(JScallback)) URLencode(JScallback)
  )
  session$sendCustomMessage("shinyToastifyUpdate", message)
  # observeEvent(input[["shinyToastifyOnClose"]], {
  #   Rcallback()
  # }, once = TRUE)
}
