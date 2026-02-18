# Lekcja 25: Trouble i Dropbar -- diagnostyka i breadcrumbs

> Czas: ~30-45 min | Poziom: Intermediate/Advanced

## Cel lekcji

Nauczysz sie uzywac Trouble jako centralny panel diagnostyki calego projektu (bledy,
referencje, symbole, quickfix) oraz Dropbar jako breadcrumbs -- kontekstowa sciezke
(plik > modul > klasa > metoda) wyswietlana na gorze kazdego okna. Ta lekcja zamyka
modul 4 (LSP i narzedzia) i laczy wszystkie poznane narzedzia w spojny workflow.

## Teoria

### Trouble -- panel diagnostyki i referencji

**Trouble** to zaawansowany panel, ktory zbiera informacje z roznych zrodel (diagnostyka
LSP, quickfix, location list, symbole, referencje) i wyswietla je w czytelnym,
nawigawalnym oknie.

Roznica miedzy Trouble a `[d`/`]d`:
- `[d`/`]d` -- skacza po diagnostykach **jednego pliku**, po kolei
- Trouble -- wyswietla diagnostyki **calego projektu**, pogrupowane, z filtrami

#### Tryby Trouble

| Klawisz | Tryb | Opis |
|---------|------|------|
| `<leader>xx` | Diagnostics | Wszystkie diagnostyki z calego projektu |
| `<leader>xX` | Buffer Diagnostics | Diagnostyki tylko z biezacego pliku |
| `<leader>xs` | Symbols | Symbole biezacego pliku (jak Aerial, ale w Trouble) |
| `<leader>xl` | LSP Defs/Refs | Definicje i referencje symbolu pod kursorem |
| `<leader>xL` | Location List | Zawartosc location list |
| `<leader>xq` | Quickfix | Zawartosc quickfix list |

#### Diagnostics: `<leader>xx`

Otwiera panel ze WSZYSTKIMI diagnostykami projektu. Bledy i ostrzezenia ze wszystkich
otwartych buforow sa zebrane w jednym miejscu:

```
┌─ Trouble ──────────────────────────────────────────────────────┐
│  Diagnostics (12)                                              │
├────────────────────────────────────────────────────────────────┤
│  󰅚 exercises/python/broken.py                                  │
│    20:12 "math" is not defined                          Pyright │
│    26:12 "config" is not defined                        Pyright │
│    36:11 Argument missing for "greeting"                Pyright │
│    44:20 Argument of type "str" is not ...              Pyright │
│    54:11 Cannot access attribute "phone"                Pyright │
│                                                                │
│  󰅚 exercises/typescript/broken.ts                               │
│    23:1  Property 'email' is missing                    ts(2741)│
│    34:7  Type 'number' is not assignable to 'string'    ts(2322)│
│    44:39 Property 'description' does not exist          ts(2339)│
└────────────────────────────────────────────────────────────────┘
```

> **Twoja konfiguracja**: `auto_close = true` -- Trouble automatycznie sie zamknie
> kiedy naprawisz ostatni blad. `focus = true` -- po otwarciu kursor od razu
> jest w panelu Trouble (nie musisz przeskakiwac Ctrl+w).

#### Buffer Diagnostics: `<leader>xX`

To samo co `<leader>xx`, ale tylko dla biezacego bufora. Przydatne kiedy pracujesz
nad jednym plikiem i nie chcesz widziec bledow z innych plikow.

#### Symbols: `<leader>xs`

Wyswietla symbole biezacego pliku w Trouble -- alternatywa dla Aerial.
Roznica: Trouble pokazuje symbole w flat list z wyszukiwaniem, Aerial w panelu
bocznym z drzewem.

#### LSP Definitions/References: `<leader>xl`

Otwiera panel z definicjami i referencjami symbolu pod kursorem. Zamiast
quickfix/Telescope (jak przy `gr`), wyniki laduja w Trouble panel.

#### Quickfix: `<leader>xq`

Wyswietla zawartosc quickfix list w panelu Trouble. Quickfix list to lista
wynikow z roznych operacji (:grep, :make, LSP references). Trouble daje
ladniejszy widok niz domyslny `:copen`.

#### Nawigacja w Trouble

| Klawisz | Opis |
|---------|------|
| `j` / `k` | Nawiguj po liscie |
| `CR` (Enter) | Skocz do wybranego elementu |
| `q` | Zamknij panel Trouble |
| `o` | Skocz i zamknij Trouble |
| `<Tab>` | Nastepny element z preview |
| `<S-Tab>` | Poprzedni element z preview |

> **Tip**: Trouble integruje sie z `[d`/`]d` -- mozesz nawigowac po diagnostykach
> w Trouble klawiszami, a potem zamknac panel i kontynuowac prace.

### Dropbar -- breadcrumbs

