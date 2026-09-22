-- ==========================================
-- 01 - Exploration de la base de données
-- ==========================================

SELECT "customers" AS table_name, COUNT(*) AS nb_rows FROM customers
UNION ALL
SELECT "orders", COUNT(*) FROM orders
UNION ALL
SELECT "order_items", COUNT(*) FROM order_items
UNION ALL
SELECT "order_payments", COUNT(*) FROM order_payments
UNION ALL
SELECT "order_reviews", COUNT(*) FROM order_reviews
UNION ALL
SELECT "products", COUNT(*) FROM products
UNION ALL
SELECT "sellers", COUNT(*) FROM sellers
UNION ALL
SELECT "geolocation", COUNT(*) FROM geolocation
UNION ALL
SELECT "product_category_name_translation", COUNT(*) FROM product_category_name_translation;

SELECT * FROM orders;
SELECT "orders" AS Nom_table, COUNT(*) AS Nbr_commandes FROM orders;
SELECT order_status AS statut_commande FROM orders GROUP BY order_status;
SELECT order_status AS statut_commande, COUNT(*) AS Nbr_statut_commande FROM orders GROUP BY order_status;

SELECT * FROM customers;
SELECT "customers" AS Nom_table, COUNT(*) AS Nbr_client FROM customers;
SELECT "customers" AS Nom_table, COUNT(DISTINCT customer_unique_id) AS Nbr_client FROM customers;
SELECT customer_unique_id FROM customers WHERE customer_unique_id IS NULL;

SELECT "orders" AS Nom_table, COUNT(DISTINCT order_id) AS Nbr_commandes FROM orders;
SELECT order_id, COUNT(order_id) AS Lignes_commandes FROM order_items GROUP BY order_id HAVING Lignes_commandes > 1 ORDER BY Lignes_commandes DESC;

SELECT * FROM orders WHERE customer_id IS NULL;

SELECT customer_unique_id, COUNT(*) as nbr_commande_par_client
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customer_unique_id
ORDER BY nbr_commande_par_client DESC;

SELECT "orders" AS table_name, COUNT(*) FROM orders WHERE order_delivered_carrier_date IS NULL;

SELECT order_purchase_timestamp FROM orders ORDER BY order_purchase_timestamp ASC LIMIT 1;
SELECT order_purchase_timestamp FROM orders ORDER BY order_purchase_timestamp DESC LIMIT 1;


-- Trouver la première et la dernière commande

SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp) FROM orders

-- Trouver le nombre de commandes par année

SELECT
	strftime('%Y',order_purchase_timestamp) AS "Annee",
	COUNT(*) AS nb_commandes
FROM ORDERS
GROUP BY annee
ORDER BY annee ASC

-- Trouver le nombre de commandes par mois

SELECT
	strftime('%Y-%m',order_purchase_timestamp) AS "Mois",
	COUNT(*) AS nb_commandes
FROM ORDERS
GROUP BY Mois
ORDER BY Mois ASC

-- Trouver le mois qui a enregistré le plus de commandes

SELECT
	strftime('%Y-%m',order_purchase_timestamp) AS "Mois",
	COUNT(*) AS nb_commandes
FROM ORDERS
GROUP BY Mois
ORDER BY nb_commandes DESC

--
-- Pour strftime() les formats sont les suivants %Y (année), %m (mois), %d (jour), %H (heure), %M (minute), %S (seconde), %Y-%m (année-mois)
--

-- 1 ligne = 1 commande
SELECT c.customer_unique_id, o.order_id, SUM(oi.price) as montant_commande
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id, o.order_id
ORDER BY montant_commande DESC

-- 1 ligne = 1 client
SELECT c.customer_unique_id, SUM(oi.price) as montant_commande, COUNT(o.order_id)
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY montant_commande DESC


-- Vérifier l'unicité des clés primaires

SELECT
    order_id,
    COUNT(*) AS nb
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT customer_id, COUNT(*) AS nb
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS nb
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT seller_id, COUNT(*) AS nb
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;



-- ==========================================
-- 05 - Comprendre l'activité commerciale
-- ==========================================

