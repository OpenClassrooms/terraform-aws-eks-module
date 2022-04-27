# Settings colors
ifeq ($(COLOR),0)
    # No COLORS
    GREEN :=
    BGREEN :=
    YELLOW :=
    BYELLOW :=
    RED :=
    BRED :=
    BLUE :=
    BBLUE :=
    RESET :=
else
    # COLORS
    GREEN := \033[0;32m
    BGREEN := \033[1;32m
    YELLOW := \033[0;33m
    BYELLOW := \033[1;33m
    RED := \033[0;31m
    BRED := \033[1;31m
    BLUE := \033[0;34m
    BBLUE := \033[1;34m
    RESET := \033[0m
endif

.PHONY: help
## [HELP] show help
help:
	@printf "\n";
	@printf "Usage:\n";
	@printf "  $(GREEN)make$(RESET) $(YELLOW)<target>$(RESET)\n";
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		if (!map[FILENAME]) {\
	        printf "\nTargets from $(BLUE)%s$(RESET):\n", FILENAME; \
			map[FILENAME] = 1; \
		} \
	    helpMessage = match(lastLine, /^## (.*)/); \
	    if (helpMessage) { \
	        helpCommand = substr($$1, 0, index($$1, ":")); \
	        helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
	        printf "  => $(YELLOW)%-$(TARGET_MAX_CHAR_NUM)s$(RESET) $(GREEN)%s$(RESET)\n", helpCommand, helpMessage; \
	    } \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n";

.PHONY: terraform_apply
## Apply terraform config
terraform_apply:
	terraform aply

.PHONY: generate_initial_kube_config
## Generate First time setup Kubeconfig to access the cluster in order to setup IAM Accesses
generate_initial_kube_config:
	@CLUSTER_NAME=$$(terraform output eks_cluster_name | tr -d '"'); \
	ENDPOINT=$$(terraform output eks_cluster_endpoint | tr -d '"'); \
	CERTIFICATE=$$(terraform output cluster_ca_certificate | tr -d '"'); \
	ACCOUNT_ID=$$(AWS_PAGER="" aws sts get-caller-identity | jq -r .Account); \
	echo "apiVersion: v1\nclusters:\n- cluster:\n    certificate-authority-data: $${CERTIFICATE}\n    server: $${ENDPOINT}\n  name: $${CLUSTER_NAME}\ncontexts:\n- context:\n    cluster: $${CLUSTER_NAME}\n    user: aws\n  name: eks\ncurrent-context: eks\nkind: Config\npreferences: {}\nusers:\n- name: aws\n  user:\n    exec:\n      apiVersion: client.authentication.k8s.io/v1alpha1\n      args:\n      - token\n      - -i\n      - $${CLUSTER_NAME}\n      command: aws-iam-authenticator\n      env: null\n      interactiveMode: IfAvailable\n      provideClusterInfo: false" >  ~/.kube/initial-config-eks
	@echo "ROOT Configuration generated in ~/.kube/initial-config-eks"
	@echo "Usage example: KUBECONFIG=~/.kube/initial-config-eks kubectl get nodes"

.PHONY: backup_eks_awsauth_configmap
## Connects to the EKS cluster with the root config to get the aws-auth configmap and save it
backup_eks_awsauth_configmap: 
	@echo "Saving EKS aws-auth configmap to backup_configmap_aws-auth_YYYY_MM_DD_hh-mm-ss.yaml"; \
	KUBECONFIG=~/.kube/initial-config-eks kubectl -n kube-system get configmaps aws-auth -o yaml > backup_configmap_aws-auth_$$(date +%Y_%m_%d_%H-%M-%S).yaml;

.PHONY: generate_kube_config
## Generate Kubeconfig to access the cluster
generate_kube_config:
	@CLUSTER_NAME=$$(terraform output eks_cluster_name | tr -d '"'); \
	ENDPOINT=$$(terraform output eks_cluster_endpoint | tr -d '"'); \
	CERTIFICATE=$$(terraform output cluster_ca_certificate | tr -d '"'); \
	ACCOUNT_ID=$$(AWS_PAGER="" aws sts get-caller-identity | jq -r .Account); \
	echo "apiVersion: v1\nclusters:\n- cluster:\n    certificate-authority-data: $${CERTIFICATE}\n    server: $${ENDPOINT}\n  name: $${CLUSTER_NAME}\ncontexts:\n- context:\n    cluster: $${CLUSTER_NAME}\n    user: aws\n  name: eks\ncurrent-context: eks\nkind: Config\npreferences: {}\nusers:\n- name: aws\n  user:\n    exec:\n      apiVersion: client.authentication.k8s.io/v1alpha1\n      args:\n      - token\n      - -i\n      - $${CLUSTER_NAME}\n      - -r\n      - arn:aws:iam::$${ACCOUNT_ID}:role/eks-admin-role\n      command: aws-iam-authenticator\n      env: null\n      interactiveMode: IfAvailable\n      provideClusterInfo: false" >  ~/.kube/config-eks
	@echo "Configuration generated in ~/.kube/config-eks"
	@echo "Usage example: KUBECONFIG=~/.kube/config-eks kubectl get nodes"

.PHONY: display_eks_awsauth_configmap
## Connects to the EKS cluster with the root config and display the aws-auth configmap
display_eks_awsauth_configmap: 
	KUBECONFIG=~/.kube/initial-config-eks kubectl -n kube-system get configmaps aws-auth -o yaml

.PHONY: patch_eks_awsauth_configmap
## Connects to the EKS cluster with the root config to patch the configmaps to allow other users to connect
patch_eks_awsauth_configmap: 
	@echo "Getting EKS aws-auth configmap"; \
	KUBECONFIG=~/.kube/initial-config-eks kubectl -n kube-system get configmaps aws-auth -o yaml > /tmp/configmap_aws-auth.yaml;
	@EKS_ADMIN_ROLE=$$(terraform output eks_admin_role_name | tr -d '"'); \
	if [ $$(grep -c $$EKS_ADMIN_ROLE /tmp/configmap_aws-auth.yaml) != "0" ]; \
	then \
		echo "$$EKS_ADMIN_ROLE role already present in the configmap."; \
	else \
		echo "$$EKS_ADMIN_ROLE role missing in the configmap. Adding it..."; \
		ACCOUNT_ID=$$(AWS_PAGER="" aws sts get-caller-identity | jq -r .Account); \
		cat /tmp/configmap_aws-auth.yaml | sed s/"kind: ConfigMap"/"    - groups:\n      - system:masters\n      rolearn: arn:aws:iam::$$ACCOUNT_ID:role\/$$EKS_ADMIN_ROLE\n      username: $$EKS_ADMIN_ROLE\nkind: ConfigMap"/g > /tmp/new_configmap_aws-auth.yaml ; \
		KUBECONFIG=~/.kube/initial-config-eks kubectl apply -f /tmp/new_configmap_aws-auth.yaml ; \
	fi;
