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
3. **Executable registerEnroll.sh and run it:**
   ```bash
   chmod +x scripts/registerEnroll.sh
   ./scripts/registerEnroll.sh
   ```
4. **Generate genesis block, channel transcation and anchor peer update transactions:**
   ##### run a scripts that complete this
   ```bash
   chmod +x scripts/createArtifacts.sh
   ./scripts/createArtifacts.sh
   ```
   ##### or manually run this
   ```bash
   configtxgen -profile EHRSystemGenesis -channelID system-channel -outputBlock config/artifacts/genesis.block

   configtxgen -profile EHRChannel -outputCreateChannelTx ./config/artifacts/channel.tx -channelID ehrchannel

   configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/HospitalOrgMSPanchors.tx   -channelID ehrchannel   -asOrg HospitalOrgMSP  
   configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/DoctorOrgMSPanchors.tx   -channelID ehrchannel   -asOrg DoctorOrgMSP
   configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/LabOrgMSPanchors.tx  -channelID ehrchannel   -asOrg LabOrgMSP
   configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/PharmaOrgMSPanchors.tx   -channelID ehrchannel   -asOrg PharmaOrgMSP
   configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/PatientOrgMSPanchors.tx   -channelID ehrchannel   -asOrg PatientOrgMSP
   ```
   
5. **Start all peer organizations:**
   ```bash
   docker-compose -f docker/docker-compose-orderer.yaml up -d
   docker-compose -f docker/docker-compose-peers.yaml up -d
   ```
6. **Create channel using channel transaction:**
   ```bash
   export FABRIC_CFG_PATH=${PWD}/config
   export CORE_PEER_TLS_ENABLED=true
   export CORE_PEER_LOCALMSPID=HospitalOrgMSP
   export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt
   export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
   export CORE_PEER_ADDRESS=localhost:7051

   peer channel create   -o localhost:7050   --ordererTLSHostnameOverride orderer.example.com   -c ehrchannel   --tls   --cafile       ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt   -f ${PWD}/config/artifacts/channel.tx   --outputBlock ${PWD}/config/artifacts/ehrchannel.block
   ```

7. **Join all peers to the channel:**
   ##### run a scripts that complete this
   ```bash
   chmod +x scripts/joinChannel.sh
   ./scripts/joinChannel.sh
   ```
   ##### or manually run this
   ##### This is for peer0.hospitalOrg.example.com
   ```bash
   docker cp config/artifacts/ehrchannel.block peer0.hospitalOrg.example.com:/etc/hyperledger/fabric/ehrchannel.block

   docker exec -it peer0.hospitalOrg.example.com bash
      export CORE_PEER_TLS_ENABLED=true
      export CORE_PEER_LOCALMSPID=HospitalOrgMSP
      export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@hospitalOrg.example.com/msp
      export CORE_PEER_ADDRESS=peer0.hospitalOrg.example.com:7051
      export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/peers/peer0.hospitalOrg.example.com/tls/ca.crt
      peer channel join -b /etc/hyperledger/fabric/ehrchannel.block
      peer channel list
   ```
   ##### .....Repeat this for all peer
   
8. **Package Chaincode**
    ##### First go to chaincode/ehr-chaincode
   ```bash
   cd chaincode/ehr-chaincode
   ```
   ##### run this:
   ```bash
   go mod init ehr
   go mod tidy
   GO111MODULE=on go mod vendor
   ```
   ##### Navigate root directory
   ```bash
   cd ../../
   ```
   ```bash
   export FABRIC_CFG_PATH=$PWD/config/
   peer lifecycle chaincode package ehr.tar.gz   --path ./chaincode/ehr-chaincode   --lang golang   --label ehr_1.0
   ```

9. **Install Chaincode for all peer**
      ##### run a scripts that complete this setp
      ```bash
      chmod +x scripts/installChaincode.sh
      ./scripts/installChaincode.sh
      ```
      ##### or manually complete:
      ```bash
      export CORE_PEER_TLS_ENABLED=true
      export CORE_PEER_LOCALMSPID=HospitalOrgMSP
      export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
      export CORE_PEER_ADDRESS=localhost:7051
      export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt
      peer lifecycle chaincode install ehr.tar.gz
      ```
      ##### .....Repeat this for all peer

