# 🚀 Capstone-Infra: Azure DevOps Cloud Capstone Project Infrastructure

This repository defines the **Infrastructure as Code (IaC)** for a real-world Azure-based DevOps Capstone project. It provisions secure, scalable, and resilient infrastructure to support a **microservices-based application** running on **Azure Kubernetes Service (AKS)** with multi-region deployment, automated CI/CD, and enterprise-grade security.

---

## 🌟 Project Goal

To design and deploy a production-grade cloud infrastructure on **Azure** using **Terraform** and **Azure DevOps**, with:

- High availability & disaster recovery (HA + DR)
- Centralized CI/CD automation
- Enterprise-grade security & compliance
- Cloud-native observability

---

## ✨ Key Features & Components

### 🏗️ Core Azure Resources

- **Multi-Region AKS**:  
  - `Primary`: Australia Central  
  - `DR`: Japan West (Active-Passive)

- **Networking**:
  - VNets, public/private subnets
  - Azure NAT Gateway for secure outbound access
  - Azure Bastion for admin access
  - VNet peering across regions
  - Simulated On-Prem VNet + VPN Gateway

- **Container Registry**: Azure Container Registry (ACR) with geo-replication

- **Databases**: Azure SQL Database with geo-replication

- **Secrets**: Azure Key Vault (region-specific)

- **Monitoring**:
  - Azure Monitor
  - Log Analytics
  - Application Insights
  - Container Insights

- **IAM & Security**:
  - Custom role assignments
  - NSGs with least privilege
  - Azure Policy enforcement
  - Budget alerts

---

## 🏛️ High-Level Architecture

```mermaid
graph TD
    subgraph Global
        TM(Azure Traffic Manager)
        ACR(Azure Container Registry)
        ADO(Azure DevOps Repos & Pipelines)
    end

    subgraph Primary Region: Australia Central
        AKS_P(Azure Kubernetes Service)
        SQL_P(Azure SQL Database)
        KV_P(Azure Key Vault)
        MON_P(Azure Monitor / Log Analytics)
        VNET_P(VNet & Subnets)
    end

    subgraph DR Region: Japan West
        AKS_DR(Azure Kubernetes Service)
        SQL_DR(Azure SQL Database)
        KV_DR(Azure Key Vault)
        MON_DR(Azure Monitor / Log Analytics)
        VNET_DR(VNet & Subnets)
    end

    subgraph On-Premises Simulation
        VNET_ONPREM(Simulated On-Prem VNet)
    end

    ADO --> ACR
    ADO --> AKS_P
    ADO --> AKS_DR

    TM --> AKS_P
    TM --> AKS_DR

    AKS_P --- SQL_P
    AKS_P --- KV_P
    AKS_P --> MON_P

    AKS_DR --- SQL_DR
    AKS_DR --- KV_DR
    AKS_DR --> MON_DR

    SQL_P <--> SQL_DR

    VNET_P <--> VNET_DR
    VNET_P <--> VNET_ONPREM
