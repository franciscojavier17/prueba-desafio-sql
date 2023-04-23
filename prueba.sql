
-- Creamos la base de datos

CREATE DATABASE Prueba_Francisco_Moya_177;

-- Ingresamos a ella

\c Prueba_Francisco_Moya_177;

-- 1.- Crea el modelo, respeta las claves primarias, foráneas y tipos de datos.

    -- Primera tabla

CREATE TABLE peliculas(
id SERIAL,
nombre VARCHAR(255),
years INT,
PRIMARY KEY (id)
);

    -- Segunda tabla

CREATE TABLE tags(
id SERIAL,
tag VARCHAR(32),
PRIMARY KEY (id)
);

    -- Tabla intermedia

CREATE TABLE pelicula_tag(
id SERIAL PRIMARY KEY,
pelicula_id INT,
tag_id INT,
FOREIGN KEY (pelicula_id)
REFERENCES peliculas(id),
FOREIGN KEY (tag_id)
REFERENCES tags(id)
);

-- Vemos las tablas creadas

\dt

-- 2.- Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados.

    -- 5 peliculas

INSERT INTO peliculas (nombre, years) VALUES
('Rapidos y furiosos 5', 2011),
('Scarface', 1983),
('Dragon Ball Super: Broly', 2018),
('Avengers endgame', 2019),
('Los soldados secretos de Bengasi', 2016);

-- Comprobamos lo que queriamos

SELECT * FROM peliculas;

    -- 5 tags

INSERT INTO tags (tag) VALUES
('Aventura'),
('Crimen'),
('Fantasía'),
('Ciencia ficción'),
('Acción');

-- Comprobamos lo que queriamos

SELECT * FROM tags;

    -- Tags asociados a las peliculas

INSERT INTO pelicula_tag(pelicula_id, tag_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5);

-- Comprobamos lo que queriamos

SELECT * FROM pelicula_tag;

-- 3.- Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.

SELECT COUNT(pelicula_tag), peliculas.nombre 
FROM peliculas 
LEFT JOIN pelicula_tag ON pelicula_tag.pelicula_id = peliculas.id
GROUP BY peliculas.nombre;

-- 4.- Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.

    -- Primera tabla

CREATE TABLE Preguntas(
id SERIAL,
pregunta VARCHAR(255),
respuesta_correcta VARCHAR,
PRIMARY KEY (id)
);

    -- Segunda tabla

CREATE TABLE Usuarios(
id SERIAL,
nombre VARCHAR(255),
edad INT,
PRIMARY KEY (id)
);

    -- Tabla intermedia

CREATE TABLE Respuestas (
id SERIAL,
respuesta VARCHAR(255),
usuario_id INT,
pregunta_id INT,
PRIMARY KEY (id),
FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
FOREIGN KEY (pregunta_id) REFERENCES preguntas(id)
);

-- Vemos las tablas creadas

\dt

-- 5.- Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.

    -- Insertamos 5 usuarios

INSERT INTO Usuarios (nombre, edad) VALUES
('Thomas', 25),
('Matias', 18),
('Alvaro', 29),
('Rodrigo', 33),
('Martin', 18);

-- Comprobamos lo que queriamos

SELECT * FROM Usuarios;

    -- Insertamos 5 preguntas

INSERT INTO preguntas(pregunta, respuesta_correcta) VALUES
('¿Qué comprarías con un millón de dólares?', 'Una casa'),
('¿Cuál es el lugar más frío de la tierra?', 'La Antártida'),
('¿Cuántos minutos tiene una hora?', '60 minutos'),
('¿Cual es el volcan mas grande de Chile?', 'Volcan Ojos del Salado'),
('¿Quién escribió La Odisea?', 'Homero');

-- Comprobamos lo que queriamos

SELECT * FROM preguntas;

    -- Insertamos las respuestas

INSERT INTO respuestas(respuesta, usuario_id, pregunta_id) VALUES
('Una casa', 1, 1),
('Una casa', 2, 1),
('La Antártida', 1, 2),
('Pasapalabra', 4, 2),
('Ni idea', 3, 2);

-- Comprobamos lo que queriamos

SELECT * FROM respuestas;

-- 6.- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).

SELECT 
	usuarios.id, 
	usuarios.nombre, 
	(
		SELECT COUNT(respuestas) FROM respuestas 
		LEFT JOIN preguntas ON respuestas.pregunta_id = preguntas.id
		WHERE respuestas.respuesta = preguntas.respuesta_correcta  
		AND respuestas.usuario_id = usuarios.id 
	)
FROM usuarios 
GROUP BY usuarios.id, usuarios.nombre;

-- 7.- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.

SELECT 
	preguntas.id, 
	preguntas.pregunta, 
		(
		SELECT COUNT(respuestas) FROM respuestas 
		LEFT JOIN usuarios ON respuestas.usuario_id = usuarios.id
		WHERE respuestas.respuesta = preguntas.respuesta_correcta  
		AND respuestas.pregunta_id = preguntas.id 
	)
FROM preguntas 
GROUP BY preguntas.id, preguntas.pregunta;

-- 8.- Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación.

ALTER TABLE respuestas 
DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD FOREIGN KEY (usuario_id) 
REFERENCES usuarios(id) 
ON DELETE CASCADE;
DELETE FROM usuarios
WHERE id = 1;

-- Comprobamos lo que queriamos

SELECT * FROM respuestas;

-- 9.- Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.

ALTER TABLE usuarios
ADD CONSTRAINT check_age CHECK(edad >= 18);

-- Comprobamos lo que queriamos

SELECT * FROM usuarios;

-- 10.- Altera la tabla existente de usuarios agregando el campo email con la restricción de único.

ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255);
ADD CONSTRAINT email_unique UNIQUE (email);
INSERT INTO usuarios (nombre, edad, email) VALUES 
('Matias', 18, 'Matias@gmail.com'),
('Alvaro', 29, 'Alvaro@gmail.com'),
('Rodrigo', 33, 'Rodrigo@gmail.com'),
('Martin', 18, 'Martin@gmail.com');

-- Comprobamos lo que queriamos

SELECT * FROM usuarios;

-- Salir de postgreSQL

\q