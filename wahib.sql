CREATE DATABASE IF NOT EXISTS wahib
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE wahib;



CREATE TABLE Donor (
  Donor_ID INT AUTO_INCREMENT PRIMARY KEY,
  User_Name VARCHAR(100) NOT NULL,
  Email VARCHAR(255) NOT NULL,
  Password VARCHAR(120) NOT NULL,
  National_ID VARCHAR(10) NOT NULL,
  Phone VARCHAR(15) NULL,
  Birth_Date DATE NULL,
  Blood_Type ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  UNIQUE KEY uq_donor_email (Email),
  UNIQUE KEY uq_donor_national (National_ID)
) ENGINE=InnoDB;

CREATE TABLE Hospital (
  Hospital_ID INT AUTO_INCREMENT PRIMARY KEY,
  Hospital_Name VARCHAR(100) NOT NULL,
  Email VARCHAR(255) NOT NULL,
  Password VARCHAR(120) NOT NULL,
  Phone VARCHAR(20) NULL,
  Location VARCHAR(255) NULL,
  UNIQUE KEY uq_hosp_email (Email)
) ENGINE=InnoDB;

CREATE TABLE BloodRequest (
  Request_ID INT AUTO_INCREMENT PRIMARY KEY,
  Hospital_ID INT NOT NULL,
  Quantity INT NOT NULL,
  Creation_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
  Status ENUM('Open','Closed') NULL DEFAULT 'Open',
  Emergency BOOLEAN NULL DEFAULT FALSE,
  Blood_Type ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  CONSTRAINT fk_breq_hospital
    FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  INDEX idx_breq_hosp (Hospital_ID),
  INDEX idx_breq_state (Status, Emergency)
) ENGINE=InnoDB;

CREATE TABLE EligibilityTest (
  Test_ID INT AUTO_INCREMENT PRIMARY KEY,
  Donor_ID INT NOT NULL,
  Test_Date DATE NOT NULL DEFAULT (CURRENT_DATE),
  Weight DECIMAL(5,2) NULL,
  Hemoglobin_Level DECIMAL(4,2) NULL,
  Is_Passed BOOLEAN NOT NULL DEFAULT FALSE,
  Next_Date DATE NULL,
  CONSTRAINT fk_test_donor
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  UNIQUE KEY uq_donor_testdate (Donor_ID, Test_Date)
) ENGINE=InnoDB;

CREATE TABLE Appointment (
  Appointment_ID INT AUTO_INCREMENT PRIMARY KEY,
  Request_ID INT NOT NULL,
  Donor_ID INT NOT NULL,
  Appointment_Date DATE NOT NULL,
  Appointment_Time TIME NOT NULL,
  CONSTRAINT fk_appt_request
    FOREIGN KEY (Request_ID) REFERENCES BloodRequest(Request_ID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_appt_donor
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  UNIQUE KEY uq_appt_slot (Donor_ID, Appointment_Date, Appointment_Time),
  INDEX idx_appt_req (Request_ID),
  INDEX idx_appt_donor (Donor_ID)
) ENGINE=InnoDB;

INSERT INTO Hospital (Hospital_Name, Email, Password, Phone, Location) VALUES
  ('Riyadh Central Hospital', 'rch@example.com', '123', '0110000000', 'Riyadh, KSA'),
  ('Jeddah North Hospital', 'jnh@example.com', '123', '0120000000', 'Jeddah, KSA');

INSERT INTO Donor (User_Name, Email, Password, National_ID, Phone, Birth_Date, Blood_Type) VALUES
  ('Lamis Al-Saleh', 'lamis@example.com', '123', '1234567890', '0500000000', '2003-01-01', 'O+'),
  ('Maha Al-Harbi', 'maha@example.com', '123', '1234567891', NULL, '2002-05-15', 'A-');

INSERT INTO BloodRequest (Hospital_ID, Quantity, Creation_Date, Status, Emergency, Blood_Type) VALUES
  (1, 3, CURRENT_DATE, 'Open', TRUE, 'O+'),
  (2, 2, CURRENT_DATE, 'Closed', FALSE, 'A-');

INSERT INTO EligibilityTest (Donor_ID, Test_Date, Weight, Hemoglobin_Level, Is_Passed, Next_Date) VALUES
  (1, CURRENT_DATE - INTERVAL 30 DAY, 55.00, 13.20, TRUE, CURRENT_DATE + INTERVAL 30 DAY),
  (2, CURRENT_DATE - INTERVAL 10 DAY, 52.50, 12.60, TRUE, CURRENT_DATE + INTERVAL 50 DAY);

INSERT INTO Appointment (Request_ID, Donor_ID, Appointment_Date, Appointment_Time) VALUES
  (1, 1, CURRENT_DATE + INTERVAL 2 DAY, '09:30:00'),
  (2, 2, CURRENT_DATE + INTERVAL 3 DAY, '11:00:00');
