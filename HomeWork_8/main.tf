terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "apache2_image" {
  name         = "apache2_image:latest"
  keep_locally = false
}

resource "docker_container" "apache2_image" {
  image = docker_image.apache2_image.latest
  name  = "apache2_image"
  ports {
    internal = 80
    external = 8080
  }
}
