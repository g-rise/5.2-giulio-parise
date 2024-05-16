USE universidad;


-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1 AS 'primer apellido', apellido2 AS 'segundo apellido', nombre FROM persona WHERE tipo = 'alumno' ORDER BY apellido1, apellido2, nombre;


-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1 AS 'primer apellido', apellido2 AS 'segundo apellido' FROM persona WHERE tipo = 'alumno' AND telefono IS NULL;


-- 3. Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM persona WHERE tipo = 'alumno' AND fecha_nacimiento LIKE '1999%';


-- 4. Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
SELECT * FROM persona WHERE tipo = 'profesor' AND telefono IS NULL AND nif REGEXP 'K$';


-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * FROM asignatura WHERE  cuatrimestre = 1 AND curso = 3 AND id_grado = 7;


-- 6. Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1 AS 'primer cognom', p.apellido2 AS 'segon cognom', p.nombre AS 'nom', d.nombre AS 'departament' FROM profesor pr JOIN persona p ON pr.id_profesor = p.id JOIN departamento d ON pr.id_departamento = d.id ORDER BY p.apellido1, p.apellido2, p.nombre;


-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
SELECT a.nombre AS 'Assignatura', ce.anyo_inicio AS 'Any d\'inici', ce.anyo_fin AS 'Any de fi', p.nif AS 'NIF alumne' FROM alumno_se_matricula_asignatura asma JOIN persona p ON asma.id_alumno = p.id JOIN asignatura a ON asma.id_asignatura = a.id JOIN curso_escolar ce ON asma.id_curso_escolar = ce.id WHERE p.nif = '26902806M';


-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT d.id, d.nombre AS 'Departament' FROM departamento d JOIN profesor pr ON d.id = pr.id_departamento JOIN asignatura a USING (id_profesor) JOIN grado g ON a.id_grado = g.id WHERE g.id = 4;
    

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT p.apellido1, p.apellido2, p.nombre FROM persona p JOIN alumno_se_matricula_asignatura asma ON p.id = asma.id_alumno JOIN asignatura a ON asma.id_asignatura = a.id JOIN curso_escolar ce ON asma.id_curso_escolar = ce.id WHERE ce.id = 5;  -- WHERE ce.anyo_inicio = '2018' AND ce.anyo_fin = '2019'


-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- 1. Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT d.nombre AS Departament, p.apellido1 AS 'Primer cognom', p.apellido2 AS 'Segon cognom', p.nombre AS Nom FROM profesor pr JOIN persona p ON pr.id_profesor = p.id LEFT JOIN departamento d ON pr.id_departamento = d.id ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre;


-- 2. Retorna un llistat amb els professors/es que no estan associats a un departament.
SELECT p.id AS 'ID Professor', p.apellido1 AS 'Primer cognom', p.apellido2 AS 'Segon cognom', p.nombre AS Nom FROM profesor pr JOIN persona p ON pr.id_profesor = p.id LEFT JOIN departamento d ON pr.id_departamento = d.id WHERE pr.id_departamento IS NULL;


-- 3. Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT d.id, d.nombre AS 'Departament' FROM departamento d LEFT JOIN profesor pr ON d.id = pr.id_departamento WHERE pr.id_profesor IS NULL;


-- 4. Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT pr.id_profesor, p.apellido1, p.apellido2, p.nombre FROM profesor pr JOIN persona p ON pr.id_profesor = p.id LEFT JOIN asignatura a USING (id_profesor) WHERE a.id_profesor IS NULL;


-- 5. Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT * FROM asignatura a LEFT JOIN profesor pr USING (id_profesor) WHERE a.id_profesor IS NULL;


-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT d.id, d.nombre FROM departamento d LEFT JOIN profesor pr ON d.id = pr.id_departamento LEFT JOIN asignatura a USING (id_profesor) LEFT JOIN alumno_se_matricula_asignatura asma ON a.id = asma.id_asignatura LEFT JOIN curso_escolar ce ON asma.id_curso_escolar = ce.id WHERE a.nombre IS NULL;


-- Consultes resum:
-- 1. Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(id) AS 'Nombre total d\'alumnes' FROM persona WHERE tipo = 'alumno';


-- 2. Calcula quants alumnes van néixer en 1999.
SELECT COUNT(id) AS 'Alumnes nascuts el 1999' FROM persona WHERE fecha_nacimiento LIKE '1999%';


-- 3. Calcula quants professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT d.nombre AS Departament, COUNT(pr.id_profesor) AS 'Nombre de professors' FROM departamento d JOIN profesor pr ON d.id = pr.id_departamento GROUP BY d.nombre ORDER BY COUNT(pr.id_profesor) DESC;


-- 4. Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors/es associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT d.nombre AS Departament, COUNT(pr.id_profesor) AS 'Nombre de professors' FROM departamento d LEFT JOIN profesor pr ON d.id = pr.id_departamento GROUP BY d.nombre;


-- 5. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingues en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT g.nombre AS Grau, COUNT(a.id) AS 'Nombre total d\'assigantures' FROM grado g LEFT JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre ORDER BY COUNT(a.id) DESC;


-- 6. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT g.nombre AS Grau, COUNT(a.id) AS 'Nombre total d\'assigantures' FROM grado g JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre HAVING COUNT(a.id) > 50 ORDER BY COUNT(a.id) DESC;


-- 7. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT g.nombre AS Grau, a.tipo AS 'Tipus d\'assignatura', SUM(a.creditos) AS 'Nombre total de crèdits' FROM grado g JOIN asignatura a ON g.id = a.id_grado GROUP BY g.nombre, a.tipo;


-- 8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT ce.anyo_inicio AS 'Curs escolar', COUNT(DISTINCT asma.id_alumno) AS 'Nombre d\'alumnes matriculats' FROM curso_escolar ce LEFT JOIN alumno_se_matricula_asignatura asma ON ce.id = asma.id_curso_escolar GROUP BY ce.anyo_inicio;


-- 9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT  p.id AS 'ID professor', p.nombre AS Nom, p.apellido1 AS 'Primer cognom', p.apellido2 AS 'Segon Cognom', COUNT(a.id) AS 'Nombre d\'assignatures' FROM profesor pr JOIN persona p ON pr.id_profesor = p.id LEFT JOIN asignatura a USING (id_profesor) GROUP BY pr.id_profesor ORDER BY COUNT(a.id) DESC;


-- 10. Retorna totes les dades de l'alumne/a més jove.
select * FROM persona WHERE fecha_nacimiento = (SELECT MAX(fecha_nacimiento) FROM persona WHERE tipo = 'alumno');


-- 11. Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.id, p.nombre, p.apellido1, p.apellido2, d.nombre AS departament, a.id_profesor AS 'asignatures associades' FROM persona p JOIN profesor pr ON  p.id = pr.id_profesor JOIN departamento d ON pr.id_departamento = d.id LEFT JOIN asignatura a USING (id_profesor) WHERE a.id_profesor IS NULL;


