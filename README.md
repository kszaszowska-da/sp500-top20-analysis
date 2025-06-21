# sp500-top20-stock-data-analysis 
Analiza danych giełdowych 20 największych spółek z indeksu S&P 500 (2014–2024) przy użyciu PostgreSQL i Power BI  

**ENGLISH BELOW**

---

## Dashboard Power BI  

Projekt zawiera **interaktywny dashboard** stworzony w Power BI, który umożliwia eksplorację danych za pomocą filtrów i dynamicznych wizualizacji.  
Model danych został zbudowany na podstawie widoków zaimportowanych z bazy PostgreSQL, gdzie kluczowym elementem jest symbol spółki.  
W razie potrzeby tworzono dodatkowe kolumny i miary w celu ułatwienia analizy oraz lepszego zobrazowania danych w raportach.  
Dzięki temu możliwe jest szybkie filtrowanie i szczegółowa analiza danych wybranej firmy.

![Dashboard Power BI](img/dashboard_top20_sp500.jpg)

---


## Pytania badawcze i analiza wyników


### 1. Które firmy mają największy średni obrót akcjami oraz najwyższą średnią cenę zamknięcia?

**Cel analizy:**
Zidentyfikować spółki cieszące się największym zainteresowaniem inwestorów (wysoki obrót) oraz te, które osiągają najwyższe ceny akcji (średnia cena zamknięcia).

**Co analizujemy:**
Dla każdej spółki z top 20 indeksu S\&P 500 analizujemy:

* średni wolumen obrotu (średnia liczba akcji będących przedmiotem transakcji w danym okresie),
* średnią cenę zamknięcia (średnia wartość końcowa notowań z danego dnia).

**Wnioski:**

* Najwyższą średnią cenę zamknięcia osiągały akcje **Costco (COST)** i **Netflix (NFLX)** – powyżej 300 USD.
* Największym średnim wolumenem obrotu wyróżnia się zdecydowanie spółka **NVIDIA (NVDA)** – blisko 0,5 miliarda akcji, co znacznie przewyższa pozostałe firmy.
* Pomimo stosunkowo niskiej średniej ceny zamknięcia akcji, NVIDIA przyciąga ogromne zainteresowanie inwestorów, co może być efektem dynamicznego rozwoju technologicznego i popularności na rynku.
* Firmy takie jak **META, TSLA** czy **AMZN** również znajdują się w czołówce pod względem jednego lub obu analizowanych wskaźników, co potwierdza ich wysoką aktywność rynkową i atrakcyjność dla inwestorów.


### 2. Średnia różnica procentowa między ceną otwarcia a zamknięcia dla poszczególnych firm

**Cel analizy:**
Sprawdzić, które spółki mają tendencję do zyskiwania lub tracenia na wartości w ciągu dnia, czyli czy ich akcje średnio rosną, czy spadają w trakcie jednej sesji.

**Co analizujemy:**
Średnią dzienną różnicę procentową według wzoru:
`(zamknięcie – otwarcie) / otwarcie × 100`
dla każdego dnia, a następnie średnią wartość z tych różnic dla każdej firmy.

**Wnioski:**

* **NVIDIA (NVDA)** ma najwyższą dodatnią średnią różnicę, co oznacza, że najczęściej kończy sesję na plusie.
* Także **AAPL, META, LLY, ORCL** i **TSLA** wykazują dodatnie średnie dzienne zmiany, czyli często zyskują na wartości w ciągu dnia.
* **Berkshire Hathaway (BRK\_B)** i **AMZN** jako jedyne mają ujemne średnie różnice, co oznacza, że ich kursy mają tendencję do spadania w ciągu dnia.


### 3. Średnia cena zamknięcia w latach 2014–2024

**Cel analizy:**
Zidentyfikować długoterminowe trendy cenowe oraz zmiany wartości akcji w czasie.

**Co analizujemy:**

