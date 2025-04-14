-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2025 at 10:39 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jru_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `assignment_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `due_date` datetime NOT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`assignment_id`, `course_id`, `title`, `description`, `due_date`, `file_path`, `user_id`, `created_at`) VALUES
(39, 84, 'ASSIGNMENT', '1', '2025-04-20 00:00:00', 'https://docs.google.com/forms/d/1sbvSOq3gj4B1qUMuyGnQXW-OIk-xjGgKs5wNs9M3ys0/edit', 48, '2025-04-14 03:47:24'),
(40, 84, 'ASSIGNMNET', '2', '2025-12-20 00:00:00', '/uploads/lesson 1.ppt', 48, '2025-04-14 03:47:59');

-- --------------------------------------------------------

--
-- Table structure for table `assignment_submissions`
--

CREATE TABLE `assignment_submissions` (
  `submission_id` int(11) NOT NULL,
  `assignment_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `submission_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignment_submissions`
--

INSERT INTO `assignment_submissions` (`submission_id`, `assignment_id`, `student_id`, `file_path`, `submitted_at`, `grade`, `feedback`, `submission_text`) VALUES
(30, 39, 50, 'https://docs.google.com/forms/d/e/1FAIpQLSdEA6wV1OerOpZJ1QvBLykDfiYlYMP0RbvhDJZaScpOqCZ-Vg/viewform?usp=dialog', '2025-04-14 03:48:40', NULL, NULL, 'done');

-- --------------------------------------------------------

--
-- Table structure for table `calendar_events`
--

