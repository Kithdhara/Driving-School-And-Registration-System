# DrivePro Academy - Driving School System

## What is this project?
This is a **Role-Based Driving School Registration and Scheduling Web Application**. It allows a driving school to manage their daily operations. 

It handles three types of users:
1. **Admins:** The owners/managers of the school. They can see all students, approve payments, manage instructors, assign lessons (schedules), and view the system dashboard.
2. **Instructors:** The teachers. They can log in, view the lessons they have been assigned, mark them as completed, or request reschedules.
3. **Students:** The learners. They can register for the school, log in, submit their session preferences (Weekday/Weekend), and submit their payment (e.g., $475 fee).

### Tech Stack
- **Backend:** Java Servlets, JSP (JavaServer Pages)
- **Frontend:** HTML, TailwindCSS (for styling)
- **Database:** MySQL
- **Architecture:** MVC (Model-View-Controller) pattern with DAO (Data Access Object) layer.

---

## Step 1: Setting up the Database (MySQL Workbench)
Since you moved the file location, you need to re-import the database into MySQL Workbench.

1. Open **MySQL Workbench**.
2. Connect to your local MySQL server (usually clicking the `Local instance 3306` box and entering your password, which is `root`).
3. In the top menu bar, click **Server** -> **Data Import**.
4. Select **Import from Self-Contained File**.
5. Click the `...` button to browse for the file. Navigate to:
   `D:\Self Study\SLIIT\OOP\Project\VMain\DrivingSchoolSystem\Database_ DrivingSchool.sql`
6. Under "Default Target Schema", you can leave it blank (the SQL file will create the `driving_school` database automatically).
7. Click **Start Import** at the bottom right.
8. Once finished, look at the **Schemas** tab on the left panel, right-click, and select **Refresh All**. You should now see the `driving_school` database!

---

## Step 2: Running the Project in IntelliJ IDEA
This project runs on a server called **Apache Tomcat**. Here is how to configure it in IntelliJ IDEA:

### A. Setup Tomcat in IntelliJ
1. Open the project in IntelliJ IDEA.
2. In the top-right corner, click on **Current File** (or "Add Configuration" / the dropdown next to the Play button) and select **Edit Configurations...**.
3. Click the **+** (Add New Configuration) button in the top left of the window.
4. Scroll down and select **Tomcat Server** -> **Local**.
   *(If you don't see Tomcat, make sure you have IntelliJ IDEA Ultimate. If you only have Community Edition, you will need the "Smart Tomcat" plugin).*
5. Name it something like "Tomcat 10" or "Driving School".
6. If you haven't configured Tomcat before, click the `Configure...` button next to "Application server" and point it to where you installed Apache Tomcat on your computer.

### B. Add the Project Artifact
1. Still inside the Tomcat configuration window, click the **Deployment** tab.
2. Click the **+** button at the bottom of the list and select **Artifact...**.
3. Select `DrivingSchoolSystem:war exploded`.
4. In the "Application context" field at the bottom, just type `/`. (This means the app will run at `http://localhost:8080/`).
5. Click **Apply** and **OK**.

### C. Run It!
1. Click the green **Play (Run)** button at the top right.
2. Wait for IntelliJ to build the project and start Tomcat. 
3. Your browser should automatically open to `http://localhost:8080/`. If not, open your browser and type that in.

---

## Step 3: How to Test the Project

Once the project is running, here is the intended flow to test everything:

### 1. Student Flow
- Navigate to `register.jsp` or click "Sign up".
- Create a new student account.
- Log in with the credentials you just created.
- Click on **Payments**, select a schedule preference, and "Submit Payment".

### 2. Admin Flow
- Log out, and log in with the admin account:
  - **Username:** `admin`
  - **Password:** `admin` (or whatever you set in the database).
- Go to **Students & Payments** and you will see the student you just created. Click the checkmark to "Confirm" their payment.
- Go to **Instructors** and add a new instructor. 
  - *Note: Their login credentials will be saved in a text file named `instructor_credentials.txt` in your project folder!*
- Go to **Master Schedule**, select the student, select the instructor, pick a date/time, and click "Assign Session".

### 3. Instructor Flow
- Log out, and log in using the newly created instructor's credentials (from the text file).
- Go to **Sessions** and you will see the lesson the admin just assigned. 
- Click "Request Reschedule".
- If you log back into the Admin account and check **Session Requests**, you will see the request waiting for approval!