10. **Approve the Chaincode Definition**
      ##### run a scripts that complete this setp
      ```bash
      chmod +x scripts/approveChaincode.sh
      ./scripts/approveChaincode.sh
      ```
      ##### or manually complete:
      ##### first export some necessary value
      ```bash
      export CC_NAME=ehr
      export CC_VERSION=1.0
      export CC_SEQUENCE=1
      export CC_INIT_REQUIRED=true
      export CC_PACKAGE_ID=ehr_1.0:21b49b0aa00c70520ee03e461aa3b45578874c346c39f03968a20097f5a482d5 // set your own package id
      export CHANNEL_NAME=ehrchannel
      ```
      ##### next for hospital peer:
      ```bash
      export CORE_PEER_LOCALMSPID=HospitalOrgMSP
      export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
      export CORE_PEER_ADDRESS=localhost:7051
      export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt

      peer lifecycle chaincode approveformyorg   --orderer localhost:7050   --ordererTLSHostnameOverride orderer.example.com   --channelID $CHANNEL_NAME   --name $CC_NAME   --version $CC_VERSION   --package-id $CC_PACKAGE_ID   --sequence $CC_SEQUENCE  --init-required  --tls   --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
      ```
    ##### .....Repeat this for all peer
11. **Commit the Chaincode Definition**
    ##### run a scripts that complete this setp
      ```bash
      chmod +x scripts/commitChaincode.sh
      ./scripts/commitChaincode.sh
      ```
      ##### or manually complete:
    ```bash
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=HospitalOrgMSP
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt

    peer lifecycle chaincode commit   -o localhost:7050   --ordererTLSHostnameOverride orderer.example.com   --channelID ehrchannel   --name ehr   --version 1.0   --sequence 1   --init-required   --tls   --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt   --peerAddresses localhost:7051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt   --peerAddresses localhost:8051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/doctorOrg.example.com/peers/peer0.doctorOrg.example.com/tls/ca.crt   --peerAddresses localhost:9051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/labOrg.example.com/peers/peer0.labOrg.example.com/tls/ca.crt   --peerAddresses localhost:1051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/peers/peer0.pharmaOrg.example.com/tls/ca.crt   --peerAddresses localhost:11051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/patientOrg.example.com/peers/peer0.patientOrg.example.com/tls/ca.crt
    ```

12. **Chaincode Initialization**
    ```bash
    export CORE_PEER_LOCALMSPID=HospitalOrgMSP
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt
    export CORE_PEER_TLS_ENABLED=true

    peer chaincode invoke   -o localhost:7050   --ordererTLSHostnameOverride orderer.example.com   --tls   --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt   -C ehrchannel   -n ehr   --peerAddresses localhost:7051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt   --peerAddresses localhost:8051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/doctorOrg.example.com/peers/peer0.doctorOrg.example.com/tls/ca.crt   --peerAddresses localhost:9051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/labOrg.example.com/peers/peer0.labOrg.example.com/tls/ca.crt   --peerAddresses localhost:1051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/peers/peer0.pharmaOrg.example.com/tls/ca.crt   --peerAddresses localhost:11051   --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/patientOrg.example.com/peers/peer0.patientOrg.example.com/tls/ca.crt   -c '{"function":"InitLedger","Args":[]}'   --isInit
    ```
      ##### run this and check chaincode work perfectly 
      ```bash
      peer chaincode query -C ehrchannel -n ehr -c '{"Args":["GetAllDoctors"]}'
      ```
      ##### output like this:
      ```bash
      [
        {"id":"doc1","name":"Dr. Alice","hospital":"hospital1","specialty":"Cardiology"},
        {"id":"doc2","name":"Dr. Bob","hospital":"hospital2","specialty":"Neurology"}
      ]
      ```

13. **Clean up all things**
    ```bash
    chmod +x scripts/cleanupIdentities.sh
    ./scripts/cleanupIdentities.sh
    ```
   
