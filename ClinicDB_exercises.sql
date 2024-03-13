--6
--Sa se afiseze dintre angajati, cei care sunt medici, iar apoi doar cei care au programari.Sa se afiseze si serviciile medicale optate.
--(3 tipuri diferite de colectii)
create or replace procedure p
is
  type t_angajati_medici is table of varchar2(30) index by PLS_INTEGER;
  ang_med t_angajati_medici;
  
  type t_med_cu_prog is table of varchar2(30);
  med_cu_prog t_med_cu_prog := t_med_cu_prog();

  type t_serviciu is varray(200) of varchar2(100);
  servicii t_serviciu := t_serviciu();
  
  contor number :=1;
  v_nume varchar2(10);
  v_prenume varchar2(10);
  v_denumire varchar(50);
begin  
  --initializare tabel indexat cu toti medicii
  for med in (select id_angajat_m from medic) loop
     select nume, prenume
       into v_nume, v_prenume
       from angajati a, medic m
       where m.id_angajat_m = med.id_angajat_m
       and a.id_angajat = m.id_angajat_m;
     
     ang_med(contor) := v_nume || ' ' || v_prenume;
     contor := contor + 1;
  end loop;
  
 
  --initializare tabel imbricat doar cu medicii care au programari
  for v_id in (select distinct id_angajat_m from programari)loop
        select nume, prenume
       into v_nume, v_prenume
       from angajati a, medic m
       where m.id_angajat_m = v_id.id_angajat_m
       and a.id_angajat = m.id_angajat_m;
       
        med_cu_prog.extend();
        med_cu_prog(med_cu_prog.count):= v_nume || ' ' || v_prenume;
  end loop;
  
   DBMS_OUTPUT.PUT_LINE('Medicii clinicii:');
   DBMS_OUTPUT.NEW_LINE;

   for i in ang_med.first .. ang_med.last loop
      DBMS_OUTPUT.PUT_LINE(ang_med(i)|| ' ');

  end loop;
     DBMS_OUTPUT.NEW_LINE;
     DBMS_OUTPUT.PUT_LINE('Medicii cu programari:');
     DBMS_OUTPUT.NEW_LINE;

   for i in med_cu_prog.first .. med_cu_prog.last loop
      DBMS_OUTPUT.PUT_LINE(med_cu_prog(i)|| ' ');
  end loop;
  
  --initializare vector cu serviciile medicale optate
    for v_id in (select distinct id_serviciu_medical from programari)loop
    
          select tip_serviciu
          into v_denumire
          from programari p, servicii_medicale sm
          where p.id_serviciu_medical = v_id.id_serviciu_medical
          and p.id_serviciu_medical = sm.id_serviciu_medical
          and rownum = 1;

          
         servicii.extend();
         servicii(servicii.count) := v_denumire;
       
    end loop;
     DBMS_OUTPUT.NEW_LINE;
     DBMS_OUTPUT.PUT_LINE('Serviciile medicale optate:');
     DBMS_OUTPUT.NEW_LINE;

     for i in servicii.first .. servicii.last loop
      DBMS_OUTPUT.PUT_LINE(servicii(i)|| ' ');
  end loop;
  
end;
/
execute p;

--7
--Sa se selecteze pacientii care sunt nascuti in aceeasi zi cu programarea lor.
--(S-au folosit 2 cursoare diferite)
CREATE OR REPLACE procedure proc
 IS
 
    cursor c is select * 
                from pacienti;
    cursor e (pac_id pacienti.id_pacient%type)  
        is select * 
            from programari 
            where id_pacient = pac_id;      
    v_prog programari%rowtype;
    contor number:= 0;
begin 
    for v_pac in c loop
    
          open e(v_pac.id_pacient); 
      
            fetch e into v_prog; 
            exit when e%notfound; 
            if (extract(day from v_pac.data_nastere) = extract(day from v_prog.data)) then
                        contor := 1;
                        DBMS_OUTPUT.PUT_LINE('Pacientul ' || v_pac.nume ||' ' ||v_pac.prenume || ' este nascut in aceeasi zi cu programarea sa si anume: ' || v_pac.data_nastere );    
            end if;
        close e; 
    end loop; 
    if (contor = 0)then
        DBMS_OUTPUT.PUT_LINE('Nu exista pacienti nascuti in aceeasi zi cu programarea lor'  );  
    end if;
