-- exe 0
CREATE TABLE obiekty (name VARCHAR(64), geom geometry)

INSERT INTO obiekty VALUES ('obiekt1', 'COMPOUNDCURVE( (0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1),CIRCULARSTRING(3 1, 4 2, 5 1), (5 1, 6 1))');
INSERT INTO obiekty VALUES ('obiekt2', 'CURVEPOLYGON(
                                        COMPOUNDCURVE( (10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2, 12 0, 10 2), (10 2, 10 6)),
                                        COMPOUNDCURVE(CIRCULARSTRING(11 2,12 3, 13 2), CIRCULARSTRING(13 2, 12 1, 11 2)) )');
INSERT INTO obiekty VALUES ('obiekt3', 'CURVEPOLYGON(COMPOUNDCURVE((10 17, 12 13), (12 13, 7 15),(7 15, 10 17) ))');
INSERT INTO obiekty VALUES ('obiekt4', 'COMPOUNDCURVE( (20 20, 25 25), (25 25, 27 24),(27 24, 25 22),(25 22, 26 21), (26 21, 22 19),(22 19, 20.5 19.5))');
INSERT INTO obiekty VALUES ('obiekt5', 'MULTIPOINT(30 30 59, 38 32 234)');
INSERT INTO obiekty VALUES ('obiekt6', 'GEOMETRYCOLLECTION ( POINT(2 3), LINESTRING(1 1, 3 2))');


-- exe 1

SELECT DISTINCT ST_area(St_buffer(ST_ShortestLine((SELECT geom FROM obiekty WHERE name='obiekt3'), (SELECT geom FROM obiekty WHERE name='obiekt4')), 5)) FROM obiekty;

-- exe 2

UPDATE obiekty
SET geom  = 'COMPOUNDCURVE( (20 20, 25 25), (25 25, 27 24),(27 24, 25 22),(25 22, 26 21), (26 21, 22 19),(22 19, 20.5 19.5), (20.5 19.5, 20 20))'
WHERE name = 'obiekt4';

SELECT ST_Area(ST_BuildArea(geom)) FROM obiekty WHERE name='obiekt4';
-- or
SELECT ST_Area(ST_Polygonize(geom)) FROM obiekty WHERE name='obiekt4';

-- exe 3

INSERT INTO obiekty VALUES ('obiekt7', ST_Union((SELECT geom FROM obiekty WHERE name='obiekt4'), (SELECT geom FROM obiekty WHERE name='obiekt3')))

-- exe 4

SELECT ST_Area(ST_Buffer(ST_Union(ARRAY(SELECT geom FROM obiekty WHERE NOT ST_AsText(geom) LIKE '%CIRCULARSTRING%')),5 ));