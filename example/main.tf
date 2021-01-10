module "web_server" {
  source        = "./http_server"
  instance_type = "t3.nano"
  profile       = "ikhrnet"
}

output "ami_id" {
  value = module.web_server.ami_id
}

output "instance_id" {
  value = module.web_server.instance_id
}

output "public_dns" {
  value = module.web_server.public_dns
}
