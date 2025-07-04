#!/bin/bash

set -euo pipefail

function infoln() {
  echo -e "\033[1;34m[INFO]\033[0m $*"
}

infoln "Setting environment variables..."
export CHANNEL_NAME=ehrchannel
export CC_NAME=ehr
export CC_VERSION=1.0
export CC_SEQUENCE=1
export CC_INIT_REQUIRED=true

infoln "Committing chaincode to channel $CHANNEL_NAME..."
peer lifecycle chaincode commit \
  -o localhost:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  --channelID $CHANNEL_NAME \
  --name $CC_NAME \
  --version $CC_VERSION \
  --sequence $CC_SEQUENCE \
  --init-required \
  --tls \
  --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt \
  --peerAddresses localhost:7051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:8051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/doctorOrg.example.com/peers/peer0.doctorOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:9051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/labOrg.example.com/peers/peer0.labOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:1051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/peers/peer0.pharmaOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:11051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/patientOrg.example.com/peers/peer0.patientOrg.example.com/tls/ca.crt

infoln "✅ Chaincode committed successfully to channel $CHANNEL_NAME"
