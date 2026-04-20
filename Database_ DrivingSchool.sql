-- DROP DATABASE driving_school; -- to get a new start everytime/ just do it for testing . not for the real thing. u dont want ur data to vipe out

CREATE DATABASE driving_school;

USE driving_school;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,              -- UNIQUE removed for testing
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'STUDENT', 'INSTRUCTOR') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table students (
	student_id int auto_increment primary key,
    user_id int not null,
    full_name        VARCHAR(100) NOT NULL,
    phone            VARCHAR(15)  NOT NULL,
	nic               VARCHAR(20)  NOT NULL,    -- UNIQUE removed for testing
    email            VARCHAR(100) NOT NULL,     -- UNIQUE removed for testing
    permit_type     VARCHAR(50)  NOT NULL,
    address           VARCHAR(255),
    registration_date date default (current_date),
    foreign key (user_id) references users(user_id)
);

CREATE TABLE instructors (
    instructor_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT          NOT NULL,
    full_name        VARCHAR(100) NOT NULL,
    phone            VARCHAR(15)  NOT NULL,
    email            VARCHAR(100) NOT NULL,     -- UNIQUE removed for testing
    license_type     VARCHAR(50)  NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
create table schedules(
	schedule_id   INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT         NOT NULL,
    instructor_id INT         NOT NULL,
    lesson_date   DATE        NOT NULL,
    lesson_time   TIME        NOT NULL,
    status ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED') not null DEFAULT 'SCHEDULED',
    notes         VARCHAR(255),
    FOREIGN KEY (student_id)    REFERENCES students(student_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
    -- we can add UNIQUE too but think about it 
);
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('CARD', 'CASH', 'ONLINE') NOT NULL,
    session_preference ENUM('WEEKDAY', 'WEEKEND') NOT NULL,
    package_type ENUM('INDIVIDUAL', 'VIP', 'REFRESHER') NOT NULL DEFAULT 'INDIVIDUAL',
    sessions_included INT NOT NULL DEFAULT 10,
    payment_status ENUM('PENDING', 'CONFIRMED', 'REJECTED') NOT NULL DEFAULT 'PENDING',

    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

CREATE TABLE session_requests (
    request_id     INT AUTO_INCREMENT PRIMARY KEY,
    schedule_id    INT          NOT NULL,
    instructor_id  INT          NOT NULL,
    request_type ENUM('RESCHEDULE', 'UNAVAILABLE') NOT NULL,
    reason         VARCHAR(255) NOT NULL,
    requested_date DATE,
    requested_time TIME,
    status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    created_at     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id)   REFERENCES schedules(schedule_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
    -- ON DELETE CASCADE lets look at this later 
);

-- Student reviews of instructors
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    instructor_id INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(500),
    review_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE CASCADE
);
