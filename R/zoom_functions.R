get_token <- function(base_encoded, id_account) {
  headers = c(
    `Authorization` = paste('Basic', base_encoded)
  )

  params = list(
    `grant_type` = 'account_credentials',
    `account_id` = id_account
  )

  res <- httr::POST(url = 'https://zoom.us/oauth/token',
                    httr::add_headers(.headers = headers),
                    query = params, encode = "json")

  zoom_token <- content(res)$access_token
  return(zoom_token)
}


get_recordings <- function(zoom_token, id_room) {

  headers = c(
    'Authorization' = paste('Bearer', zoom_token)
  )

  res <- VERB("GET", url = paste0("https://api.zoom.us/v2/meetings/",
                                  id_room, "/recordings"),
              add_headers(headers))

  answer <- content(res)
  return(answer)
}


delete_recordings <- function(zoom_token, id_room) {
  headers = c(
    'Authorization' = paste('Bearer', zoom_token)
  )

  res <- VERB("DELETE", url = paste0("https://api.zoom.us/v2/meetings/",
                                     id_room, "/recordings?action=trash"),
              add_headers(headers))

}

copy_bucket <- function(download_videos) {
  copy_command <- paste('/snap/bin/gsutil cp', download_videos, 'gs://zoom_downloads')
  system(copy_command)
}