end proc; 
/

begin
    proc;
end;
/

--8
--Stiind ca serviciile medicale se incadreaza intre 100 si 200 ron, sa se defineasca un subprogram care specifica daca o programare 
--se incadreaza in pretul mediu de 150 ron.
create or replace function f(v_id programari.id_programare%type)
return number is
    v_suma number;
    exceptie1 exception;
    exceptie2 exception;
begin 
 select suma
 into v_suma
 from programari pr, servicii_medicale sm, plata p
 where pr.id_programare = v_id
 and pr.id_serviciu_medical = sm.id_serviciu_medical
 and sm.id_plata = p.id_plata;
 
 if(v_suma < 150) 
 then raise exceptie1;
 end if;
 
 if(v_suma>150)
 then raise exceptie2;
 end if;
 
 return v_suma;
 
 exception 
 when exceptie1 then
 raise_application_error (-20003, 'Serviciul medical se afla sub media de pret');
 
 when exceptie2 then
 raise_application_error(-20003, 'Serviciul medical este peste media de pret');
 
 when NO_DATA_FOUND then 
 raise_application_error(-20003, 'Nu exista programare cu acest id');
  
end f;
/
declare 
v_sum number;
begin
begin
        v_sum := f(62);
        DBMS_OUTPUT.PUT_LINE(' Suma serviciului medical este: '|| v_sum );
    exception
        when others then
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    end;
end;
/

--9
--Fiind dat id-ul unui pacient, sa se afiseze modalitatea sa de plata(cash/card/cec).
create or replace procedure procedura(v_id pacienti.id_pacient%TYPE)
 is
 v_plata varchar(10);
 exceptie EXCEPTION;
begin
 select modalitate_plata
 into v_plata
 from pacienti pac, programari pr, servicii_medicale sm, plata p, factura f
 where pac.id_pacient = v_id
 and pac.id_pacient = pr.id_pacient
 and pr.id_serviciu_medical = sm.id_serviciu_medical
 and sm.id_plata = p.id_plata
 and p.id_plata = f.id_factura;
 DBMS_OUTPUT.PUT_LINE('Modalitatea de plata este '|| lower(v_plata));
 
 if (lower(v_plata) != 'cec' and lower(v_plata) != 'cash' and lower(v_plata) != 'card') then
 raise exceptie;
 end if;
 
 exception
 when exceptie then
        raise_application_error(-20001,'Modalitate de plata invalida');
 when NO_DATA_FOUND then
         raise_application_error(-20002,'Nu exista pacient cu id-ul dat');
 when TOO_MANY_ROWS then
        raise_application_error(-20003,'Exista mai multe programari pentru pacientul cu id-ul dat');
 when others then
        raise_application_error(-20004,'Alta eroare!');
 
 
 end procedura;
/ 
begin
procedura(15);
end;
/

--10
--Trigger LMD la nivel de comanda.
--Trigger care se declanseaza la operatiile de INSERT, DELETE, UPDATE pe tabela Angajati,
--iar in tabela info_lmd se introduce tipul operatiei si data curenta.

create table info_lmd
(tip char(1),
data date default SYSDATE);

create or replace trigger ang_trigger 
before insert or update or delete on angajati
declare
v_tip info_lmd.tip%type;
begin
    if INSERTING then v_tip :='I';
    elsif UPDATING then v_tip:='U';
    elsif DELETING then v_tip :='D';
end if;

insert into info_lmd(tip, data) 
values (v_tip,sysdate);

end;
/
insert into angajati values (400, 'Pop', 'Alin', 6000);
delete from angajati where salariu=6000;
drop table info_lmd;
drop trigger ang_trigger;

--11
--Trigger LMD la nivel de linie.
--S-a definit un trigger care sa nu permita adaugarea un nou angajat cu un salariu mai mare decat maximul existent deja in tabela.
create or replace trigger salariu_trigger
before insert on angajati
for each row
declare
    v_max number;
