library(httr)
library(jsonlite)
library(purrr)
library(glue)
library(fs)
library(lubridate)

path <- system('pwd', intern = TRUE)
readRenviron(paste0(path, "/.Renviron"))

#Functions
source(glue("{path}/R/zoom_functions.R"))

#Credentials
base_encoded <- Sys.getenv("BASE64_ENCODED")
id_account <- Sys.getenv("ACCOUNT_ID")
zoom_token <- get_token(base_encoded, id_account)

#Local directory to store them
download_files <-  paste0(path, '/download_videos/')
if (!dir.exists(download_files)) {
  dir.create(download_files)
}
id_room <- Sys.getenv("ID_ROOM")

answer <- get_recordings(zoom_token, id_room)


while (!is.null(answer$recording_files)) {
  n <- length(as.list(answer)$recording_files)
  for (i in 1:n) {
    url_download <- answer$recording_files[[i]]$download_url
    timezone <- hours(6)
    #Subtracts 6 hours for the desired timezone
    video_name <- sub(" ", "T",as.character(as_datetime(answer$start_time) - timezone))
    video_type <- answer$recording_files[[i]]$recording_type
    extension <- tolower(answer$recording_files[[i]]$file_extension)
    download.file(glue("{url_download}?access_token={zoom_token}"),
                  glue("{download_files}{video_name}_{video_type}.{extension}"))
    print(glue("Downloading the videos from the date: {video_name}"))
  }
  delete_recordings(zoom_token, id_room)
  Sys.sleep(30)

  #Files are uploaded to a GCP bucket and deleted locally
  download_videos <- dir_ls(download_files)
  map(.x = download_videos, .f = ~copy_bucket(.x))
  system(glue("rm {download_files}*"))
  answer <- get_recordings(zoom_token, id_room)
}
