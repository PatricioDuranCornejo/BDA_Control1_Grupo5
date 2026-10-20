--1. Cargar los catálogos de región y comuna.
INSERT INTO region (id, nombre) VALUES
(1, 'Metropolitana de Santiago'),
(2, 'Valparaíso'),
(3, 'Biobío'),
(4, 'La Araucanía');

INSERT INTO comuna (id, nombre, id_region) VALUES
(1, 'Santiago',     1),
(2, 'Providencia',  1),
(3, 'Ñuñoa',        1),
(4, 'Maipú',        1),
(5, 'Viña del Mar', 2),
(6, 'Valparaíso',   2),
(7, 'Concepción',   3),
(8, 'Temuco',       4);

--2. Cargar especies, razas y tipos de atención.
INSERT INTO especie (id, tipo) VALUES
(1, 'Perro'),
(2, 'Gato'),
(3, 'Conejo');

-- Mestizo según raza/id
INSERT INTO raza (id, tipo, id_especie) VALUES
(1, 'Labrador',        1),
(2, 'Poodle',          1),
(3, 'Mestizo',         1),
(4, 'Siamés',          2),
(5, 'Persa',           2),
(6, 'Mestizo',         2),
(7, 'Cabeza de León',  3);

INSERT INTO tipo_atencion (id, tipo) VALUES
(1, 'Consulta general'),
(2, 'Vacunación'),
(3, 'Cirugía'),
(4, 'Control'),
(5, 'Urgencia');

--3. Cargar clientes y mascotas; RM: 4 clientes y 5 mascotas, Valparaíso: 2 y 3, Biobío: 1 y 1, Araucanía: 0 y 0.
INSERT INTO cliente (id, rut, nombres, apellidos, id_comuna) VALUES
(1, '15.234.567-8', 'Ana',      'Pérez Lagos',     3),
(2, '16.345.678-9', 'Bruno',    'Soto Díaz',       1),
(3, '17.456.789-0', 'Carla',    'Rojas Vega',      5),
(4, '18.567.890-1', 'Diego',    'Muñoz Pinto',     2),
(5, '14.678.901-2', 'Elena',    'Vargas Mella',    6),
(6, '13.789.012-3', 'Felipe',   'Castro Ibáñez',   7),
(7, '19.890.123-4', 'Gabriela', 'Díaz Contreras',  4);

INSERT INTO mascota (id, nombre, id_raza, id_cliente) VALUES
(1, 'Firulais', 1, 1),
(2, 'Luna',     4, 1),
(3, 'Max',      2, 2),
(4, 'Michi',    5, 3),
(5, 'Rocky',    3, 4),
(6, 'Pelusa',   7, 5),
(7, 'Toby',     1, 6),
(8, 'Nina',     6, 7),
(9, 'Bobby',    2, 3);

--4. Cargar sucursales; la sucursal 4 en Concepción permite comprobar el empate de la consulta 7.
INSERT INTO sucursal (id, nombre, direccion, id_comuna) VALUES
(1, 'Clínica Centro',      'Av. Libertador Bernardo O''Higgins 1200', 1),
(2, 'Clínica Providencia', 'Av. Providencia 2450',                    2),
(3, 'Clínica Viña',        'Av. San Martín 800',                      5),
(4, 'Clínica Concepción',  'Calle Barros Arana 650',                  7);

--5. Cargar el catálogo compartido de sueldos y los empleados.
INSERT INTO sueldo (id, monto) VALUES
(1, 2200000.00),
(2, 1800000.00),
(3,  900000.00),
(4,  700000.00),
(5, 1200000.00);

INSERT INTO empleado (id, rut, nombres, apellidos, cargo, id_sueldo) VALUES
(1,  '10.111.111-1', 'Camila',    'Fuentes Araya',  'Veterinario',    1),
(2,  '10.222.222-2', 'Tomás',     'Herrera Núñez',  'Veterinario',    2),
(3,  '10.333.333-3', 'Valentina', 'Reyes Salazar',  'Veterinario',    1),
(4,  '10.444.444-4', 'Sofía',     'Mora Bravo',     'Asistente',      3),
(5,  '10.555.555-5', 'Matías',    'Lagos Tapia',    'Recepcionista',  4),
(6,  '10.666.666-6', 'Isidora',   'Paz Cordero',    'Administrativo', 5),
(7,  '10.777.777-7', 'Joaquín',   'Ortiz Fuentes',  'Veterinario',    2),
(8,  '10.888.888-8', 'Renata',    'Silva Moya',     'Asistente',      4),
(9,  '10.999.999-9', 'Pablo',     'Gómez Rivas',    'Veterinario',    2),
(10, '11.000.000-0', 'Daniela',   'Ruiz Campos',    'Recepcionista',  4);

