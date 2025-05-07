import time

import pandas as pd
import requests
from bs4 import BeautifulSoup

BASE_URL = "https://jency.archiwa.gov.pl/pl/baza-danych/page/{page}/"
START_PAGE = 1
END_PAGE = 1142
OUTPUT_CSV = "baza_danych.csv"


def parse_table(soup):
    """
    Znajduje i parsuje pierwszą tabelę na stronie.
    Zwraca listę wierszy, każdy jako lista komórek tekstowych.
    """
    table = soup.find("table")
    if not table:
        return []
    rows = []
    for tr in table.find_all("tr"):
        cols = [td.get_text(strip=True) for td in tr.find_all(["td", "th"])]
        if cols:
            rows.append(cols)
    return rows


def main():
    all_data = []
    header = None

    for page in range(START_PAGE, END_PAGE + 1):
        url = BASE_URL.format(page=page)
        print(f"Pobieram stronę {page} → {url}")
        res = requests.get(url)
        if res.status_code != 200:
            print(f"  ! Błąd {res.status_code}, pomijam stronę.")
            continue

        soup = BeautifulSoup(res.content, "html.parser")
        rows = parse_table(soup)
        if not rows:
            print("  -> Brak tabeli na tej stronie, pomijam.")
            continue

        # Pierwszy wiersz jako nagłówek
        if header is None:
            header = rows[0]
            data_rows = rows[1:]
        else:
            # Zakładamy, że struktura jest taka sama, więc odrzucamy kolejny header
            data_rows = rows[1:]

        all_data.extend(data_rows)

        # Polite delay, by nie przeciążać serwera
        time.sleep(0.5)

    # Zapis do CSV z pandas (szybszy niż csv.writer)
    df = pd.DataFrame(all_data, columns=header)
    df.to_csv(OUTPUT_CSV, index=False, encoding="utf-8-sig")
    print(f"\nZapisano {len(df)} rekordów do pliku {OUTPUT_CSV}")


if __name__ == "__main__":
    main()
