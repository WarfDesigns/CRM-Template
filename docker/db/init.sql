-- =================================================================
--  STEP 1: CREATE AND USE THE DATABASE
-- =================================================================
CREATE DATABASE IF NOT EXISTS CRM_DB;
USE CRM_DB;

-- =================================================================
--  STEP 2: CREATE ALL TABLES
-- =================================================================

-- Create Users table (for CRM system users like sales reps, managers)
CREATE TABLE IF NOT EXISTS `Users` (
    `user_id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL, -- In a real app, always store hashed passwords
    `role` ENUM('Admin', 'Manager', 'Sales Rep') NOT NULL DEFAULT 'Sales Rep',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `is_active` BOOLEAN DEFAULT TRUE
);

-- Create Companies table
CREATE TABLE IF NOT EXISTS `Companies` (
    `company_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `industry` VARCHAR(100),
    `website` VARCHAR(255),
    `phone_number` VARCHAR(20),
    `address` VARCHAR(255),
    `city` VARCHAR(100),
    `state` VARCHAR(50),
    `zip_code` VARCHAR(20),
    `owner_user_id` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`owner_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
);

-- Create Contacts table (for individual people)
CREATE TABLE IF NOT EXISTS `Contacts` (
    `contact_id` INT AUTO_INCREMENT PRIMARY KEY,
    `company_id` INT,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `email` VARCHAR(255) UNIQUE,
    `phone_number` VARCHAR(20),
    `job_title` VARCHAR(100),
    `owner_user_id` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`company_id`) REFERENCES `Companies`(`company_id`) ON DELETE SET NULL,
    FOREIGN KEY (`owner_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
);

-- Create Deals (or Opportunities) table
CREATE TABLE IF NOT EXISTS `Deals` (
    `deal_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `stage` ENUM('Prospecting', 'Qualification', 'Proposal', 'Negotiation', 'Closed Won', 'Closed Lost') NOT NULL,
    `amount` DECIMAL(12, 2),
    `expected_close_date` DATE,
    `company_id` INT,
    `primary_contact_id` INT,
    `owner_user_id` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`company_id`) REFERENCES `Companies`(`company_id`) ON DELETE CASCADE,
    FOREIGN KEY (`primary_contact_id`) REFERENCES `Contacts`(`contact_id`) ON DELETE SET NULL,
    FOREIGN KEY (`owner_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL
);

-- Create Activities (or Interactions) table to log calls, emails, meetings
CREATE TABLE IF NOT EXISTS `Activities` (
    `activity_id` INT AUTO_INCREMENT PRIMARY KEY,
    `type` ENUM('Call', 'Email', 'Meeting', 'Note') NOT NULL,
    `subject` VARCHAR(255),
    `notes` TEXT,
    `activity_date` DATETIME NOT NULL,
    `user_id` INT,
    -- Foreign keys to link activity to other records
    `contact_id` INT NULL,
    `company_id` INT NULL,
    `deal_id` INT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL,
    FOREIGN KEY (`contact_id`) REFERENCES `Contacts`(`contact_id`) ON DELETE CASCADE,
    FOREIGN KEY (`company_id`) REFERENCES `Companies`(`company_id`) ON DELETE CASCADE,
    FOREIGN KEY (`deal_id`) REFERENCES `Deals`(`deal_id`) ON DELETE CASCADE
);

