project_region = "europe-west1"

instance_zones = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]

server_instance_type  = "e2-medium"
server_instance_image = "nomad-104"
server_instance_count = 3
server_instance_tag   = "nomad-server"

client_instance_type  = "e2-medium"
client_instance_image = "nomad-104"
client_instance_count = 3
client_instance_tag   = "nomad-client"

whitelist = ["213.127.71.65", "81.187.43.208"]