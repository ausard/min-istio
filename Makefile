default:
	terraform init
	helm repo update
	terraform apply -auto-approve
destroy:
	terraform destroy -auto-approve