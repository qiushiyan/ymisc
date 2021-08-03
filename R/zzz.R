.onLoad <- function(libname, pkgname) {
  registerS3method("knit_print", "script", knit_print.script)
}

