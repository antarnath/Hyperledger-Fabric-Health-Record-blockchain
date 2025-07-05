package main

import (
	"log"
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract for EHR
type SmartContract struct {
	contractapi.Contract
}

// === Structs ===
type Patient struct {
	ID            string   `json:"id"`
	Name          string   `json:"name"`
	DOB           string   `json:"dob"`
	Gender        string   `json:"gender"`
	History       []string `json:"history"`
	Prescriptions []string `json:"prescriptions"`
	LabReports    []string `json:"labReports"`
}

type Doctor struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Hospital  string `json:"hospital"`
	Specialty string `json:"specialty"`
}

type Hospital struct {
	ID       string   `json:"id"`
	Name     string   `json:"name"`
	Doctors  []string `json:"doctors"`
	Patients []string `json:"patients"`
}

type Prescription struct {
	ID        string `json:"id"`
	DoctorID  string `json:"doctorId"`
	PatientID string `json:"patientId"`
	Date      string `json:"date"`
	Notes     string `json:"notes"`
}

type LabReport struct {
	ID        string `json:"id"`
	PatientID string `json:"patientId"`
	Date      string `json:"date"`
	Results   string `json:"results"`
}

type MedicineStock struct {
	MedicineName string `json:"medicineName"`
	Quantity     int    `json:"quantity"`
}

// // === Chaincode Init ===
// func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
// 	return nil
// }

func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	// Add initial doctors
	doctors := []Doctor{
		{ID: "doc1", Name: "Dr. Alice", Hospital: "hospital1", Specialty: "Cardiology"},
		{ID: "doc2", Name: "Dr. Bob", Hospital: "hospital2", Specialty: "Neurology"},
	}
	for _, doc := range doctors {
		docJSON, err := json.Marshal(doc)
		if err != nil {
			return err
		}
		err = ctx.GetStub().PutState("DOCTOR_"+doc.ID, docJSON)
		if err != nil {
			return err
		}
	}

	// Add initial medicine
	stock := MedicineStock{MedicineName: "Paracetamol", Quantity: 500}
	stockJSON, err := json.Marshal(stock)
	if err != nil {
		return err
	}
	err = ctx.GetStub().PutState("MEDICINE_Paracetamol", stockJSON)
	if err != nil {
		return err
	}

	return nil
}


// === HospitalOrg Functions ===
func (s *SmartContract) CreateDoctor(ctx contractapi.TransactionContextInterface, id, name, hospital, specialty string) error {
	doctor := Doctor{
		ID:        id,
		Name:      name,
		Hospital:  hospital,
		Specialty: specialty,
	}
	doctorJSON, err := json.Marshal(doctor)
	if err != nil {
		return err
	}
	return ctx.GetStub().PutState("DOCTOR_"+id, doctorJSON)
}

func (s *SmartContract) UpdateDoctor(ctx contractapi.TransactionContextInterface, id, field, value string) error {
	docJSON, err := ctx.GetStub().GetState("DOCTOR_" + id)
	if err != nil || docJSON == nil {
		return fmt.Errorf("doctor not found")
	}
	var doctor Doctor
	err = json.Unmarshal(docJSON, &doctor)
	if err != nil {
		return err
	}
	switch field {
	case "name":
		doctor.Name = value
	case "hospital":
		doctor.Hospital = value
	case "specialty":
		doctor.Specialty = value
	default:
		return fmt.Errorf("invalid field")
	}

	updated, _ := json.Marshal(doctor)
	return ctx.GetStub().PutState("DOCTOR_"+id, updated)
}

func (s *SmartContract) GetAllDoctors(ctx contractapi.TransactionContextInterface) ([]*Doctor, error) {
	resultsIterator, err := ctx.GetStub().GetStateByRange("DOCTOR_", "DOCTOR_z")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var doctors []*Doctor
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var doctor Doctor
		err = json.Unmarshal(queryResponse.Value, &doctor)
		if err != nil {
			return nil, err
		}
		doctors = append(doctors, &doctor)
	}
	return doctors, nil
}

func (s *SmartContract) GetAllPatients(ctx contractapi.TransactionContextInterface) ([]*Patient, error) {
	resultsIterator, err := ctx.GetStub().GetStateByRange("PATIENT_", "PATIENT_z")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var patients []*Patient
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		var patient Patient
		err = json.Unmarshal(queryResponse.Value, &patient)
		if err != nil {
			return nil, err
		}
		patients = append(patients, &patient)
	}
	return patients, nil
}

// === DoctorOrg Functions ===
func (s *SmartContract) CreatePatientRecord(ctx contractapi.TransactionContextInterface, id, name, dob, gender string) error {
	patient := Patient{
		ID:            id,
		Name:          name,
		DOB:           dob,
		Gender:        gender,
		History:       []string{},
		Prescriptions: []string{},
		LabReports:    []string{},
	}
	patientJSON, err := json.Marshal(patient)
	if err != nil {
		return err
	}
	return ctx.GetStub().PutState("PATIENT_"+id, patientJSON)
}

func (s *SmartContract) UpdatePatientRecord(ctx contractapi.TransactionContextInterface, id, field, value string) error {
	patientJSON, err := ctx.GetStub().GetState("PATIENT_" + id)
	if err != nil || patientJSON == nil {
		return fmt.Errorf("patient not found")
	}
	var patient Patient
	err = json.Unmarshal(patientJSON, &patient)
	if err != nil {
		return err
	}
	switch field {
	case "name":
		patient.Name = value
	case "dob":
		patient.DOB = value
	case "gender":
		patient.Gender = value
	default:
		return fmt.Errorf("invalid field")
	}

	updated, _ := json.Marshal(patient)
	return ctx.GetStub().PutState("PATIENT_"+id, updated)
}

