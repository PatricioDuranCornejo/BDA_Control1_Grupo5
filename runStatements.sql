--1. Mascota con más atenciones por sucursal.
WITH atenciones_agrupadas AS (
	SELECT
		sucursal.id AS sucursal_id,
        sucursal.nombre AS sucursal_nombre,
        mascota.id AS mascota_id,
        mascota.nombre AS mascota_nombre,
        COUNT(atencion.id) AS atenciones_totales
	FROM sucursal
    JOIN atencion ON sucursal.id = atencion.id_sucursal
    JOIN mascota ON atencion.id_mascota = mascota.id
    GROUP BY
		sucursal.id, sucursal.nombre,
        mascota.id, mascota.nombre
),
atenciones_ranking AS (
	SELECT
		sucursal_id, sucursal_nombre,
        mascota_id, mascota_nombre,
        atenciones_totales,
        RANK() OVER (
			PARTITION BY sucursal_id
            ORDER BY atenciones_totales DESC
		) as ranking
	FROM atenciones_agrupadas
)
SELECT
	sucursal_id, sucursal_nombre,
    mascota_id, mascota_nombre,
    atenciones_totales
FROM atenciones_ranking
WHERE ranking = 1;

--2. Veterinario con más atenciones realizadas por mes durante el 2024.
WITH veterinarios_agrupados AS (
	SELECT
		empleado.rut AS empleado_rut,
        empleado.cargo AS empleado_cargo,
        TO_CHAR(atencion.fecha_atencion, 'YYYY-MM') as mes,
        COUNT(atencion.id) AS atenciones_totales
	FROM atencion
    JOIN atencion_empleado ON atencion.id = atencion_empleado.id_atencion
    JOIN empleado ON atencion_empleado.id_empleado = empleado.id
    WHERE
		atencion.fecha_atencion >= '2024-01-01'
		AND atencion.fecha_atencion < '2025-01-01'
        AND empleado.cargo = 'Veterinario'
	GROUP BY
		empleado.rut, empleado.cargo,
        TO_CHAR(atencion.fecha_atencion, 'YYYY-MM')
),
veterinarios_ranking AS (
	SELECT
		empleado_rut, empleado_cargo,
        mes,
        atenciones_totales,
        RANK() OVER (
			PARTITION BY mes
            ORDER BY atenciones_totales DESC
		) AS ranking
	FROM veterinarios_agrupados
)
SELECT
	empleado_rut, empleado_cargo,
    mes,
    atenciones_totales
FROM veterinarios_ranking
WHERE ranking = 1
ORDER BY mes ASC;

--3. Especie más atendida por sucursal.
WITH conteo AS (
    SELECT s.id      AS id_sucursal,
           s.nombre  AS sucursal,
           e.id      AS id_especie,
           e.tipo    AS especie,
           COUNT(*)  AS atenciones
    FROM atencion a
    JOIN sucursal s ON s.id = a.id_sucursal
    JOIN mascota  m ON m.id = a.id_mascota
    JOIN raza     r ON r.id = m.id_raza
    JOIN especie  e ON e.id = r.id_especie
    GROUP BY s.id, s.nombre, e.id, e.tipo
),
ranking AS (
    SELECT conteo.*,
           RANK() OVER (PARTITION BY id_sucursal ORDER BY atenciones DESC) AS posicion
    FROM conteo
)
SELECT sucursal, especie, atenciones
FROM ranking
WHERE posicion = 1
ORDER BY sucursal, especie;

--4. Cliente que más ha gastado en atenciones por año.
WITH gasto AS (
    SELECT EXTRACT(YEAR FROM a.fecha_atencion) AS anio,
           c.id                   AS id_cliente,
           CONCAT(c.nombres, ' ', c.apellidos) AS cliente,
           SUM(a.costo_total)     AS total_gastado
    FROM atencion a
    JOIN mascota m ON m.id = a.id_mascota
    JOIN cliente c ON c.id = m.id_cliente
    GROUP BY EXTRACT(YEAR FROM a.fecha_atencion), c.id, c.nombres, c.apellidos
),
ranking AS (
    SELECT gasto.*,
           RANK() OVER (PARTITION BY anio ORDER BY total_gastado DESC) AS posicion
    FROM gasto
)
SELECT anio, cliente, total_gastado
FROM ranking
WHERE posicion = 1
ORDER BY anio, cliente;