-- Trouver le nombre de commandes passées chaque mois
SELECT strftime("%Y-%m", order_purchase_timestamp) as Mois, COUNT(*) as Nbr_commandes
FROM orders
GROUP BY mois
ORDER BY mois ASC

-- Trouver la valeur totale des produits commandés chaque mois
SELECT strftime("%Y-%m", o.order_purchase_timestamp)as Mois, SUM(oi.price) as Vtot_mois
FROM orders as o
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY Mois
ORDER BY Mois ASC

-- Trouver la valeur des produits, les frais de livraisons et le montant total pour chaque mois
SELECT strftime("%Y-%m", o.order_purchase_timestamp)as Mois, SUM(oi.price) as Produits, SUM(oi.freight_value) as Livraison, SUM(oi.price + oi.freight_value) as Total
FROM orders as o
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY Mois
ORDER BY Mois ASC

-- Calculer le panier moyen
SELECT strftime("%Y-%m", o.order_purchase_timestamp)as Mois,COUNT(DISTINCT oi.order_id) as Commandes ,ROUND(SUM(oi.price),2) as Produits, ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id),2) as Panier_moyen
FROM orders as o
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY Mois
ORDER BY Mois ASC

-- Comparer les commandes et le chiffre d'affaires
SELECT strftime("%Y-%m", o.order_purchase_timestamp)as Mois,COUNT(DISTINCT oi.order_id) as Commandes ,ROUND(SUM(oi.price),2) as "Valeur Produits", ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id),2) as "Panier moyen"
FROM orders as o
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY Mois
ORDER BY Mois ASC

-- ==========================================
-- 06 - Analyse du comportement client
-- ==========================================

-- Trouver le nombre de commandes par client
SELECT c.customer_unique_id, COUNT(*) as "Nombre de commandes"
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id

-- Combien les clients dépensent-ils au total
SELECT c.customer_unique_id, SUM(oi.price) as "Dépense totale"
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id

-- Calculer le panier moyen de chaque client
SELECT c.customer_unique_id, COUNT(DISTINCT oi.order_id) as Commandes, SUM(oi.price) as "Dépense totale", ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id),2) as Panier_moyen
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id

-- Identifier les clients les plus importants
SELECT c.customer_unique_id, COUNT(DISTINCT oi.order_id) as Commandes, SUM(oi.price) as "Dépense totale", ROUND(SUM(oi.price) / COUNT(DISTINCT oi.order_id),2) as Panier_moyen
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
JOIN order_items as oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY "Dépense totale" DESC
LIMIT 20

-- Combien de clients ont effectué une seule commande, deux commandes, trois commandes etc ?
WITH Table_int AS (
SELECT c.customer_unique_id as Client, COUNT(*) as "Nombre de commandes"
FROM customers as c
JOIN orders as o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
)
SELECT "Nombre de commandes", COUNT(Client) as "Nombre de clients"
FROM Table_int
GROUP BY "Nombre de commandes"
ORDER BY "Nombre de commandes" ASC

-- ==========================================
-- 07 - Analyse des produits et catégories
-- ==========================================

-- Trouver le nombre de produits pour chaque catégorie
SELECT product_category_name AS "Catégorie", COUNT(DISTINCT product_id) AS "Nombre de produits"
FROM products
GROUP BY product_category_name
ORDER BY "Nombre de produits" DESC

-- Traduire les catégories en anglais
SELECT p.product_category_name, pcnt.product_category_name_english AS "Catégorie", COUNT(DISTINCT p.product_id) AS "Nombre de produits"
FROM products AS p
LEFT JOIN product_category_name_translation AS pcnt
ON p.product_category_name = pcnt.product_category_name
GROUP BY p.product_category_name

-- Trouver les catégories qui génèrent le plus de ventes
SELECT p.product_category_name AS "Catégorie PT", pcnt.product_category_name_english AS "Catégorie EN", COUNT(oi.product_id) AS "Nombre de produits"
FROM products AS p
LEFT JOIN product_category_name_translation AS pcnt
ON p.product_category_name = pcnt.product_category_name
LEFT JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name, pcnt.product_category_name_english
ORDER BY "Nombre de produits" DESC

