#!/bin/bash

set -euo pipefail

function infoln() {
  echo -e "\033[1;34m[INFO]\033[0m $*"
}

CHANNEL_NAME="ehrchannel"
CHAINCODE_NAME="ehr"  
CHAINCODE_VERSION="1.0"
CHAINCODE_PACKAGE_ID="ehr_1.0:0323213207fdab754b30b41acf003fbc1cfd65afa7023ec2f75043e99ccfd0c3"
CHAINCODE_SEQUENCE=1

ORDERER_CA="${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
ORDERER_ADDRESS="localhost:7050"

function approveForHospitalOrg() {
  infoln "Approving chaincode for HospitalOrg..."
  export CORE_PEER_LOCALMSPID=HospitalOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt

  peer lifecycle chaincode approveformyorg \
    -o $ORDERER_ADDRESS \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $CHAINCODE_PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --init-required
}

function approveForDoctorOrg() {
  infoln "Approving chaincode for DoctorOrg..."
  export CORE_PEER_LOCALMSPID=DoctorOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/doctorOrg.example.com/users/Admin@doctorOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:8051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/doctorOrg.example.com/peers/peer0.doctorOrg.example.com/tls/ca.crt

  peer lifecycle chaincode approveformyorg \
    -o $ORDERER_ADDRESS \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $CHAINCODE_PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --init-required 
}

function approveForLabOrg() {
  infoln "Approving chaincode for LabOrg..."
  export CORE_PEER_LOCALMSPID=LabOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/labOrg.example.com/users/Admin@labOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/labOrg.example.com/peers/peer0.labOrg.example.com/tls/ca.crt

  peer lifecycle chaincode approveformyorg \
    -o $ORDERER_ADDRESS \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $CHAINCODE_PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --init-required
}

function approveForPharmaOrg() {
  infoln "Approving chaincode for PharmaOrg..."
  export CORE_PEER_LOCALMSPID=PharmaOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/users/Admin@pharmaOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:1051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/peers/peer0.pharmaOrg.example.com/tls/ca.crt

  peer lifecycle chaincode approveformyorg \
    -o $ORDERER_ADDRESS \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $CHAINCODE_PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --init-required
}

function approveForPatientOrg() {
  infoln "Approving chaincode for PatientOrg..."
  export CORE_PEER_LOCALMSPID=PatientOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/patientOrg.example.com/users/Admin@patientOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:11051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/patientOrg.example.com/peers/peer0.patientOrg.example.com/tls/ca.crt

  peer lifecycle chaincode approveformyorg \
    -o $ORDERER_ADDRESS \
    --ordererTLSHostnameOverride orderer.example.com \
    --tls --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $CHAINCODE_PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --init-required
}

# Call each function
approveForHospitalOrg
approveForDoctorOrg
approveForLabOrg
approveForPharmaOrg
approveForPatientOrg
