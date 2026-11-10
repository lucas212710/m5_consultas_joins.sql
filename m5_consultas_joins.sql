
-- CONSULTA 1: Vista general de ventas
-- Relaciona ventas, clientes, productos y categorías.

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Se obtuvieron 10 ventas que permiten
-- analizar los ingresos por cliente, producto,
-- categoría y ciudad.


-- CONSULTA 2: Clientes sin ventas

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: No se encontraron clientes sin compras.
-- Los 5 clientes registrados realizaron al menos una venta.
-- Desde CRM, esto indica que todos los clientes tuvieron
-- actividad comercial.


-- CONSULTA 3: Productos sin ventas

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: No se encontraron productos sin ventas.
-- Los 6 productos del catálogo registran movimiento comercial.
-- El área de Producto puede analizar cuáles generan
-- mayores ingresos y cuáles necesitan mayor impulso.


-- CONSULTA 4: Consolidado por períodos (UNION ALL)

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primera semana' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-05' AND '2024-03-09'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segunda semana' AS canal
    FROM ventas
    WHERE fecha_venta BETWEEN '2024-03-10' AND '2024-03-15'
) AS consolidado
GROUP BY canal;

-- Hallazgo:
-- Primera semana: $3.230.
-- Segunda semana: $3.214.
-- La primera semana registró una facturación
-- ligeramente superior.