--6. Asignar empleados a sucursales sin horarios superpuestos; conservar los empates salariales de las sucursales 2 y 3.
INSERT INTO sucursal_empleado (id_sucursal, id_empleado, horario_atencion_inicio, horario_atencion_fin) VALUES
(1, 1, '09:00:00', '14:00:00'),
(1, 2, '09:00:00', '18:00:00'),
(1, 4, '10:00:00', '19:00:00'),
(1, 5, '14:00:00', '18:00:00'),
(2, 1, '14:00:00', '19:00:00'),
(2, 3, '09:00:00', '18:00:00'),
(2, 6, '09:00:00', '18:00:00'),
(3, 7, '09:00:00', '18:00:00'),
(3, 8, '09:00:00', '18:00:00'),
(3, 5, '09:00:00', '13:00:00'),
(4, 9, '09:00:00', '18:00:00'),
(4, 10,'09:00:00', '18:00:00');

--7. Cargar los medicamentos.
INSERT INTO medicamento (id, nombre, fabricante, precio) VALUES
(1, 'Amoxicilina',  'Laboratorio Chile', 8500.00),
(2, 'Meloxicam',    'Drag Pharma',       6200.00),
(3, 'Ivermectina',  'Virbac',            5400.00),
(4, 'Prednisolona', 'Laboratorio Chile', 4800.00),
(5, 'Omeprazol',    'Drag Pharma',       3900.00),
(6, 'Cefalexina',   'Virbac',            9100.00);

--8. Cargar atenciones; IDs 2 a 24: 23 atenciones en 2024, septiembre con una; IDs 1 y 25 a 40: fuera de 2024.
INSERT INTO atencion (id, id_tipo, fecha_atencion, costo_total, id_mascota, id_sucursal) VALUES
(1,  4, '2023-12-15',  25000.00, 1, 1),
(2,  1, '2024-01-10',  30000.00, 1, 1),
(3,  2, '2024-01-22',  20000.00, 3, 1),
(4,  1, '2024-02-05',  30000.00, 2, 1),
(5,  3, '2024-02-18', 150000.00, 5, 2),
(6,  2, '2024-03-07',  20000.00, 4, 3),
(7,  1, '2024-03-20',  30000.00, 6, 3),
(8,  5, '2024-04-11',  80000.00, 3, 1),
(9,  4, '2024-04-25',  25000.00, 1, 1),
(10, 1, '2024-05-09',  30000.00, 7, 3),
(11, 2, '2024-05-21',  20000.00, 8, 2),
(12, 3, '2024-06-14', 180000.00, 9, 3),
(13, 1, '2024-06-28',  30000.00, 4, 3),
(14, 1, '2024-07-03',  30000.00, 5, 2),
(15, 4, '2024-07-19',  25000.00, 5, 2),
(16, 2, '2024-08-08',  20000.00, 2, 1),
(17, 1, '2024-08-30',  30000.00, 1, 1),
(18, 5, '2024-09-12',  90000.00, 8, 2),
(19, 1, '2024-10-02',  30000.00, 6, 3),
(20, 4, '2024-10-23',  25000.00, 9, 3),
(21, 2, '2024-11-06',  20000.00, 3, 1),
(22, 1, '2024-11-27',  30000.00, 2, 1),
(23, 3, '2024-12-10', 160000.00, 1, 1),
(24, 4, '2024-12-19',  25000.00, 5, 2),
(25, 1, '2025-03-12',  30000.00, 3, 1),
(26, 2, '2025-09-20',  20000.00, 4, 3),
(27, 1, '2025-11-12',  35000.00, 1, 1),
(28, 2, '2025-12-05',  22000.00, 2, 1),
(29, 4, '2026-01-15',  28000.00, 5, 2),
(30, 3, '2026-02-20', 200000.00, 4, 3),
(31, 1, '2026-03-10',  35000.00, 8, 2),
(32, 5, '2026-04-18',  95000.00, 6, 3),
(33, 1, '2026-05-07',  35000.00, 3, 1),
(34, 2, '2026-06-14',  22000.00, 9, 3),
(35, 4, '2026-07-09',  28000.00, 1, 1),
(36, 1, '2026-08-21',  35000.00, 7, 3),
(37, 3, '2026-09-15', 210000.00, 5, 2),
(38, 1, '2026-10-08',  35000.00, 2, 1),
(39, 1, '2026-05-20',  35000.00, 7, 4),
(40, 2, '2026-06-02',  22000.00, 7, 4);

--9. Asignar empleados a las atenciones; incluir asistentes para comprobar el filtro por cargo Veterinario de la consulta 2.
INSERT INTO atencion_empleado (id_atencion, id_empleado) VALUES
(1, 1),
(2, 1), (2, 4),
(3, 2), (3, 4),
(4, 2), (4, 4),
(5, 3),
(6, 7),
(7, 7),
(8, 1), (8, 4),
(9, 1), (9, 4),
(10, 7),
(11, 3),
(12, 7),
(13, 7),
(14, 3),
(15, 3),
(16, 2),
(17, 2),
(18, 3),
(19, 7),
(20, 7),
(21, 2),
(22, 1),
(23, 1),
(24, 3),
(25, 2),
(26, 7),
(27, 1),
(28, 2),
(29, 3),
(30, 7),
(31, 3),
(32, 7),
(33, 2),
(34, 7),
(35, 1),
(36, 7),
(37, 3),
(38, 2),
(39, 9),
(40, 9);

