# Hyperledger Fabric Health Record Blockchain Project

This project implements a permissioned blockchain-based Electronic Health Record (EHR) system using **Hyperledger Fabric**. The system ensures secure, tamper-proof sharing of patient health data among multiple healthcare organizations.

---

## Project Overview

This EHR blockchain network includes five organizations:

- **HospitalOrg**
- **DoctorOrg**
- **LabOrg**
- **PharmaOrg**
- **PatientOrg**

Each organization runs its own peer and has its identities managed by Fabric CA. The network enables secure data exchange with privacy and permission control.

---

## Features

- **Permissioned Blockchain:** Only authorized participants can access or update records.
- **Modular Chaincode:** Chaincode written in Go (`ehr_chaincode.go`) with role-based access control.
- **Identity Management:** Fabric CA used for generating and managing cryptographic identities.
- **Multi-Org Channel:** Single channel (`ehrchannel`) joined by all organizations.
- **Chaincode Lifecycle:** Package, install, approve, and commit chaincode on the channel.
- **REST API (Planned):** Backend API layer to interact with the blockchain network.

---
