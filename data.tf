data aws_vpc "this" {
  default = false

  tags = {
    Name = "devops - main"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    Name = "*public*"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    Name = "*private*"
  }
}

data "aws_ami" "eks_worker_1_13" {
  filter {
    name = "name"
    values = [
    "amazon-eks-node-1.13-v20191119"]
  }

  most_recent = true
  owners = [
  "amazon"]
}