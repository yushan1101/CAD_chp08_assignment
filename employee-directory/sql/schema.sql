-- sql/schema.sql
CREATE DATABASE IF NOT EXISTS employee_directory
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE employee_directory;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  empId     VARCHAR(10)  NOT NULL UNIQUE,
  name      VARCHAR(120) NOT NULL,
  email     VARCHAR(120) NOT NULL UNIQUE,
  department VARCHAR(50) NOT NULL,
  position  VARCHAR(100) NOT NULL,
  hireDate  DATE         NOT NULL,
  salary    DECIMAL(10,2) NOT NULL,
  active    TINYINT(1)   NOT NULL DEFAULT 1,
  CHECK (salary >= 1500 AND salary <= 50000)
) ENGINE=InnoDB;

INSERT INTO employees
  (empId, name, email, department, position, hireDate, salary, active)
VALUES
  ('EMP001', 'Ahmad Faiz bin Zakaria',
   'ahmad.faiz@company.com.my',
   'IT', 'Software Engineer', '2021-03-15', 5500.00, 1),

  ('EMP002', 'Nur Hidayah binti Roslan',
   'nur.hidayah@company.com.my',
   'HR', 'HR Executive', '2020-07-01', 4200.00, 1),

  ('EMP003', 'Lim Wei Jian',
   'lim.weijian@company.com.my',
   'Finance', 'Financial Analyst', '2019-11-20', 6000.00, 1),

  ('EMP004', 'Siti Aminah binti Yusof',
   'siti.aminah@company.com.my',
   'IT', 'System Administrator', '2022-01-10', 4800.00, 1),

  ('EMP005', 'Rajesh a/l Subramaniam',
   'rajesh.sub@company.com.my',
   'Finance', 'Accounts Executive', '2018-06-05', 4500.00, 0),

  ('EMP006', 'Nurul Ain binti Hamdan',
   'nurul.ain@company.com.my',
   'HR', 'Recruitment Specialist', '2023-02-14', 3800.00, 1),

  ('EMP007', 'Chong Kah Meng',
   'chong.kahmeng@company.com.my',
   'IT', 'DevOps Engineer', '2021-09-30', 7200.00, 1);