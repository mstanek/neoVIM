# Cwiczenie 07: Rejestry (registers)

> Powiazana lekcja: `lessons/07-rejestry.md`

## Instrukcje
- Prefix: `"{rejestr}` przed operacja (np. `"ayy`, `"bp`)
- Unnamed `""`: domyslny, synchronizowany ze schowkiem (`clipboard=unnamedplus`)
- Yank register `"0`: ostatni yank (nie nadpisywany przez delete!)
- Delete registers `"1`-`"9`: historia delete'ow (FIFO)
- Named `"a`-`"z`: zapis do rejestru. `"A`-`"Z`: dopisanie (append!)
- Black hole `"_`: usun bez zapisywania gdziekolwiek
- Special: `"%` (filename), `".` (last insert), `":` (last command), `"/` (last search)
- Insert/Command: `Ctrl+r {reg}` -- wklej rejestr bez wychodzenia z trybu
- Expression: `Ctrl+r =` -- kalkulator w Insert mode
- Podglad: `:reg` -- lista rejestrow

## Cwiczenie 1: Klasyczny problem unnamed register

Ten scenariusz demonstruje najczestszy problem poczatkujacych z rejestrami.

```
WAZNA LINIA: skopiuj mnie i wklej ponizej
SMIECI: ta linia jest do usuniecia
MIEJSCE DOCELOWE: tu wklej wazna linie ->
```

Scenariusz BEZ wiedzy o rejestrach (pokaz problemu):
1. Kursor na `WAZNA LINIA`. `yy` -- kopiuj
2. Kursor na `SMIECI`. `dd` -- usun (nadpisuje unnamed `""` register!)
3. Kursor na `MIEJSCE DOCELOWE`. `p` -- wkleja... SMIECI! Nie to co chciales!
4. `u` -- cofnij

Rozwiazanie 1 -- uzyj `"0` (yank register):
1. Kursor na `WAZNA LINIA`. `yy` -- kopiuj (trafia do `""` i `"0`)
2. Kursor na `SMIECI`. `dd` -- usun (nadpisuje `""`, ale NIE `"0`!)
3. Kursor na `MIEJSCE DOCELOWE`. `"0p` -- wklej z yank register!
4. `u` wielokrotnie -- cofnij

Rozwiazanie 2 -- uzyj `"_` (black hole):
1. Kursor na `WAZNA LINIA`. `yy` -- kopiuj
2. Kursor na `SMIECI`. `"_dd` -- usun do black hole (unnamed NIE zmieniony!)
3. Kursor na `MIEJSCE DOCELOWE`. `p` -- wklej oryginalnie skopiowana linie!
4. `u` wielokrotnie -- cofnij

## Cwiczenie 2: Named registers -- przechowywanie wielu fragmentow

Skopiuj rozne fragmenty do roznych rejestrow i wklej je w odpowiednich miejscach.

```python
# --- Zrodla ---
SECRET_KEY = "abc123-very-secret"
DATABASE_URL = "postgresql://localhost:5432/mydb"
REDIS_URL = "redis://localhost:6379/0"
API_TOKEN = "tok_live_abcdefgh"

# --- Cel: uzupelnij config ---
config = {
    "secret": "",       # <- wklej SECRET_KEY
    "database": "",     # <- wklej DATABASE_URL
    "cache": "",        # <- wklej REDIS_URL
    "token": "",        # <- wklej API_TOKEN
}
```

Zadania:
1. Kursor na `"abc123-very-secret"`. `"ayi"` -- kopiuj zawartosc cudzyslowow do rejestru `a`
2. Kursor na `"postgresql://..."`. `"byi"` -- do rejestru `b`
3. Kursor na `"redis://..."`. `"cyi"` -- do rejestru `c`
4. Kursor na `"tok_live_..."`. `"dyi"` -- do rejestru `d`
5. `:reg abcd` -- sprawdz wszystkie 4 rejestry
6. Kursor wewnatrz pustego `""` przy `"secret"`. `ci"` -> `Ctrl+r a` -> `Esc`
7. Kursor wewnatrz `""` przy `"database"`. `ci"` -> `Ctrl+r b` -> `Esc`
8. Powtorz dla `"cache"` (rejestr `c`) i `"token"` (rejestr `d`)
9. `u` wielokrotnie -- cofnij