CREATE TABLE `calendar_events` (
  `event_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `time` time DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `course_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `calendar_events`
--

INSERT INTO `calendar_events` (`event_id`, `title`, `date`, `time`, `description`, `type`, `user_id`, `created_at`, `updated_at`, `course_id`) VALUES
(4, 'Prelim Exam', '2025-04-15', '10:00:00', 'Exam', 'exam', 48, '2025-04-14 03:51:15', '2025-04-14 03:51:15', 84),
(5, 'Prelim Exam', '2025-04-15', '13:00:00', '', 'exam', 48, '2025-04-14 03:51:40', '2025-04-14 03:51:40', 86),
(6, 'MIDTERM', '2025-04-21', '10:08:00', 'EXAM', 'exam', 48, '2025-04-14 04:04:14', '2025-04-14 04:04:14', 86);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `entity_type` enum('assignment','quiz','material','exam') NOT NULL,
  `entity_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`comment_id`, `user_id`, `entity_type`, `entity_id`, `content`, `created_at`) VALUES
(19, 50, 'quiz', 20, 'done', '2025-04-14 16:45:00'),
(20, 48, 'quiz', 20, 'okay', '2025-04-14 16:45:53');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `course_id` int(11) NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `section` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `class_schedule` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`course_id`, `course_name`, `section`, `user_id`, `class_schedule`) VALUES
(74, 'ELEC014', 'BSIT-3B', NULL, 'THU'),
(75, 'ELEC014', 'BSCS-3A', NULL, 'MON'),
(76, 'GEC010', 'BSPH-2A', NULL, 'TUE'),
(77, 'GEC010', 'BSN-1A', NULL, 'MON'),
(79, 'GEC010', 'BSN-1B', NULL, 'TUE'),
(82, ' ITFELECT1', 'BSIT-3A', NULL, 'MON'),
(83, 'ITELECT3', 'BSIT-3A', NULL, 'MON'),
(84, 'ITELECT4', 'BSIT-3A', 48, 'MONDAY'),
(86, 'ITELECT1', 'BSIT-3A', 48, 'MON'),
(87, 'ITELECT3', 'BSIT-3A', 49, 'MONDAY');

-- --------------------------------------------------------

--
-- Table structure for table `course_content`
--

CREATE TABLE `course_content` (
  `content_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `file_path` varchar(255) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `course_content`
--

INSERT INTO `course_content` (`content_id`, `course_id`, `title`, `content`, `created_at`, `file_path`, `user_id`) VALUES
(23, 82, 'Course Material', 'Week 1 Course Material', '2025-04-13 08:32:02', 'uploads\\(TEXAS) Week 5-Activity 2 - Sheet1.csv', 41),
(25, 82, 'Course Material', 'Week 2 Course Material', '2025-04-13 08:39:01', 'uploads\\(TEXAS) Week 5-Activity 2 - Sheet1.csv', 41),
(28, 83, 'Course Material', 'Lesson 1 - Immersive Technology', '2025-04-14 00:24:25', '/uploads/lesson 1.ppt', 45),
(29, 84, 'Course Material', 'Week 1 Course Material', '2025-04-14 01:41:15', '/uploads/lesson 1 (1).ppt', 48),
(30, 84, 'MAterial1', 'Material', '2025-04-14 03:42:32', '/uploads/lesson 1.ppt', 48);

-- --------------------------------------------------------

--
-- Table structure for table `course_materials`
--

CREATE TABLE `course_materials` (
  `material_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `content` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `instructor_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `exams`
--

CREATE TABLE `exams` (
  `exam_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `exam_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `duration_minutes` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exams`
--

INSERT INTO `exams` (`exam_id`, `course_id`, `title`, `description`, `exam_date`, `created_at`, `duration_minutes`, `file_path`, `user_id`) VALUES
(10, 82, 'ITFELECT1 - PRELIM EXAM', 'Prelim Exam', '2025-04-15 00:00:00', '2025-04-13 08:46:22', 60, 'https://docs.google.com/forms/d/e/1FAIpQLScEf5T-amlYHmqPTnuwegK-WR9xNN--VxVXQQNsuFBwA3614w/alreadyresponded?hr_submission=ChkIn6OTsdQPEhAIlZH7kd4VEgcIioXGwYIVEAE', 41),
(11, 82, 'ITFELECT1 - MIDTERM EXAM', 'Midterm Exam', '2025-05-15 00:00:00', '2025-04-13 08:48:29', 60, '/uploads/(TEXAS) Week 5-Activity 2 - Sheet1.csv', 41),
(12, 83, 'Prelim Exam', 'Read and follow the instructions carefully and promptly.\r\n', '2025-05-15 00:00:00', '2025-04-14 00:38:26', 60, 'https://docs.google.com/forms/d/1vrkgZCaIy0P49skgHjzi4AYEAbNUG94m-yXDKzULqPQ/edit', 45),
(14, 84, 'Exam', '1', '2025-08-20 00:00:00', '2025-04-14 03:49:14', 60, 'https://docs.google.com/forms/d/1vrkgZCaIy0P49skgHjzi4AYEAbNUG94m-yXDKzULqPQ/edit', 48);

-- --------------------------------------------------------

--
-- Table structure for table `exam_submissions`
--

CREATE TABLE `exam_submissions` (
  `submission_id` int(11) NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `submission_text` text DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `school_year` varchar(9) NOT NULL,
  `semester` enum('1st','2nd') NOT NULL,
  `prelim_grade` decimal(5,2) DEFAULT NULL,
  `midterm_grade` decimal(5,2) DEFAULT NULL,
  `finals_grade` decimal(5,2) DEFAULT NULL,
  `overall_grade` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `grades`
--

INSERT INTO `grades` (`grade_id`, `student_id`, `course_id`, `recorded_at`, `school_year`, `semester`, `prelim_grade`, `midterm_grade`, `finals_grade`, `overall_grade`) VALUES
(7, 50, 84, '2025-04-14 03:50:09', '2024-2025', '2nd', 80.00, 80.00, 80.00, 80.00),
(8, 50, 87, '2025-04-14 03:53:41', '2024-2025', '2nd', 75.00, 75.00, 75.00, 75.00);

-- --------------------------------------------------------

--
-- Table structure for table `quizzes`
--

CREATE TABLE `quizzes` (
  `quiz_id` int(11) NOT NULL,
  `course_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `quiz_date` date DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizzes`
--

INSERT INTO `quizzes` (`quiz_id`, `course_id`, `title`, `description`, `created_at`, `quiz_date`, `duration_minutes`, `file_path`, `user_id`) VALUES
(16, 82, 'Quiz 1', 'Create a spreadsheet and list down potential clients based on the assigned state.\r\n\r\n\r\nInformation needed:\r\nName:\r\nCompany/Business Name:\r\nBusiness Address:\r\nPhone:\r\nEmail:\r\nHas Website: (Yes/No)\r\nWebsite URL:\r\nSocMed URL:\r\nRemarks: (Notes about the website [needs revamp / needs redesign]', '2025-04-13 08:41:54', '2025-04-15', 20, '/uploads/(TEXAS) Week 5-Activity 2 - Sheet1.csv', 41),
(17, 82, 'Quiz 2', 'Week 2 Quiz', '2025-04-13 09:59:46', '2025-04-15', 10, 'https://docs.google.com/forms/d/e/1FAIpQLScEf5T-amlYHmqPTnuwegK-WR9xNN--VxVXQQNsuFBwA3614w/alreadyresponded?hr_submission=ChkIn6OTsdQPEhAIlZH7kd4VEgcIioXGwYIVEAE', 41),
(18, 83, 'TLA1', '1. Think about any immersive technology you’ve encountered (e.g., VR games, AR filters, MR tools, or virtual environments).\r\n2. Identify the following:\r\nType: Is it VR, AR, MR, or a Multi-User Virtual Environment (MUVE)?\r\nPurpose: What is it used for, and how does it enhance the user experience?\r\n3. Be ready to share your example with the class briefly.\r\n\r\n\r\nPurpose: This activity will help connect today’s topic to real-world examples and prepare you for our discussion on immersive technology.', '2025-04-14 00:31:01', '2025-05-20', 15, 'https://docs.google.com/forms/d/1sbvSOq3gj4B1qUMuyGnQXW-OIk-xjGgKs5wNs9M3ys0/edit', 45),
(19, 84, 'adq1', 'qsdad', '2025-04-14 03:10:20', '2025-12-04', 50, '/uploads/lesson 1 (1).ppt', 48),
(20, 84, 'Quiz 1', 'Week 1 Quiz', '2025-04-14 03:43:42', '2025-04-15', 50, 'https://docs.google.com/forms/d/1vrkgZCaIy0P49skgHjzi4AYEAbNUG94m-yXDKzULqPQ/edit', 48);

-- --------------------------------------------------------

--
-- Table structure for table `quiz_submissions`
--

CREATE TABLE `quiz_submissions` (
  `submission_id` int(11) NOT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `student_id` int(11) DEFAULT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `grade` decimal(5,2) DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `submission_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_submissions`
--

INSERT INTO `quiz_submissions` (`submission_id`, `quiz_id`, `student_id`, `submitted_at`, `grade`, `feedback`, `file_path`, `submission_text`) VALUES
(9, 20, 50, '2025-04-14 03:44:53', 10.00, NULL, 'https://docs.google.com/forms/d/e/1FAIpQLSdEA6wV1OerOpZJ1QvBLykDfiYlYMP0RbvhDJZaScpOqCZ-Vg/viewform?usp=dialog', 'Done'),
(10, 19, 50, '2025-04-14 03:46:24', 10.00, NULL, 'uploads\\8869e90a-ffc5-4e24-b80b-4f2a0d9a46ad_0773b9dc-eca2-4916-bdd1-2a997c7c1990_(TEXAS) Week 5-Activity 2 - Sheet1 (1).csv', 'done');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `student_number` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `degree` varchar(100) NOT NULL,
  `enrollment_date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `user_id`, `student_number`, `first_name`, `last_name`, `degree`, `enrollment_date`) VALUES
(7, 34, 'SN000034', 'Asi', '', '', '2025-04-01'),
(8, 35, 'SN000035', 'Kobe', '', '', '2025-04-01'),
(47, 50, 'SN000050', 'Geric', 'Gultiano', 'information technolohy', '2025-04-14');

-- --------------------------------------------------------

--
-- Table structure for table `student_courses`
--

CREATE TABLE `student_courses` (
  `enrollment_id` int(11) NOT NULL,
  `student_id` int(11) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `enrolled_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_courses`
--

INSERT INTO `student_courses` (`enrollment_id`, `student_id`, `course_id`, `enrolled_at`) VALUES
(36, 50, 84, '2025-04-14 03:40:37'),
(37, 50, 86, '2025-04-14 03:41:42'),
(38, 50, 87, '2025-04-14 03:53:03');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('student','faculty','admin') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(9, 'admin', 'admin@admin', 'string', 'admin', '2025-02-11 19:20:17'),
(34, 'Asi', 'ivaldez_220000000293@uic.edu.ph', 'ASI', 'student', '2025-04-02 05:19:18'),
(35, 'Kobe', 'kcorpuz_220000002183@uic.edu.ph', 'kobe', 'student', '2025-04-02 05:20:46'),
(40, 'Admin', 'orentgultiano11@gmail.com', '$2b$12$ldWtvfFWUHI46kxGYCJBq.e/AY2rCaOJ2RRRdHW95zwl9aiFcVEKq', 'admin', '2025-04-03 11:46:34'),
(48, 'Sir Geric', 'wlage35@gmail.com', '$2b$12$K5IdMZ2stPPWs2Bo3kuE4udhX9POyh1PrNqdLdpJX1kUfpe8fmDQC', 'faculty', '2025-04-14 01:34:57'),
(49, 'John Doe', 'jdoe@gmail.com', '$2b$12$DttrUa/jo7MK/bLGVIHYOea/joa7f80pwTFnmS87zEoBDrycJecMG', 'faculty', '2025-04-14 01:59:56'),
(50, 'Geric Gultiano', 'ggultiano_220000000886@uic.edu.ph', '$2b$12$uoqMbxeJyPfwQs5EYJH4v.LmE1Aw/dFoBiKOm2VLEdQ50PYpHeevq', 'student', '2025-04-14 03:38:41');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `calendar_events`
--
ALTER TABLE `calendar_events`
  ADD PRIMARY KEY (`event_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `calendar_events_ibfk_2` (`course_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `entity_type` (`entity_type`,`entity_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `fk_courses_users` (`user_id`);

--
-- Indexes for table `course_content`
--
ALTER TABLE `course_content`
  ADD PRIMARY KEY (`content_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `course_materials`
--
ALTER TABLE `course_materials`
  ADD PRIMARY KEY (`material_id`),
  ADD KEY `course_id` (`course_id`),
  ADD KEY `instructor_id` (`instructor_id`),
  ADD KEY `content_id` (`content_id`),
  ADD KEY `fk_course_materials_user` (`user_id`);

--
-- Indexes for table `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`exam_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `exam_id` (`exam_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD PRIMARY KEY (`quiz_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `quiz_id` (`quiz_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `student_number` (`student_number`);

--
-- Indexes for table `student_courses`
--
ALTER TABLE `student_courses`
  ADD PRIMARY KEY (`enrollment_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `assignment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `calendar_events`
--
ALTER TABLE `calendar_events`
  MODIFY `event_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `course_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `course_content`
--
ALTER TABLE `course_content`
  MODIFY `content_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `course_materials`
--
ALTER TABLE `course_materials`
  MODIFY `material_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
  MODIFY `exam_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `quiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `student_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `student_courses`
--
ALTER TABLE `student_courses`
  MODIFY `enrollment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assignments`
--
ALTER TABLE `assignments`
  ADD CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `assignment_submissions`
--
ALTER TABLE `assignment_submissions`
  ADD CONSTRAINT `assignment_submissions_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`assignment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `assignment_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `calendar_events`
--
ALTER TABLE `calendar_events`
  ADD CONSTRAINT `calendar_events_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `calendar_events_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `calendar_events_ibfk_3` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`);

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `fk_courses_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `course_content`
--
ALTER TABLE `course_content`
  ADD CONSTRAINT `course_content_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `course_materials`
--
ALTER TABLE `course_materials`
  ADD CONSTRAINT `course_materials_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `course_materials_ibfk_3` FOREIGN KEY (`content_id`) REFERENCES `course_content` (`content_id`),
  ADD CONSTRAINT `fk_course_materials_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `exam_submissions`
--
ALTER TABLE `exam_submissions`
  ADD CONSTRAINT `exam_submissions_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`exam_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `exam_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `grades_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `grades_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_submissions`
--
ALTER TABLE `quiz_submissions`
  ADD CONSTRAINT `quiz_submissions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quiz_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_student_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_courses`
--
ALTER TABLE `student_courses`
  ADD CONSTRAINT `student_courses_fk` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_courses_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
