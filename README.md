<<<<<<< HEAD
# Task 6: Subqueries & Nested Queries

## 🎯 Objective
Use subqueries in `SELECT`, `WHERE`, and `FROM` (derived tables) including scalar and correlated subqueries, `IN`, `EXISTS`, and `ANY/ALL`.

## 🧰 Tools
- MySQL Workbench

## 📚 What’s Covered
- Scalar subqueries in `SELECT`
- Correlated subqueries in `WHERE`
- `IN`, `EXISTS`, `NOT EXISTS`
- Derived tables (subqueries in `FROM`)
- `ANY` / `ALL` usage

## 🗂 Files
- `task6_subqueries.sql` — all example queries

## 🧪 Sample Highlights
- Products above average price  
- Users with/without orders via `EXISTS`/`NOT EXISTS`  
- Most expensive product per category (correlated)  
- Order totals using derived table

## ❓ Interview Q&A (short)
1. **What is a subquery?** A query inside another query; returns a value/set/table to the outer query.  
2. **Subquery vs Join?** Joins combine rows across tables in one level; subqueries compute a value/set that the outer query uses. Sometimes interchangeable, but performance/readability differs.  
3. **Correlated subquery?** A subquery that references outer query columns; runs once per outer row.  
4. **Can subqueries return multiple rows?** Yes (e.g., in `IN`/`EXISTS`). Scalar subquery must return a single value.  
5. **How does `EXISTS` work?** Tests if the subquery returns any row; stops on first match (efficient for existence checks).  
6. **Performance impact?** Correlated subqueries can be slower; indexes help; consider rewriting as joins/derived tables if needed.  
7. **Scalar subquery?** Returns a single value (one row, one column).  
8. **Where can we use subqueries?** `SELECT`, `WHERE`, `FROM`, `HAVING`, and even `INSERT/UPDATE` in some RDBMS.  
9. **Subquery in FROM?** Yes; called a derived table; must give it an alias.  
10. **Derived table?** A temporary result set produced by a subquery in `FROM` used like a table.

## ✅ Outcome
Advanced query logic using subqueries, correlated subqueries, and derived tables on an e-commerce schema.
=======
# task-6-subqueries-nested-queries
SQL subqueries (scalar and correlated), IN/EXISTS, and derived tables in SELECT, WHERE, and FROM on an e-commerce schema.
>>>>>>> b40601945b8833046609985a6a3ddb10bbfdf8b3
