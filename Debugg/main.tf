resource "local_file" "record" {
  content = " Code to Demonstrate Persistant Logging"
  filename = "${path.module}/record.txt"
}