-- Trouver les catégories qui génèrent le plus de chiffre d'affaires
SELECT p.product_category_name AS "Catégorie PT", pcnt.product_category_name_english AS "Catégorie EN", COUNT(oi.product_id) AS "Articles vendus", SUM(oi.price) AS CA, ROUND(SUM(oi.price)/COUNT(oi.product_id),2) AS "Prix moyen"
FROM products AS p
LEFT JOIN product_category_name_translation AS pcnt
ON p.product_category_name = pcnt.product_category_name
LEFT JOIN order_items AS oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name, pcnt.product_category_name_english
ORDER BY CA DESC

-- ==========================================
-- 08 - Analyse des paiments
-- ==========================================

-- Trouver le nombre de paiments par commande (et supérieur à 1)
SELECT order_id AS "Commande", COUNT(order_id) AS "Nombre de paiments"
FROM order_payments
GROUP BY "Commande"
HAVING "Nombre de paiments" > 1
ORDER BY "Nombre de paiments" DESC

-- Trouver le nombre de paiments effectués avec chaque moyen de paiment
SELECT payment_type AS "Moyen de paiement", COUNT(payment_type) AS "Nombre de paiements"
FROM order_payments
GROUP BY "Moyen de paiement"
ORDER BY "Nombre de paiements" DESC

-- Trouver le montant associé à chaque moyen de paiment
SELECT payment_type AS "Moyen de paiement", COUNT(payment_type) AS "Nombre de paiements", SUM(payment_value) AS "Montant total"
FROM order_payments
GROUP BY "Moyen de paiement"
ORDER BY "Nombre de paiements" DESC

-- Trouver le panier moyen selon le moyen de paiment
SELECT payment_type AS "Moyen de paiement", COUNT(payment_type) AS "Nombre de paiements", SUM(payment_value) AS "Montant total", ROUND(SUM(payment_value)/COUNT(payment_type),2) AS "Montant moyen"
FROM order_payments
GROUP BY "Moyen de paiement"
ORDER BY "Nombre de paiements" DESC

-- Construction de tableau : order_id, valeur totale des produits, frais de livraison, valeur totale des paiements
WITH Table_articles AS (
SELECT oi.order_id AS "Commande", SUM(oi.price) AS "Produits", SUM(oi.freight_value) AS "Livraison"
FROM order_items AS oi
GROUP BY "Commande"
)
SELECT "Commande", "Produits", "Livraison", SUM(op.payment_value) AS "Paiements"
FROM Table_articles
JOIN order_payments AS op
ON Table_articles."Commande" = op.order_id
GROUP BY "Commande"
ORDER BY "Produits" DESC

-- ============================================
-- 09 - Analyse des commandes et de leur statut
-- ============================================

-- Répartition des commandes par statut
SELECT order_status As "Statut", COUNT(order_id) AS "Nombre de commandes"
FROM orders
GROUP BY order_status

-- Pourcentage de chaque statut
SELECT order_status As "Statut", COUNT(order_id) AS "Nombre de commandes", ROUND((COUNT(order_id) * 100.0)/(SELECT COUNT(*) FROM orders),2) AS "% des commandes"
FROM orders
GROUP BY order_status

-- Chiffre d'affaires selon le statut
SELECT order_status As "Statut", COUNT(DISTINCT o.order_id) AS "Nombre de commandes", ROUND((COUNT(DISTINCT o.order_id) * 100.0)/(SELECT COUNT(*) FROM orders),2) AS "% des commandes", SUM(oi.price) AS "CA produits"
FROM orders AS o
LEFT JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY "Statut"

-- Trouver le nombre de jours moyen entre l'achat et la livraison au clien
WITH delai_livraison AS (
SELECT order_id, julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp) AS "Délai de livraison"
FROM orders
WHERE order_status = "delivered"
)
SELECT ROUND(AVG("Délai de livraison"),2)
FROM delai_livraison

-- Trouver l'écart entre la date de livraison estimée et la livraison réelle pour chaque commande
SELECT order_id AS "Commande", strftime("%d/%m/%Y",order_delivered_customer_date) AS "Livraison réelle", strftime("%d/%m/%Y",order_estimated_delivery_date) AS "Livraison estimée", ROUND(julianday(order_delivered_customer_date) - julianday(order_estimated_delivery_date),2) AS "Ecart"
FROM orders
WHERE order_status = "delivered"
ORDER BY "Ecart" DESC

