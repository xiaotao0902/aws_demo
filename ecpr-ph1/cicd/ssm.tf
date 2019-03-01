resource "aws_iam_role" "ssm-role-gitlab" {
  name = "ssm-role-gitlab"

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

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = "${aws_iam_role.ssm-role-gitlab.name}"
}

resource "aws_iam_instance_profile" "ssm-role-gitlab-profile" {
    name = "ssm-role-gitlab-profile"
    role = "${aws_iam_role.ssm-role-gitlab.name}"
}



