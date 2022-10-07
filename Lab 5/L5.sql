/*
    P1 Creando las tablas
*/

CREATE TABLE s2_person(
    id              INTEGER PRIMARY KEY, 
    name            VARCHAR(255),
    UNIQUE(id)
);

CREATE TABLE s2_hero(
    id              INTEGER,
    name            VARCHAR(255),
    intelligence    INTEGER,
    strength        INTEGER,
    speed           INTEGER,
    PRIMARY KEY (id, name),
    FOREIGN KEY (id) REFERENCES s2_person(id),
    UNIQUE(id),
    UNIQUE(name)
);

CREATE TABLE s2_related(
    id              INTEGER,
    name_p          VARCHAR(255),
    name_h          VARCHAR(255),
    PRIMARY KEY (id, name_h),
    FOREIGN KEY (id) REFERENCES s2_person(id),
    FOREIGN KEY (name_h) REFERENCES s2_hero(name)
);

CREATE TABLE s2_work(
    id              INTEGER,
    name_h          VARCHAR(255),
    name            VARCHAR(255),
    PRIMARY KEY (id, name_h),
    FOREIGN KEY (id) REFERENCES s2_person(id),
    FOREIGN KEY (name_h) REFERENCES s2_hero(name),
    UNIQUE(id)
);

CREATE TABLE s2_alter(
    id              INTEGER,
    name_h          VARCHAR(255),
    name            VARCHAR(255),
    PRIMARY KEY (id, name_h),
    FOREIGN KEY (id) REFERENCES s2_person(id),
    FOREIGN KEY (name_h) REFERENCES s2_hero(name),
    UNIQUE(id)
);