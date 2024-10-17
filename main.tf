terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-2"
  access_key = ""
  secret_key = ""
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

# publica 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"  # AZ 1
  tags = {
    Name = "MyPublicSubnet1"
  }
}

#publica 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2b"  # AZ 2
  tags = {
    Name = "MyPublicSubnet2"
  }
}

# private 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2c"  # AZ 3
  tags = {
    Name = "MyPrivateSubnet1"
  }
}

# private 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-2d"  # AZ 4
  tags = {
    Name = "MyPrivateSubnet2"
  }
}

# tabla de ruta
resource "aws_route_table" "my_route_table_public" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "mi_tabla_de_ruta_publica"
  }
}

# Asocia la tabla de ruta a la publica 1
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.my_route_table_public.id
}

# Asocia la tabla de ruta a la publica 2
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.my_route_table_public.id
}

# Define una tabla de ruta privada
resource "aws_route_table" "my_route_table_private" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "mi_tabla_de_ruta_privada"
  }
}

# Asocia la tabla de ruta a la private 1
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.my_route_table_private.id
}

# Asocia la tabla de ruta a la private 2
resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.my_route_table_private.id
}

# Define un Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "route_to_internet_gateway_public" {
  route_table_id         = aws_route_table.my_route_table_public.id    
  destination_cidr_block = "0.0.0.0/0"                 
  gateway_id             = aws_internet_gateway.my_igw.id 
}

# Define las instancias EC2 en subredes públicas
resource "aws_instance" "my_instance1" {
  ami                    = "ami-0ddda618e961f2270"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  tags = {
    Name = "MyInstance1"
  }
}

resource "aws_instance" "my_instance2" {
  ami                    = "ami-0ddda618e961f2270"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_2.id
  associate_public_ip_address = true
  tags = {
    Name = "MyInstance2"
  }
}

# Define las instancias EC2 en subredes privadasss
resource "aws_instance" "my_instance3" {
  ami                    = "ami-0ddda618e961f2270"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1.id
  associate_public_ip_address = false
  tags = {
    Name = "MyInstance3"
  }
}

resource "aws_instance" "my_instance4" {
  ami                    = "ami-0ddda618e961f2270"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_2.id
  associate_public_ip_address = false
  tags = {
    Name = "MyInstance4"
  }
}
