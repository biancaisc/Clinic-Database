--4
CREATE TABLE ASIGURARE (
    id_asigurare NUMBER PRIMARY KEY,
    nume_companie VARCHAR2(100),
    nr_polita VARCHAR2(20)
);


CREATE TABLE ISTORIC (
    id_istoric NUMBER PRIMARY KEY,
    nume_diagnostic VARCHAR2(100)
);


CREATE TABLE PACIENTI (
    id_pacient NUMBER PRIMARY KEY,
    nume VARCHAR2(100),
    prenume VARCHAR2(100),
    telefon VARCHAR2(20),
    id_asigurare NUMBER,
    data_nastere DATE,
    adresa VARCHAR2(100),
    id_istoric NUMBER,
    FOREIGN KEY (id_asigurare) REFERENCES ASIGURARE (id_asigurare),
    FOREIGN KEY (id_istoric) REFERENCES ISTORIC (id_istoric)
);

CREATE TABLE ANGAJATI (
    id_angajat NUMBER PRIMARY KEY,
    prenume VARCHAR(100),
    nume VARCHAR2(50),
    salariu NUMBER
);


CREATE TABLE MEDIC (
    id_angajat_m NUMBER PRIMARY KEY,
    tip_medic VARCHAR2(50),
    FOREIGN KEY (id_angajat_m) REFERENCES ANGAJATI (id_angajat)
);


CREATE TABLE ASISTENTA (
    id_angajat_a NUMBER PRIMARY KEY,
    domeniu VARCHAR2(50),
    FOREIGN KEY (id_angajat_a) REFERENCES ANGAJATI (id_angajat)
);

CREATE TABLE PERSONAL_SUPORT (
    id_angajat_p NUMBER PRIMARY KEY,
    domeniu VARCHAR2(50),
    FOREIGN KEY (id_angajat_p) REFERENCES ANGAJATI (id_angajat)
);



CREATE TABLE FACTURA (
    id_factura NUMBER PRIMARY KEY,
    modalitate_plata VARCHAR2(30)
);


CREATE TABLE PLATA (
    id_plata NUMBER PRIMARY KEY,
    suma NUMBER,
    data DATE,
    FOREIGN KEY (id_plata) REFERENCES FACTURA (id_factura)
);

CREATE TABLE SERVICII_MEDICALE (
    id_serviciu_medical NUMBER  PRIMARY KEY,
    tip_serviciu VARCHAR2(50),
    id_plata INT,
    FOREIGN KEY (id_plata) REFERENCES PLATA (id_plata)
);

CREATE TABLE TRATAMENT (
    id_tratament NUMBER PRIMARY KEY,
    doza VARCHAR2(22),
    data_inceput DATE,
    data_final DATE
);

CREATE TABLE PRESCRIPTIE (
    id_prescriptie NUMBER PRIMARY KEY,
    data_prescriere DATE,
    data_expirare DATE,
    id_factura NUMBER,
    id_tratament NUMBER,
    FOREIGN KEY (id_factura) REFERENCES FACTURA (id_factura),
    FOREIGN KEY (id_tratament) REFERENCES TRATAMENT (id_tratament)
);


CREATE TABLE PROGRAMARI (
    id_programare NUMBER PRIMARY KEY,
    data DATE,
    ora TIMESTAMP,
    id_prescriptie NUMBER,
    id_pacient NUMBER,
    id_angajat_m NUMBER,
    id_serviciu_medical NUMBER,
    FOREIGN KEY (id_prescriptie) REFERENCES PRESCRIPTIE (id_prescriptie),
    FOREIGN KEY (id_pacient) REFERENCES PACIENTI (id_pacient),
    FOREIGN KEY (id_angajat_m) REFERENCES Medic(id_angajat_m),
    FOREIGN KEY (id_serviciu_medical) REFERENCES SERVICII_MEDICALE (id_serviciu_medical)
);



CREATE TABLE FARMACIE (
    id_farmacie NUMBER PRIMARY KEY,
    locatie VARCHAR2(50),
    id_prescriptie NUMBER,
    FOREIGN KEY (id_prescriptie) REFERENCES PRESCRIPTIE (id_prescriptie)
);