-- Trouver le pourcentage de commandes livrées au client qui sont arrivées après la date estimée
WITH ecart_livraison AS (
SELECT order_id AS "Commande", strftime("%d/%m/%Y",order_delivered_customer_date) AS "Livraison réelle", strftime("%d/%m/%Y",order_estimated_delivery_date) AS "Livraison estimée", ROUND(julianday(order_delivered_customer_date) - julianday(order_estimated_delivery_date),2) AS "Ecart"
FROM orders
WHERE order_status = "delivered"
)
SELECT SUM(CASE WHEN "Ecart" > 0 THEN "1" ELSE "0" END)*100.0/ COUNT(*) AS "Livraison_retard"
FROM ecart_livraison


-- ==============================
-- 10 - Analyse des avis clients
-- ==============================

-- Trouver le nombre d'avis qui ont été attribuées pour chaque note

SELECT review_score, COUNT(review_score)
FROM order_reviews
GROUP BY review_score

-- Trouver la moyenne des notes des avis pour l'ensemble des commandes

SELECT ROUND(AVG(review_score),2)
FROM order_reviews

-- Trouver le pourcentage d'avis correspond à chaque note

SELECT review_score as "Note", COUNT(review_score) as "Nombre d'avis", ROUND(COUNT(review_score) * 100.0 / (SELECT COUNT(*) FROM order_reviews),2) as "% des avis"
FROM order_reviews
GROUP BY Note

-- Trouver le pourcentage des avis qui sont des mauvaises notes (< 2)

SELECT "Taux de mauvaises notes" AS KPI, ROUND(SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) *100.0 / (SELECT COUNT(*) FROM order_reviews),2) AS Valeur
FROM order_reviews

-- Trouver si les commandes livrées en retard ont de moins bonnes notes
WITH fusion_table AS (
SELECT 	o.order_id AS "Commande", strftime("%d/%m/%Y",o.order_delivered_customer_date) AS "Livraison réelle", 
		strftime("%d/%m/%Y",o.order_estimated_delivery_date) AS "Livraison estimée", 
		ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) AS "Ecart",
		"or".review_score, 
		CASE 
			WHEN ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) > 0.0 AND ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) <= 10.0 THEN 'leger_retard' 
			WHEN ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) > 10.0 AND ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) <= 100.0 THEN 'retard_moyen'
			WHEN ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) > 100.0 THEN 'retard_important' 
			ELSE 'pas_de_retard' 
		END AS "Retard"
FROM orders AS "o"
JOIN order_reviews AS "or"
ON o.order_id = "or".order_id
WHERE order_status = "delivered"
ORDER BY "Ecart" DESC
)
SELECT Retard, ROUND(AVG(review_score),2) AS "Moyenne score"
FROM fusion_table
GROUP BY "Retard"

-- Trouver le nombres de commandes se trouvant dans chaque catégorie
WITH fusion_table AS (
SELECT 	o.order_id AS "Commande", strftime("%d/%m/%Y",o.order_delivered_customer_date) AS "Livraison réelle", 
		strftime("%d/%m/%Y",o.order_estimated_delivery_date) AS "Livraison estimée", 
		ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) AS "Ecart",
		"or".review_score, 
		CASE 
			WHEN ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) > 0.0 AND ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) <= 10.0 THEN 'leger_retard' 
			WHEN ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) > 10.0 AND ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) <= 100.0 THEN 'retard_moyen'
			WHEN ROUND(julianday(o.order_delivered_customer_date) - julianday(o.order_estimated_delivery_date),2) > 100.0 THEN 'retard_important' 
			ELSE 'pas_de_retard' 
		END AS "Retard"
FROM orders AS "o"
JOIN order_reviews AS "or"
ON o.order_id = "or".order_id
WHERE order_status = "delivered"
ORDER BY "Ecart" DESC
)
SELECT Retard, COUNT(Commande) AS "Nombre de commandes", ROUND(AVG(review_score),2) AS "Moyenne score"
FROM fusion_table
GROUP BY "Retard"


-- Vérifier une cardinalité

SELECT
    order_id,
    COUNT(*) AS nombre_avis
FROM order_reviews
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY nombre_avis DESC;