# sp500-top20-analysis
Data analysis of top 20 S&P 500 companies (2014–2024) using PostgreSQL and Power BI

**ENGLISH BELOW**


# Analiza 20 największych spółek z indeksu S&P 500 (wersja polska)



![Dashboard Power BI](img/dashboard_top20_sp500.jpg)

---

## Struktura bazy danych

Projekt opiera się na bazie danych PostgreSQL, w której zawarto dane giełdowe dla 20 największych spółek z indeksu S&P 500 (łącznie 21 tabel – jedna główna i po jednej na każdą spółkę). 
Dane obejmują lata 2014–2024.
Baza danych została zaprojektowana w PostgreSQL i zawiera następujące tabele:

![ERD](img/ERD.jpg)





Projekt zawiera szereg funkcji i widoków, które umożliwiają analizę danych giełdowych w Power BI w celu wizualizacji oraz dostarczenia wniosków.

---

## Technologie i narzędzia

- **PostgreSQL** – relacyjna baza danych, przechowywanie i przetwarzanie danych, tworzenie zapytań analitycznych, funkcji i widoków  
- **Power BI** – dashboard interaktywny, model danych oraz dodatkowe kolumny i miary, końcowa prezentacja wyników analizy  
- **PyCharm** – środowisko pracy z danymi i zarządzania kodem   
- **CSV** – format danych źródłowych  

---

## Struktura folderów

- `sql/` – zapytania SQL  
- `data/` – dane źródłowe CSV
- `power_bi/` – dashboard w formacie .pbix
- `img/` – dashboard Power BI, schemat ERD
- `README.md` – opis projektu  
