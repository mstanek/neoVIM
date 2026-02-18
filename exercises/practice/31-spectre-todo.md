# Cwiczenie 31: Spectre i Todo

> Powiazana lekcja: `lessons/31-spectre-todo.md`

## Instrukcje
- `<leader>S` -- toggle Spectre (project-wide search & replace)
- `<leader>sw` -- szukaj slowa pod kursorem w Spectre
- `<leader>sp` -- szukaj w biezacym pliku
- W Spectre: `Enter` (skocz), `dd` (usun wynik), `<leader>R` (replace all), `<leader>rc` (replace current)
- W Spectre: `I` (toggle regex), `ti` (ignore case), `th` (hidden files)
- `<leader>ft` -- znajdz wszystkie TODO/FIXME/etc. (Telescope)
- `]t` / `[t` -- nastepny / poprzedni todo-comment
- Todo notes (`*/notes/todo.md`): `<leader>ta` (add), `<leader>tx` (smart done), `<leader>ti/td/tb` (move)

## Cwiczenie 1: Filtrowanie sciezek w Spectre

1. Otworz Spectre: `<leader>S`
2. W polu Search wpisz: `import`
3. Przejrzyj wyniki -- za duzo? Zawez wyszukiwanie
4. W polu Path wpisz: `**/*.py` -- teraz widac tylko pliki Python
5. Zmien Path na: `**/*.ts` -- tylko TypeScript
6. Zmien Path na: `exercises/**` -- tylko katalog exercises
7. Zamknij Spectre: `<leader>S`
8. Wniosek: pole Path pozwala precyzyjnie kontrolowac zakres wyszukiwania

## Cwiczenie 2: Selektywny replace -- usuwanie wynikow

1. Otworz Spectre: `<leader>S`
2. Search: `return`, Replace: `RETURN` (celowo uppercase do testowania)
3. Przejrzyj liste wynikow -- jest ich duzo
4. Uzyj `dd` na wynikach, ktore NIE sa z katalogu `exercises/python/`
5. Powinny zostac tylko wyniki z plikow Python
6. **NIE zatwierdzaj** (`<leader>R`) -- to cwiczenie filtrowania
7. Zamknij Spectre: `<leader>S`
8. Cel: naucz sie usuwac niechciane wyniki przed zatwierdzeniem

## Cwiczenie 3: Regex -- znajdz wzorce w kodzie

1. Otworz Spectre: `<leader>S`
2. Wlacz regex: `I`
3. Wyszukaj wszystkie definicje funkcji Python:
   - Search: `def \w+\(` -- dopasuje `def nazwa(`
4. Przejrzyj wyniki -- ile funkcji jest w projekcie?
5. Zmien na wyszukiwanie klas:
   - Search: `class \w+`
6. Zmien na wyszukiwanie importow z `..` (relative):
   - Search: `from ['"]\.\.`
   - Path: `**/*.ts`
7. Zamknij: `<leader>S`

## Cwiczenie 4: Spectre -- zamiana nazwy typu w wielu plikach

Scenariusz: chcesz zmienic nazwe interfejsu w calym projekcie.

1. Otworz `exercises/typescript/interfaces.ts`
2. Znajdz nazwe interfejsu (np. `User` lub `Product`)
3. Ustaw kursor na niej, nacisnij `<leader>sw`
4. Spectre otwiera sie z ta nazwa w polu Search
5. W polu Replace wpisz nowa nazwe (np. `UserAccount` lub `ProductItem`)
6. Przejrzyj wyniki -- zauwaz pliki, w ktorych nazwa wystepuje
7. Uzyj `Enter` na wybranym wyniku -- przeniesie Cie do pliku, zeby zweryfikowac kontekst
8. Wroc do Spectre (bedzie nadal otwarty)
9. **NIE zatwierdzaj** -- zamknij: `<leader>S`

## Cwiczenie 5: Szukanie w biezacym pliku -- czyszczenie kodu

