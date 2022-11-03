/*
    P1 Creando las tablas
    !_<3_dbs
    DROP TABLE s2_person CASCADE;
    DROP TABLE s2_hero CASCADE;
    DROP TABLE s2_related CASCADE;
    DROP TABLE s2_work CASCADE;
    DROP TABLE s2_ CASCADE;
*/

CREATE TABLE s2_person(
    id              INTEGER, 
    name_p          VARCHAR(255),
    PRIMARY KEY(id, name_p),
    UNIQUE(id, name_p)
);

CREATE TABLE s2_hero( 
    id              INTEGER,
    name_p          VARCHAR(255),
    name_h          VARCHAR(255),
    intelligence    INTEGER,
    strength        INTEGER,
    speed           INTEGER,
    PRIMARY KEY (id, name_p, name_h),
    FOREIGN KEY (id, name_p) REFERENCES s2_person(id, name_p),
    UNIQUE(id, name_p, name_h)
);

CREATE TABLE s2_related(
    id              INTEGER,
    name_p         VARCHAR(255),
    name_ph         VARCHAR(255),
    name_h          VARCHAR(255),
    relation        VARCHAR(255),
    PRIMARY KEY (id, name_p, name_ph),
    FOREIGN KEY (id, name_p) REFERENCES s2_person(id, name_p),
    FOREIGN KEY (id, name_ph, name_h) REFERENCES s2_hero(id, name_p, name_h),
    UNIQUE(id, name_p, name_ph, relation)
);

CREATE TABLE s2_work(
    id              INTEGER,
    name_p          VARCHAR(255), -- name of the person related°°°
    name_h          VARCHAR(255), -- name of the hero
    name_w          VARCHAR(255),
    PRIMARY KEY (id, name_p, name_h, name_w),
    FOREIGN KEY (id, name_p, name_h) REFERENCES s2_hero(id, name_p, name_h),
    UNIQUE(id, name_p, name_h, name_w)
);

CREATE TABLE s2_alter(
    id              INTEGER,
    name_p          VARCHAR(255),
    name_h          VARCHAR(255),
    name_a          VARCHAR(255),
    PRIMARY KEY (id, name_p, name_h),
    FOREIGN KEY (id, name_p, name_h) REFERENCES s2_hero(id, name_p, name_h),
    UNIQUE(id, name_p, name_h)
);

/*
    RESPONDIENDO PREGUNTAS
*/