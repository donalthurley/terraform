resource "aws_db_subnet_group" "default" {
    name = "main"
    subnet_ids = tolist(data.terraform_remote_state.vpc.outputs.private_subnets)
    
    tags = {
        "Name" = "${var.db_name} subnet group"
    }
}