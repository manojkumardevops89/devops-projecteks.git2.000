resource "aws_iam_role_policy_attachment" "alb_controller_policy" {
  role       = "dev-ng-eks-node-group-2026031412372272800000001"
  policy_arn = "arn:aws:iam::400516512948:policy/AWSLoadBalancerControllerIAMPolicy"
}
