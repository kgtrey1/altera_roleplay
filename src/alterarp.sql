-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Hôte : gk91407-001.dbaas.ovh.net:35364
-- Généré le : mer. 02 déc. 2020 à 12:41
-- Version du serveur :  10.5.8-MariaDB-1:10.5.8+maria~buster-log
-- Version de PHP : 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `alterarp`
--

-- --------------------------------------------------------

--
-- Structure de la table `clothes`
--

CREATE TABLE `clothes` (
  `steamid` varchar(17) NOT NULL,
  `owned` text NOT NULL DEFAULT '[]',
  `saved` text NOT NULL DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `clothes`
--

INSERT INTO `clothes` (`steamid`, `owned`, `saved`) VALUES
('76561199031450989', '[]', '[{\"set\":\"none\",\"skin\":[]},{\"set\":\"none\",\"skin\":[]},{\"set\":\"none\",\"skin\":[]}]');

-- --------------------------------------------------------

--
-- Structure de la table `employee`
--

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `jobname` varchar(32) NOT NULL DEFAULT 'unemployed',
  `enterprise` varchar(32) NOT NULL DEFAULT 'none',
  `grade` tinyint(3) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `employee`
--

INSERT INTO `employee` (`id`, `steamid`, `jobname`, `enterprise`, `grade`) VALUES
(1, '76561199031450989', 'mechanics', 'ent_bennys', 2);

-- --------------------------------------------------------

--
-- Structure de la table `enterprises`
--

CREATE TABLE `enterprises` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `label` varchar(32) NOT NULL,
  `safe` longtext NOT NULL,
  `money` int(11) NOT NULL,
  `for_sale` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `enterprises`
--

INSERT INTO `enterprises` (`id`, `name`, `label`, `safe`, `money`, `for_sale`) VALUES
(1, 'ent_bennys', 'Benny\'s', '[]', 10090, 1);

-- --------------------------------------------------------

--
-- Structure de la table `grades`
--

CREATE TABLE `grades` (
  `id` int(11) NOT NULL,
  `jobname` varchar(32) NOT NULL,
  `grade` tinyint(3) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL,
  `label` varchar(32) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_m` longtext NOT NULL,
  `skin_f` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `grades`
--

INSERT INTO `grades` (`id`, `jobname`, `grade`, `name`, `label`, `salary`, `skin_m`, `skin_f`) VALUES
(1, 'unemployed', 1, 'unemployed', 'Sans emploi', 0, '', ''),
(2, 'mechanics', 2, 'boss', 'Chef d\'entreprise', 100, '', '');

-- --------------------------------------------------------

--
-- Structure de la table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `inventory` longtext NOT NULL DEFAULT '[]'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `inventory`
--

INSERT INTO `inventory` (`id`, `steamid`, `inventory`) VALUES
(1, '76561199031450989', '{\"chips\":86}');

-- --------------------------------------------------------

--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `label` varchar(32) NOT NULL,
  `volume` float NOT NULL,
  `weight` float NOT NULL,
  `texture` varchar(100) NOT NULL,
  `usable` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `items`
--

INSERT INTO `items` (`id`, `name`, `label`, `volume`, `weight`, `texture`, `usable`) VALUES
(1, 'water_bottle', 'Bouteille d\'eau', 1, 0.5, 'ba_prop_club_tonic_bottle', 1),
(2, 'chips', 'Paquet de chips', 1, 0.5, 'ng_proc_food_chips01a', 0);

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL,
  `label` varchar(32) NOT NULL,
  `whitelisted` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `jobs`
--

INSERT INTO `jobs` (`id`, `name`, `label`, `whitelisted`) VALUES
(1, 'unemployed', 'Sans emploi', 0),
(2, 'ems', 'EMS', 1),
(3, 'banker', 'Banquier', 1),
(4, 'cardealer', 'Concessionnaire', 1),
(5, 'mechanics', 'Mécanicien', 1),
(6, 'police', 'Force de l\'ordre', 1);

-- --------------------------------------------------------

--
-- Structure de la table `licenses`
--

CREATE TABLE `licenses` (
  `steamid` varchar(20) NOT NULL,
  `car` tinyint(1) NOT NULL DEFAULT 0,
  `bike` tinyint(1) NOT NULL DEFAULT 0,
  `truck` tinyint(1) NOT NULL DEFAULT 0,
  `idcard` tinyint(1) NOT NULL DEFAULT 0,
  `firearms` tinyint(1) NOT NULL DEFAULT 0,
  `code` tinyint(1) NOT NULL DEFAULT 0,
  `hasdriving` tinyint(1) NOT NULL DEFAULT 0,
  `hasfirearms` tinyint(1) NOT NULL DEFAULT 0,
  `hasidcard` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `licenses`
--

INSERT INTO `licenses` (`steamid`, `car`, `bike`, `truck`, `idcard`, `firearms`, `code`, `hasdriving`, `hasfirearms`, `hasidcard`) VALUES
('76561199031450989', 0, 0, 0, 1, 1, 1, 0, 0, 1);

-- --------------------------------------------------------

--
-- Structure de la table `money`
--

CREATE TABLE `money` (
  `id` int(11) NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `cash` int(11) NOT NULL,
  `bank` int(11) NOT NULL DEFAULT 0,
  `dirty` int(11) DEFAULT 0,
  `bankname` varchar(32) NOT NULL DEFAULT 'none',
  `iban` varchar(10) NOT NULL DEFAULT 'none'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `money`
--

INSERT INTO `money` (`id`, `steamid`, `cash`, `bank`, `dirty`, `bankname`, `iban`) VALUES
(5, '76561199031450989', 9995211, 500, 0, 'maze', 'TEST'),
(6, 'sqfdezfeza', 0, 200, 0, 'maze', 'lol'),
(7, '76561198260097021', 1000, 0, 0, 'none', 'none');

-- --------------------------------------------------------

--
-- Structure de la table `stats`
--

CREATE TABLE `stats` (
  `id` int(11) NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `str_lvl` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `str_progress` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `stats`
--

INSERT INTO `stats` (`id`, `steamid`, `str_lvl`, `str_progress`) VALUES
(1, '76561199031450989', 5, 0);

-- --------------------------------------------------------

--
-- Structure de la table `transaction`
--

CREATE TABLE `transaction` (
  `id` int(11) NOT NULL,
  `date` varchar(32) NOT NULL,
  `type` varchar(10) NOT NULL,
  `sender` varchar(32) NOT NULL,
  `receiver` varchar(32) NOT NULL DEFAULT 'none',
  `amount` int(11) NOT NULL,
  `bankname` varchar(16) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `transaction`
--

INSERT INTO `transaction` (`id`, `date`, `type`, `sender`, `receiver`, `amount`, `bankname`) VALUES
(3, '25/08/2020 16:34:29', 'transfer', 'Obiwan Kenobi', 'TTYBOY233', 1000, 'maze'),
(4, '25/08/2020 16:34:59', 'withdraw', 'Obiwan Kenobi', 'none', 1000, 'maze'),
(5, '25/08/2020 16:35:03', 'deposit', 'ObiwanKenobi', 'none', 100, 'maze'),
(6, '25/08/2020 16:46:00', 'withdraw', 'Obiwan Kenobi', 'none', 1000, 'fleeca'),
(7, '25/08/2020 16:46:25', 'deposit', 'ObiwanKenobi', 'none', 900, 'fleeca'),
(8, '25/08/2020 16:46:53', 'deposit', 'ObiwanKenobi', 'none', 1000, 'fleeca'),
(9, '25/08/2020 16:47:11', 'transfer', 'Obiwan Kenobi', 'TTYBOY233', 1000, 'fleeca'),
(10, '25/08/2020 20:36:52', 'deposit', 'ObiwanKenobi', 'none', 500, 'maze'),
(11, '25/08/2020 20:42:32', 'transfer', 'Obiwan Kenobi', 'lol', 100, 'maze'),
(12, '25/08/2020 20:42:57', 'transfer', 'Obiwan Kenobi', 'lol', 100, 'maze'),
(13, '01/09/2020 17:12:35', 'withdraw', 'Obiwan Kenobi', 'none', 100, 'maze'),
(14, '01/09/2020 17:12:46', 'deposit', 'Obiwan Kenobi', 'none', 300, 'maze');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `steamid` varchar(17) NOT NULL,
  `license` varchar(255) NOT NULL,
  `height` varchar(4) NOT NULL,
  `birthdate` varchar(10) NOT NULL,
  `firstname` varchar(16) NOT NULL,
  `lastname` varchar(16) NOT NULL,
  `skin` longtext NOT NULL,
  `position` varchar(255) NOT NULL,
  `gender` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `steamid`, `license`, `height`, `birthdate`, `firstname`, `lastname`, `skin`, `position`, `gender`) VALUES
(5, '76561199031450989', 'd45d7a63d583433bcc200b87f5c9daee3de83588', '200', '30/01/1997', 'Obiwan', 'Kenobii', '{\"blush_3\":0,\"beard_2\":0,\"bracelets_1\":-1,\"eyebrows_4\":0,\"complexion_1\":0,\"eye_color\":0,\"glasses_1\":0,\"pants_1\":0,\"makeup_3\":0,\"age_1\":0,\"eyebrows_1\":0,\"age_2\":0,\"shoes_1\":0,\"beard_1\":0,\"tshirt_1\":0,\"sun_1\":0,\"chain_1\":0,\"lipstick_1\":0,\"beard_4\":0,\"makeup_4\":0,\"bproof_2\":0,\"hair_1\":0,\"bracelets_2\":0,\"hair_2\":0,\"bodyb_1\":0,\"chest_1\":0,\"torso_1\":0,\"chest_3\":0,\"blemishes_1\":0,\"lipstick_2\":0,\"blush_1\":0,\"bags_2\":0,\"mask_1\":0,\"eyebrows_2\":0,\"skin\":3,\"sun_2\":0,\"ears_1\":-1,\"hair_color_1\":0,\"tshirt_2\":0,\"face\":0,\"moles_2\":0,\"chain_2\":0,\"decals_2\":0,\"watches_2\":0,\"mask_2\":0,\"torso_2\":0,\"decals_1\":0,\"pants_2\":0,\"bproof_1\":0,\"bags_1\":0,\"beard_3\":0,\"sex\":0,\"watches_1\":-1,\"glasses_2\":0,\"lipstick_3\":0,\"makeup_2\":0,\"bodyb_2\":0,\"moles_1\":0,\"shoes_2\":0,\"arms\":0,\"helmet_1\":-1,\"chest_2\":0,\"ears_2\":0,\"hair_color_2\":0,\"helmet_2\":0,\"eyebrows_3\":0,\"blush_2\":0,\"lipstick_4\":0,\"makeup_1\":0,\"blemishes_2\":0,\"arms_2\":0,\"complexion_2\":0}', '{\"z\":33.50381088256836,\"x\":237.6387634277344,\"y\":-1382.751220703125}', 'M'),
(6, '76561198260097021', '7a3e242231dbad2b4967b4318511aed7d0cbcda4', '180', '15/10/1996', 'Aeron', 'Lieto', '{\"makeup_2\":0,\"sun_2\":0,\"sun_1\":0,\"lipstick_1\":0,\"eyebrows_4\":0,\"mask_1\":0,\"glasses_2\":0,\"bodyb_2\":0,\"decals_1\":0,\"bracelets_2\":0,\"helmet_1\":-1,\"blemishes_2\":0,\"lipstick_3\":0,\"makeup_4\":0,\"chain_2\":0,\"glasses_1\":5,\"age_2\":0,\"shoes_1\":0,\"age_1\":0,\"hair_2\":0,\"hair_color_1\":1,\"watches_2\":0,\"shoes_2\":0,\"makeup_3\":0,\"eyebrows_2\":10,\"blush_2\":0,\"chest_2\":0,\"chain_1\":0,\"tshirt_2\":0,\"lipstick_2\":0,\"face\":0,\"moles_1\":0,\"decals_2\":0,\"bproof_1\":0,\"bracelets_1\":-1,\"hair_color_2\":22,\"pants_1\":0,\"blush_3\":0,\"mask_2\":0,\"eye_color\":1,\"skin\":0,\"bags_1\":0,\"watches_1\":-1,\"beard_1\":11,\"moles_2\":0,\"beard_3\":0,\"complexion_1\":0,\"arms\":0,\"chest_1\":0,\"eyebrows_1\":0,\"blemishes_1\":0,\"pants_2\":0,\"ears_2\":0,\"lipstick_4\":0,\"arms_2\":0,\"beard_2\":5,\"eyebrows_3\":0,\"chest_3\":0,\"makeup_1\":0,\"torso_1\":0,\"complexion_2\":0,\"sex\":0,\"blush_1\":0,\"tshirt_1\":0,\"bproof_2\":0,\"bodyb_1\":0,\"helmet_2\":0,\"bags_2\":0,\"beard_4\":0,\"ears_1\":-1,\"hair_1\":3,\"torso_2\":0}', '{\"z\":38.69100189209,\"y\":-306.02728271484,\"x\":-154.27418518066}', 'M');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `clothes`
--
ALTER TABLE `clothes`
  ADD PRIMARY KEY (`steamid`);

--
-- Index pour la table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `enterprises`
--
ALTER TABLE `enterprises`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`steamid`);

--
-- Index pour la table `money`
--
ALTER TABLE `money`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `stats`
--
ALTER TABLE `stats`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `employee`
--
ALTER TABLE `employee`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `enterprises`
--
ALTER TABLE `enterprises`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `grades`
--
ALTER TABLE `grades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `money`
--
ALTER TABLE `money`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `stats`
--
ALTER TABLE `stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
