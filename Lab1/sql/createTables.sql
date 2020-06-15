DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers
(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
	age INT NOT NULL
);

DROP TABLE IF EXISTS rooms;
CREATE TABLE rooms
(
	id      INT AUTO_INCREMENT PRIMARY KEY,
    area    INT NOT NULL,
    inventory VARCHAR(200) NOT NULL
);


DROP TABLE IF EXISTS workshops;
CREATE TABLE workshops 
(
	id      INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT REFERENCES teachers(id),
    name    VARCHAR(50) NOT NULL,
	description VARCHAR(200) NOT NULL
);

DROP TABLE IF EXISTS students;
CREATE TABLE students 
(
	id           INT AUTO_INCREMENT PRIMARY KEY,
    workshop_id  INT REFERENCES workshops(id),
    name    VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    course INT NOT NULL
);

DROP TABLE IF EXISTS workshop_timetable;
CREATE TABLE workshop_timetable
(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    room_id  INT REFERENCES rooms(id),
    teacher_id  INT REFERENCES teachers(id),
    workshop_id  INT REFERENCES workshops(id),
    date DATETIME DEFAULT now() NOT NULL
);

DROP TABLE IF EXISTS competitoins;
CREATE TABLE competitoins 
(
	id           INT AUTO_INCREMENT PRIMARY KEY,
    room_id  INT REFERENCES rooms(id),
    teacher_id  INT REFERENCES teachers(id),
    workshop_id  INT REFERENCES workshops(id),
    name VARCHAR(50) NOT NULL,
    date DATETIME DEFAULT now() NOT NULL
);

INSERT INTO teachers(name, surname, age) VALUES
("Roman", "Soroka", 21),
("Petrov", "Petrovich", 44),
("Kadur", "Verhovish", 31);

INSERT INTO rooms(area, inventory) VALUES
(400, "basket, balls, benches"),
(350, "rackets, windows, high ceiling"),
(200, "dumbbells, benches, bars, mashines");

INSERT INTO workshops(teacher_id, name, description) VALUES 
(1, "Tenis", "We paly tenis in pairs. Our teachers are very good and professional."),
(2, "Basketball", "We basketball in teams. Our teams travel and win lots of tournamensts."),
(3, "Workout", "We workout. We won't let your chindren hurt themselvs.");

INSERT INTO students(workshop_id, name, surname, course) VALUES 
(1, "Viktor", "Comarovski", 4),
(1, "Kurdason", "Cermeniv", 2),
(3, "Hjrman", "Jfrpsnrv", 4),
(2, "Joseph", "Halil", 1),
(3, "Student", "Studentovich", 1);

INSERT INTO workshop_timetable(teacher_id, workshop_id, room_id) VALUES 
(3, 2, 1),
(3, 3, 2),
(1, 1, 1),
(2, 3, 3),
(3, 1, 3),
(1, 2, 2);

INSERT INTO competitoins(teacher_id, workshop_id, room_id, name) VALUES
(3, 2, 1, "Victory to YOU!"),
(3, 3, 2, "No way this is real"),
(1, 1, 1, "The tournament of the century"),
(2, 3, 3, "Why do it tomorrow? Tournament"),
(3, 1, 3, "Why not come to us??"),
(1, 2, 2, "This will the best time of your year");