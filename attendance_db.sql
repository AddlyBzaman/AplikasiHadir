-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2025 at 04:14 AM
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
-- Database: `attendance_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `check_in` datetime DEFAULT NULL,
  `check_out` datetime DEFAULT NULL,
  `status` enum('present','absent','leave') DEFAULT 'present'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `user_id`, `date`, `check_in`, `check_out`, `status`) VALUES
(1, 1, '2025-06-25', '2025-06-25 06:18:49', NULL, 'present'),
(2, 1, '2025-07-02', '2025-07-02 06:02:49', NULL, 'present'),
(3, 4, '2025-07-02', '2025-07-02 06:15:36', NULL, 'present'),
(4, 1, '2025-07-10', '2025-07-10 06:18:17', NULL, 'present'),
(5, 5, '2025-07-10', '2025-07-10 06:40:57', NULL, 'present'),
(6, 6, '2025-07-10', '2025-07-10 06:44:45', NULL, 'present'),
(39, 17, '2025-07-15', '2025-07-15 08:43:00', '2025-07-15 08:56:17', 'present');

-- --------------------------------------------------------

--
-- Table structure for table `cuti`
--

CREATE TABLE `cuti` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `alasan` text NOT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cuti`
--

INSERT INTO `cuti` (`id`, `user_id`, `alasan`, `tanggal_mulai`, `tanggal_selesai`, `created_at`) VALUES
(1, 1, 'Liburan keluarga', '2025-07-04', '2025-07-06', '2025-07-02 05:38:25'),
(2, 1, 'Libur keluarga', '2025-07-03', '2025-07-05', '2025-07-10 06:31:58'),
(3, 1, 'Libur keluarga', '2025-07-03', '2025-07-05', '2025-07-10 06:32:58'),
(4, 1, 'sakit', '2025-07-11', '2025-07-12', '2025-07-10 06:38:48'),
(5, 5, 'sakit', '2025-07-12', '2025-07-31', '2025-07-10 06:41:44'),
(6, 6, 'pergi', '2025-07-12', '2025-07-24', '2025-07-10 06:45:20'),
(7, 7, 'mager', '2025-07-13', '2025-07-17', '2025-07-13 13:24:13'),
(8, 11, 'mager', '2025-07-24', '2025-07-26', '2025-07-13 13:59:38'),
(9, 1, 'sakit', '2025-07-13', '2025-07-14', '2025-07-13 14:26:17'),
(10, 1, 'sakit', '2025-07-30', '2025-07-31', '2025-07-13 14:58:35'),
(11, 15, 'sace', '2025-07-14', '2025-07-25', '2025-07-14 12:22:11'),
(12, 17, 'sakit', '2025-07-14', '2025-07-24', '2025-07-14 14:37:34'),
(13, 15, 'Urusan keluarga', '2025-07-20', '2025-07-22', '2025-07-14 14:43:04'),
(14, 17, 'sakit', '2025-07-17', '2025-07-24', '2025-07-15 01:44:19');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` text NOT NULL,
  `role` varchar(50) DEFAULT 'employee',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'Aldi', 'aldi@example.com', '$2b$10$xSGB8s1Ma1icIr1PbtjrfusQXpmZ1H5Dp/vQuJT4PbbddjAlV4W2W', 'employee', '2025-06-25 04:47:07'),
(2, 'abdul', 'abdul@example.com', '$2b$10$bhsd5P6tM0CBvs79zsTl8uPrQrQ1fumIh8LMSncArE2ok5dZ3xsTa', 'admin', '2025-06-25 05:48:25'),
(3, 'abdul', 'abdul@contoh.com', '$2b$10$8HaWrJmv9KJ3MGRjSfDyhOWxL8eO0gQdliMrVXuZmCFBD48Xq/DWC', 'employee', '2025-07-02 05:52:45'),
(4, 'difa ramadhan', 'difa@contoh.com', '$2b$10$S0O.6McGTmGOcFQoSb0r5O8nzwmG8.lZBzgAcqrgExGWz8Vf2.2xu', 'employee', '2025-07-02 06:14:34'),
(5, 'difa ramadan', 'difa1@gmail.com', '$2b$10$yoF7AptcTFPXgJfhnurrVeVLvsiQhtxXqqvfBFMpXmHyKWHg28HwG', 'employee', '2025-07-10 06:39:35'),
(6, 'aulia mayang', 'aulia123@gmail.com', '$2b$10$SVjj1H2mOuQDDM0h7bfZ/u0wxWLvzoRiBFbyPEONyVGgw3E506HbC', 'employee', '2025-07-10 06:44:01'),
(7, 'addly', 'addly@gmail.com', '$2b$10$NZ5xnZt1.BpnV9T2JNHKu.1nFuARJbL1dxEw5jReVK8bWFfh4fFmi', 'employee', '2025-07-13 12:28:17'),
(8, 'naya', 'naya@yolo.com', '$2b$10$oXIPnUbEKtN4Lgp7GqUnuu58baT4V80S2BMu0rktkskA/cD3gj30O', 'employee', '2025-07-13 12:57:20'),
(9, 'navi', 'navi@yolo.com', '$2b$10$qilCb3KrX8YOlIdLoaknGOoB0d86zD5gyhU4s0.VHjgQHC4Z0gLc.', 'admin', '2025-07-13 13:24:36'),
(10, 'asep', 'asep@yolo.com', '$2b$10$Qd3Nl4e48TttvHTHi6IlPu1.m43pvq6.bbjY6KnxC0zyTOhOxpPIe', 'employee', '2025-07-13 13:32:44'),
(11, 'sinta', 'sinta@email.com', '$2b$10$5W2zuQJ7cJ1pHu.LTIWQcuLO2tC8T2X6YNUcrhxgjeAAiezm5YwrW', 'employee', '2025-07-13 13:57:44'),
(12, 'fandi', 'fandi@yolo.com', '$2b$10$1mvbXYETPhlzGn3u54VhxeG4EjwMCmHxZq/GTQJMxTQYX3YeEm.sW', 'employee', '2025-07-14 11:57:44'),
(13, 'sanja', 'sanja@gmail.com', '$2b$10$pyYuJi6TwmY3uGsa7pqFXOE6eu70Xra.HGGoUZ69GXhPvVsSTange', 'employee', '2025-07-14 12:04:50'),
(14, 'nova', 'nova@gmail.com', '$2b$10$YsJnBKmweJ2iaIlgC7x2HuD5hY8HHXuKjHR8PIEdWKcS.aANiaIIK', 'employee', '2025-07-14 12:12:24'),
(15, 'anjay', 'anjay@yolo.com', '$2b$10$xswGb2Y/YWtIU7MgaHmiueGxQ1kDAgFTbnkSoNrUrlJeX3YQkY6Zm', 'employee', '2025-07-14 12:21:31'),
(16, 'siti', 'siti@yolo.com', '$2b$10$ZJL7nzCCxR7WwLyVN2OyQOvZoSvv/D1Ryckv5Rmx9wftSw77ctNRm', 'employee', '2025-07-14 12:55:35'),
(17, 'santisakinah', 'santisakinah@yolo.com', '$2b$10$3BobMFNDfLVJlDRIkJknceOHvIFIYJ1IK86yUgkWBxR7iB7fVVkzy', 'employee', '2025-07-14 13:00:16'),
(18, 'Sakinah', 'sakinah@example.com', '$2b$10$hoa5i7LxhVk1jb1k4pfIselPScF/3IW4m4tFPS0OJEbiWw5SxacXq', 'employee', '2025-07-14 14:14:26');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cuti`
--
ALTER TABLE `cuti`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `cuti`
--
ALTER TABLE `cuti`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cuti`
--
ALTER TABLE `cuti`
  ADD CONSTRAINT `cuti_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