begin
    select max(salariu) 
    into v_max from angajati;

    if :NEW.salariu > v_max then
        RAISE_APPLICATION_ERROR(-20001, ‘Salariul nu poate fi mai mare decât cel mai mare salariu existent.’);
    end if;
end;
/
insert into ANGAJATI (id_angajat, prenume, nume, salariu) 
values (99, ‘Naomi’, ‘Popa’, 5000);

--12
--Trigger LDD 

--tabel care retine orice modificare de tip LDD facuta in baza de date a clinicii
create table info_clinica
(eveniment varchar2(20),
tip_obiect varchar2(30),
nume_obiect varchar2(30),
data timestamp(3));

create or replace trigger info_trigger
 after create or drop or alter on schema
begin
  --Verificare daca modificarile sunt facute
  --in intervalul de lucru al clinicii
 if(to_char(SYSDATE,'HH24') not between 7 and 17)
then
   RAISE_APPLICATION_ERROR(-20001,'Nu se pot face modificari in afara programului.');
else
 insert into info_clinica
 values ( SYS.SYSEVENT, SYS.DICTIONARY_OBJ_TYPE,
 SYS.DICTIONARY_OBJ_NAME, SYSTIMESTAMP(3));
 
end if; 
end;
/
create index ind on medicamente(denumire);
drop index ind;

--13
--Pachet care contine toate obiectele definite în cadrul proiectului.
CREATE OR REPLACE PACKAGE pachet AS 
 PROCEDURE p; 
 PROCEDURE proc;
 FUNCTION f(v_id programari.id_programare%type)
 RETURN NUMBER; 
 PROCEDURE procedura(v_id pacienti.id_pacient%TYPE);
END pachet; 
/ 

CREATE OR REPLACE PACKAGE BODY pachet AS 
  procedure p
is
  type t_angajati_medici is table of varchar2(30) index by PLS_INTEGER;
  ang_med t_angajati_medici;
  
  type t_med_cu_prog is table of varchar2(30);
  med_cu_prog t_med_cu_prog := t_med_cu_prog();

  type t_serviciu is varray(200) of varchar2(100);
  servicii t_serviciu := t_serviciu();
  
  contor number :=1;
  v_nume varchar2(10);
  v_prenume varchar2(10);
  v_denumire varchar(50);
begin  
  --initializare tabel indexat cu toti medicii
  for med in (select id_angajat_m from medic) loop
     select nume, prenume
       into v_nume, v_prenume
       from angajati a, medic m
       where m.id_angajat_m = med.id_angajat_m
       and a.id_angajat = m.id_angajat_m;
     
     ang_med(contor) := v_nume || ' ' || v_prenume;
     contor := contor + 1;
  end loop;
  
 
  --initializare tabel imbricat doar cu medicii care au programari
  for v_id in (select distinct id_angajat_m from programari)loop
        select nume, prenume
       into v_nume, v_prenume
       from angajati a, medic m
       where m.id_angajat_m = v_id.id_angajat_m
       and a.id_angajat = m.id_angajat_m;
       
        med_cu_prog.extend();
        med_cu_prog(med_cu_prog.count):= v_nume || ' ' || v_prenume;
  end loop;
  
   DBMS_OUTPUT.PUT_LINE('Medicii clinicii:');
   DBMS_OUTPUT.NEW_LINE;

   for i in ang_med.first .. ang_med.last loop
      DBMS_OUTPUT.PUT_LINE(ang_med(i)|| ' ');

  end loop;
     DBMS_OUTPUT.NEW_LINE;
     DBMS_OUTPUT.PUT_LINE('Medicii cu programari:');
     DBMS_OUTPUT.NEW_LINE;

   for i in med_cu_prog.first .. med_cu_prog.last loop
      DBMS_OUTPUT.PUT_LINE(med_cu_prog(i)|| ' ');
  end loop;
  
  --initializare vector cu serviciile medicale optate
    for v_id in (select distinct id_serviciu_medical from programari)loop
    
          select tip_serviciu
          into v_denumire
          from programari p, servicii_medicale sm
          where p.id_serviciu_medical = v_id.id_serviciu_medical
          and p.id_serviciu_medical = sm.id_serviciu_medical
          and rownum = 1;

          
         servicii.extend();
         servicii(servicii.count) := v_denumire;
       
    end loop;
     DBMS_OUTPUT.NEW_LINE;
     DBMS_OUTPUT.PUT_LINE('Serviciile medicale optate:');
     DBMS_OUTPUT.NEW_LINE;

     for i in servicii.first .. servicii.last loop
      DBMS_OUTPUT.PUT_LINE(servicii(i)|| ' ');
  end loop;
  
