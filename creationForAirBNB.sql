--Crear Tablas user, review, place, amenity, PlaceAmenity, State, city

CREATE TABLE User(
    id VARCHAR2(50) PRIMARY KEY,
    update_at TIMESTAMP,
    created_at TIMESTAMP,
    email VARCHAR2(50) UNIQUE NOT NULL,
    password VARCHAR2(50) NOT NULL,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50)
);

CREATE TABLE State(
    id VARCHAR2(50) PRIMARY KEY,
    update_at TIMESTAMP,
    created_at TIMESTAMP,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE City(
    id VARCHAR2(50) PRIMARY KEY,
    update_at TIMESTAMP,
    created_at TIMESTAMP,
    state_id VARCHAR2(50) NOT NULL,
    nombre VARCHAR2(50) NOT NULL
);

CREATE TABLE Place (
    id VARCHAR2(50) PRIMARY KEY,
    update_at TIMESTAMP,
    created_at TIMESTAMP,
    user_id VARCHAR2(50) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    city_id VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(255), 
    num_rooms INTEGER DEFAULT 0,
    num_bathrooms INTEGER DEFAULT 0,
    max_huesped INTEGER DEFAULT 0,
    precio_noche INTEGER DEFAULT 0,
    latitud FLOAT,
    longitud FLOAT
);

CREATE TABLE Review (
    id VARCHAR2(50) PRIMARY KEY, 
    update_at TIMESTAMP,
    created_at TIMESTAMP,
    user_id VARCHAR2(50) NOT NULL,
    place_id VARCHAR2(50) NOT NULL,
    texto VARCHAR2(255) NOT NULL
);

CREATE TABLE Amenity (
    id VARCHAR2(50) PRIMARY KEY,
    update_at TIMESTAMP,
    created_at TIMESTAMP,
    nombre VARCHAR2(50)
);

CREATE TABLE PlaceAmenity (
    amenity_id VARCHAR2(50) NOT NULL,
    place_id VARCHAR2(50) NOT NULL,
    PRIMARY KEY (amenity_id, place_id)
);

-- Agregar restricciones de las llaves foraneas (FK, Foreign keys)
ALTER TABLE City ADD CONSTRAINT fk_city_state FOREIGN KEY (state_id) REFERENCES State(id);
ALTER TABLE Place ADD CONSTRAINT fk_place_user FOREIGN KEY (user_id) REFERENCES User(id);
ALTER TABLE Place ADD CONSTRAINT fk_place_city FOREIGN KEY (city_id) REFERENCES City(id);
ALTER TABLE Review ADD CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES User(id);
ALTER TABLE Review ADD CONSTRAINT fk_review_place FOREIGN KEY (place_id) REFERENCES Place(id);
ALTER TABLE PlaceAmenity ADD CONSTRAINT fk_placeamenity_amenity FOREIGN KEY (amenity_id) REFERENCES Amenity(id);
ALTER TABLE PlaceAmenity ADD CONSTRAINT fk_placeamenity_place FOREIGN KEY (place_id) REFERENCES Place(id);