
/* EXERCICES TRIGGERS */

/* Exercice 1 */

CREATE OR REPLACE TRIGGER updateEmpNomNorm
	AFTER
	INSERT OR UPDATE of empNom
	ON Employe
	REFERENCING OLD AS old NEW AS new 
	FOR EACH ROW
	BEGIN
		UPDATE Employe
			SET EmpNomNorm = Fcondense(:new.empNom);
	END;


/* Exercice 2 */

CREATE OR REPLACE TRIGGER gereNbEmployes
	AFTER
	INSERT OR DELETE OR UPDATE OF EmpDpt
	ON Employe
	REFERENCING OLD AS old NEW AS new 
	FOR EACH ROW
	BEGIN 
		IF (INSERTING OR UPDATING) THEN
			UPDATE DEPARTEMENT 
				SET dptNbEmps = dptnbEmps + 1
				WHERE dptNo = :new.empDpt;
		
		END IF;
		
		IF (DELETING OR UPDATING) THEN
			UPDATE DEPARTEMENT 
				SET dptNbEmps = dptnbEmps - 1
				WHERE dptNo = :old.empDpt;
		END IF;
	END;

/* Exercice 3 */
/* Modification de EmpSal, DptMasseMax, EmpDpt */

CREATE OR REPLACE TRIGGER gereMasseSalariale
	BEFORE 
	UPDATE OR INSERT of empSal, DptMasseMax, empDpt
	ON Employe
	REFERENCING OLD AS old NEW AS NEW
	FOR EACH ROW
	BEGIN 
		IF (MasseSal(:new.EmpDpt) > :new.DptMasseMax) THEN
			RAISE_APPLICATION_ERROR(-20100, 
				'La masse salariale ne peut pas dépasser
				DptMasseMax');
		END IF;
	END;

/* Exercice 4 */ 

CREATE OR REPLACE TRIGGER gereSalEmploye
	BEFORE
	UPDATE OF empSal
	ON Employe
	REFERENCING OLD AS old NEW AS new
	FOR EACH ROW
	BEGIN
		IF (:new.empSal < :old.empSal) THEN
			RAISE_APPLICATION_ERROR(-20100,
				'Un salaire ne peut pas diminuer');
		END IF;
	END;
	












