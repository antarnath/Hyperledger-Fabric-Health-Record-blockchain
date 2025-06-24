#!/bin/bash

set -euo pipefail

function infoln() {
  echo -e "\033[1;34m[INFO ] $*\033[0m"
}

function createHospitalOrg() {
  infoln "Enrolling CA admin for HospitalOrg"
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/hospitalOrg.example.com/

  mkdir -p $FABRIC_CA_CLIENT_HOME

  fabric-ca-client enroll \
    -u https://admin:adminpw@localhost:7054 \
    --caname ca-hospital \
    --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospital.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospital.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospital.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-hospital.pem
    OrganizationalUnitIdentifier: orderer' > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.hospitalOrg.example.com-cert.pem"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/ca/ca.hospitalOrg.example.com-cert.pem"

  infoln "Registering peer0, user1, admin for HospitalOrg"
  fabric-ca-client register --caname ca-hospital --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-hospital --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-hospital --id.name hospitaladmin --id.secret hospitaladminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"

  infoln "Generating MSP for peer0.hospitalOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7054 \
    --caname ca-hospital \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/msp/config.yaml"

  infoln "Generating TLS certs for peer0.hospitalOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7054 \
    --caname ca-hospital \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.hospitalOrg.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls/tlscacerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls/signcerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls/keystore/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.hospitalOrg.example.com/tls/server.key"

  infoln "Generating user1 MSP"
  fabric-ca-client enroll \
    -u https://user1:user1pw@localhost:7054 \
    --caname ca-hospital \
    -M "${FABRIC_CA_CLIENT_HOME}/users/User1@hospitalOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/User1@hospitalOrg.example.com/msp/config.yaml"

  infoln "Generating admin MSP"
  fabric-ca-client enroll \
    -u https://hospitaladmin:hospitaladminpw@localhost:7054 \
    --caname ca-hospital \
    -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@hospitalOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/hospitalOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@hospitalOrg.example.com/msp/config.yaml"
}

function createDoctorOrg() {
  infoln "Enrolling CA admin for DoctorOrg"
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/doctorOrg.example.com/
  mkdir -p $FABRIC_CA_CLIENT_HOME
  fabric-ca-client enroll \
    -u https://admin:adminpw@localhost:7055 \
    --caname ca-doctor \
    --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7055-ca-doctor.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7055-ca-doctor.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7055-ca-doctor.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7055-ca-doctor.pem
    OrganizationalUnitIdentifier: orderer' > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.doctorOrg.example.com-cert.pem"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/ca/ca.doctorOrg.example.com-cert.pem"

  infoln "Registering peer0, user1, admin for DoctorOrg"
  fabric-ca-client register --caname ca-doctor --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-doctor --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-doctor --id.name doctoradmin --id.secret doctoradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"

  infoln "Generating MSP for peer0.doctorOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7055 \
    --caname ca-doctor \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/msp/config.yaml"

  infoln "Generating TLS certs for peer0.doctorOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7055 \
    --caname ca-doctor \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.doctorOrg.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls/tlscacerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls/signcerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls/keystore/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.doctorOrg.example.com/tls/server.key"

  infoln "Generating user1 MSP"
  fabric-ca-client enroll \
    -u https://user1:user1pw@localhost:7055 \
    --caname ca-doctor \
    -M "${FABRIC_CA_CLIENT_HOME}/users/User1@doctorOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/User1@doctorOrg.example.com/msp/config.yaml"

  infoln "Generating admin MSP"
  fabric-ca-client enroll \
    -u https://doctoradmin:doctoradminpw@localhost:7055 \
    --caname ca-doctor \
    -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@doctorOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/doctorOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@doctorOrg.example.com/msp/config.yaml"
}

function createLabOrg() {
  infoln "Enrolling CA admin for LabOrg"
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/labOrg.example.com/
  mkdir -p $FABRIC_CA_CLIENT_HOME
  fabric-ca-client enroll \
    -u https://admin:adminpw@localhost:7056 \
    --caname ca-lab \
    --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7056-ca-lab.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7056-ca-lab.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7056-ca-lab.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7056-ca-lab.pem
    OrganizationalUnitIdentifier: orderer' > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.labOrg.example.com-cert.pem"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/ca/ca.labOrg.example.com-cert.pem"

  infoln "Registering peer0, user1, admin for LabOrg"
  fabric-ca-client register --caname ca-lab --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-lab --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-lab --id.name labadmin --id.secret labadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"

  infoln "Generating MSP for peer0.labOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7056 \
    --caname ca-lab \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/msp/config.yaml"

  infoln "Generating TLS certs for peer0.labOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7056 \
    --caname ca-lab \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.labOrg.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls/tlscacerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls/signcerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls/keystore/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.labOrg.example.com/tls/server.key"

  infoln "Generating user1 MSP"
  fabric-ca-client enroll \
    -u https://user1:user1pw@localhost:7056 \
    --caname ca-lab \
    -M "${FABRIC_CA_CLIENT_HOME}/users/User1@labOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/User1@labOrg.example.com/msp/config.yaml"

  infoln "Generating admin MSP"
  fabric-ca-client enroll \
    -u https://labadmin:labadminpw@localhost:7056 \
    --caname ca-lab \
    -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@labOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/labOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@labOrg.example.com/msp/config.yaml"
}

