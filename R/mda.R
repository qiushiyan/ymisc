library(tidymodels)

set_new_model("discrim_mixture")
set_model_mode(model = "discrim_mixture", mode = "classification")
set_model_engine(
  "discrim_mixture",
  mode = "classification",
  eng = "mda"
)
set_dependency("discrim_mixture", eng = "mda", pkg = "mda")

# ’ Example custom parsnip model
#'
#' parsnip model for mixture discriminant analysis
discrim_mixture <- function(mode = "classification",
                            sub_classes = NULL) {
  # Check for correct mode
  if (mode != "classification") {
    rlang::abort("`mode` should be 'classification'")
  }

  # Capture the arguments in quosures
  args <- list(sub_classes = rlang::enquo(sub_classes))

  # Save some empty slots for future parts of the specification
  new_model_spec(
    "discrim_mixture",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}
