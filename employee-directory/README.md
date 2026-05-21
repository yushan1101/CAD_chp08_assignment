# Employee Directory
### Chapter 8 Individual Assignment
**Course:** Web Application Development  
**Faculty:** Faculty of Computing, Universiti Teknologi Malaysia

---

## Student Information
Name : Tang Yu Shan
Matric Number : A24CS0199
Course : SCSM2223 CROSS-PLATFORM APPLICATION DEVELOPMENT
Section : 04

---

## Project Overview
This assignment is to build a fully functional single-page web application — an Employee Directory.

**Tech Stack:**
- Frontend: Vue 3 (Composition API, Vite, port 5174)
- HTTP Client: Axios (single instance with interceptors)
- Backend: Node.js + Express (port 3001)
- Database: MySQL via Laragon (port 3306)

------------------------------

## Setup Instructions

### Step 1 — Create project folder
Create 'employee-directory` folder using mkdir

### Step 2 — Install frontend dependencies
Open a terminal in the project root and run:
npm install

### Step 3 — Install backend dependencies
cd server
npm install

### Step 4 — Set up the database
1. Open **Laragon** and click **Start All**
2. Create sql file with the employees data (7 employees)
3. Click **Database** to open HeidiSQL
4. In HeidiSQL: **File → Load SQL file** → select `sql/schema.sql`
5. Press **F9** to execute
6. Press **F5** to refresh to see `employee_directory` with 7 rows

### Step 5 — Run the API server
Open a terminal and run:
npm run server

and it shows: VITE ready at http://localhost:5174

### Step 6 — Run the frontend
Open a second terminal and run:
npm run dev

and it shows: API running at http://localhost:3001


## Notes on decisions
1. Every SQL query uses ? placeholder prepared statements instead of string concatenation.
2. MySQL stores active as (1 or 0) but Vue checkbox v-model works with true or false. The conversion is handled explicitly in EmployeeForm.vue using Number(val.active) === 1 when loading and form.value.active ? 1 : 0 when saving.