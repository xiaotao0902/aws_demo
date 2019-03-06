# Add a role for SSM
resource "aws_iam_role" "ssm-role-eks" {
  name = "ssm-role-eks"

  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOS
}
# Add SSM role policy
resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = "${aws_iam_role.ssm-role-eks.name}"
}
# Add SSM role policy
resource "aws_iam_instance_profile" "ssm-role-eks-profile" {
    name = "ssm-role-eks-profile"
    role = "${aws_iam_role.ssm-role-eks.name}"
}
