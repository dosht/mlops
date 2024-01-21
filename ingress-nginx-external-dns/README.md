# Tutorial: Installing Ingress Nginx and External DNS via Helm and Terraform on AKS with Managed Identity

This repository contains code and instructions for installing Ingress Nginx and External DNS on Azure Kubernetes Service (AKS) using Helm and Terraform. The deployment is configured to use AKS Managed Identity for authentication.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

- An Azure subscription
- Azure CLI installed
- Helm installed
- Terraform installed
- AKS cluster created with Managed Identity enabled

## Getting Started

To get started with the installation, follow these steps:

1. Clone this repository to your local machine.
2. Open a terminal and navigate to the repository directory.
3. Update the necessary configuration files with your specific settings.
4. Run the Terraform commands to provision the required resources.
5. Verify DNS Zone, user assigned identity and role assignments are created in Azure Portal.
6. Verify Ingress Nginx and External DNS are deployed using Helm.
7. Verify Ingress Nginx and External DNS are running and test the functionality.

For detailed step-by-step instructions, please refer to the [full tutorial](/Users/mu/src/mlops/ingress-nginx-external-dns/README.md).

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This code is licensed under the [MIT License](LICENSE).