-- Create Tasks table for to-do items
CREATE TABLE IF NOT EXISTS `Tasks` (
    `task_id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `due_date` DATE,
    `status` ENUM('Not Started', 'In Progress', 'Completed') DEFAULT 'Not Started',
    `priority` ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    `assigned_to_user_id` INT,
    `related_deal_id` INT NULL,
    `related_contact_id` INT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`assigned_to_user_id`) REFERENCES `Users`(`user_id`) ON DELETE SET NULL,
    FOREIGN KEY (`related_deal_id`) REFERENCES `Deals`(`deal_id`) ON DELETE SET NULL,
    FOREIGN KEY (`related_contact_id`) REFERENCES `Contacts`(`contact_id`) ON DELETE SET NULL
);


-- =================================================================
--  STEP 3: INSERT MOCK DATA (ORDER IS CRITICAL)
-- =================================================================

-- Insert Users
INSERT INTO `Users` (`user_id`, `first_name`, `last_name`, `email`, `password_hash`, `role`) VALUES
(1, 'Sarah', 'Jones', 'sarah.jones@example.com', 'hashed_password_123', 'Sales Rep'),
(2, 'Mike', 'Ross', 'mike.ross@example.com', 'hashed_password_456', 'Manager'),
(3, 'Admin', 'User', 'admin@example.com', 'hashed_password_789', 'Admin');

-- Insert Companies
INSERT INTO `Companies` (`company_id`, `name`, `industry`, `website`, `owner_user_id`) VALUES
(1, 'Innovate Corp', 'Technology', 'https://innovatecorp.com', 1),
(2, 'Global Tech Inc.', 'Software', 'https://globaltech.com', 1),
(3, 'Startup Solutions', 'Consulting', 'https://startupsolutions.io', 1);

-- Insert Contacts
INSERT INTO `Contacts` (`contact_id`, `company_id`, `first_name`, `last_name`, `email`, `job_title`, `owner_user_id`) VALUES
(1, 1, 'John', 'Doe', 'john.doe@innovatecorp.com', 'VP of Engineering', 1),
(2, 1, 'Alice', 'Williams', 'alice.williams@innovatecorp.com', 'Project Manager', 1),
(3, 2, 'Jane', 'Smith', 'jane.smith@globaltech.com', 'CEO', 1),
(4, 3, 'Bob', 'Johnson', 'bob.j@startupsolutions.io', 'Founder', 1);

-- Insert Deals
INSERT INTO `Deals` (`deal_id`, `name`, `stage`, `amount`, `expected_close_date`, `company_id`, `primary_contact_id`, `owner_user_id`) VALUES
(1, 'Innovate Corp - Q4 Software Upgrade', 'Closed Won', 75000.00, '2025-08-15', 1, 1, 1),
(2, 'Global Tech - New Website Project', 'Closed Lost', 50000.00, '2025-08-20', 2, 3, 1),
(3, 'Startup Solutions - Consulting Retainer', 'Proposal', 25000.00, '2025-09-30', 3, 4, 1),
(4, 'Innovate Corp - 2026 Support Contract', 'Qualification', 15000.00, '2025-10-25', 1, 2, 1);

-- Insert Activities
INSERT INTO `Activities` (`type`, `subject`, `notes`, `activity_date`, `user_id`, `contact_id`, `deal_id`) VALUES
('Meeting', 'Final Proposal Review with John', 'Walked through the final terms. John is ready to sign.', '2025-08-10 14:00:00', 1, 1, 1),
('Note', 'Deal Won', 'Contract signed and sent to accounting.', '2025-08-15 11:30:00', 1, 1, 1),
('Call', 'Follow-up call with Jane Smith', 'Budget was re-allocated to another project. They will reconsider in Q1 2026.', '2025-08-18 10:00:00', 1, 3, 2),
('Email', 'Sent Proposal to Startup Solutions', 'Emailed the standard consulting retainer proposal to Bob.', '2025-08-17 17:00:00', 1, 4, 3);

-- Insert Tasks
INSERT INTO `Tasks` (`title`, `due_date`, `status`, `priority`, `assigned_to_user_id`, `related_deal_id`, `related_contact_id`) VALUES
('Follow up with Bob Johnson on proposal', '2025-08-25', 'Not Started', 'High', 1, 3, 4),
('Schedule kick-off meeting with Alice Williams', '2025-08-22', 'Not Started', 'Medium', 1, 4, 2),
('Generate invoice for Innovate Corp', '2025-08-16', 'Completed', 'High', 1, 1, 1);