# Zoom Video Downloader 
This is an R project that uses the Zoom API to download videos from cloud recordings and upload them to a GCP bucket.

## Requirements
- R version 4.0.2 or higher 
- R packages: httr, jsonlite, purrr, glue, fs, lubridate

## Configuration 
Before using the download scripts you need to configure your Zoom API credentials in a .Renviron file that contains:
- `CLIENT_ID=""`
- `CLIENT_SECRET=""`
- `BASE64_ENCODED=""`
- `ACCOUNT_ID=""`
- `ID_SALA=""`

You can obtain these values by creating in the App Marketplace from Zoom, a Server-to-Server OAuth app to obtain the accound_id, client_id and client_secret. 

BASE64_ENCODED is the combination of client_id:client_secret in base64. 

You also need to set up your GCP credentials to be able to upload the videos to a bucket (in this case called zoom_downloads).

## Download 
The zoom_download.R script downloads videos from Zoom cloud recordings and stores them in a local directory. 

To download videos, we obtain them with a GET request to the API and specify the target directory where the downloaded videos will be stored. After downloading them, it deletes them, although they remain in the trash for 30 days, still recoverable.

Finally, downloaded videos are uploaded to a GCP bucket and deleted locally. 

## Contribution
If you want to contribute to this project, you are welcome to do so! Simply fork the repository, make your changes, and submit a pull request. You can also report bugs or request new features through the repository issues. 

## Author
This project was developed by Pierina Ponce. 