**Dropbar** wyswietla sciezke kontekstu na gorze kazdego okna edytora (winbar).
Pokazuje gdzie dokladnie jestes w hierarchii kodu:

```
┌─ 󰈙 data_processing.py > 󰠱 DataValidator > 󰊕 _validate_row ─────────────┐
│                                                                           │
│     def _validate_row(self, index: int, row: dict) -> list:              │
│         errors: list[ValidationError] = []                                │
│         for col in self.schema.columns:                                   │
│             value = row.get(col.name)                                     │
│             ...                                                           │
```

Sciezka aktualizuje sie automatycznie w miare jak poruszasz kursor -- widzisz
w jakim pliku, w jakiej klasie i w jakiej metodzie aktualnie jestes.

#### Elementy breadcrumb

```
 plik > 󰠱 klasa > 󰊕 metoda > 󰌗 if block
```

| Ikona | Typ |
|-------|-----|
| 󰈙 | Plik |
| 󰠱 | Klasa |
| 󰊕 | Funkcja |
| 󰆧 | Metoda |
| 󰜢 | Property |
| 󰌗 | Control flow (if/for/while) |

#### Dropbar Pick: `<leader>dp`

Interaktywna nawigacja przez breadcrumbs. Po nacisnieciu `<leader>dp` mozesz
klikac na poszczegolne segmenty breadcrumb -- otwiera sie dropdown z lista
elementow na tym poziomie.

```
 data_processing.py > DataValidator > _validate_row
                           │
                           ▼
                    ┌──────────────────┐
                    │ 󰊕 validate        │
                    │ 󰊕 _validate_row  │ ◄── aktualny
                    │ 󰊕 is_valid        │
                    └──────────────────┘
```

Mozesz nawigowac:
- Kliknij na segment breadcrumb -- otwiera dropdown
- Strzalkami/j/k wybierz element
- Enter -- skocz do niego
- Esc -- zamknij dropdown

#### Skad Dropbar bierze dane?

Dropbar uzywa kombinacji **treesitter** i **LSP**:
- Treesitter -- szybkie lokalne parsowanie (wie ze jestes wewnatrz `if` w `for` w metodzie)
- LSP -- informacje o symbolach (nazwy klas, metod, funkcji)

### Laczenie narzedzi -- pelny workflow

Teraz masz caly arsenal narzedzi do nawigacji i diagnostyki. Oto jak je laczyc:

#### Scenariusz 1: Naprawianie bledow w projekcie

```
1. <leader>xx          -- otwierasz Trouble: widac wszystkie bledy
2. Enter na bledzie    -- skaczesz do pliku z bledem
3. <leader>ld          -- czytasz pelna diagnostyke
4. <leader>ca          -- naprawiasz code action
5. <leader>xx          -- sprawdzasz Trouble: blad zniknal?
6. Enter na nastepnym  -- nastepny blad
```

#### Scenariusz 2: Eksploracja nowego kodu

```
1. <leader>o           -- Aerial: ogolna struktura pliku
2. <leader>ss          -- Namu: fuzzy jump do interesujacego symbolu
3. gd                  -- definicja: skad to pochodzi?
4. gr                  -- referencje: kto tego uzywa?
5. Dropbar             -- breadcrumbs: patrzysz gdzie jestes
6. Ctrl+O              -- wroc do punktu wyjscia
```

#### Scenariusz 3: Refactoring

```
1. <leader>ss          -- Namu: skocz do symbolu
2. <leader>rn          -- rename: zmien nazwe
3. <leader>xl          -- Trouble LSP: sprawdz wszystkie referencje
4. <leader>cf          -- format: posprzataj kod
5. <leader>xx          -- Trouble: upewnij sie ze nie ma nowych bledow
```

### Mapa narzedzi -- podsumowanie modulu 4

| Kategoria | Klawisze |
|-----------|---------|
| **Nawigacja LSP** | `gd` definicja, `gr` referencje, `gp` peek, `K` hover, `gri` implementation, `grt` type |
| **Diagnostyka** | `]d`/`[d` nawigacja, `<leader>ld` linia, `<leader>xX` bufor, `<leader>xx` projekt |
| **Akcje** | `<leader>ca` code action, `<leader>rn` rename, `<leader>cf` format |
| **Symbole** | `<leader>o` Aerial, `{`/`}` prev/next, `<leader>ss` Namu, `<leader>sw` workspace |
| **Panele** | `<leader>xl` Trouble refs, `<leader>xq` quickfix, `<leader>dp` Dropbar |

## Cwiczenia

### Cwiczenie 1: Trouble Diagnostics -- widok projektu

Otworz dwa pliki z bledami (w roznych buforach):
1. `exercises/python/broken.py` (`:e exercises/python/broken.py`)
2. `exercises/typescript/broken.ts` (`:e exercises/typescript/broken.ts`)