* Średnie roczne ceny zamknięcia w latach 2014–2024 (w ujęciu co dwa lata)
* Wzrosty (2014 vs. 2024):

  * wartościowe (różnica cenowa w USD)
  * procentowe (dynamika zmian)

**Wnioski:**

* **Liderzy wzrostu wartościowego (USD):**

  * **Eli Lilly (LLY)** – +759,82 USD
  * **Costco (COST)** – +722,06 USD
  * **Netflix (NFLX)** – +614,00 USD
  * **Meta (META)** – +440,49 USD
* **Liderzy wzrostu procentowego:**

  * **NVIDIA (NVDA)** – +24 402,27%
  * **Broadcom (AVGO)** – +2 591,68%
  * **Eli Lilly (LLY)** – +1 488,38%
  * **Tesla (TSLA)** – +1 448,76%
* **Najniższe zmiany wartościowe i procentowe:**

  * **ExxonMobil (XOM)** – tylko +47,59 USD i +72,23%

Większość firm notuje długoterminowy wzrost średnich cen zamknięcia, co wskazuje na pozytywne postrzeganie ich wartości przez rynek. **NVIDIA** i **LLY** to liderzy dekady.


### 4. W których miesiącach średnia cena akcji była najwyższa (średnia z 10 lat)?

**Cel analizy:**
Wskazanie sezonowości cen akcji.

**Co analizujemy:**
Średnie miesięczne ceny zamknięcia z każdego miesiąca (zsumowane dla 10 lat).

**Wnioski:**

* Sezonowość jest widoczna – większość sektorów wykazuje tendencję wzrostową pod koniec roku, szczególnie w listopadzie i grudniu.
* Efekt stycznia jest umiarkowany – brak wyraźnych skoków cen w styczniu dla większości branż.
* Okres wakacyjny (lipiec–sierpień) przynosi spowolnienie, szczególnie w sektorach dóbr konsumpcyjnych, technologicznym i energetycznym.
* Najniższe ceny energii występują w miesiącach letnich, co może być powiązane z niższym zużyciem i większą produkcją ze źródeł odnawialnych.


### 5. Które firmy miały największą zmienność cen akcji (odchylenie standardowe)?

**Cel analizy:**
Zmierzenie ryzyka inwestycyjnego – im większa zmienność, tym trudniej przewidzieć przyszłą cenę akcji.

**Co analizujemy:**
Odchylenie standardowe cen zamknięcia (2014–2024) dla każdej firmy z TOP 20 w indeksie S\&P 500. Dodatkowo uwzględniono średnią cenę zamknięcia dla kontekstu.

**Wnioski:**

* Największą zmienność odnotowano dla firm: **Eli Lilly (LLY), Costco (COST), Netflix (NFLX)** – odchylenia >200.
* Inne firmy o wysokiej zmienności to: **META, Mastercard (MA), Microsoft (MSFT)** – odchylenia powyżej 130.
* Najmniejszą zmiennością charakteryzowały się m.in. **Walmart (WMT), ExxonMobil (XOM)** – odchylenia poniżej 30.
* Dodatkowa obserwacja:

  * **Berkshire Hathaway (BRK\_B)** ma wysoką cenę, ale umiarkowaną zmienność.
  * **Tesla (TSLA)**, mimo przeciętnej ceny, wykazuje stosunkowo wysokie ryzyko.


### 6. Które firmy miały najwięcej dni wzrostowych i spadkowych (różnica)?

**Cel analizy:**
Zidentyfikować, czy dana firma częściej zyskuje, czy traci na wartości w ciągu dnia – czyli jaki jest dominujący kierunek dziennych zmian cen akcji.

**Co analizujemy:**
Dla każdej firmy liczbę dni, w których:

* cena zamknięcia > cena otwarcia → dzień wzrostowy
* cena zamknięcia < cena otwarcia → dzień spadkowy

**Wnioski:**

