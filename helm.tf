resource "kubernetes_namespace" "ns" {
  metadata {
    annotations = {
      name = "apps"
    }

    labels = {
      mylabel = "apps"
    }

    name = "apps"
  }
}



# Create a namespace for Argo CD
resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}

# Install Argo CD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  version         = "5.37.0"  # Replace with the desired version of Argo CD
  namespace       = kubernetes_namespace.argocd_namespace.metadata[0].name
  create_namespace = false

  set {
    name  = "server.service.type"
    value = "LoadBalancer"  # Replace with the desired service type (e.g., ClusterIP, NodePort)
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
}

# external secrets

resource "kubernetes_service_account" "kes" {
  metadata {
    name = "kubernetes-external-secrets"
    #name = "kubernetes-external-secrets"
  }
  secret {
    name = "${kubernetes_secret.kes.metadata.0.name}"
  }
}
resource "kubernetes_secret" "kes" {
  metadata {
    name = "kubernetes-external-secrets"
  }
}

resource "helm_release" "external_secrets" {
  depends_on = [kubernetes_service_account.kes]
  name       = "external-secrets-controller"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
#  version    = "v0.5.9"

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "webhook.port"
    value = "9443"
  }
}


/*
# postgres
resource "helm_release" "postgres" {
  depends_on = [ kubernetes_namespace.ns ]
  chart = "postgresql"
  name = "postgresql-postgresql"
  version = "11.6.19"
  timeout = 700
  repository = "https://charts.bitnami.com/bitnami"
  namespace = "apps"

  values = [
    file("./templates/postgresql/values.yaml")
  ]
}


# redis
resource "helm_release" "redis" {
  depends_on = [ kubernetes_namespace.ns ]
  chart = "redis"
  name = "redis"
  timeout = 700
  repository = "https://charts.bitnami.com/bitnami"
  namespace = "apps"

  values = [
    file("./templates/redis/values.yaml")
  ]
}



# mongo
resource "helm_release" "mongodb" {
  depends_on = [ kubernetes_namespace.ns ]
  chart = "mongodb"
  name = "mongodb"
  version = "13.9.4"
  timeout = 700
  repository = "https://charts.bitnami.com/bitnami"
  namespace = "apps"

  values = [
    file("./templates/mongodb/values.yaml")
  ]
}



*/