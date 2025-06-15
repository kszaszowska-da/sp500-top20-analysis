# sp500-top20-analysis
Data analysis of top 20 S&P 500 companies (2014–2024) using PostgreSQL and Power BI

**ENGLISH BELOW**


# Analiza danych giełdowych 20 największych spółek z indeksu S&P 500 (2014–2024) przy użyciu PostgreSQL i Power BI)

## Dashboard Power BI

---


![Dashboard Power BI](img/dashboard_top20_sp500.jpg)



Projekt zawiera interaktywny dashboard stworzony w Power BI, który umożliwia eksplorację danych za pomocą filtrów i dynamicznych wizualizacji. Model danych został zbudowany na podstawie widoków zaimportowanych z bazy PostgreSQL, gdzie kluczowym elementem jest symbol spółki. W razie potrzeby tworzono dodatkowe kolumny i miary w celu ułatwienia analizy oraz lepszego zobrazowania danych w raportach. Dzięki temu możliwe jest szybkie filtrowanie i szczegółowa analiza danych wybranej firmy.

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
- `power_bi/` – dashboard (.pbix)
- `img/` – dashboard Power BI, schemat ERD
- `README.md` – opis projektu

