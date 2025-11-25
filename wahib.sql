CREATE TABLE `appointment` (
  `Appointment_ID` int(11) NOT NULL,
  `Request_ID` int(11) NOT NULL,
  `Donor_ID` int(11) NOT NULL,
  `Appointment_Date` date NOT NULL,
  `Appointment_Time` time NOT NULL,
  `Status` enum('Booked','Completed','Cancelled') NOT NULL DEFAULT 'Booked'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`Appointment_ID`, `Request_ID`, `Donor_ID`, `Appointment_Date`, `Appointment_Time`, `Status`) VALUES
(1, 1, 1, '2025-11-24', '09:30:00', 'Booked'),
(2, 2, 2, '2025-11-25', '11:00:00', 'Booked'),
(91, 18, 18, '2025-11-24', '10:00:00', 'Completed'),
(92, 19, 19, '2025-11-25', '12:00:00', 'Completed'),
(93, 20, 20, '2025-11-20', '09:00:00', 'Completed'),
(94, 21, 21, '2025-11-26', '14:30:00', 'Booked'),
(95, 22, 1, '2025-11-27', '11:00:00', 'Booked'),
(96, 23, 2, '2025-11-28', '15:00:00', 'Booked'),
(97, 18, 22, '2025-11-25', '14:00:00', 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `bloodrequest`
--

CREATE TABLE `bloodrequest` (
  `Request_ID` int(11) NOT NULL,
  `Hospital_ID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Creation_Date` date NOT NULL,
  `Status` enum('Open','Closed') NOT NULL DEFAULT 'Open',
  `Emergency` tinyint(1) NOT NULL DEFAULT '0',
  `Blood_Type` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `City` varchar(100) NOT NULL,
  `Location` varchar(255) NOT NULL,
  `Needed_By` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bloodrequest`
--

INSERT INTO `bloodrequest` (`Request_ID`, `Hospital_ID`, `Quantity`, `Creation_Date`, `Status`, `Emergency`, `Blood_Type`, `City`, `Location`, `Needed_By`) VALUES
(1, 1, 3, '2025-11-22', 'Open', 1, 'O+', 'Riyadh', 'Main Campus - Emergency Department', '2025-11-25'),
(2, 2, 2, '2025-11-22', 'Closed', 0, 'A-', 'Jeddah', 'North Corniche - Blood Bank', '2025-11-27'),
(18, 7, 4, '2025-11-22', 'Open', 1, 'A+', 'Riyadh', 'Building 2 - ER', '2025-11-30'),
(19, 7, 2, '2025-11-23', 'Open', 0, 'O-', 'Riyadh', 'Blood Lab', '2025-12-01'),
(20, 8, 3, '2025-11-20', 'Open', 0, 'B+', 'Dammam', 'Bank A', '2025-11-29'),
(21, 9, 5, '2025-11-21', 'Open', 1, 'AB+', 'Medina', 'Emergency Room', '2025-11-28'),
(22, 8, 1, '2025-11-22', 'Open', 0, 'O+', 'Dammam', 'Blood Unit 3', '2025-11-26'),
(23, 9, 2, '2025-11-22', 'Open', 0, 'A-', 'Medina', 'South Wing', '2025-12-02');

-- --------------------------------------------------------

--
-- Table structure for table `donor`
--

CREATE TABLE `donor` (
  `Donor_ID` int(11) NOT NULL,
  `User_Name` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(120) NOT NULL,
  `National_ID` varchar(10) NOT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  `Birth_Date` date DEFAULT NULL,
  `Age` tinyint(3) UNSIGNED DEFAULT NULL,
  `City` varchar(100) DEFAULT NULL,
  `Blood_Type` enum('O+','O-','A+','A-','B+','B-','AB+','AB-') NOT NULL,
  `Last_Donation_Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `donor`
--

INSERT INTO `donor` (`Donor_ID`, `User_Name`, `Email`, `Password`, `National_ID`, `Phone`, `Birth_Date`, `Age`, `City`, `Blood_Type`, `Last_Donation_Date`) VALUES
(1, 'Lamis Al-Saleh', 'lamis@example.com', '12345678', '1234567890', '0500000000', '2003-01-01', 21, 'Riyadh', 'O+', NULL),
(2, 'Maha Al-Harbi', 'maha@example.com', '12345678', '1234567891', '0505812345', '2002-05-15', 22, 'Jeddah', 'A-', NULL),
(18, 'Sara Al-Qahtani', 'sara@example.com', '12345678', '2234567890', '0551111111', '2000-04-12', 24, 'Riyadh', 'A+', '2025-11-24'),
(19, 'Reem Al-Otaibi', 'reem@example.com', '12345678', '2234567891', '0552222222', '1999-10-05', 25, 'Jeddah', 'B+', '2025-11-25'),
(20, 'Noor Al-Mutairi', 'noor@example.com', '12345678', '2234567892', '0553333333', '2001-02-20', 23, 'Dammam', 'O-', '2025-11-20'),
(21, 'Fahad Al-Subaie', 'fahad@example.com', '12345678', '2234567893', '0554444444', '1998-01-11', 26, 'Medina', 'AB+', NULL),
(22, 'leen aldbays', 'leenkd240@gmail.com', '12345678', '1234534590', '0505145678', '2003-06-24', 22, 'Riyadh', 'O+', '2025-11-25');

-- --------------------------------------------------------

--
-- Table structure for table `eligibilitytest`
--

CREATE TABLE `eligibilitytest` (
  `Test_ID` int(11) NOT NULL,
  `Donor_ID` int(11) NOT NULL,
  `Test_Date` date NOT NULL,
  `Weight` decimal(5,2) DEFAULT NULL,
  `Hemoglobin_Level` decimal(4,2) DEFAULT NULL,
  `Is_Passed` tinyint(1) NOT NULL DEFAULT '0',
  `Next_Date` date DEFAULT NULL,
  `Infectious_Disease` enum('yes','no') NOT NULL DEFAULT 'no'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `eligibilitytest`
--

INSERT INTO `eligibilitytest` (`Test_ID`, `Donor_ID`, `Test_Date`, `Weight`, `Hemoglobin_Level`, `Is_Passed`, `Next_Date`, `Infectious_Disease`) VALUES
(1, 1, '2025-10-23', '55.00', '13.20', 1, '2025-12-22', 'no'),
(2, 2, '2025-11-12', '52.50', '12.60', 1, '2026-01-11', 'no'),
(34, 18, '2025-11-25', '50.00', '23.00', 1, '2026-01-25', 'no'),
(35, 20, '2025-11-25', '67.00', '34.00', 1, '2026-01-25', 'no'),
(36, 19, '2025-11-25', '56.00', '14.00', 1, '2026-01-25', 'no'),
(37, 22, '2025-11-25', '56.00', '14.00', 1, '2026-01-25', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `hospital`
--

CREATE TABLE `hospital` (
  `Hospital_ID` int(11) NOT NULL,
  `Hospital_Name` varchar(100) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(120) NOT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `City` varchar(100) NOT NULL,
  `Location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hospital`
--

INSERT INTO `hospital` (`Hospital_ID`, `Hospital_Name`, `Email`, `Password`, `Phone`, `City`, `Location`) VALUES
(1, 'Riyadh Central Hospital', 'rch@example.com', '12345678', '0110000000', 'Riyadh', 'Main Campus - King Fahd Rd'),
(2, 'Jeddah North Hospital', 'jnh@example.com', '12345678', '0120000000', 'Jeddah', 'North Corniche - Blood Bank'),
(7, 'King Abdulaziz Hospital', 'kamh@example.com', '12345678', '0111111111', 'Riyadh', 'King Abdulaziz Rd'),
(8, 'Dammam Medical Center', 'dmc@example.com', '12345678', '0132222222', 'Dammam', 'Corniche - Main Building'),
(9, 'Medina National Hospital', 'mnh@example.com', '12345678', '0143333333', 'Medina', 'North Area - Health District');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`Appointment_ID`),
  ADD UNIQUE KEY `uq_appt_slot` (`Donor_ID`,`Appointment_Date`,`Appointment_Time`),
  ADD KEY `idx_appt_req` (`Request_ID`),
  ADD KEY `idx_appt_donor` (`Donor_ID`);

--
-- Indexes for table `bloodrequest`
--
ALTER TABLE `bloodrequest`
  ADD PRIMARY KEY (`Request_ID`),
  ADD KEY `idx_breq_hosp` (`Hospital_ID`),
  ADD KEY `idx_breq_state` (`Status`,`Emergency`);

--
-- Indexes for table `donor`
--
ALTER TABLE `donor`
  ADD PRIMARY KEY (`Donor_ID`),
  ADD UNIQUE KEY `uq_donor_email` (`Email`),
  ADD UNIQUE KEY `uq_donor_national` (`National_ID`);

--
-- Indexes for table `eligibilitytest`
--
ALTER TABLE `eligibilitytest`
  ADD PRIMARY KEY (`Test_ID`),
  ADD UNIQUE KEY `uq_donor_testdate` (`Donor_ID`,`Test_Date`);

--
-- Indexes for table `hospital`
--
ALTER TABLE `hospital`
  ADD PRIMARY KEY (`Hospital_ID`),
  ADD UNIQUE KEY `uq_hosp_email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `Appointment_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `bloodrequest`
--
ALTER TABLE `bloodrequest`
  MODIFY `Request_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `donor`
--
ALTER TABLE `donor`
  MODIFY `Donor_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `eligibilitytest`
--
ALTER TABLE `eligibilitytest`
  MODIFY `Test_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `hospital`
--
ALTER TABLE `hospital`
  MODIFY `Hospital_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `fk_appt_donor` FOREIGN KEY (`Donor_ID`) REFERENCES `donor` (`Donor_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appt_request` FOREIGN KEY (`Request_ID`) REFERENCES `bloodrequest` (`Request_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `bloodrequest`
--
ALTER TABLE `bloodrequest`
  ADD CONSTRAINT `fk_breq_hospital` FOREIGN KEY (`Hospital_ID`) REFERENCES `hospital` (`Hospital_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `eligibilitytest`
--
ALTER TABLE `eligibilitytest`
  ADD CONSTRAINT `fk_test_donor` FOREIGN KEY (`Donor_ID`) REFERENCES `donor` (`Donor_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
