/* Exercice 1 */

CREATE OR REPLACE Function FLibSexe(sexe CHAR) 
	RETURN VARCHAR DETERMINISTIC IS

	BEGIN
		IF (sexe = 'M') THEN
			return 'Masculin';
		ELSIF (sexe = 'F') THEN 
			return 'Féminin';
		ELSE 
			raise_application_error(-20100,
									'Le sexe n''est pas égal à
									F ou M');
		END IF;
	END;


/* Exercice 2 */

CREATE OR REPLACE Function MasseSal(dpt VARCHAR) 
	RETURN INT DETERMINISTIC IS

	salaire int;
	

	BEGIN
		SELECT SUM(empSal)
		INTO :salaire
		FROM Employe
			where empDpt = :dpt
			GROUP BY empDpt;

	RETURN salaire;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			RETURN 0;

	END;


/* Exercice 3 */


CREATE OR REPLACE Function Fcondense(chaine VARCHAR)
	RETURN VARCHAR DETERMINISTIC IS

	translated VARCHAR;
	
	BEGIN
		translated := upper(chaine);
		/* Tous les caractères spéciaux ne sont pas présents */
		return translate(translated, 'Éù)({}#ÈÊËẼÑ"''^\\/:;,|&ùµ', 'EEEEN');
	END;


/* Exercice 4 */

CREATE OR REPLACE Function FnumDiv(dpt Departement.dptno%Type)
	RETURN INT IS

	niveau INT := 1;
	pere Departement.dptno%Type;
	courant Departement.dptNo%Type := dpt;

	BEGIN
		WHILE (courant IS NOT NULL) LOOP
			niveau := niveau + 1;
			SELECT dptAdm 
				INTO pere
				FROM DEPARTEMENT 
				WHERE dptNo = dpt;

			courant := pere;

		END LOOP;

		RETURN niveau;

	END;



/* Exercice 5 */ -- à tester

CREATE OR REPLACE FUNCTION listeEmp(dpt Departement.dptNo%Type) 
	RETURN VARCHAR IS

	liste VARCHAR(250);
 	unNom VARCHAR(30);
	CURSOR noms IS 
		SELECT empNom from employe
			WHERE empdpt = dpt
			ORDER BY empNom;

	BEGIN
		OPEN noms;
		FETCH noms INTO unNom;

		WHILE noms%FOUND LOOP
			liste := liste || unNom
			FETCH noms INTO unNom
		END LOOP

		CLOSE noms;
	END;

CREATE VIEW VDptDetail(DptNo, DptLib, DptNomsEmp) AS
	SELECT dptNo, dptLib, listeEmp(dptNo) 
		FROM Departement;

/* Exercice 6 */ 

		
CREATE OR REPLACE Function dptDirectDependant(dpt Departement.DptNo%Type) 
	RETURN INT IS
	
	n INT;

	BEGIN 
		SELECT count(*) INTO n FROM Departement where dptAdm = dpt;
		RETURN n;		
	END;

CREATE OR REPLACE Function dptIndirectDependant(dpt Departement.DptNo%Type)
	RETURN INT IS

	total INT;
	BEGIN
		return parcoursRecursif(dpt);
	END;

create or replace Function parcoursRecursif(dpt Departement.DptNo%Type) 
	RETURN INT IS

	total INT := 0;
	pere Departement.DptNo%Type := dpt;
	courant Departement.DptNo%Type;
	
	CURSOR dpts IS
		SELECT dptNo from Departement
			WHERE dptAdm = pere;

	BEGIN 
		OPEN dpts;
		FETCH dpts INTO courant;
		WHILE dpts%found LOOP
			total := total + 1;
			total := total + parcoursRecursif(courant);
			FETCH dpts INTO courant;
		END LOOP;
		CLOSE dpts;

		RETURN total;
	END;
	


CREATE VIEW VDptResp(DptNo, DptLib, DptNbDir, DptNbIndir) AS
	SELECT DptNo, DptLib, dptDirectDependant(dptno), dptIndirectDependant(dptno)
		FROM DEPARTEMENT;


/* Exercice 7 */
CREATE OR REPLACE PROCEDURE PtsfGroupe(dpt1 Departement.DptNo%Type, dpt2 Departement.DptNo%Type) IS

	
	courant Employe.EmpNo%Type;

	CURSOR Employes IS
		SELECT empno from employe 
		where empdpt = dpt1;

	BEGIN
		OPEN Employes;
		FETCH Employes INTO courant;
		WHILE Employes%found LOOP
			UPDATE Employe 
				SET empdpt = dpt2 
					WHERE empno = courant;
			
			FETCH Employes INTO courant;
		END LOOP;
	END;


/* Exercice 8 -- à tester */


create or replace
PROCEDURE PmodAdm(nouveauFils Departement.DptNo%Type, nouveauPere Departement.DptNo%Type) IS

	pere Departement.DptNo%Type;

	BEGIN
	
  select dptAdm INTO pere from departement where dptno = nouveauPere;
  
	WHILE (pere = nouveauFils OR pere IS NULL) LOOP
		IF (pere IS NULL) THEN
      UPDATE Departement
			SET dptAdm = nouveauPere 
			WHERE dptNo = nouveauFils;
		END IF; 
    select dptAdm INTO pere from departement where dptno = nouveauPere;
	END LOOP;

END;


/* Exercice 9 */