## Cwiczenie 3: Append do rejestru -- zbieranie fragmentow

Zbierz sygnatury funkcji z roznych miejsc pliku do jednego rejestru.

```python
class OrderService:
    def create_order(self, user_id: int, items: list) -> Order:
        """Create new order."""
        pass

    def cancel_order(self, order_id: int, reason: str) -> bool:
        """Cancel existing order."""
        pass

    def get_order(self, order_id: int) -> Order:
        """Get order by ID."""
        pass

    def list_orders(self, user_id: int, status: str = "all") -> list[Order]:
        """List orders for user."""
        pass

    def update_status(self, order_id: int, new_status: str) -> Order:
        """Update order status."""
        pass
```

Zadania:
1. Kursor na `def create_order(...)`. `"ayy` -- kopiuj do rejestru `a`
2. Kursor na `def cancel_order(...)`. `"Ayy` -- DOPISZ do rejestru `a` (wielka A!)
3. Kursor na `def get_order(...)`. `"Ayy` -- dopisz
4. Kursor na `def list_orders(...)`. `"Ayy` -- dopisz
5. Kursor na `def update_status(...)`. `"Ayy` -- dopisz
6. `:reg a` -- rejestr `a` powinien zawierac 5 linii!
7. Przejdz na koniec pliku (`G`). `o` -> `Esc` -> `"ap` -- wklej wszystkie sygnatury
8. `u` wielokrotnie -- cofnij

## Cwiczenie 4: Delete registers -- historia usuniec

Cwicz nawigacje po historii delete'ow w rejestrach `"1`-`"9`.

```
Linia Alpha
Linia Bravo
Linia Charlie
Linia Delta
Linia Echo
```

Zadania:
1. `dd` -- usun "Alpha" (trafia do `"1`)
2. `dd` -- usun "Bravo" (`"1` = Bravo, `"2` = Alpha)
3. `dd` -- usun "Charlie" (`"1` = Charlie, `"2` = Bravo, `"3` = Alpha)
4. `dd` -- usun "Delta" (`"1` = Delta, ... `"4` = Alpha)
5. `dd` -- usun "Echo" (wszystkie 5 linii sa w rejestrach 1-5)
6. `:reg 1 2 3 4 5` -- sprawdz zawartosci
7. Teraz odtworzenie w ORYGINALNEJ kolejnosci:
   - `"5p` -- wklej Alpha
   - `"4p` -- wklej Bravo
   - `"3p` -- wklej Charlie
   - `"2p` -- wklej Delta
   - `"1p` -- wklej Echo
8. `u` wielokrotnie -- cofnij

## Cwiczenie 5: Ctrl+r -- wklejanie w Insert i Command-line

Uzyj `Ctrl+r` do wklejania rejestrow bez wychodzenia z trybu Insert.

```typescript
// Wpisz nazwe pliku w komentarzu:
// Plik:

// Wpisz biezaca date:
// Data:

// Kalkulator: 2 * PI * 10 =

// Kopiuj slowo i uzyj w substitute:
const oldVariableName = "test";
const anotherOld = "demo";
```

Zadania:
1. Kursor na koncu `// Plik:`. `a` (Insert mode) -> `Ctrl+r %` -> wstawi nazwe pliku! -> `Esc`
2. Kursor na koncu `// Data:`. `a` -> `Ctrl+r =` -> wpisz `strftime('%Y-%m-%d')` + Enter -> `Esc`
3. Kursor na koncu `// Kalkulator:`. `a` -> `Ctrl+r =` -> `2 * 3.14159 * 10` + Enter -> `Esc`
4. Kursor na `oldVariableName`. `yiw` -- kopiuj slowo
5. `:` -> `%s/` -> `Ctrl+r "` -> wstawi skopiowane slowo! -> `/newName/g`
6. Obserwuj inccommand. `Esc` -- anuluj
7. `u` wielokrotnie -- cofnij

