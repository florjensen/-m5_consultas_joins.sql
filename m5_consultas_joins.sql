USE Ventas_Tech_DB

select * from dbo.Categorias;
select* from dbo.Clientes;
select* from dbo.Productos;
select * from dbo.Ventas;

/*Consulta 1 — Vista base del proyecto (INNER JOIN) Combiná ventas, clientes, productos y territorios para obtener en una sola fila:
fecha, nombre del cliente, segmento, región, nombre del producto, categoría, cantidad, precio unitario,total de venta y canal. Esta
consulta será la fuente de datos principal en PowerBI.*/

SELECT 
    v.fecha_venta               AS Fecha,
    c.nombre                    AS Nombre_Cliente,
    c.ciudad                    AS Ciudad,   
    p.nombre_producto           AS Nombre_Producto,
    cat.Nombre_categoria        AS Categoria,
    v.cantidad                  AS Cantidad,
    v.precio_unitario           AS Precio_Unitario,
    (v.cantidad * v.precio_unitario) AS Total_Venta
FROM dbo.Ventas v
INNER JOIN dbo.Clientes c 
    ON v.id_cliente = c.id_cliente
INNER JOIN dbo.Productos p 
    ON v.id_producto = p.id_producto
INNER JOIN dbo.Categorias cat 
    ON p.id_categoria = cat.id_categoria;

    /*Consulta 2 — Clientes sin ventas (LEFT JOIN)Identificá clientes registrados que aún no han realizado ninguna compra. Mostrá su
nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.*/

SELECT 
    c.nombre                    AS Nombre,
    c.email                     AS Email,
    c.fecha_registro            AS Fecha_registro
        FROM dbo.Clientes c
LEFT JOIN dbo.Ventas v 
    ON c.id_cliente = v.id_cliente

    WHERE v.id_venta IS NULL;
     -- todos los clientes tienen ventas realizadas-- 

/*Consulta 3 — Productos sin ventas (LEFT JOIN)Identificá productos del catálogo que no tienen ninguna venta registrada. Mostrá
nombre del producto, categoría y precio. Usá WHERE ... IS NULL*/

SELECT 
    p.nombre_producto       AS Nombre_producto,
    cat.nombre_categoria    AS Categoria,
    p.precio                AS Precio
FROM dbo.Productos p 
LEFT JOIN dbo.Categorias cat
ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.Ventas v
ON p.id_producto = v.id_producto
     WHERE v.id_producto IS NULL;
     -- todos los productos tienen al menos una venta realizada--

     /*Consulta 4 — Consolidado por canal(UNION ALL) Usá UNION ALL para combinar en un solo resultado las ventas Online y Presencial,
agregando una columna canal que identifique el origen de cada fila. Al final calculá eltotal por canal con un GROUPBY.*/
 
 SELECT 
    canal,
    SUM(cantidad * precio_unitario) AS total_venta
FROM(
    SELECT 
        'Online' AS canal, 
        cantidad, 
        precio_unitario 
    FROM dbo.Ventas 
    WHERE id_venta <= 5

    UNION ALL

    SELECT 
        'Presencial' AS canal, 
        cantidad, 
        precio_unitario 
    FROM dbo.Ventas 
    WHERE id_venta > 5
) AS Venta_canal 
GROUP BY canal;