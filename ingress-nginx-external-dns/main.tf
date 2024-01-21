data "azurerm_subscription" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_zone" "aks_dns_zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
}

resource "helm_release" "ingress" {
  name       = "ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.ingress_namespace
  version    = "3.36.0"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
}

resource "helm_release" "exteranal_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = var.ingress_namespace
  version    = "5.4.6"

  values = [
    templatefile("${path.root}/external-dns/values.yaml", {
      azure_subscription_id  = data.azurerm_subscription.current.subscription_id
      azure_tenant_id        = data.azurerm_subscription.current.tenant_id
      external_dns_client_id = azurerm_user_assigned_identity.aks_dns_identity.client_id
      azure_resource_group   = var.resource_group_name
    })
  ]
}

resource "azurerm_user_assigned_identity" "aks_dns_identity" {
  name                = "aks-dns-identity"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
}

resource "azurerm_federated_identity_credential" "default" {
  name                = var.ingress_namespace
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.aks_dns_identity.id
  subject             = "system:serviceaccount:${var.ingress_namespace}:external-dns"
}

resource "azurerm_role_assignment" "aks_dns_role_assignment" {
  scope                = azurerm_dns_zone.aks_dns_zone.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_dns_identity.principal_id
}

resource "azurerm_role_assignment" "aks_rg_reader_role_assignment" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.aks_dns_identity.principal_id
}