CREATE TABLE MEDICAMENTE (
    id_medicament NUMBER PRIMARY KEY,
    denumire VARCHAR2(50),
    data_expirare DATE,
    stoc NUMBER,
    id_farmacie NUMBER,
    FOREIGN KEY (id_farmacie) REFERENCES FARMACIE(id_farmacie)
);


CREATE TABLE ISTORIC_TRATAMENT (
    id_istoric NUMBER,
    id_tratament NUMBER,
    FOREIGN KEY (id_istoric) REFERENCES ISTORIC (id_istoric),
    FOREIGN KEY (id_tratament) REFERENCES TRATAMENT (id_tratament)
);



--5
CREATE SEQUENCE index_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


INSERT INTO ASIGURARE (id_asigurare, nume_companie, nr_polita)
VALUES (index_seq.nextval, 'BiosClinic', '1234');
INSERT INTO ASIGURARE (id_asigurare, nume_companie, nr_polita)
VALUES (index_seq.nextval, 'Allinz', '6789');
INSERT INTO ASIGURARE (id_asigurare, nume_companie, nr_polita)
VALUES (index_seq.nextval, 'PLife', '5432');
INSERT INTO ASIGURARE (id_asigurare, nume_companie, nr_polita)
VALUES (index_seq.nextval, 'ProtectMed', '0987');
INSERT INTO ASIGURARE (id_asigurare, nume_companie, nr_polita)
VALUES (index_seq.nextval, 'MedCare', '9876');

select * from asigurare;


INSERT INTO ISTORIC (id_istoric, nume_diagnostic)
VALUES (index_seq.nextval, 'Bronsita');
INSERT INTO ISTORIC (id_istoric, nume_diagnostic)
VALUES (index_seq.nextval, 'Diabet zaharat');
INSERT INTO ISTORIC (id_istoric, nume_diagnostic)
VALUES (index_seq.nextval, 'Hipertensiune arteriala');
INSERT INTO ISTORIC (id_istoric, nume_diagnostic)
VALUES (index_seq.nextval, 'Gripa');
INSERT INTO ISTORIC (id_istoric, nume_diagnostic)
VALUES (index_seq.nextval, 'Astm bronsic');

select * from istoric;

INSERT INTO PACIENTI (id_pacient, nume, prenume, telefon, id_asigurare, data_nastere, adresa, id_istoric)
VALUES (index_seq.nextval, 'Ioana', 'Maria', '123456789', 2,TO_DATE('1990-05-10', 'YYYY-MM-DD'), 'strada cornelie', 8);
INSERT INTO PACIENTI (id_pacient, nume, prenume, telefon, id_asigurare, data_nastere, adresa, id_istoric)
VALUES (index_seq.nextval, 'Carina', 'Popov', '987654321', 3, TO_DATE('1985-12-01', 'YYYY-MM-DD'), 'bd-ul dorobanti 4', 9);
INSERT INTO PACIENTI (id_pacient, nume, prenume, telefon, id_asigurare, data_nastere, adresa, id_istoric)
VALUES (index_seq.nextval, 'Ioan', 'Popescu', '567891234', 4,TO_DATE('1978-08-20', 'YYYY-MM-DD'), 'strada aurel vlaicu 16', 10);
INSERT INTO PACIENTI (id_pacient, nume, prenume, telefon, id_asigurare, data_nastere, adresa, id_istoric)
VALUES (index_seq.nextval, 'Patrick', 'Enache', '432198765', 5, TO_DATE('1992-03-18', 'YYYY-MM-DD'), 'soseaua pipera 21', 11);
INSERT INTO PACIENTI (id_pacient, nume, prenume, telefon, id_asigurare, data_nastere, adresa, id_istoric)
VALUES (index_seq.nextval, 'Alina', 'Cuc', '987654321', 6, TO_DATE('1980-07-05', 'YYYY-MM-DD'), 'primaverii 35', 12);