* Firmy z największą przewagą dni wzrostowych to: **Mastercard (MA), Apple (AAPL), Oracle (ORCL), Microsoft (MSFT)**. Osiągały one dodatni bilans ponad 180–200 dni w latach 2014–2024.
* Spółki takie jak **ExxonMobil (XOM)** i **Berkshire Hathaway (BRK\_B)** miały więcej dni spadkowych niż wzrostowych.
* **Tesla (TSLA)** i **Amazon (AMZN)** wykazały niemal równowagę między dniami wzrostowymi a spadkowymi, co może świadczyć o dużej zmienności i braku dominującego kierunku.

---

## Struktura bazy danych  

Projekt opiera się na bazie danych PostgreSQL, zawierającej dane giełdowe dla 20 największych spółek z indeksu S&P 500 (łącznie 21 tabel – jedna główna oraz po jednej dla każdej spółki).  
Dane obejmują lata 2014–2024, a baza została zaprojektowana w PostgreSQL i zawiera następujące tabele:

![ERD](img/ERD.jpg)

Projekt zawiera szereg funkcji i widoków, które umożliwiają analizę danych giełdowych w Power BI w celu wizualizacji oraz wyciągania wniosków.

---

## Technologie i narzędzia

- **PostgreSQL** – relacyjna baza danych: przechowywanie, przetwarzanie danych, tworzenie zapytań analitycznych, funkcji i widoków  
- **Power BI** – interaktywny dashboard, model danych, dodatkowe kolumny i miary, końcowa prezentacja wyników  
- **PyCharm** – środowisko pracy z danymi i zarządzania kodem  
- **CSV** – format danych źródłowych  

---

## Struktura folderów

- `sql/` – zapytania SQL  
- `data/` – dane źródłowe CSV  
- `power_bi/` – dashboard (.pbix)  
- `img/` – dashboard Power BI, schemat ERD  
- `README.md` – opis projektu  

---

## Autor

Projekt edukacyjny łączący analizę danych, pracę w PostgreSQL oraz tworzenie interaktywnych wizualizacji w Power BI.

---

## Źródła 

Dane giełdowe pobrano z serwisu [Stooq](https://stooq.pl/).

---
---

# sp500-top20-stock-data-analysis 
Stock market data analysis of the 20 largest companies in the S&P 500 index (2014–2024) using PostgreSQL and Power BI  

---

## Power BI Dashboard  

The project features an **interactive dashboard** built in Power BI, allowing users to explore data through filters and dynamic visualizations.  
The data model is based on views imported from a PostgreSQL database, where the company symbol is the key element.  
Additional columns and measures were created when necessary to simplify analysis and enhance data presentation in the reports.  
As a result, users can easily filter and perform in-depth analysis of a selected company.

![Dashboard Power BI](img/dashboard_top20_sp500.jpg)

---

## Database Structure  

The project is based on a PostgreSQL database containing stock market data for the 20 largest companies in the S&P 500 index (21 tables in total – one main table and one per company).  
The dataset covers the years 2014–2024. The database was designed in PostgreSQL and includes the following tables:

![ERD](img/ERD.jpg)

The project also includes several functions and views that enable data analysis in Power BI, allowing for effective visualization and insights.

---

## Technologies & Tools  

- **PostgreSQL** – relational database for storing and processing data, creating analytical queries, functions, and views  
- **Power BI** – interactive dashboard, data modeling, additional columns and measures, final presentation of results  
- **PyCharm** – data development and code management environment  
- **CSV** – source data format  

---

## Folder Structure  

- `sql/` – SQL queries  
- `data/` – source CSV files  
- `power_bi/` – dashboard file (.pbix)  
- `img/` – Power BI dashboard, ERD diagram  
- `README.md` – project description  

---

## Author  

An educational project combining data analysis, work in PostgreSQL, and the creation of interactive visualizations in Power BI.

---

## Sources

Stock market data taken from [Stooq](https://stooq.pl/).