end p;
 

 
 procedure proc
 IS
 
    cursor c is select * 
                from pacienti;
    cursor e (pac_id pacienti.id_pacient%type)  
        is select * 
            from programari 
            where id_pacient = pac_id;      
    v_prog programari%rowtype;
    contor number:= 0;
begin 
    for v_pac in c loop
    
          open e(v_pac.id_pacient); 
      
            fetch e into v_prog; 
            exit when e%notfound; 
            if (extract(day from v_pac.data_nastere) = extract(day from v_prog.data)) then
                        contor := 1;
                        DBMS_OUTPUT.PUT_LINE('Pacientul ' || v_pac.nume ||' ' ||v_pac.prenume || ' este nascut in aceeasi zi cu programarea sa si anume: ' || v_pac.data_nastere );    
            end if;
        close e; 
    end loop; 
    if (contor = 0)then
        DBMS_OUTPUT.PUT_LINE('Nu exista pacienti nascuti in aceeasi zi cu programarea lor'  );  
    end if;
end proc; 

function f(v_id programari.id_programare%type)
return number is
    v_suma number;
    exceptie1 exception;
    exceptie2 exception;
begin 
 select suma
 into v_suma
 from programari pr, servicii_medicale sm, plata p
 where pr.id_programare = v_id
 and pr.id_serviciu_medical = sm.id_serviciu_medical
 and sm.id_plata = p.id_plata;
 
 if(v_suma < 150) 
 then raise exceptie1;
 end if;
 
 if(v_suma>150)
 then raise exceptie2;
 end if;
 
 return v_suma;
 
 exception 
 when exceptie1 then
 raise_application_error (-20003, 'Serviciul medical se afla sub media de pret');
 
 when exceptie2 then
 raise_application_error(-20003, 'Serviciul medical este peste media de pret');
 
 when NO_DATA_FOUND then 
 raise_application_error(-20003, 'Nu exista programare cu acest id');
  
end f;

procedure procedura(v_id pacienti.id_pacient%TYPE)
 is
 v_plata varchar(10);
 exceptie EXCEPTION;
begin
 select modalitate_plata
 into v_plata
 from pacienti pac, programari pr, servicii_medicale sm, plata p, factura f
 where pac.id_pacient = v_id
 and pac.id_pacient = pr.id_pacient
 and pr.id_serviciu_medical = sm.id_serviciu_medical
 and sm.id_plata = p.id_plata
 and p.id_plata = f.id_factura;
 DBMS_OUTPUT.PUT_LINE('Modalitatea de plata este '|| lower(v_plata));
 
 if (lower(v_plata) != 'cec' and lower(v_plata) != 'cash' and lower(v_plata) != 'card') then
 raise exceptie;
 end if;
 
 exception
 when exceptie then
        raise_application_error(-20001,'Modalitate de plata invalida');
 when NO_DATA_FOUND then
         raise_application_error(-20002,'Nu exista pacient cu id-ul dat');
 when TOO_MANY_ROWS then
        raise_application_error(-20003,'Exista mai multe programari pentru pacientul cu id-ul dat');
 when others then
        raise_application_error(-20004,'Alta eroare!');
 
 
 end procedura;

END pachet; 
/ 

--ex6 
EXECUTE pachet.p; 

--ex7
EXECUTE pachet.proc;

--ex8
DECLARE
v_result NUMBER;
BEGIN
  v_result := pachet.f(60);
  DBMS_OUTPUT.PUT_LINE(v_result);
END;

--ex9
EXECUTE pachet.procedura(14);