func (s *SmartContract) UploadPrescription(ctx contractapi.TransactionContextInterface, prescID, doctorID, patientID, date, notes string) error {
	presc := Prescription{
		ID:        prescID,
		DoctorID:  doctorID,
		PatientID: patientID,
		Date:      date,
		Notes:     notes,
	}
	prescJSON, _ := json.Marshal(presc)
	err := ctx.GetStub().PutState("PRESCRIPTION_"+prescID, prescJSON)
	if err != nil {
		return err
	}
	patJSON, err := ctx.GetStub().GetState("PATIENT_" + patientID)
	if err != nil || patJSON == nil {
		return fmt.Errorf("patient not found")
	}
	var patient Patient
	json.Unmarshal(patJSON, &patient)
	patient.Prescriptions = append(patient.Prescriptions, prescID)
	updated, _ := json.Marshal(patient)
	return ctx.GetStub().PutState("PATIENT_"+patientID, updated)
}

func (s *SmartContract) GetMyPatients(ctx contractapi.TransactionContextInterface, doctorID string) ([]*Patient, error) {
	allPatients, err := s.GetAllPatients(ctx)
	if err != nil {
		return nil, err
	}
	var result []*Patient
	for _, pat := range allPatients {
		for _, prescID := range pat.Prescriptions {
			prescJSON, _ := ctx.GetStub().GetState("PRESCRIPTION_" + prescID)
			var presc Prescription
			json.Unmarshal(prescJSON, &presc)
			if presc.DoctorID == doctorID {
				result = append(result, pat)
				break
			}
		}
	}
	return result, nil
}

// === PatientOrg Functions ===
func (s *SmartContract) GetMyPrescriptions(ctx contractapi.TransactionContextInterface, patientID string) ([]*Prescription, error) {
	patJSON, err := ctx.GetStub().GetState("PATIENT_" + patientID)
	if err != nil || patJSON == nil {
		return nil, fmt.Errorf("patient not found")
	}
	var patient Patient
	json.Unmarshal(patJSON, &patient)
	var prescriptions []*Prescription
	for _, pid := range patient.Prescriptions {
		prescJSON, _ := ctx.GetStub().GetState("PRESCRIPTION_" + pid)
		var presc Prescription
		json.Unmarshal(prescJSON, &presc)
		prescriptions = append(prescriptions, &presc)
	}
	return prescriptions, nil
}

func (s *SmartContract) GetMyLabReports(ctx contractapi.TransactionContextInterface, patientID string) ([]*LabReport, error) {
	patJSON, err := ctx.GetStub().GetState("PATIENT_" + patientID)
	if err != nil || patJSON == nil {
		return nil, fmt.Errorf("patient not found")
	}
	var patient Patient
	json.Unmarshal(patJSON, &patient)
	var reports []*LabReport
	for _, rid := range patient.LabReports {
		reportJSON, _ := ctx.GetStub().GetState("LABREPORT_" + rid)
		var report LabReport
		json.Unmarshal(reportJSON, &report)
		reports = append(reports, &report)
	}
	return reports, nil
}

func (s *SmartContract) GetMyTreatmentHistory(ctx contractapi.TransactionContextInterface, patientID string) ([]string, error) {
	patJSON, err := ctx.GetStub().GetState("PATIENT_" + patientID)
	if err != nil || patJSON == nil {
		return nil, fmt.Errorf("patient not found")
	}
	var patient Patient
	json.Unmarshal(patJSON, &patient)
	return patient.History, nil
}

// === LabOrg Functions ===
func (s *SmartContract) GetPatientPrescriptions(ctx contractapi.TransactionContextInterface, patientID string) ([]*Prescription, error) {
	return s.GetMyPrescriptions(ctx, patientID)
}

func (s *SmartContract) UploadLabReport(ctx contractapi.TransactionContextInterface, reportID, patientID, date, results string) error {
	report := LabReport{
		ID:        reportID,
		PatientID: patientID,
		Date:      date,
		Results:   results,
	}
	reportJSON, _ := json.Marshal(report)
	err := ctx.GetStub().PutState("LABREPORT_"+reportID, reportJSON)
	if err != nil {
		return err
	}
	patJSON, err := ctx.GetStub().GetState("PATIENT_" + patientID)
	if err != nil || patJSON == nil {
		return fmt.Errorf("patient not found")
	}
	var patient Patient
	json.Unmarshal(patJSON, &patient)
	patient.LabReports = append(patient.LabReports, reportID)
	updated, _ := json.Marshal(patient)
	return ctx.GetStub().PutState("PATIENT_"+patientID, updated)
}

// === PharmaOrg Functions ===
func (s *SmartContract) UpdateMedicineStock(ctx contractapi.TransactionContextInterface, name string, quantity int) error {
	stock := MedicineStock{
		MedicineName: name,
		Quantity:     quantity,
	}
	stockJSON, _ := json.Marshal(stock)
	return ctx.GetStub().PutState("MEDICINE_"+name, stockJSON)
}

func (s *SmartContract) GetMedicineStock(ctx contractapi.TransactionContextInterface, name string) (*MedicineStock, error) {
	stockJSON, err := ctx.GetStub().GetState("MEDICINE_" + name)
	if err != nil || stockJSON == nil {
		return nil, fmt.Errorf("medicine not found")
	}
	var stock MedicineStock
	json.Unmarshal(stockJSON, &stock)
	return &stock, nil
}

// === Main ===
func main() {
	chaincode, err := contractapi.NewChaincode(&SmartContract{}) // ✅ correct: no "chaincode." prefix
	if err != nil {
		log.Panicf("Error create ehr_chaincode: %v", err)
	}

	if err := chaincode.Start(); err != nil {
		log.Panicf("Error starting ehr_chaincode: %v", err)
	}
}