Teraz:
1. Nacisnij `<leader>xx` -- otwiera sie Trouble z diagnostykami
2. Powinienes widziec bledy z OBU plikow, pogrupowane po nazwie pliku
3. Nawiguj `j`/`k` po liscie
4. Bledy Python (Pyright) sa w jednej grupie, TypeScript (ts_ls) w drugiej
5. Nacisnij Enter na bledzie z `broken.ts` -- Neovim otworzy ten plik i przeskoczy
   do linii z bledem
6. Nacisnij `<leader>xx` ponownie -- wroc do Trouble
7. Zamknij: `q`

### Cwiczenie 2: Buffer Diagnostics

Otworz `exercises/python/broken.py`:

1. Nacisnij `<leader>xX` -- Buffer Diagnostics
2. Powinienes widziec TYLKO bledy z `broken.py` (nie z `broken.ts`)
3. Nawiguj po bledach, sprawdz opisy
4. Enter na bledzie -- skaczesz do niego
5. Porownaj z `<leader>xx` -- tam sa bledy z calego projektu

### Cwiczenie 3: Trouble z naprawianiem

Otworz `exercises/python/broken.py`:

1. Nacisnij `<leader>xX` -- Buffer Diagnostics
2. Policz ile jest bledow (powinno byc ~9)
3. Enter na pierwszym bledzie (`math` not defined)
4. Napraw: `<leader>ca` -> "Add import math"
5. Nacisnij `<leader>xX` ponownie -- sprawdz czy blad zniknal z listy
6. Powinienes widziec o jeden blad mniej
7. Cofnij naprawke (`u`) zeby zachowac plik do dalszych cwiczen

### Cwiczenie 4: Trouble Symbols

Otworz `exercises/python/data_processing.py`:

1. Nacisnij `<leader>xs` -- Symbols w Trouble
2. Zobaczysz liste symboli pliku -- klasy, funkcje, metody
3. Porownaj z Aerial (`<leader>o`) -- Trouble pokazuje flat list,
   Aerial drzewo hierarchiczne
4. Enter na `Pipeline` -- skaczesz do klasy
5. Zamknij Trouble (`q`)

### Cwiczenie 5: Trouble LSP References

Otworz `exercises/python/data_processing.py`:

1. Ustaw kursor na nazwie `DataSchema` (~linia 53)
2. Nacisnij `<leader>xl` -- LSP Definitions/References
3. Trouble pokaze wszystkie miejsca gdzie `DataSchema` jest uzywana:
   - Definicja klasy
   - Uzycie w `DataValidator.__init__` jako typ parametru `schema`
   - Inne referencje
4. Enter na referencji -- skaczesz do niej
5. Porownaj z `gr` -- `gr` otwiera quickfix/Telescope, `<leader>xl` otwiera Trouble

### Cwiczenie 6: Dropbar -- odczytywanie breadcrumbs

Otworz `exercises/python/data_processing.py`:

1. Spojrz na gore okna edytora -- widac breadcrumb:
   `󰈙 data_processing.py`
2. Nawiguj kursorem do metody `_validate_row` w klasie `DataValidator` (~linia 243)
3. Breadcrumb powinien sie zmienic na:
   `󰈙 data_processing.py > 󰠱 DataValidator > 󰊕 _validate_row`
4. Nawiguj do `Pipeline.process()` (~linia 306)
5. Breadcrumb: `󰈙 data_processing.py > 󰠱 Pipeline > 󰊕 process`
6. Nawiguj do helper function `flatten_dict()` (~linia 358)
7. Breadcrumb: `󰈙 data_processing.py > 󰊕 flatten_dict`
   (brak klasy -- to top-level function)

### Cwiczenie 7: Dropbar Pick

Kontynuuj w `exercises/python/data_processing.py`:

1. Nacisnij `<leader>dp` -- Dropbar Pick
2. Kliknij (lub nawiguj) na segment z nazwa klasy
3. Powinien pojawic sie dropdown z innymi elementami na tym poziomie
4. Wybierz inna klase lub funkcje -- skaczesz do niej
5. Powroc `Ctrl+O`

### Cwiczenie 8: Dropbar w roznych plikach

1. Otworz `exercises/typescript/api-service.ts`
2. Nawiguj do metody `getUsers()` (~linia 104)
3. Breadcrumb: `api-service.ts > 󰠱 ApiService > 󰊕 getUsers`
4. Otworz `exercises/vue/UserCard.vue`
5. Nawiguj do funkcji `onFollow()` (~linia 80)
6. Breadcrumb powinien pokazywac kontekst Vue SFC

### Cwiczenie 9: Pelny workflow -- diagnostyka + nawigacja

Otworz `exercises/python/broken.py`:

