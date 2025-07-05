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

## Getting Started

### Prerequisites

- Go (1.20 or higher recommended)
- Docker & Docker Compose
- Hyperledger Fabric binaries (`peer`, `orderer`, `configtxgen`, etc.)
- Git (for version control)

### Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/antarnath/Hyperledger-Fabric-Health-Record-blockchain.git
   cd Hyperledger-Fabric-Health-Record-blockchain
   ```
2. **Start CA containers:**
   ```bash
   docker-compose -f docker/docker-compose-ca.yaml up -d
   ```
3. ** Executable registerEnroll.sh and run it:**
   ```bash
   chmod +x scripts/registerEnroll.sh
   ./scripts/registerEnroll.sh
   ```
4. **Generate genesis block, channel transcation and anchor peer update transactions:**
   ```bash
      configtxgen -profile EHRSystemGenesis -channelID system-channel -outputBlock config/artifacts/genesis.block
   
      configtxgen -profile EHRChannel -outputCreateChannelTx ./config/artifacts/channel.tx -channelID ehrchannel

      configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/HospitalOrgMSPanchors.tx   -channelID ehrchannel   -asOrg HospitalOrgMSP  
      configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/DoctorOrgMSPanchors.tx   -channelID ehrchannel   -asOrg DoctorOrgMSP
      configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/LabOrgMSPanchors.tx  -channelID ehrchannel   -asOrg LabOrgMSP
      configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/PharmaOrgMSPanchors.tx   -channelID ehrchannel   -asOrg PharmaOrgMSP
      configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/PatientOrgMSPanchors.tx   -channelID ehrchannel   -asOrg PatientOrgMSP
   ```
   or just run a scripts that complete this
   ```bash
      chmod +x scripts/createArtifacts.sh
      ./scripts/createArtifacts.sh
   ```