--10. Cargar pagos; atenciones 23, 36, 37 y 38 sin pagos, 12 y 30 en cuotas y 32 con pago parcial; al 19-10-2026 el pago tardío de 24 entra en los últimos 12 meses y el de 26 queda fuera.
INSERT INTO pago (id_atencion, fecha_pago, monto) VALUES
(1,  '2023-12-15',  25000.00),
(2,  '2024-01-10',  30000.00),
(3,  '2024-01-22',  20000.00),
(4,  '2024-02-05',  30000.00),
(5,  '2024-02-20', 150000.00),
(6,  '2024-03-07',  20000.00),
(7,  '2024-03-20',  30000.00),
(8,  '2024-04-11',  80000.00),
(9,  '2024-04-25',  25000.00),
(10, '2024-05-09',  30000.00),
(11, '2024-05-21',  20000.00),
(12, '2024-06-14',  90000.00),
(12, '2024-07-01',  90000.00),
(13, '2024-06-28',  30000.00),
(14, '2024-07-03',  30000.00),
(15, '2024-07-19',  25000.00),
(16, '2024-08-08',  20000.00),
(17, '2024-08-30',  30000.00),
(18, '2024-09-12',  90000.00),
(19, '2024-10-02',  30000.00),
(20, '2024-10-23',  25000.00),
(21, '2024-11-06',  20000.00),
(22, '2024-11-27',  30000.00),
(24, '2025-11-20',  25000.00),
(25, '2025-03-12',  30000.00),
(26, '2025-10-05',  20000.00),
(27, '2025-11-12',  35000.00),
(28, '2025-12-05',  22000.00),
(29, '2026-01-15',  28000.00),
(30, '2026-02-20', 100000.00),
(30, '2026-03-20', 100000.00),
(31, '2026-03-10',  35000.00),
(32, '2026-04-18',  50000.00),
(33, '2026-05-07',  35000.00),
(34, '2026-06-14',  22000.00),
(35, '2026-07-09',  28000.00),
(39, '2026-05-20',  35000.00),
(40, '2026-06-02',  22000.00);

--11. Cargar recetas y medicamentos; perro: Meloxicam en 5 recetas, gato: Prednisolona en 3 (Omeprazol: 11 unidades en 2), conejo: empate Ivermectina y Meloxicam.
INSERT INTO receta (id, id_atencion) VALUES
(1, 2), (2, 5), (3, 8), (4, 9), (5, 12), (6, 18), (7, 22),
(8, 26), (9, 31), (10, 19), (11, 32), (12, 29), (13, 33);

INSERT INTO receta_medicamento (id_receta, id_medicamento, cantidad) VALUES
(1, 1, 2), (1, 2, 1),
(2, 2, 2), (2, 6, 1),
(3, 1, 1), (3, 4, 1),
(4, 2, 1),
(5, 6, 2), (5, 2, 1),
(6, 4, 1), (6, 5, 1),
(7, 4, 1),
(8, 5, 10),
(9, 3, 1), (9, 4, 1),
(10, 3, 1),
(11, 2, 1),
(12, 2, 1),
(13, 1, 1);

--12. Sincronizar las secuencias con los identificadores cargados para evitar IDs duplicados en futuras inserciones.
SELECT setval(pg_get_serial_sequence('region', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM region;
SELECT setval(pg_get_serial_sequence('comuna', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM comuna;
SELECT setval(pg_get_serial_sequence('especie', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM especie;
SELECT setval(pg_get_serial_sequence('raza', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM raza;
SELECT setval(pg_get_serial_sequence('cliente', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM cliente;
SELECT setval(pg_get_serial_sequence('mascota', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM mascota;
SELECT setval(pg_get_serial_sequence('sucursal', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM sucursal;
SELECT setval(pg_get_serial_sequence('sueldo', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM sueldo;
SELECT setval(pg_get_serial_sequence('empleado', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM empleado;
SELECT setval(pg_get_serial_sequence('sucursal_empleado', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM sucursal_empleado;
SELECT setval(pg_get_serial_sequence('tipo_atencion', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM tipo_atencion;
SELECT setval(pg_get_serial_sequence('atencion', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM atencion;
SELECT setval(pg_get_serial_sequence('atencion_empleado', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM atencion_empleado;
SELECT setval(pg_get_serial_sequence('pago', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM pago;
SELECT setval(pg_get_serial_sequence('medicamento', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM medicamento;
SELECT setval(pg_get_serial_sequence('receta', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM receta;
SELECT setval(pg_get_serial_sequence('receta_medicamento', 'id'), COALESCE(MAX(id), 1), MAX(id) IS NOT NULL) FROM receta_medicamento;
