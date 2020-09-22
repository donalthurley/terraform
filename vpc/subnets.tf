/* 
Public subnets
Each subnet in a different AZ
 */
resource "aws_subnet" "public" {
    count                   = length(var.availabilty_zones)
    vpc_id                  = aws_vpc.main.id
    cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
    availability_zone       = element(var.availabilty_zones, count.index)
    map_public_ip_on_launch = true

    tags = {
        "Name" = "Public subnet - ${element(var.availabilty_zones, count.index)}"
     }
}

/* 
Private subnets
Each subnet in a different AZ
 */
resource "aws_subnet" "private" {
    count                   = length(var.availabilty_zones)
    vpc_id                  = aws_vpc.main.id

    # Take into account CIDR blocks allocated to the public subnets

    cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + length(var.availabilty_zones))
    availability_zone       = element(var.availabilty_zones, count.index)
    map_public_ip_on_launch = false

    tags = {
        "Name" = "Private subnet - ${element(var.availabilty_zones, count.index)}"
     }
}

/*
NAT gateways enable instances in a private subnet
to connect the Internet or other AWS services,
but prevent the Internet from initiating a connection with those instances.

We create a separate NAT gateway in each AZ for high availability.

Each NAT gateway requires an Elastic IP.
*/
resource "aws_eip" "nat" {
    count = length(var.availabilty_zones)
    vpc = true
}

resource "aws_nat_gateway" "main" {
    count = length(var.availabilty_zones)
    subnet_id = element(aws_subnet.public.*.id, count.index)
    allocation_id = element(aws_eip.nat.*.id, count.index)

    tags = {
        "Name" = "NAT - ${element(var.availabilty_zones, count.index)}"
     }
}