select * from pacienti;

INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Cornel', 'Marius', 2000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Munteanu', 'Ion', 2500);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Elena', 'Pirip', 3000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Carina', 'Ionescu', 3500);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Eric', 'Pop', 4000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Ion', 'Popescu', 2000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Marc', 'Voda', 2500);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Karina', 'Plesu', 3000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Radu', 'Chirita', 3500);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'David', 'Tencu', 4000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Bogdan', 'Felix', 2000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Alex', 'Apetre', 2500);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Marius', 'Ion', 3000);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Cristina', 'Petru', 3500);
INSERT INTO ANGAJATI (id_angajat, prenume, nume, salariu)
VALUES (index_seq.nextval, 'Albert', 'Munteanu', 4000);

select * from angajati;


INSERT INTO MEDIC (id_angajat_m, tip_medic)
VALUES (20, 'Cardiolog');
INSERT INTO MEDIC (id_angajat_m, tip_medic)
VALUES (21, 'Dermatolog');
INSERT INTO MEDIC (id_angajat_m, tip_medic)
VALUES (22, 'Cardiolog');
INSERT INTO MEDIC (id_angajat_m, tip_medic)
VALUES (23, 'Dermatolog');
INSERT INTO MEDIC (id_angajat_m, tip_medic)
VALUES (24, 'Ginecolog');

select * from medic;

INSERT INTO ASISTENTA (id_angajat_a, domeniu)
VALUES (25, 'Asistenta pediatrie');
INSERT INTO ASISTENTA (id_angajat_a, domeniu)
VALUES (26, 'Asistenta pediatrie');
INSERT INTO ASISTENTA (id_angajat_a, domeniu)
VALUES (27, 'Asistenta pediatrie');
INSERT INTO ASISTENTA (id_angajat_a, domeniu)
VALUES (28, 'Asistenta cardiolog');
INSERT INTO ASISTENTA (id_angajat_a, domeniu)
VALUES (29, 'Asistenta dermatologie');




INSERT INTO PERSONAL_SUPORT (id_angajat_p, domeniu)
VALUES (30, 'IT');
INSERT INTO PERSONAL_SUPORT (id_angajat_p, domeniu)
VALUES (31, 'Relatii cu clientii');
INSERT INTO PERSONAL_SUPORT (id_angajat_p, domeniu)
VALUES (32, 'IT');
INSERT INTO PERSONAL_SUPORT (id_angajat_p, domeniu)
VALUES (33, 'relatii cu clientii');
INSERT INTO PERSONAL_SUPORT (id_angajat_p, domeniu)
VALUES (34, 'IT');

INSERT INTO FACTURA (id_factura, modalitate_plata)
VALUES (index_seq.nextval, 'Cec');
INSERT INTO FACTURA (id_factura, modalitate_plata)
VALUES (index_seq.nextval, 'Card');
INSERT INTO FACTURA (id_factura, modalitate_plata)
VALUES (index_seq.nextval, 'Cash');
INSERT INTO FACTURA (id_factura, modalitate_plata)
VALUES (index_seq.nextval, 'Cash');
INSERT INTO FACTURA (id_factura, modalitate_plata)
VALUES (index_seq.nextval, 'Card');

select * from factura;

INSERT INTO PLATA (id_plata, suma, data)
VALUES (36, 100, TO_DATE('2023-05-01', 'YYYY-MM-DD'));
INSERT INTO PLATA (id_plata, suma, data)
VALUES (37, 200, TO_DATE('2023-05-02', 'YYYY-MM-DD'));
INSERT INTO PLATA (id_plata, suma, data)
VALUES (38, 150, TO_DATE('2023-05-03', 'YYYY-MM-DD'));
INSERT INTO PLATA (id_plata, suma, data)
VALUES (39, 200,TO_DATE('2023-05-02', 'YYYY-MM-DD') );
INSERT INTO PLATA (id_plata, suma, data)
VALUES (40, 150, TO_DATE('2023-05-03', 'YYYY-MM-DD'));

select * from plata;

