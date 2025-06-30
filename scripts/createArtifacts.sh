#!/bin/bash

set -e

function infoln() {
  echo -e "\033[1;33m[INFO]\033[0m $*"
}


function createArtifacts(){
  export FABRIC_CFG_PATH=./config
  infoln "Generate genesis.blok"
  configtxgen -profile EHRSystemGenesis -channelID system-channel -outputBlock config/artifacts/genesis.block
  infoln "Generate channel transcation"
  configtxgen -profile EHRChannel -outputCreateChannelTx ./config/artifacts/channel.tx -channelID ehrchannel
  infoln "Generate Anchor Peer Update Transactions for Each Org"
  configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/HospitalOrgMSPanchors.tx   -channelID ehrchannel   -asOrg HospitalOrgMSP  
  configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/DoctorOrgMSPanchors.tx   -channelID ehrchannel   -asOrg DoctorOrgMSP
  configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/LabOrgMSPanchors.tx  -channelID ehrchannel   -asOrg LabOrgMSP
  configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/PharmaOrgMSPanchors.tx   -channelID ehrchannel   -asOrg PharmaOrgMSP
  configtxgen -profile EHRChannel   -outputAnchorPeersUpdate ./config/artifacts/PatientOrgMSPanchors.tx   -channelID ehrchannel   -asOrg PatientOrgMSP
}


function main(){
  createArtifacts
}

main
