# Cwiczenie 02: Ruchy (motions)

> Powiazana lekcja: `lessons/02-ruchy.md`

## Instrukcje
- Slowa: `w`/`b`/`e`/`ge` (word), `W`/`B`/`E`/`gE` (WORD)
- Linia: `0` (poczatek), `^` (pierwszy znak), `$` (koniec), `g_` (ostatni znak)
- Plik: `gg` (poczatek), `G` (koniec), `{n}G` (linia n), `Ctrl+d`/`Ctrl+u`
- Paragraf: `{` (poprzedni), `}` (nastepny)
- Szukanie znaku: `f{c}`/`F{c}` (do znaku), `t{c}`/`T{c}` (przed znak), `;`/`,`
- Para: `%` (matchujacy nawias)
- Ekran: `H`/`M`/`L`, `zz`/`zt`/`zb`

## Cwiczenie 1: word vs WORD -- nawigacja po kodzie

Ustaw kursor na poczatku kazdej linii i policz ile razy musisz nacisnac `w` vs `W`
zeby dojsc do konca. Zapisz wyniki.

```typescript
const apiUrl = "https://api.example.com/v2/users?active=true&page=1";
const selector = document.querySelector('.user-card[data-id="42"]');
const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const cmd = `docker run --rm -v $(pwd):/app -p 8080:3000 my-image:latest`;
```

Linia 1 -- `w`: ___ razy, `W`: ___ razy
Linia 2 -- `w`: ___ razy, `W`: ___ razy

Tip: `W` jest znacznie szybszy na dlugich wyrazeniach z interpunkcja.

## Cwiczenie 2: Precyzyjna nawigacja f/t z powtarzaniem

W kazdej linii ponizej wykonaj podane zadanie:

```python
prices = [10.50, 20.75, 30.00, 45.25, 99.99, 15.80, 67.30]
config = {"host": "localhost", "port": 5432, "name": "mydb", "pool": 10}
path = "/home/user/.config/nvim/lua/plugins/telescope.lua"
sql = "SELECT id, name, email FROM users WHERE status = 'active' ORDER BY name"
```

Zadania:
1. Linia 1: Ustaw kursor na `[`. Uzyj `f,` + `;` zeby przeskoczyc do 4. przecinka
2. Linia 2: Z poczatku linii uzyj `f"` + `;` zeby dojsc do `"port"` (ktory cudzyslow to bedzie?)
3. Linia 3: Z poczatku uzyj `f/` + `;` zeby przeskoczyc po slashach -- policz ile ich jest
4. Linia 4: Z poczatku uzyj `f,` + `;`;`;` zeby dojsc do 3. przecinka

## Cwiczenie 3: f vs t -- roznica w praktyce

Ponizszy kod zawiera bledy. Uzyj `t` i `f` z operatorami (nastepna lekcja),
ale na razie cwicz same ruchy -- ustaw kursor i sprawdz GDZIE laduje.

```javascript
function greet(firstName, lastName, title) {
    return `${title}. ${firstName} ${lastName}`;
}

const items = [apple, banana, cherry, date, elderberry];
const text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit";
```

Zadania (ustaw kursor na poczatku kazdej linii):
1. `f(` -- kursor laduje NA `(`. Teraz `f,` -- na pierwszym przecinku wewnatrz nawiasow
2. `t(` -- kursor laduje PRZED `(`. Roznica 1 znak -- kluczowa przy `dt(`, `ct(`
3. Na linii z `items`: `f[` potem `f,` + `;` + `;` -- trzeci przecinek
4. Na linii z `text`: `f"` -- na otwierajacym `"`. Potem `f"` ponownie -- ERROR: nie znajdzie!
   Uzyj `;` zamiast powtornego `f"` -- `;` kontynuuje ostatni find

## Cwiczenie 4: Nawigacja 0/^/$ po kodzie z wcieciami

Nawiguj w kazdej linii pomiedzy trzema pozycjami. Zapisz jaki znak jest pod kursorem.

```python
    def calculate_discount(self, price, percentage):
        if percentage > 100:
            raise ValueError("Discount cannot exceed 100%")
        discounted = price * (1 - percentage / 100)
        return round(discounted, 2)
```

