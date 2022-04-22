resource "aws_vpc" "vpc" {
  cidr_block           = var.eks_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge({
    Name                                            = "${var.eks_cluster_name}-vpc"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }, var.tags, var.default_tags)
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.eks_public_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.eks_public_subnet_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, var.default_tags, {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
    "Name"                                          = "node-group-subnet-${var.eks_cluster_name}-${count.index + 1}"
    "state"                                         = "public"
  })
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.eks_private_subnet_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.eks_private_subnet_cidr, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, var.default_tags, {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
    "Name"                                          = "fargate-subnet-${var.eks_cluster_name}-${count.index + 1}"
    "state"                                         = "private"
  })
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, var.default_tags, {
    Name = "${var.eks_cluster_name}-inernet-gw"
  })
}

resource "aws_eip" "nat_gateway_eip" {
  count = length(var.eks_public_subnet_cidr)
  vpc   = true
  tags = merge(var.tags, var.default_tags, {
    Name = "${var.eks_cluster_name}-nat-gateway-eip"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.eks_public_subnet_cidr)
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = merge(var.tags, var.default_tags, {
    Name = format("${var.eks_cluster_name}-nat-gw-%02d", count.index + 1)
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, var.default_tags, {
    Name = "${var.eks_cluster_name}-public-route-table"
  })
}

resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
  depends_on             = [aws_route_table.public_route_table]
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.eks_public_subnet_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.eks_private_subnet_cidr)
  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, var.default_tags, {
    Name = format("${var.eks_cluster_name}-private-route-table-%02d", count.index + 1)
  })
}

resource "aws_route" "private_default_route" {
  count                  = length(var.eks_private_subnet_cidr)
  route_table_id         = aws_route_table.private_route_table[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
  depends_on             = [aws_route_table.private_route_table]
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.eks_private_subnet_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}