--5. Medicamento más recetado por especie.
WITH conteo AS (
    SELECT e.id            AS id_especie,
           e.tipo          AS especie,
           m.id            AS id_medicamento,
           m.nombre        AS medicamento,
           COUNT(DISTINCT rm.id_receta) AS veces_recetado
    FROM receta_medicamento rm
    JOIN receta       r  ON r.id  = rm.id_receta
    JOIN atencion     a  ON a.id  = r.id_atencion
    JOIN mascota      ma ON ma.id = a.id_mascota
    JOIN raza         rz ON rz.id = ma.id_raza
    JOIN especie      e  ON e.id  = rz.id_especie
    JOIN medicamento  m  ON m.id  = rm.id_medicamento
    GROUP BY e.id, e.tipo, m.id, m.nombre
),
ranking AS (
    SELECT conteo.*,
           RANK() OVER (PARTITION BY id_especie ORDER BY veces_recetado DESC) AS posicion
    FROM conteo
)
SELECT especie, medicamento, veces_recetado
FROM ranking
WHERE posicion = 1
ORDER BY especie, medicamento;

--6. Total recaudado por sucursal por mes en los últimos 12 meses.
SELECT s.nombre                          AS sucursal,
       TO_CHAR(p.fecha_pago, 'YYYY-MM') AS mes,
       SUM(p.monto)                      AS total_recaudado
FROM pago p
JOIN atencion a ON a.id = p.id_atencion
JOIN sucursal s ON s.id = a.id_sucursal
WHERE p.fecha_pago >= (CURRENT_DATE - INTERVAL '11 months')::date
  AND p.fecha_pago <= CURRENT_DATE
GROUP BY s.id, s.nombre, TO_CHAR(p.fecha_pago, 'YYYY-MM')
ORDER BY mes, sucursal;

--7. Tipo de atención más solicitado por comuna.
WITH conteo AS (
    SELECT c.id     AS id_comuna,
           c.nombre AS comuna,
           ta.id    AS id_tipo,
           ta.tipo  AS tipo_atencion,
           COUNT(*) AS cantidad
    FROM atencion a
    JOIN sucursal      s  ON s.id  = a.id_sucursal
    JOIN comuna        c  ON c.id  = s.id_comuna
    JOIN tipo_atencion ta ON ta.id = a.id_tipo
    GROUP BY c.id, c.nombre, ta.id, ta.tipo
),
ranking AS (
    SELECT conteo.*,
           RANK() OVER (PARTITION BY id_comuna ORDER BY cantidad DESC) AS posicion
    FROM conteo
)
SELECT comuna, tipo_atencion, cantidad
FROM ranking
WHERE posicion = 1
ORDER BY comuna, tipo_atencion;

--8. Empleados con mayor y menor sueldo por sucursal, indicando su cargo.
WITH sueldos AS (
    SELECT s.id        AS id_sucursal,
           s.nombre    AS sucursal,
           e.id        AS id_empleado,
           CONCAT(e.nombres, ' ', e.apellidos) AS empleado,
           e.cargo,
           su.monto    AS sueldo,
           RANK() OVER (PARTITION BY s.id ORDER BY su.monto DESC) AS pos_mayor,
           RANK() OVER (PARTITION BY s.id ORDER BY su.monto ASC)  AS pos_menor
    FROM sucursal s
    JOIN sucursal_empleado se ON se.id_sucursal = s.id
    JOIN empleado          e  ON e.id  = se.id_empleado
    JOIN sueldo            su ON su.id = e.id_sueldo
)
SELECT sucursal, 'Mayor sueldo' AS condicion, empleado, cargo, sueldo
FROM sueldos
WHERE pos_mayor = 1
UNION ALL
SELECT sucursal, 'Menor sueldo' AS condicion, empleado, cargo, sueldo
FROM sueldos
WHERE pos_menor = 1
ORDER BY sucursal, condicion DESC, empleado;

--9. Lista de regiones con la cantidad de clientes y de mascotas registradas en ellas.
SELECT r.nombre AS region,
       COUNT(DISTINCT c.id) AS cantidad_clientes,
       COUNT(DISTINCT m.id) AS cantidad_mascotas
FROM region r
LEFT JOIN comuna co ON co.id_region = r.id
LEFT JOIN cliente c ON c.id_comuna = co.id
LEFT JOIN mascota m ON m.id_cliente = c.id
GROUP BY r.id, r.nombre
ORDER BY r.nombre;

--10. Atenciones sin pago asociado por sucursal, indicando el monto total adeudado.
SELECT s.nombre AS sucursal,
       COUNT(a.id) AS atenciones_sin_pago,
       SUM(a.costo_total) AS monto_adeudado
FROM atencion a
JOIN sucursal s ON s.id = a.id_sucursal
LEFT JOIN pago p ON p.id_atencion = a.id
WHERE p.id IS NULL
GROUP BY s.id, s.nombre
ORDER BY s.nombre;