Dla linii `        if percentage > 100:`:
- `0` -- kursor na: _____ (spacja)
- `^` -- kursor na: _____ (litera `i` w `if`)
- `$` -- kursor na: _____ (`:`)

Cwicz: na kazdej linii nacisnij `0`, `^`, `$` i obserwuj roznice.

## Cwiczenie 5: Nawigacja {/} po blokach kodu

Uzyj `}` zeby przeskakiwac miedzy blokami kodu. Policz ile razy musisz nacisnac `}`
zeby dojsc od `class TaskManager` do `def cancel_task`.

```python
class TaskManager:
    def __init__(self):
        self.tasks = []
        self.completed = []

    def add_task(self, title, priority="medium"):
        task = {"title": title, "priority": priority, "status": "pending"}
        self.tasks.append(task)
        return task

    def complete_task(self, title):
        for task in self.tasks:
            if task["title"] == title:
                task["status"] = "done"
                self.tasks.remove(task)
                self.completed.append(task)
                return True
        return False

    def get_pending(self):
        return [t for t in self.tasks if t["status"] == "pending"]

    def cancel_task(self, title):
        self.tasks = [t for t in self.tasks if t["title"] != title]
```

Odpowiedz: `}` nacisniety ___ razy.

## Cwiczenie 6: Matchujace nawiasy z %

Ustaw kursor na otwarciu kazdego nawiasu i nacisnij `%`. Sprawdz czy kursor
przeskakuje na poprawny zamykajacy nawias.

```typescript
const result = calculate(
  getPrice(items.filter(
    (item) => item.quantity > 0 && isAvailable(item.id)
  ).map(item => item.price)),
  getTaxRate({ country: "PL", type: "VAT" })
);

interface Config {
  database: {
    connection: {
      host: string;
      port: number;
    };
    pool: {
      min: number;
      max: number;
    };
  };
}
```

Zadania:
1. Ustaw kursor na `(` po `calculate` -- `%` przeskoczy na `)` przed `;`
2. Ustaw kursor na `(` po `filter` -- `%` przeskoczy na `)` przed `.map`
3. Ustaw kursor na `{` po `Config` -- `%` przeskoczy na koncowe `}`
4. Cwicz: `%` tam i z powrotem kilka razy na kazdej parze

## Cwiczenie 7: Scroll i pozycja ekranu

Otworz plik `exercises/python/calculator.py` i wykonaj:

1. `gg` -- poczatek pliku
2. `Ctrl+d` -- pol ekranu w dol. Zapamietaj numer linii: ___
3. `Ctrl+d` -- jeszcze raz. Numer linii: ___
4. `zz` -- wycentruj ekran na biezacej linii
5. `H` -- kursor na gorze ekranu (ale nie na linii 1 -- na gorze WIDOCZNEGO okna)
6. `L` -- kursor na dole ekranu
7. `M` -- kursor na srodku
8. `zt` -- biezaca linia na gorze ekranu
9. `zb` -- biezaca linia na dole ekranu
10. `50G` -- skocz do linii 50
11. `zz` -- wycentruj
12. `20G` -- skocz do linii 20

Obserwuj jak `scrolloff=8` wplywa na pozycje kursora przy `H` i `L`.

## Cwiczenie bonusowe

Otworz `exercises/python/models.py` i nawiguj po pliku uzywajac WYLACZNIE motions z tej lekcji.
Zadnych strzalek, zadnego wyszukiwania `/`.

1. `gg` -- poczatek pliku
2. Uzyj `}` zeby dojsc do klasy `Product`
3. Wewnatrz klasy uzyj `f"` + `;` zeby znalezc wszystkie stringi w cudzyslowach
4. `}` do nastepnej klasy -- `OrderItem`
5. W linii `def subtotal` uzyj `f(`, `%` zeby przeskoczyc miedzy nawiasami
6. `{` kilka razy zeby wrocic do poczatku `Product`
7. `G` -- koniec pliku
8. `50%` -- polowa pliku
9. `gg` -- poczatek

Wyzwanie: nawiguj od poczatku do konca pliku uzywajac TYLKO `w`, `b`, `}`, `{`, `f`, `;`,
`gg`, `G` -- bez `h/j/k/l`!
