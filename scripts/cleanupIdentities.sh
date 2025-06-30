#!/bin/bash

set -e

# List of organizations
ORG_FOLDERS=(
  "hospitalOrg"
  "doctorOrg"
  "labOrg"
  "pharmaOrg"
  "patientOrg"
  "ordererOrg"
)

function infoln() {
  echo -e "\033[1;33m[INFO]\033[0m $*"
}

# Stop and remove all containers from your fabric compose files
function cleanupContainers() {
  infoln "Stopping and removing containers from CA, orderer, and peers"
  docker-compose -f docker/docker-compose-ca.yaml down -v
  docker-compose -f docker/docker-compose-orderer.yaml down -v
  docker-compose -f docker/docker-compose-peers.yaml down -v
}

function cleanupOrg() {
  local ORG=$1
  local ORG_CA_DIR="organizations/fabric-ca/${ORG}"

  infoln "Cleaning up ${ORG_CA_DIR} (except fabric-ca-server-config.yaml)"

  # Remove all files and directories except fabric-ca-server-config.yaml
  find "${ORG_CA_DIR}" -mindepth 1 ! -name "fabric-ca-server-config.yaml" -exec rm -rf {} +
}

function cleanupEnrollments() {
  infoln "Removing peerOrganizations and ordererOrganizations folders"
  rm -rf organizations/peerOrganizations
  rm -rf organizations/ordererOrganizations
}

function cleanupArtifacts() {
  infoln "Cleaning up config/artifacts folder"
  rm -rf config/artifacts/*
}

function main() {
  for ORG in "${ORG_FOLDERS[@]}"; do
    cleanupOrg "$ORG"
  done
  cleanupEnrollments
  cleanupArtifacts
  cleanupContainers
  infoln "Cleanup complete."
}

main
