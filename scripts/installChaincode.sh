#!/bin/bash

set -euo pipefail

function infoln() {
  echo -e "\033[1;34m[INFO]\033[0m $*"
}

PACKAGE_FILE="ehr.tar.gz"
CHAINCODE_PATH="ehr.tar.gz"

function installHospitalOrg() {
  infoln "Installing chaincode on peer0.hospitalOrg"
  export CORE_PEER_LOCALMSPID=HospitalOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/users/Admin@hospitalOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:7051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt
  peer lifecycle chaincode install $PACKAGE_FILE
}

function installDoctorOrg() {
  infoln "Installing chaincode on peer0.doctorOrg"
  export CORE_PEER_LOCALMSPID=DoctorOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/doctorOrg.example.com/users/Admin@doctorOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:8051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/doctorOrg.example.com/peers/peer0.doctorOrg.example.com/tls/ca.crt
  peer lifecycle chaincode install $PACKAGE_FILE
}

function installLabOrg() {
  infoln "Installing chaincode on peer0.labOrg"
  export CORE_PEER_LOCALMSPID=LabOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/labOrg.example.com/users/Admin@labOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/labOrg.example.com/peers/peer0.labOrg.example.com/tls/ca.crt
  peer lifecycle chaincode install $PACKAGE_FILE
}

function installPharmaOrg() {
  infoln "Installing chaincode on peer0.pharmaOrg"
  export CORE_PEER_LOCALMSPID=PharmaOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/users/Admin@pharmaOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:1051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/peers/peer0.pharmaOrg.example.com/tls/ca.crt
  peer lifecycle chaincode install $PACKAGE_FILE
}

function installPatientOrg() {
  infoln "Installing chaincode on peer0.patientOrg"
  export CORE_PEER_LOCALMSPID=PatientOrgMSP
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/patientOrg.example.com/users/Admin@patientOrg.example.com/msp
  export CORE_PEER_ADDRESS=localhost:11051
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/patientOrg.example.com/peers/peer0.patientOrg.example.com/tls/ca.crt
  peer lifecycle chaincode install $PACKAGE_FILE
}

# Execute all
installHospitalOrg
installDoctorOrg
installLabOrg
installPharmaOrg
installPatientOrg
