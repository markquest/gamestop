resource "aws_iam_role" "gamestop-kube-master-s3-role" {
  name               = "gamestop-master-server-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

resource "aws_iam_instance_profile" "gamestop-kube-master-profile" {
  name = "gamestop-master-server-profile"
  role = aws_iam_role.gamestop-kube-master-s3-role.name
}
