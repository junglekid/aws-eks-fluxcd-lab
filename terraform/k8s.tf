### Weave GitOp
resource "kubernetes_namespace" "weave_gitops" {
  metadata {
    annotations = {
      name = "weave-gitops"
    }

    name = "weave-gitops"
  }
}

### React App
resource "kubernetes_namespace" "react_app" {
  metadata {
    annotations = {
      name = "react-app"
    }

    name = "react-app"
  }
}

### Podinfo
resource "kubernetes_namespace" "podinfo" {
  metadata {
    annotations = {
      name = "podinfo"
    }

    name = "podinfo"
  }
}
