---
marp: true
---

<!-- _class: invert -->

## AKS Windows Server Node Pool

* Is Kubernetes different on Windows and Linux? Windows Server node pool support
  includes some limitations that are part of the upstream Windows Server in
  Kubernetes project. These limitations are not specific to AKS. For more
  information on the upstream support for Windows Server in Kubernetes, see the
  Supported functionality and limitations section of the Intro to Windows
  support in Kubernetes document, from the Kubernetes project.

---

## Kubernetes On Windows

* Historically, Kubernetes is Linux-focused. Many examples used in the upstream
  Kubernetes.io website are intended for use on Linux nodes. When you create
  deployments that use Windows Server containers, the following considerations
  at the OS level apply:

---

## Kubernetes On Windows - Identity

* Identity: Linux identifies a user by an integer user identifier (UID). A user
  also has an alphanumeric user name for logging on, which Linux translates to
  the user's UID. Similarly, Linux identifies a user group by an integer group
  identifier (GID) and translates a group name to its corresponding GID. Windows
  Server uses a larger binary security identifier (SID) that's stored in the
  Windows Security Access Manager (SAM) database. This database is not shared
  between the host and containers, or between containers.

---

## Kubernetes On Windows - File Permissions

* File permissions: Windows Server uses an access control list based on SIDs,
  rather than a bitmask of permissions and UID+GID.

---

## Kubernetes On Windows - File Paths

* File paths: The convention on Windows Server is to use \ instead of /. In pod
  specs that mount volumes, specify the path correctly for Windows Server
  containers. For example, rather than a mount point of /mnt/volume in a Linux
  container, specify a drive letter and location such as /K/Volume to mount as
  the K: drive.

---

## Can I run Windows only clusters in AKS?

* The master nodes (the control plane) in an AKS cluster are hosted by the AKS
  service. You won't be exposed to the operating system of the nodes hosting the
  master components. All AKS clusters are created with a default first node
  pool, which is Linux-based. This node pool contains system services that are
  needed for the cluster to function. We recommend that you run at least two
  nodes in the first node pool to ensure the reliability of your cluster and the
  ability to do cluster operations. The first Linux-based node pool can't be
  deleted unless the AKS cluster itself is deleted.

---

## AKS Windows Node Pools And Networking

* AKS clusters with Windows node pools must use the Azure Container Networking
  Interface (Azure CNI) (advanced) networking model. Kubenet (basic) networking
  is not supported. For more information on the differences in network models,
  see Network concepts for applications in AKS. The Azure CNI network model
  requires additional planning and consideration for IP address management. For
  more information on how to plan and implement Azure CNI, see Configure Azure
  CNI networking in AKS.