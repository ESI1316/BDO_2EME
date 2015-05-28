Soit la table T(a, b, c, d, e, f, g)

Clé : a et b

Dépendance fonctionnelle b -> c, d, e (Non pris en compte)

Forme normale : 2


/* Faux */
SELECT distinct x.b
	FROM 
		(Select b, c, d, e FROM T
		GROUP BY b) AS x

	JOIN (Select b, c, d, e FROM T
		GROUP BY b) AS y
	ON x.b = y.b
	
	GROUP BY x.b
	HAVING count(*) > 1



SELECT b 
	FROM T
	GROUP BY b
	HAVING COUNT(distinct c) != 1 ||
		   COUNT(distinct d) != 1 ||
		   COUNT(distinct e) != 1;

		/* PLUS SIMPLE */
SELECT b
	FROM
	(SELECT b, c, d, e 
		FROM T
		GROUP BY b, c, d, e)

	GROUP BY b
	HAVING COUNT(*) > 1


T(a, b, f, g)
T2(b, c, d, e)

T2[b] c T[b]


/* 2.3 */

/* La clause sert à référencer l'ancien tuple et le nouveau tuple 
  
   REFERENCING doit avoir FOR EACH ROW !

   On ne met pas referencing pour les delete, et les insert
 
 */

/* SQL */

