1. Otworz `exercises/python/data_processing.py`
2. Nacisnij `<leader>sp` -- Spectre z filtrem na biezacy plik
3. Search: `self\.` -- znajdz wszystkie odwolania do self
4. Przejrzyj ile razy self wystepuje i w jakich metodach
5. Zamknij: `<leader>S`
6. Otworz `<leader>sp` ponownie
7. Search: `pass` -- znajdz puste metody (stub-y)
8. Zamknij: `<leader>S`

## Cwiczenie 6: Todo-comments -- przeglad calego projektu

1. Nacisnij `<leader>ft` -- otwiera sie Telescope z lista TODO/FIXME/etc.
2. Przejrzyj liste -- posortowana po plikach
3. Wpisz `FIXME` w filtrze Telescope -- zawez do samych FIXME
4. `Esc`, otwrz ponownie: `<leader>ft`
5. Wpisz `HACK` -- zawez do HACK
6. Wybierz dowolny wynik, `Enter` -- przenosi do komentarza
7. Uzyj `]t` -- skok do nastepnego todo-comment w pliku
8. Uzyj `[t` -- skok do poprzedniego

## Cwiczenie 7: Dodawanie todo-comments do kodu

Otworz `exercises/typescript/store.ts` i dodaj ponizsze komentarze w odpowiednich miejscach
(tryb Insert, potem `Esc`). Nie zapisuj pliku -- cofnij zmiany po cwiczeniu.

1. Na gorze pliku dodaj: `// FIXME: brak obslugi bledow przy inicjalizacji`
2. Przy pierwszym `return` dodaj: `// PERF: mozliwa optymalizacja -- cache wynikow`
3. Przy dowolnym `if` dodaj: `// HACK: tymczasowe obejscie, do przepisania`
4. Na koncu pliku dodaj: `// NOTE: format danych zgodny z API v3`
5. Nacisnij `<leader>ft` -- Twoje komentarze pojawiaja sie w liscie
6. Uzyj `]t`/`[t` do nawigacji miedzy nimi
7. Cofnij wszystko: `u` wielokrotnie

## Cwiczenie 8: Todo notes -- pelny cykl zadania

> Wymaga pliku `notes/todo.md` -- stworz jesli nie istnieje (`:e notes/todo.md`)
> z sekcjami `## In Progress`, `## Backlog`, `## Done`.

1. Przejdz do sekcji Backlog
2. `<leader>ta` -- dodaj zadanie "Napisac testy do modulu auth"
3. `<leader>ta` -- dodaj "Zrefaktorowac endpoint users"
4. `<leader>ta` -- dodaj "Zaktualizowac dokumentacje API"
5. Ustaw kursor na pierwszym zadaniu -- `<leader>ti` (przenies do In Progress)
6. Ustaw kursor na tym samym zadaniu w In Progress -- `<leader>tx` (smart done)
7. Sprawdz sekcje Done -- zadanie powinno tam byc z `@done(...)` timestamp
8. Przenies drugie zadanie: `<leader>tk` (w gore), `<leader>tj` (w dol)

## Cwiczenie bonusowe

**Polaczony workflow -- od znalezienia problemu do zamkniecia zadania:**

1. Otworz `<leader>ft` -- przegladaj todo-comments w projekcie
2. Wybierz interesujacy FIXME lub TODO, `Enter` -- przechodzisz do kodu
3. Przeanalizuj problem, potem otworz Spectre: `<leader>sw` na slowie kluczowym
4. Sprawdz czy problem wystepuje w innych plikach (ile wynikow?)
5. Zamknij Spectre: `<leader>S`
6. Otworz `notes/todo.md` i dodaj zadanie opisujace naprawe (`<leader>ta`)
7. Przenies do In Progress: `<leader>ti`
8. Wroc do kodu: `Ctrl+P`, wpisz nazwe pliku z FIXME
9. (Udawaj naprawe) -- usun komentarz FIXME, `Esc`
10. Wroc do `notes/todo.md` i oznacz zadanie jako zrobione: `<leader>tx`
11. Cofnij zmiany w kodzie: `u` wielokrotnie
