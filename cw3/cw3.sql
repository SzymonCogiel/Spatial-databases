-- cw. 4
CREATE VIEW CountBuildings AS
SELECT popp.f_codedesc as buildings 
FROM popp, majrivers
WHERE ST_DWithin(popp.geom, majrivers.geom, 1000.0) and f_codedesc='Building';
-- ST_DWithin: Zwraca prawdę, jeśli geometrie znajdują się w określonej odległości 


SELECT COUNT(*) FROM CountBuildings;


-- cw. 5

SELECT a.name, a.geom, a.elev INTO airportsNew FROM airports as a;

--a)


SELECT an.name, ST_X(an.geom) AS x_cor
FROM airportsNew as an
ORDER BY x_cor DESC LIMIT 1;

SELECT an.name, ST_X(an.geom) AS x_cor
FROM airportsNew as an
ORDER BY x_cor LIMIT 1;



--b) 
INSERT INTO airportsNew VALUES (
    'airportB',
    (SELECT st_centroid (
    ST_MakeLine (
        (SELECT geom FROM airportsNew WHERE name = 'ANNETTE ISLAND'),
        (SELECT geom FROM airportsNew WHERE name = 'ATKA')
    ))),
	8849);
	
SELECT * FROM airportsNew WHERE name = 'airportB' OR name = 'ATKA' OR name = 'ANNETTE ISLAND';
	
-- 6)
Select ST_area(St_buffer(st_ShortestLine(airports.geom, lakes.geom), 1000)) AS area
FROM airports, lakes
WHERE lakes.names='Iliamna Lake' AND airports.name='AMBLER';


-- 7)
Select vegdesc AS description, Sum(ST_Area(trees.geom)) AS total_area
FROM trees, swamp, tundra
WHERE ST_Contains(tundra.geom, trees.geom) OR ST_Contains(swamp.geom, trees.geom)
GROUP BY vegdesc;