function createPharmaOrg() {
  infoln "Enrolling CA admin for PharmaOrg"
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/pharmaOrg.example.com/
  mkdir -p $FABRIC_CA_CLIENT_HOME
  fabric-ca-client enroll \
    -u https://admin:adminpw@localhost:7057 \
    --caname ca-pharma \
    --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7057-ca-pharma.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7057-ca-pharma.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7057-ca-pharma.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7057-ca-pharma.pem
    OrganizationalUnitIdentifier: orderer' > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.pharmaOrg.example.com-cert.pem"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/ca/ca.pharmaOrg.example.com-cert.pem"

  infoln "Registering peer0, user1, admin for PharmaOrg"
  fabric-ca-client register --caname ca-pharma --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-pharma --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-pharma --id.name pharmaadmin --id.secret pharmaadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"

  infoln "Generating MSP for peer0.pharmaOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7057 \
    --caname ca-pharma \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/msp/config.yaml"

  infoln "Generating TLS certs for peer0.pharmaOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7057 \
    --caname ca-pharma \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.pharmaOrg.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls/tlscacerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls/signcerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls/keystore/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.pharmaOrg.example.com/tls/server.key"

  infoln "Generating user1 MSP"
  fabric-ca-client enroll \
    -u https://user1:user1pw@localhost:7057 \
    --caname ca-pharma \
    -M "${FABRIC_CA_CLIENT_HOME}/users/User1@pharmaOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/User1@pharmaOrg.example.com/msp/config.yaml"

  infoln "Generating admin MSP"
  fabric-ca-client enroll \
    -u https://pharmaadmin:pharmaadminpw@localhost:7057 \
    --caname ca-pharma \
    -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@pharmaOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/pharmaOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@pharmaOrg.example.com/msp/config.yaml"
}

function createPatientOrg() {
  infoln "Enrolling CA admin for PatientOrg"
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/patientOrg.example.com/
  mkdir -p $FABRIC_CA_CLIENT_HOME
  fabric-ca-client enroll \
    -u https://admin:adminpw@localhost:7058 \
    --caname ca-patient \
    --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7058-ca-patient.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7058-ca-patient.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7058-ca-patient.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7058-ca-patient.pem
    OrganizationalUnitIdentifier: orderer' > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.patientOrg.example.com-cert.pem"
  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/ca/ca.patientOrg.example.com-cert.pem"

  infoln "Registering peer0, user1, admin for PatientOrg"
  fabric-ca-client register --caname ca-patient --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-patient --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-patient --id.name patientadmin --id.secret patientadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"

  infoln "Generating MSP for peer0.patientOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7058 \
    --caname ca-patient \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/msp/config.yaml"

  infoln "Generating TLS certs for peer0.patientOrg"
  fabric-ca-client enroll \
    -u https://peer0:peer0pw@localhost:7058 \
    --caname ca-patient \
    -M "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls" \
    --enrollment.profile tls \
    --csr.hosts peer0.patientOrg.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls/tlscacerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls/signcerts/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls/keystore/"* "${FABRIC_CA_CLIENT_HOME}/peers/peer0.patientOrg.example.com/tls/server.key"

  infoln "Generating user1 MSP"
  fabric-ca-client enroll \
    -u https://user1:user1pw@localhost:7058 \
    --caname ca-patient \
    -M "${FABRIC_CA_CLIENT_HOME}/users/User1@patientOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/User1@patientOrg.example.com/msp/config.yaml"

  infoln "Generating admin MSP"
  fabric-ca-client enroll \
    -u https://patientadmin:patientadminpw@localhost:7058 \
    --caname ca-patient \
    -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@patientOrg.example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/patientOrg/ca-cert.pem"
  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@patientOrg.example.com/msp/config.yaml"
}

function createOrdererOrg() {
  infoln "Enrolling CA admin for OrdererOrg"
  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com/
  
  mkdir -p $FABRIC_CA_CLIENT_HOME

  fabric-ca-client enroll \
    -u https://admin:adminpw@localhost:7154 \
    --caname ca-orderer \
    --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7154-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/msp/tlscacerts/ca.crt"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/tlsca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/tlsca/tlsca.example.com-cert.pem"

  mkdir -p "${FABRIC_CA_CLIENT_HOME}/ca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${FABRIC_CA_CLIENT_HOME}/ca/ca.example.com-cert.pem"

  infoln "Registering orderer and orderer admin"
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"

  infoln "Generating orderer MSP"
  fabric-ca-client enroll \
    -u https://orderer:ordererpw@localhost:7154 \
    --caname ca-orderer \
    -M "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/msp" \
    --csr.hosts orderer.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/msp/config.yaml"

  infoln "Generating TLS certs for orderer"
  fabric-ca-client enroll \
    -u https://orderer:ordererpw@localhost:7154 \
    --caname ca-orderer \
    -M "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls" \
    --enrollment.profile tls \
    --csr.hosts orderer.example.com \
    --csr.hosts localhost \
    --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls/tlscacerts/"* "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls/ca.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls/signcerts/"* "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls/server.crt"
  cp "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls/keystore/"* "${FABRIC_CA_CLIENT_HOME}/orderers/orderer.example.com/tls/server.key"

  infoln "Generating orderer admin MSP"
  fabric-ca-client enroll \
    -u https://ordererAdmin:ordererAdminpw@localhost:7154 \
    --caname ca-orderer \
    -M "${FABRIC_CA_CLIENT_HOME}/users/Admin@example.com/msp" \
    --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"

  cp "${FABRIC_CA_CLIENT_HOME}/msp/config.yaml" "${FABRIC_CA_CLIENT_HOME}/users/Admin@example.com/msp/config.yaml"
}

# MAIN
function main() {
  createHospitalOrg
  createDoctorOrg
  createLabOrg
  createPharmaOrg
  createPatientOrg
  createOrdererOrg
}

main

