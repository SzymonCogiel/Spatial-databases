create extension postgis;
CREATE SCHEMA map;


create table map.buildings(id integer primary key not null, geometry geometry, name varchar(15));
create table map.roads(id integer primary key  not null, geometry geometry, name varchar(15));
create table map.pktinfo(id integer primary key  not null, geometry geometry, name varchar(15));

INSERT INTO map.buildings VALUES
    (1, ST_GeomFromText('polygon( (9 9, 10 9, 10 8, 9 8, 9 9) )'), 'BuildingD'),
    (2, ST_GeomFromText('polygon( (8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4) )'), 'BuildingA'),
    (3, ST_GeomFromText('polygon( (1 2, 2 2, 2 1, 1 1, 1 2) )'), 'BuildingF' ),
    (4, ST_GeomFromText('polygon( (3 8, 5 8, 5 6, 3 6, 3 8) )'), 'BuildingC'),
    (5, ST_GeomFromText('polygon( (4 7, 6 7, 6 5, 4 5, 4 7) )'), 'BuildingB');

INSERT INTO map.pktinfo VALUES
    (1, ST_GeomFromText('point( 6 9.5 )'), 'K'),
    (2, ST_GeomFromText('point( 6.5 6 )'), 'J'),
    (3, ST_GeomFromText('point( 9.5 6 )'), 'I'),
    (4, ST_GeomFromText('point( 5.5 1.5 )'), 'H'),
    (5, ST_GeomFromText('point( 1 3.5 )'), 'G');

INSERT INTO map.roads VALUES
    (1, ST_GeomFromText('LINESTRING(7.5 10.5, 7.5 0)'), 'RoadY'),
    (2, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'), 'RoadX');

-- 1)
SELECT SUM(ST_Length(geometry)) FROM map.roads;

-- 2)
SELECT ST_AsEWKT(geometry) AS geometria, ST_Area(geometry) AS pole_powierzchni, ST_Perimeter(geometry) AS obwod FROM map.buildings WHERE name = 'BuildingA';


-- 3)
SELECT name AS nazwa, ST_Area(geometry) AS pole_powierzchni FROM map.buildings ORDER BY name;

-- 4)
SELECT name, ST_Perimeter(geometry) FROM map.buildings ORDER BY ST_Area(geometry) DESC LIMIT 2;

-- 5)
-- ST_Distance: For geometry types returns the minimum 2D Cartesian (planar) distance between two geometries, in projected units (spatial ref units).
SELECT ST_Distance(b.geometry, p.geometry) FROM map.buildings as b, map.pktinfo as p WHERE b.name = 'BuildingC' AND p.name = 'G';

-- 6)
-- ST_Difference: Returns a geometry representing the part of geometry A that does not intersect geometry B.
SELECT ST_Area(ST_Difference(
    (SELECT geometry FROM map.buildings WHERE name = 'BuildingC'), ST_Buffer(geometry, 0.5))
    )
FROM map.buildings WHERE name = 'BuildingB';

-- 7)
SELECT b.name FROM map.buildings b, map.roads r
WHERE st_y(st_centroid(b.geometry)) > st_y(st_centroid(r.geometry))
AND r.name = 'RoadX';

-- sprawdzenie
SELECT st_astext(st_centroid(r.geometry)) FROM map.roads r WHERE r.name='RoadX';
SELECT st_y(st_centroid(r.geometry)) FROM map.roads r WHERE r.name='RoadX';

-- 8)
-- ST_SymDifference: Returns a geometry representing the portions of geometries A and B that do not intersect.
SELECT ST_Area(ST_SymDifference(ST_GeomFromText('polygon((4 7, 6 7, 6 8, 4 8, 4 7))'), geometry)) as area
FROM map.buildings WHERE name = 'BuildingC';
