resource "kubernetes_cluster_role" "viewonly" {
  metadata {
    name = "kubernetes-dashboard-viewonly"
    labels = local.kubernetes_resources_labels
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps","endpoints","persistentvolumeclaims","pods","replicationcontrollers","replicationcontrollers/scale","serviceaccounts","services","nodes","persistentvolumeclaims","persistentvolumes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["bindings","events","limitranges","namespaces/status","pods/log","pods/status","replicationcontrollers/status","resourcequotas","resourcequotas/status"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["daemonsets","deployments","deployments/scale","replicasets","replicasets/scale","statefulsets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs","jobs"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions"]
    resources  = ["daemonsets","deployments","deployments/scale","ingresses","networkpolicies","replicasets","replicasets/scale","replicationcontrollers/scale"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["networkpolicies"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "volumeattachments"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["clusterrolebindings", "clusterroles","roles","rolebindings"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "viewonly" {
  metadata {
    name = "kubernetes-dashboard-viewonly"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.viewonly.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kubernetes_dashboard_viewonly.metadata.0.name
    namespace = var.kubernetes_namespace
  }
}

resource "kubernetes_service_account" "kubernetes_dashboard_viewonly" {
  depends_on = [kubernetes_namespace.kubernetes_dashboard]
  metadata {
    name = "kubernetes-dashboard-viewonly"
    namespace = var.kubernetes_namespace
    labels = local.kubernetes_resources_labels
  }
}

resource "kubernetes_service_account" "kubernetes_dashboard_admin" {
  depends_on = [kubernetes_namespace.kubernetes_dashboard]
  metadata {
    name = "kubernetes-dashboard-admin"
    namespace = var.kubernetes_namespace
    labels = local.kubernetes_resources_labels
  }
}

resource "kubernetes_cluster_role_binding" "admin" {
  metadata {
    name = "kubernetes-dashboard-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kubernetes_dashboard_admin.metadata.0.name
    namespace = var.kubernetes_namespace
  }
}