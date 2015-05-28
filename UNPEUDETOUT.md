%B.D.O.
%Dernier chapitre
%07 05 2015

# Normes

\texttt{SQL} 

+ 1986 == \textbf{SQL 87}
+ 1989 == \textbf{SQL-1}
+ 1992 == \textbf{SQL-2}
+ 1999 == \textbf{SQL-3} Avec la récursion, notion de déclencheur, notion
  d'objet (en parlant \texttt{Abstract Data Type})
+ 2003 == \textbf{Plus de nom spécifique} Séquence, attributs de type XML
+ 2006 == \textbf{Plus de nom spécifique} 
+ 2008 == \textbf{Plus de nom spécifique} 

# Branchements dans un \texttt{SELECT}

```SQL
SELECT exp1, 
		exp2,
		CASE expression
				WHEN valeur THEN expension1
				WHEN valeur2 THEN expension2
				[WHEN ...]...
				[ELSE ...]
		END, 
		exp3
	FROM table;
```

# \texttt{CTE} : Common Table Expression

```SQL
WITH V1(e, nb) as
	(SELECT empDpt, COUNT(*)
		FROM employe
		GROUP BY empDpt)

SELECT e, nb FROM V1
	WHERE nb = (SELECT MAX(nb) FROM V1)
```


## SELECT hiérarchique

```SQL
WITH V2(dDno, dLib, dPere) AS 
	(SELECT dptNo, dptLib, dptAdm
		FROM Departement
		WHERE dptAdm IS NULL
	UNION ALL
		SELECT dptNo, dptLib, dptAdm
			FROM Departement
			JOIN V2 v ON v.dNo = dptAdm)

SELECT * FROM V2
```

# Transactions imbriquées

Il s'agit d'une sorte de versionning

```SQL
	SAVEPOINT nomSave1

	SAVEPOINT nomSave2

	ROLLBACK TO nomSave1
```

# \texttt{ALTER SESSION}

Modifier le niveau d'isolation :

```SQL
	ALTER SESSION SET isolation_level = serializable;
```

