locals {
  default = {
    Team = "Development"
    creationDate = "date-${formatdate("DDMMYYYY",timestamp())}" # First current time stamp will be recorded, & then formatted accordingly
  }
}