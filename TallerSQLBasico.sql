-- HECHO POR LUIS SANTIAGO VANEGAS BEDOYA 
-- 230211006
-- ING. SISTEMAS 

-- a)Proyecte el listado de todas las columnas de todos los empleados.

SELECT *
FROM EMPLOYEES;

--b) Proyecte los empleados, como en el punto anterior, y ordene por nombre y apellido.

SELECT * 
FROM EMPLOYEES
ORDER BY FIRST_NAME, LAST_NAME;

-- C) Seleccione los empleados para los cuales su nombre empieza por la letra K.
SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME LIKE 'K%';

-- d) Seleccione los empleados cuyo nombre empieza por la letra K y ordene la
-- proyección igual que el inmediato pasado punto con ordenamiento.

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME LIKE 'K%'
ORDER BY FIRST_NAME, LAST_NAME;

-- e) Proyecte los IDs de departamentos (departments), con la cantidad de
-- empleados(employees), que hay en cada uno de ellos (los departamentos).

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS Cantidad_empleados
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- f) Averigüe cual es la máxima cantidad máxima de empleados que departamento
-- alguno tenga.

SELECT MAX(Cantidad_empleados) AS Max_cant_empleados
FROM(
    SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS Cantidad_empleados
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID
);

-- g) Proyecte el ID y nombre de los empleados con el nombre del departamento en el
-- que trabaja.

SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, e.DEPARTMENT_NAME
FROM EMPLOYEES e, DEPARTMENTS e
JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- h) Proyecte el número, nombre y salario de los empleados que trabajan en el
-- departamento SALES.

SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_NAME
FROM EMPLOYEES e, DEPARTMENTS e
JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE d.DEPARTMENT_NAME = 'Sales';

-- i) Igual al anterior pero ordenado de mayor a menor salario.

SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, e.DEPARTMENT_NAME
FROM EMPLOYEES e, DEPARTMENTS e
JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE d.DEPARTMENT_NAME = 'Sales'
ORDER BY e.SALARY DESC;

-- j) Obtenga el número y nombre de cada empleado junto con su salario y grado salarial.
-- Suponiendo que existe una tabla llamada salary_grades con las columnas grade_id, min_salary y max_salary

SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, sg.GRADE_ID
FROM EMPLOYEES e
JOIN SALARY_GRADE sg ON e.SALARY BETWEEN sg.MIN_SALARY AND sg.MAX_SALARY;

--  k) Proyectar el ID, nombre y grado salarial de los empleados que tienen grados salariales 2, 4 o 5.

SELECT e.employee_id, e.first_name, e.last_name, sg.grade_id 
FROM employees e
JOIN salary_grades sg ON e.salary BETWEEN sg.min_salary AND sg.max_salary
WHERE sg.grade_id IN (2, 4, 5);

-- l) Obtener el ID del departamento con el promedio salarial ordenado de mayor a menor.

SELECT DEPARTMENT_ID, AVG(SALARY) AS Promedio_salario
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID
ORDER BY Promedio_salario DESC;

-- m) Proyectar el nombre del departamento con el promedio salarial ordenado de mayor a menor.

SELECT d.DEPARTMENT_NAME, AVG(e.SALARY) AS Promedio_salario
FROM EMPLOYEES e
JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME
ORDER BY Promedio_salario DESC;

-- n) Presentar el ID del departamento con la cantidad de empleados del departamento que cuente con el mayor número de empleados.

SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS Num_Empleados
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY Num_Empleados DESC
FETCH FIRST 1 ROW ONLY;

-- o) Encuentre los jefes (manager), presentando su ID y nombre, y el nombre del departamento donde trabajan.

SELECT DISTINCT m.EMPLOYEES_ID AS MANAGER_ID, m.FIRST_NAME, d.DEPARTMENT
FROM EMPLOYEES e
JOIN EMPLOYEES m ON e.MANAGER_ID = m.EMPLOYEE_ID
JOIN DEPARTMENTS d ON m.DEPARTMENT_ID = d.DEPARTMENT_ID;
 
-- p) Determinar los nombres de cada empleado junto con el grado salarial del empleado, el grado salarial del jefe 
-- y la diferencia de grado salarial existente con su jefe.

SELECT e.first_name, e.last_name, 
       sg_e.grade_id AS employee_grade, 
       sg_m.grade_id AS manager_grade, 
       sg_m.grade_id - sg_e.grade_id AS grade_difference
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
JOIN salary_grades sg_e ON e.salary BETWEEN sg_e.min_salary AND sg_e.max_salary
JOIN salary_grades sg_m ON m.salary BETWEEN sg_m.min_salary AND sg_m.max_salary;

-- q) Averiguar los IDs y nombres de los distintos departamentos en donde hay 
-- al menos un empleado que gana más de 3000 (sin tuplas repetidas).

SELECT DISTINCT d.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM DEPARTMENTS d
JOIN EMPLOYEES e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE e.SALARY > 3000;

-- r) Identificar los IDs y nombres de los distintos departamentos en donde 
-- hay al menos dos empleados distintos que ganan más de 2500.

SELECT d.DEPARTMENTS_ID, d.DEPARMENT_NAME
FROM DEPARTMENTS d
JOIN EMPLOYEES e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE e.SALARY >2500
GROUP BY d.DEPARTMENT_ID, d.DEPARTMENT_NAME
HAVING COUNT(DISTINCT e.EMPLOYEE_ID) >= 2;

-- s) Encontrar los IDs y nombres de los empleados que ganan más dinero que su respectivo jefe.

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- t) Establecer los IDs y nombres de los departamentos en donde al menos uno de los empleados gana más de 3000 informando la cantidad de estos empleados identificada para cada departamento.
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
FROM departments d
JOIN employees e ON d.department_id = e.department_id
WHERE e.salary > 3000
GROUP BY d.department_id, d.department_name;

-- u) Determinar los IDs y nombres de los departamentos en donde todos los empleados ganan más de 3000.
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id AND e.salary <= 3000
);

-- v) Determinar los IDs y nombres de los departamentos en donde todos los empleados ganan más de 3000 y existe al menos un jefe que gana más de 5000.
SELECT d.department_id, d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id AND e.salary <= 3000
)
AND EXISTS (
    SELECT 1
    FROM employees e
    JOIN employees m ON e.manager_id = m.employee_id
    WHERE e.department_id = d.department_id AND m.salary > 5000
);

-- w) Presentar los IDs y nombres de los empleados que no son del departamento 80 y que ganan más que cualquiera de los empleados del departamento 80.
SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.department_id != 80
AND e.salary > ALL (
    SELECT salary
    FROM employees
    WHERE department_id = 80
);