INSERT INTO SERVICII_MEDICALE (id_serviciu_medical, tip_serviciu, id_plata)
VALUES (index_seq.nextval, 'Consult cardiolog', 36);
INSERT INTO SERVICII_MEDICALE (id_serviciu_medical, tip_serviciu, id_plata)
VALUES (index_seq.nextval, 'Consult dermatologie', 37);
INSERT INTO SERVICII_MEDICALE (id_serviciu_medical, tip_serviciu, id_plata)
VALUES (index_seq.nextval, 'Consult ortoped', 38);
INSERT INTO SERVICII_MEDICALE (id_serviciu_medical, tip_serviciu, id_plata)
VALUES (index_seq.nextval, 'Control rutina', 39);
INSERT INTO SERVICII_MEDICALE (id_serviciu_medical, tip_serviciu, id_plata)
VALUES (index_seq.nextval, 'Radiografie', 40);

select * from servicii_medicale;


INSERT INTO TRATAMENT (id_tratament, doza, data_inceput, data_final)
VALUES (index_seq.nextval, '1 doza', TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2023-06-10', 'YYYY-MM-DD'));
INSERT INTO TRATAMENT (id_tratament, doza, data_inceput, data_final)
VALUES (index_seq.nextval, '4 doze', TO_DATE('2023-06-02', 'YYYY-MM-DD'), TO_DATE('2023-06-12', 'YYYY-MM-DD'));
INSERT INTO TRATAMENT (id_tratament, doza, data_inceput, data_final)
VALUES (index_seq.nextval, '3 doze', TO_DATE('2023-06-03', 'YYYY-MM-DD'), TO_DATE('2023-06-14', 'YYYY-MM-DD'));
INSERT INTO TRATAMENT (id_tratament, doza, data_inceput, data_final)
VALUES (index_seq.nextval, '2 doze', TO_DATE('2023-06-04', 'YYYY-MM-DD'), TO_DATE('2023-06-16', 'YYYY-MM-DD'));
INSERT INTO TRATAMENT (id_tratament, doza, data_inceput, data_final)
VALUES (index_seq.nextval, '10 doze', TO_DATE('2023-06-05', 'YYYY-MM-DD'), TO_DATE('2023-06-18', 'YYYY-MM-DD'));

select * from tratament;


INSERT INTO PRESCRIPTIE (id_prescriptie, data_prescriere, data_expirare, id_factura, id_tratament)
VALUES (index_seq.nextval, TO_DATE('2023-05-26', 'YYYY-MM-DD'), TO_DATE('2023-06-26', 'YYYY-MM-DD'), 36, 48);
INSERT INTO PRESCRIPTIE (id_prescriptie, data_prescriere, data_expirare, id_factura, id_tratament)
VALUES (index_seq.nextval, TO_DATE('2023-05-27', 'YYYY-MM-DD'), TO_DATE('2023-06-27', 'YYYY-MM-DD'), 37, 49);
INSERT INTO PRESCRIPTIE (id_prescriptie, data_prescriere, data_expirare, id_factura, id_tratament)
VALUES (index_seq.nextval, TO_DATE('2023-05-28', 'YYYY-MM-DD'), TO_DATE('2023-06-28', 'YYYY-MM-DD'), 38, 50);
INSERT INTO PRESCRIPTIE (id_prescriptie, data_prescriere, data_expirare, id_factura, id_tratament)
VALUES (index_seq.nextval, TO_DATE('2023-05-29', 'YYYY-MM-DD'), TO_DATE('2023-06-29', 'YYYY-MM-DD'), 39, 51);
INSERT INTO PRESCRIPTIE (id_prescriptie, data_prescriere, data_expirare, id_factura, id_tratament)
VALUES (index_seq.nextval, TO_DATE('2023-05-30', 'YYYY-MM-DD'), TO_DATE('2023-06-30', 'YYYY-MM-DD'), 40, 52);

select * from prescriptie;


INSERT INTO PROGRAMARI (id_programare, data, ora, id_prescriptie, id_pacient, id_angajat_m, id_serviciu_medical)
VALUES (index_seq.nextval, TO_DATE('2023-06-03', 'YYYY-MM-DD'), TIMESTAMP '2023-06-03 12:30:00', 54, 14, 20, 42);
INSERT INTO PROGRAMARI (id_programare, data, ora, id_prescriptie, id_pacient, id_angajat_m, id_serviciu_medical)
VALUES (index_seq.nextval, TO_DATE('2023-06-04', 'YYYY-MM-DD'), TIMESTAMP '2023-06-04 14:00:00', 55, 15, 21, 43);
INSERT INTO PROGRAMARI (id_programare, data, ora, id_prescriptie, id_pacient, id_angajat_m, id_serviciu_medical)
VALUES (index_seq.nextval, TO_DATE('2023-06-20', 'YYYY-MM-DD'), TIMESTAMP '2023-06-20 16:30:00', 56, 16, 22, 44);
INSERT INTO PROGRAMARI (id_programare, data, ora, id_prescriptie, id_pacient, id_angajat_m, id_serviciu_medical)
VALUES (index_seq.nextval, TO_DATE('2023-06-06', 'YYYY-MM-DD'), TIMESTAMP '2023-06-06 09:00:00', 57, 17, 23, 45);
INSERT INTO PROGRAMARI (id_programare, data, ora, id_prescriptie, id_pacient, id_angajat_m, id_serviciu_medical)
VALUES (index_seq.nextval, TO_DATE('2023-06-07', 'YYYY-MM-DD'), TIMESTAMP '2023-06-07 13:30:00', 58, 18, 20, 46);

select * from programari;


INSERT INTO FARMACIE (id_farmacie, locatie, id_prescriptie)
VALUES (index_seq.nextval, 'Calea floreasca 37', 54);
INSERT INTO FARMACIE (id_farmacie, locatie, id_prescriptie)
VALUES (index_seq.nextval, 'Bd-ul aviatorilor 2', 55);
INSERT INTO FARMACIE (id_farmacie, locatie, id_prescriptie)
VALUES (index_seq.nextval, 'Strada Roma 29', 56);
INSERT INTO FARMACIE (id_farmacie, locatie, id_prescriptie)
VALUES (index_seq.nextval, 'Bd-ul Iuliu Maniu 4', 57);
INSERT INTO FARMACIE (id_farmacie, locatie, id_prescriptie)
VALUES (index_seq.nextval, 'Strada Elena Costea 8', 58);

select * from farmacie;


INSERT INTO MEDICAMENTE (id_medicament, denumire, data_expirare, stoc,id_farmacie)
VALUES (index_seq.nextval, 'Calmotusin', TO_DATE('2025-12-31', 'YYYY-MM-DD'), 100,66);
INSERT INTO MEDICAMENTE (id_medicament, denumire, data_expirare, stoc)
VALUES (index_seq.nextval, 'Eferalgan', TO_DATE('2025-05-15', 'YYYY-MM-DD'), 50,66);
INSERT INTO MEDICAMENTE (id_medicament, denumire, data_expirare, stoc)
VALUES (index_seq.nextval, 'Paracetamol', TO_DATE('2027-08-10', 'YYYY-MM-DD'), 75,66);
INSERT INTO MEDICAMENTE (id_medicament, denumire, data_expirare, stoc)
VALUES (index_seq.nextval, 'Nurofen', TO_DATE('2023-10-20', 'YYYY-MM-DD'), 80,66);
INSERT INTO MEDICAMENTE (id_medicament, denumire, data_expirare, stoc)
VALUES (index_seq.nextval, 'Vitamina C', TO_DATE('2026-11-30', 'YYYY-MM-DD'), 60,66);

select * from medicamente;

INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (8, 48);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (9, 49);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (8, 50);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (9, 51);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (10, 52);

INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (11, 48);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (12, 48);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (12, 51);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (10, 52);
INSERT INTO ISTORIC_TRATAMENT (id_istoric, id_tratament)
VALUES (8, 49); 

select * from istoric_tratament;

commit;