## Cwiczenie 6: Special registers -- read-only

Poznaj rejestry specjalne.

Zadania (wykonaj w dowolnym pliku):
1. `:reg %` -- pokaz nazwe biezacego pliku
2. Wykonaj jakas komende, np. `:echo "hello"`
3. `:reg :` -- pokaz ostatnia komende Ex (`echo "hello"`)
4. Wyszukaj cos: `/function`
5. `:reg /` -- pokaz ostatni wzorzec wyszukiwania (`function`)
6. Wejdz w Insert, wpisz `test tekst`, `Esc`
7. `:reg .` -- pokaz ostatnio wstawiony tekst (`test tekst`)
8. `u` -- cofnij

## Cwiczenie 7: Workflow -- kopiuj slowo, zamien wszedzie

Realistyczny workflow: kopiujesz zmienna i zamieniasz ja w calym pliku.

```python
class PaymentProcessor:
    def process_payment(self, payment_data):
        payment_amount = payment_data["amount"]
        payment_currency = payment_data["currency"]
        payment_method = payment_data["method"]

        if payment_amount <= 0:
            raise ValueError("Invalid payment amount")

        result = self.gateway.charge(
            amount=payment_amount,
            currency=payment_currency,
            method=payment_method,
        )
        return result
```

Zadanie -- zamien `payment` na `transaction`:
1. Kursor na `payment` (dowolne wystapienie). `yiw` -- kopiuj slowo do unnamed
2. `:` -> `%s/` -> `Ctrl+r "` (wkleja `payment`) -> `/transaction/g`
3. Obserwuj podglad inccommand -- wszystkie `payment` -> `transaction`
4. Enter -- wykonaj zamiane
5. `u` -- cofnij

Alternatywny workflow z named register:
1. `"ayiw` -- kopiuj `payment` do rejestru `a`
2. Zrob kilka edycji (`dd`, `cw` itp. -- unnamed register sie zmieni)
3. `:` -> `%s/` -> `Ctrl+r a` (wkleja z rejestru `a`, nie z unnamed!) -> `/transaction/g`

## Cwiczenie 8: Black hole -- bezpieczne usuwanie przy refactoringu

Scenariusz: kopiujesz funkcje i usuwasz stary kod, nie tracac kopii.

```python
def old_implementation():
    """Remove this after copying the useful parts."""
    useful_code = compute_something()
    return useful_code

def replacement():
    """This is the new version."""
    pass  # <- tu wklej useful_code
```

Zadania:
1. Kursor na `useful_code = compute_something()`. `yy` -- kopiuj
2. Kursor na `def old_implementation`. `"_d}` -- usun cala stara funkcje do BLACK HOLE
3. Schowek NIE zmieniony! Kursor na `pass`. `p` -- wklej skopiowana linie pod `pass`
4. `"_dd` -- usun linie z `pass` (znow do black hole, schowek dalej nietkniety)
5. `u` wielokrotnie -- cofnij

## Cwiczenie bonusowe

Otworz `exercises/python/calculator.py` i wykonaj zlozony workflow z rejestrami:

1. Zbierz sygnatury WSZYSTKICH metod klasy `Calculator` do rejestru `m`:
   - Znajdz kazda `def ...` wewnatrz klasy
   - `"myy` na pierwszej, `"Myy` na kazdej nastepnej (append!)
2. Zbierz docstringi do rejestru `d`:
   - Dla kazdej metody: kursor na linii z `"""..."""`, `"Dyy`
3. Wklej zebrane sygnatury na koncu pliku: `G`, `"mp`
4. Pod nimi wklej docstringi: `"dp`
5. Wstaw komentarz z data: `O` -> `# Generated on: ` -> `Ctrl+r =` -> `strftime('%Y-%m-%d')` -> Enter -> `Esc`
6. `u` wielokrotnie -- cofnij wszystko

Wyzwanie: wykonaj cale cwiczenie BEZ uzycia unnamed register (kazda operacja
z named register lub black hole). To wymusza swiadome korzystanie z rejestrow.
