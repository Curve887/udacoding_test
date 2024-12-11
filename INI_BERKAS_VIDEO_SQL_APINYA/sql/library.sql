-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2024 at 04:18 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `library`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `id` int(11) NOT NULL,
  `id_library` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `account`
--

INSERT INTO `account` (`id`, `id_library`, `name`, `email`, `password_hash`, `created_at`) VALUES
(2, '6666-6256-9653', 'test', 'test@test.com', '$2y$10$25uNg72h0aBosM5ak6Vg/uaMVHdoqC4Qm4ydVCHwrlGPylvqCo6Cu', '2024-12-11 00:57:57'),
(13, '8101-1656-4104', 'ade', 'ade@gmail.com', '$2y$10$1t67vn3sH7ht7bLohertcOC7E4v8n9NiTMumsDEMWPXyaBjCnpWMC', '2024-12-11 15:50:20'),
(14, '7231-9829-6257', 'ade', 'ade@gmail.com', '$2y$10$gv5H90ufQQMph2uv53GuCONgBn/QTeqbpvA5odyW7hR7BSH6JmDVq', '2024-12-11 15:52:42'),
(15, '5847-8471-2981', 'ade', 'ade@gmail.com', '$2y$10$Cuyj.9i56cp9fOGXWfUMvuFSBjYBm.5yS4An5UtF5ImQ.15RChJ2K', '2024-12-11 15:58:28');

-- --------------------------------------------------------

--
-- Table structure for table `borrow`
--

CREATE TABLE `borrow` (
  `id` int(11) NOT NULL,
  `id_library` varchar(100) NOT NULL,
  `book_id` int(11) NOT NULL,
  `book_title` varchar(100) NOT NULL,
  `borrow_date` datetime NOT NULL,
  `return_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `borrow`
--

INSERT INTO `borrow` (`id`, `id_library`, `book_id`, `book_title`, `borrow_date`, `return_date`) VALUES
(8, '8597-6026-4409', 1, 'Carrie', '2024-12-01 00:00:00', '2024-12-12 00:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `borrow`
--
ALTER TABLE `borrow`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `borrow`
--
ALTER TABLE `borrow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
