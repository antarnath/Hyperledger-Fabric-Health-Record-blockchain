#!/bin/bash

set -e

CHANNEL_BLOCK=./config/artifacts/ehrchannel.block

function infoln() {
  echo -e "\033[1;34m$@\033[0m"
}

function joinHospitalPeer() {
  infoln "📦 Copying ehrchannel.block into peer0.hospitalOrg.example.com"
  docker cp $CHANNEL_BLOCK peer0.hospitalOrg.example.com:/etc/hyperledger/fabric/ehrchannel.block

  infoln "🔁 Joining peer0.hospitalOrg.example.com to ehrchannel"
  docker exec peer0.hospitalOrg.example.com bash -c "
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=HospitalOrgMSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@hospitalOrg.example.com/msp
    export CORE_PEER_ADDRESS=peer0.hospitalOrg.example.com:7051
    export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/peers/peer0.hospitalOrg.example.com/tls/ca.crt
    peer channel join -b /etc/hyperledger/fabric/ehrchannel.block
    peer channel list
  "
}

function joinDoctorPeer() {
  infoln "📦 Copying ehrchannel.block into peer0.doctorOrg.example.com"
  docker cp $CHANNEL_BLOCK peer0.doctorOrg.example.com:/etc/hyperledger/fabric/ehrchannel.block

  infoln "🔁 Joining peer0.doctorOrg.example.com to ehrchannel"
  docker exec peer0.doctorOrg.example.com bash -c "
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=DoctorOrgMSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@doctorOrg.example.com/msp
    export CORE_PEER_ADDRESS=peer0.doctorOrg.example.com:8051
    export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/peers/peer0.doctorOrg.example.com/tls/ca.crt
    peer channel join -b /etc/hyperledger/fabric/ehrchannel.block
    peer channel list
  "
}

function joinLabPeer() {
  infoln "📦 Copying ehrchannel.block into peer0.labOrg.example.com"
  docker cp $CHANNEL_BLOCK peer0.labOrg.example.com:/etc/hyperledger/fabric/ehrchannel.block

  infoln "🔁 Joining peer0.labOrg.example.com to ehrchannel"
  docker exec peer0.labOrg.example.com bash -c "
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=LabOrgMSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@labOrg.example.com/msp
    export CORE_PEER_ADDRESS=peer0.labOrg.example.com:9051
    export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/peers/peer0.labOrg.example.com/tls/ca.crt
    peer channel join -b /etc/hyperledger/fabric/ehrchannel.block
    peer channel list
  "
}

function joinPharmaPeer() {
  infoln "📦 Copying ehrchannel.block into peer0.pharmaOrg.example.com"
  docker cp $CHANNEL_BLOCK peer0.pharmaOrg.example.com:/etc/hyperledger/fabric/ehrchannel.block

  infoln "🔁 Joining peer0.pharmaOrg.example.com to ehrchannel"
  docker exec peer0.pharmaOrg.example.com bash -c "
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=PharmaOrgMSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@pharmaOrg.example.com/msp
    export CORE_PEER_ADDRESS=peer0.pharmaOrg.example.com:1051
    export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/peers/peer0.pharmaOrg.example.com/tls/ca.crt
    peer channel join -b /etc/hyperledger/fabric/ehrchannel.block
    peer channel list
  "
}

function joinPatientPeer() {
  infoln "📦 Copying ehrchannel.block into peer0.patientOrg.example.com"
  docker cp $CHANNEL_BLOCK peer0.patientOrg.example.com:/etc/hyperledger/fabric/ehrchannel.block

  infoln "🔁 Joining peer0.patientOrg.example.com to ehrchannel"
  docker exec peer0.patientOrg.example.com bash -c "
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_LOCALMSPID=PatientOrgMSP
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/users/Admin@patientOrg.example.com/msp
    export CORE_PEER_ADDRESS=peer0.patientOrg.example.com:11051
    export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/peers/peer0.patientOrg.example.com/tls/ca.crt
    peer channel join -b /etc/hyperledger/fabric/ehrchannel.block
    peer channel list
  "
}

# Run all
infoln "🚀 Joining all peers to ehrchannel..."
joinHospitalPeer
joinDoctorPeer
joinLabPeer
joinPharmaPeer
joinPatientPeer
infoln "✅ All peers successfully joined ehrchannel."
