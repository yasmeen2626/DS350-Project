-- Smart Clinic Database
-- Creating all the tables needed in the clinic (Patient, Doctor, Appointment, Medicine, Payment, etc..)
CREATE DATABASE IF NOT EXISTS SmartClinicDB;
USE SmartClinicDB;

CREATE TABLE Patient (
    Patient_ID   INT PRIMARY KEY AUTO_INCREMENT,
    First_Name   VARCHAR(50) NOT NULL,
    Last_Name    VARCHAR(50) NOT NULL,
    Gender       ENUM('Male','Female') NOT NULL,
    Phone        VARCHAR(20) NOT NULL UNIQUE,
    Address      VARCHAR(150),
    Birth_Date   DATE NOT NULL
);

CREATE TABLE Doctor (
    Doctor_ID      INT PRIMARY KEY AUTO_INCREMENT,
    Doctor_Name    VARCHAR(80) NOT NULL,
    Specialization VARCHAR(80),
    Phone          VARCHAR(20) NOT NULL UNIQUE,
    Email          VARCHAR(100) UNIQUE
);

-- EER specialization of Doctor
CREATE TABLE General_Doctor (
    Doctor_ID INT PRIMARY KEY,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Specialist (
    Doctor_ID INT PRIMARY KEY,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Appointment (
    Appointment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Date           DATE NOT NULL,
    Time           TIME NOT NULL,
    Status         ENUM('Scheduled','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
    Doctor_ID      INT NOT NULL,
    Patient_ID     INT NOT NULL,
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Treatment (
    Treatment_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Description    VARCHAR(100),
    Diagnosis      VARCHAR(100),
    Cost           DECIMAL(8,2) NOT NULL CHECK (Cost >= 0),
    Appointment_ID INT NOT NULL,
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Medicine (
    Medicine_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Medicine_Name VARCHAR(100) NOT NULL,
    Quantity      INT NOT NULL DEFAULT 0 CHECK (Quantity >= 0),
    Price         DECIMAL(8,2) NOT NULL CHECK (Price >= 0)
);

-- Associative entity resolving Treatment <-> Medicine (M:N)
CREATE TABLE Requires (
    Treatment_ID INT NOT NULL,
    Medicine_ID  INT NOT NULL,
    PRIMARY KEY (Treatment_ID, Medicine_ID),
    FOREIGN KEY (Treatment_ID) REFERENCES Treatment(Treatment_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Medicine_ID) REFERENCES Medicine(Medicine_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payment (
    Payment_ID   INT PRIMARY KEY AUTO_INCREMENT,
    Payment_Date DATE NOT NULL,
    Payment_Type ENUM('Cash','Card','Insurance') NOT NULL,
    Amount       DECIMAL(8,2) NOT NULL CHECK (Amount >= 0),
    Patient_ID   INT NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tables has been completed 

USE SmartClinicDB;
INSERT INTO Patient (First_Name, Last_Name, Gender, Phone, Address, Birth_Date) VALUES
('Ahmad', 'Ali', 'Male', '0501111111', 'Riyadh', '1995-05-12'),
('Sara', 'Ahmed', 'Female', '0502222222', 'Jeddah', '1990-08-22'),
('Fahad', 'Khalf', 'Male', '0503333333', 'Dammam', '1988-02-14'),
('Mona', 'Nasser', 'Female', '0504444444', 'Khobar', '1992-11-30'),
('Khalid', 'Saad', 'Male', '0505555555', 'Mecca', '1998-07-19');

INSERT INTO Doctor (Doctor_Name, Specialization, Phone, Email) VALUES
('Dr. Waleed', 'General', '0551111111', 'waleed@clinic.com'),
('Dr. Noura', 'Cardiologist', '0552222222', 'noura@clinic.com'),
('Dr. Ziyad', 'Dermatologist', '0553333333', 'ziyad@clinic.com'),
('Dr. Reem', 'Pediatrician', '0554444444', 'reem@clinic.com'),
('Dr. Omar', 'General', '0555555555', 'omar@clinic.com');

INSERT INTO Appointment (Date, Time, Status, Doctor_ID, Patient_ID) VALUES
('2026-08-01', '09:00:00', 'Scheduled', 1, 1),
('2026-08-01', '10:00:00', 'Scheduled', 2, 2),
('2026-08-02', '11:30:00', 'Completed', 3, 3),
('2026-08-03', '01:00:00', 'Cancelled', 4, 4),
('2026-08-04', '02:30:00', 'Scheduled', 5, 5);

INSERT INTO Treatment (Description, Diagnosis, Cost, Appointment_ID) VALUES
('Routine Checkup', 'Healthy', 150.00, 1),
('Heart ECG', 'Normal', 500.00, 2),
('Skin Rash Treatment', 'Allergy', 200.00, 3),
('Child Vaccination', 'Complete', 300.00, 4),
('Blood Test', 'Pending', 100.00, 5);

INSERT INTO Medicine (Medicine_Name, Quantity, Price) VALUES
('Panadol', 100, 15.50),
('Aspirin', 50, 20.00),
('Claritin', 80, 45.00),
('Amoxicillin', 40, 60.00),
('Ibuprofen', 120, 25.00);

INSERT INTO Payment (Payment_Date, Payment_Type, Amount, Patient_ID) VALUES
('2026-08-01', 'Cash', 150.00, 1),
('2026-08-01', 'Card', 500.00, 2),
('2026-08-02', 'Insurance', 200.00, 3),
('2026-08-03', 'Cash', 300.00, 4),
('2026-08-04', 'Card', 100.00, 5);