1. `<leader>xx` -- Trouble: widac wszystkie bledy
2. Enter na bledzie `"config" is not defined` -- skaczesz do linii 26
3. Spojrz na breadcrumb -- widzisz w jakiej funkcji jestes (`get_database_url`)
4. `K` na `config` -- hover potwierdza ze zmienna nie istnieje
5. `<leader>o` -- Aerial: widzisz strukture pliku -- same funkcje, klasy
6. `}` -- skocz do nastepnej funkcji
7. Zamknij Aerial (`<leader>o`)
8. `<leader>ss` -- Namu: wpisz `process` -- skocz do `process_data`
9. `<leader>xX` -- Buffer Diagnostics: sprawdz czy ta funkcja ma bledy

### Cwiczenie 10: Trouble auto_close

Otworz `exercises/python/broken.py`:

1. Nacisnij `<leader>xX` -- Buffer Diagnostics
2. Zapamietaj ile bledow jest na liscie
3. Enter na pierwszym bledzie -- skaczesz do niego
4. Napraw blad (np. dodaj `import math`)
5. Nacisnij `<leader>xX` -- sprawdz czy lista sie skrocila
6. Napraw nastepny blad
7. Kontynuuj az naprawisz wszystkie
8. Kiedy naprawisz ostatni blad -- Trouble powinno sie AUTOMATYCZNIE zamknac
   (auto_close = true)
9. Cofnij wszystkie zmiany: `u` wielokrotnie

## Cwiczenie bonusowe

Pelny "code review" pliku `exercises/python/data_processing.py` -- uzyj WSZYSTKICH
narzedzi z modulu 4:

1. Dropbar -- obserwuj breadcrumbs przy nawigacji po pliku
2. `<leader>o` -- przejrzyj strukture w Aerial, potem `<leader>ss` + `pipe` -> `Pipeline`
3. `gd` na `BaseTransformer`, `gr` na `DataSchema`, `gp` na `ValidationError`
4. `<leader>xx` -- sprawdz diagnostyke projektu, `K` na symbolach
5. Odpowiedz: ile klas? ile helper functions? ktora klasa ma najwiecej metod?

## Podsumowanie

### Nauczone komendy

| Komenda | Opis |
|---------|------|
| `<leader>xx` | Trouble -- diagnostyki calego projektu |
| `<leader>xX` | Trouble -- diagnostyki biezacego bufora |
| `<leader>xs` | Trouble -- symbole pliku |
| `<leader>xl` | Trouble -- LSP definicje/referencje |
| `<leader>xq` | Trouble -- quickfix list |
| `<leader>dp` | Dropbar Pick -- nawigacja breadcrumbs |

### Nawigacja w Trouble

| Klawisz | Opis |
|---------|------|
| `j` / `k` | Nawiguj po liscie |
| `CR` (Enter) | Skocz do elementu |
| `o` | Skocz i zamknij |
| `q` | Zamknij panel |
| `Tab` / `S-Tab` | Nastepny/poprzedni z preview |

### Konfiguracja uzyta w tej lekcji

| Element | Wartosc / Opis |
|---------|---------------|
| Trouble `auto_close` | `true` -- zamyka sie po naprawieniu ostatniego bledu |
| Trouble `focus` | `true` -- kursor od razu w panelu |
| Dropbar | Breadcrumbs z treesitter + LSP |
| `<leader>dp` | Dropbar Pick -- interaktywna nawigacja |

### Podsumowanie modulu 4: LSP i narzedzia

W module 4 poznales caly stos narzedzi do pracy z kodem na poziomie "IDE":

| Lekcja | Temat | Kluczowe komendy |
|--------|-------|------------------|
| **21** | LSP nawigacja | `gd`, `gr`, `gp`, `gri`, `grt`, `Ctrl+O`/`Ctrl+I` |
| **22** | LSP diagnostyka | `K`, `gK`, `<leader>ld`, `[d`/`]d` |
| **23** | LSP akcje | `<leader>ca`, `<leader>rn`, `<leader>cf`, completion |
| **24** | Aerial + Namu | `<leader>o`, `{`/`}`, `<leader>ss`, `<leader>sw` |
| **25** | Trouble + Dropbar | `<leader>xx`, `<leader>xX`, `<leader>xl`, `<leader>dp` |

Te narzedzia wspoldzialaja -- uzywaj ich w kombinacji, nie w izolacji.
Aerial pokazuje strukture, Namu pozwala szybko skoczyc, LSP daje inteligencje,
Trouble zbiera diagnostyke, Dropbar mowi Ci gdzie jestes.

### Co dalej?

Modul 4 jest kompletny! W nastepnych lekcjach przejdziemy do **modulu 5** --
zaawansowane operacje: makra, registers, zaawansowane text objects, i integracja
z systemem (clipboard, terminal, Git).
