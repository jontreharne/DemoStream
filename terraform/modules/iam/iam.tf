resource "aws_iam_role" "manager_role" {
	name = "manager-role"
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
}

resource "aws_iam_instance_profile" "manager_profile" {
	name = "manager-profile"
	role = "${aws_iam_role.manager_role.id}"
}

resource "aws_iam_role_policy" "manager_policy" {
	name = "manager-policy"
	role = "${aws_iam_role.manager_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
