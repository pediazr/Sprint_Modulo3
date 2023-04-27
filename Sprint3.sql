-- se crea la bbdd
create database telovendo_sprint3;
-- se crea usuario y sus privilegios
create user 'user_telovendo'@'127.0.0.1:3306' identified by 'contraseña1';
grant all privileges on *.* to 'user_telovendo'@'127.0.0.1:3306';
use telovendo_sprint3;
-- se utiliza transaccion para asegurar que las operaciones de la base de datos se ejecuten correctamente
start transaction;
-- se crean las tablas cliente, producto y proveedor
create table proveedor
(proveedor_id int unsigned auto_increment primary key,
representante varchar(40), empresa varchar(40),
contacto1 varchar(13), contacto2 varchar(13), nombre_contacto varchar(40),
correo varchar(40), categoria_proveedor varchar(40));

create table cliente
(cliente_id int unsigned auto_increment primary key, 
nombre varchar(20), apellido varchar(20), 
direccion varchar (40) unique);

create table producto 
(producto_id int unsigned auto_increment primary key, 
nombre varchar(20), precio int unsigned, categoria varchar(40), 
stock int unsigned, proveedor_id int unsigned, color varchar(20),
foreign key (proveedor_id) references proveedor(proveedor_id));


-- se ingresan registros de proveedores
insert into proveedor (representante, empresa, contacto1, contacto2, nombre_contacto, correo, categoria_proveedor)
VALUES
  ('Kim Hyun-Suk', 'Samsung Electronics',  '+56976489876', '+82-2-2053-3', 'Maria Aravena', 'support@samsung.com', 'Electrónica de telecomunicaciones'),
  ('Tim Cook', 'Apple Inc.', '+56976489876', '+1-408-974-2', 'Benjamin Castro', 'sales@apple.com', 'Electrónica de telecomunicaciones'),
  ('Kenichiro Yoshida', 'Sony Corporation', '+56976489876', '+1-212-833-6', 'Gonzalo Mercado', 'support@sony.com', 'Electrónica de consumo'),
  ('Satya Nadella', 'Microsoft Corporation', '+56976489876', '+1-425-882-8', 'Carlos Marin', 'info@microsoft.com', 'Electrónica de oficina'),
  ('Jeff Bezos', 'Amazon.com, Inc.', '+56976489876', '+1-206-266-1', 'Pedro Diaz', 'support@amazon.com', 'Electrónica de seguridad');
  
-- se ingresan registros de productos
insert into producto (nombre, precio, categoria, stock, proveedor_id, color)
VALUES
  ('MacBook Pro', 2799900, 'Computadoras', 100, 1, 'Plateado'),
  ('iPhone 13', 1299900, 'Teléfonos inteligentes', 50, 2, 'Blanco'),
  ('Samsung Galaxy S21', 1199900, 'Teléfonos inteligentes', 200, 3, 'Gris'),
  ('PlayStation 5', 799900, 'Videojuegos', 75, 4, 'Blanco'),
  ('Samsung Note 10', 1299900, 'Teléfonos inteligentes', 200, 3, 'Blanco'),
  ('Sony Bravia 4K TV', 3999900, 'Televisores', 30, 3, 'Negro'),
  ('Bose QuietComfort', 349990, 'Auriculares', 90, 1, 'Negro'),
  ('Canon EOS R5', 4999900, 'Cámaras', 60, 5, 'Negro'),
  ('Apple Watch Series 7', 599900, 'Relojes inteligentes', 150, 2, 'Plateado'),
  ('DJI Mavic Air 2', 999990, 'Drones', 25, 5, 'Gris');
  
  -- se ingresan registros de clientes
insert into cliente (nombre, apellido, direccion) 
values 
  ('Kerstin', 'Ellingford', '384 Clove Way'),
  ('Florie', 'Romans', '33337 Bonner Plaza'),
  ('Fara', 'Chimienti', '6846 Hanson Park'),
  ('Binny', 'Cyphus', '5514 Beilfuss Lane'),
  ('Vivi', 'Fleisch', '5 South Terrace');

commit;  -- se confirman los cambios en la transaccion

-- categoria de producto que mas se repite
select categoria, count(*) as cantidad
from producto
group by categoria
having count(*) = (
    select max(cantidad)
    from (
        select count(*) as cantidad
        from producto
        group by categoria
    ) as cantidades
);
-- productos con mayor stock
select * 
from producto 
where stock = (select max(stock) from producto);
-- color mas comun de productos
select color, count(*) as cantidad
from producto
group by color
having count(*) = (
    select max(cantidad)
    from (
        select count(*) as cantidad
        from producto
        group by color
    ) as cantidades
);
-- proveedor con menor stock de productos
select proveedor.empresa, sum(producto.stock) as stock_total 
from proveedor
join producto on proveedor.proveedor_id = producto.proveedor_id 
group by proveedor.empresa 
having sum(producto.stock) = (
    select min(stock_total)
    from (
        select sum(producto.stock) as stock_total
        from proveedor
        join producto on proveedor.proveedor_id = producto.proveedor_id 
		group by proveedor.empresa 
    ) as cantidades
);

-- cambiar la categoría de productos más popular por "Electrónica y computación"

set SQL_SAFE_UPDATES=0; -- desactivo modo seguro UPDATE

update producto set categoria = 'Electrónica y computación' 
where categoria = (
select cat from (select categoria as cat from producto  group by cat order by count(*) desc limit 1) as c );

set SQL_SAFE_UPDATES=1; -- activo modo seguro UPDATE

select * from producto;
