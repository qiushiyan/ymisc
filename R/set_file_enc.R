#' Convert file encodings
#'
#' `set_file_enc` converts files between encodings. After converting, it is suggested using import functions from `readr`,
#' i.e. `read_csv`, `read_lines`, etc.
#' @param path Either a path to a file, or a directory under which all files are to be converted
#' @param from A character string describing the current encoding. By default, uses the encoding detected by
#' `readr::guess_encoding` with highest probability
#' @param to A character string describing the target encoding, default to UTF-8.
#' @export
set_file_enc <- function(path, from = "", to = "UTF-8") {
  if (utils::file_test("-f", path)) {
    file <- path
    file_ext <- substring(file, regexpr("\\.([[:alnum:]])+$", file))
    out_file <- gsub(file_ext, paste0("-", to, file_ext), file)
    if (from == "") {
      enc_likely <- as.data.frame(readr::guess_encoding(file))[1, 1]
      out <- iconv(readLines(file), from = enc_likely, to = to)
      msg <- crayon::cyan(sprintf("Use %s as the original encoding", enc_likely))
      message(msg)
      writeLines(out, file(out_file, encoding = to))
    } else {
      out <- iconv(readLines(file), from = from, to = to)
      writeLines(out, file(out_file, encoding = to))
    }
    invisible(out_file)
  } else {
    file_names <- list.files(path)
    out_dir <- paste(path, to, sep = "/")
    dir.create(out_dir)
    for (file_name in file_names) {
      file_read_path <- paste(path, file_name, sep = "/")
      file_write_path <- paste(out_dir, file_name, sep = "/")
      if (from == "") {
        enc_likely <- as.data.frame(readr::guess_encoding(file_read_path))[1, 1]
        out <- iconv(readLines(file_read_path), from = enc_likely, to = to)
        msg <- crayon::cyan(sprintf("Use %s as the original encoding", enc_likely))
        message(msg)
        writeLines(out, file(file_write_path, encoding = to))
      } else {
        out <- iconv(readLines(file), from = from, to = to)
        writeLines(out, file(out_file, encoding = to))
      }
    }
  }
}
