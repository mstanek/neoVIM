# Cwiczenie 19: Yazi

> Powiazana lekcja: `lessons/19-yazi.md`

## Instrukcje
- `<leader>E` -- Yazi floating (katalog biezacego pliku)
- `<leader>ew` -- Yazi floating (CWD projektu)
- `h/j/k/l` -- nawigacja (parent / dol / gora / wejdz)
- `a` -- nowy plik (`/` na koncu = katalog)
- `r` -- zmien nazwe
- `y` / `x` / `p` -- kopiuj / wytnij / wklej
- `d` -- usun do kosza, `D` -- usun permanentnie
- `Space` -- toggle zaznaczenia (multi-select)
- `.` -- toggle ukrytych plikow
- `,m` / `,n` / `,s` / `,e` -- sortuj: data / nazwa / rozmiar / rozszerzenie
- `/` -- szukaj w biezacym katalogu
- `q` -- wyjdz z Yazi

## Cwiczenie 1: Roznica miedzy trybami otwarcia

Porownaj dwa sposoby otwierania Yazi:

1. Otworz `exercises/python/calculator.py` w Neovim
2. `<leader>E` -- zauwaz, ze Yazi otworzyl sie w `exercises/python/`
3. `q` -- zamknij
4. `<leader>ew` -- zauwaz, ze Yazi otworzyl sie w katalogu glownym projektu
5. `q` -- zamknij

Regula: `<leader>E` = katalog biezacego pliku, `<leader>ew` = root projektu.

## Cwiczenie 2: Eksploracja projektu z podgladem

1. `<leader>ew` -- Yazi w CWD projektu
2. Nawiguj do `exercises/python/` (uzywajac `l` aby wchodzic do katalogow)
3. Przesuwaj kursor `j/k` po plikach -- obserwuj preview po prawej stronie
4. Zauwaz syntax highlighting w preview (Python)
5. Przejdz do `exercises/typescript/` -- preview z kolorami TypeScript
6. Przejdz do `exercises/vue/` -- preview z kolorami Vue (HTML + JS + CSS)
7. Wroc do katalogu glownego: `h` kilka razy lub `~` i nawiguj od nowa
8. `q` -- wyjdz

## Cwiczenie 3: Otwieranie plikow w Neovim przez Yazi

1. `<leader>E`
2. Nawiguj do `exercises/typescript/store.ts`
3. Nacisnij `Enter` -- Yazi zamknie sie, plik otworzy sie jako buffer w Neovim
4. Sprawdz bufferline -- nowy buffer pojawil sie
5. `<leader>E` ponownie -- Yazi otworzy sie w `exercises/typescript/`
6. Nawiguj do `interfaces.ts`, `Enter` -- kolejny buffer
7. Teraz masz 2+ bufferow otwartych z poziomu Yazi

## Cwiczenie 4: Multi-select -- zaznaczanie wielu plikow

1. `<leader>ew` -- Yazi w root projektu
2. Nawiguj do `exercises/python/`
3. Staw kursor na `calculator.py`, nacisnij `Space` -- plik zaznaczony (podswietlony)
4. `j` -- przejdz do `utils.py`, `Space` -- tez zaznaczony
5. `j` -- przejdz do `models.py`, `Space`
6. Masz 3 zaznaczone pliki -- widoczne podswietlenie
7. `y` -- skopiuj wszystkie 3 do schowka Yazi
8. Nawiguj `h`, potem do `exercises/practice/`
9. `p` -- wklej. Wszystkie 3 pliki skopiowane za jednym razem!
10. Posprzataj: zaznacz skopiowane pliki (`Space` na kazdym), `d` -- usun

## Cwiczenie 5: Sortowanie -- znajdz najwieksze pliki

1. `<leader>ew` -- Yazi w root
2. Nawiguj do `exercises/python/`
3. `,s` -- sortuj po rozmiarze (najwiekszy na gorze)
4. Zauwaz, ktory plik Python jest najwiekszy
5. `,m` -- sortuj po dacie modyfikacji (ostatnio zmieniony na gorze)
6. `,e` -- sortuj po rozszerzeniu
7. `,n` -- wroc do sortowania po nazwie (domyslne)
8. `q` -- wyjdz

## Cwiczenie 6: Wyszukiwanie w katalogu

1. `<leader>ew` -- Yazi w root
2. Nawiguj do `exercises/`
3. `/` -- wlacz wyszukiwanie
4. Wpisz `broken` -- Yazi podswietli pliki pasujace do wzorca
5. Nawiguj miedzy wynikami
6. `Esc` -- wyczysc wyszukiwanie
7. Nawiguj do `lessons/`
8. `/` -- wpisz `telescope` -- znajdz lekcje o Telescope
9. `q` -- wyjdz

## Cwiczenie 7: Tworzenie i usuwanie

1. `<leader>E`
2. `a` -- wpisz `yazi-test.txt` -- nowy plik
3. Zauwaz, ze plik pojawil sie w liscie
4. `a` -- wpisz `yazi-temp/` (ze slashem) -- nowy katalog
5. `l` -- wejdz do `yazi-temp/`
6. `a` -- wpisz `nested-file.py` -- plik w nowym katalogu
7. `h` -- wroc do katalogu nadrzednego
8. Zaznacz `yazi-test.txt` (`Space`) i `yazi-temp/` (`Space`)
9. `d` -- usun oba do kosza (potwierdz jesli trzeba)

## Cwiczenie bonusowe

**Scenariusz: audyt struktury projektu**

Dostajesz nowy projekt i musisz szybko zrozumiec jego strukture.
Uzyj Yazi do eksploracji -- BEZ otwierania plikow w edytorze:

1. `<leader>ew` -- Yazi w root projektu
2. Przegladaj kazdy katalog top-level (nawiguj `l`, potem `h` zeby wrocic):
   - `exercises/` -- jakie jezyki? ile plikow w kazdym?
   - `lessons/` -- ile lekcji? jakie tematy? (preview pokaze tresc)
3. `,s` w kazdym katalogu -- ktore pliki sa najwieksze?
4. `.` -- pokaz ukryte pliki. Czy jest `.gitignore`? `.git/`?
5. Nawiguj do `exercises/python/data_processing.py` -- przeczytaj preview
6. Bez otwierania pliku, przejdz do `exercises/typescript/api-service.ts`
7. Porownaj preview obu -- co robi kazdy z nich?
8. Nawiguj do `lessons/` -- preview pozwala czytac lekcje bez otwierania!
9. `q` -- wroc do Neovim. Cala eksploracja bez jednego `:e`

**Porownanie z Neo-tree:** Sprobuj to samo z `<leader>e`. Zauwaz, ze Neo-tree
nie ma preview kodu -- musisz otworzyc plik, zeby zobaczyc jego zawartosc.
Yazi wygrywa w scenariuszach "szybki recon".
