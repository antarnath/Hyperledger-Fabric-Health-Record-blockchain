#!/bin/bash

set -euo pipefail

function infoln() {
  echo -e "\033[1;34m[INFO]\033[0m $*"
}

CHANNEL_NAME="ehrchannel"
CHAINCODE_NAME="ehr"

infoln "Invoking chaincode initialization..."
peer chaincode invoke \
  -o localhost:7050 \
  --ordererTLSHostnameOverride orderer.example.com \
  --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt \
  -C $CHANNEL_NAME \
  -n $CHAINCODE_NAME \
  --isInit \
  --peerAddresses localhost:7051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/peers/peer0.hospitalOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:8051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/doctorOrg.example.com/peers/peer0.doctorOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:9051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/labOrg.example.com/peers/peer0.labOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:1051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/peers/peer0.pharmaOrg.example.com/tls/ca.crt \
  --peerAddresses localhost:11051 \
  --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/patientOrg.example.com/peers/peer0.patientOrg.example.com/tls/ca.crt \
  -c '{"Args":[]}'
