terraform {
  backend "gcs" {
    bucket = "pw-op-tf-remote-statefile"
    prefix = ""
  }
}
