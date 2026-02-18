# Cwiczenie 14: Przesuwanie linii i dot repeat

> Powiazana lekcja: `lessons/14-przesuwanie-repeat.md`

## Instrukcje
- `Alt+j` / `Alt+k` -- przesuwa linie/blok w dol/gore (Normal i Visual)
- `J` -- polacz linie (ze spacja); `gJ` -- polacz bez spacji
- `{count}J` -- polacz N linii
- `.` -- dot repeat: powtarza ostatnia zmiane
- Zmiana = cokolwiek modyfikujace bufor (`d`, `c`, `i...Esc`, `>>`, `p`, `ysiw"`, `gcc`...)
- Motion (`w`, `j`, `/`) to NIE zmiana -- `.` ich nie powtorzy
- Wzorce: `n.` (znajdz + powtorz), `j.` (linia + powtorz), `w.` (slowo + powtorz)

## Cwiczenie 1: Przesuwanie linii w Normal mode

Uzyj `Alt+j` i `Alt+k` aby posortowac linie wedlug priorytetu (od 1 do 5):

```
3. Implement caching layer
5. Update documentation
1. Fix critical login bug
4. Refactor database queries
2. Add input validation
```

1. Kursor na `1. Fix critical...` -- `Alt+k` wielokrotnie az bedzie na gorze
2. Kursor na `2. Add input...` -- `Alt+k` az bedzie pod linia 1
3. Kontynuuj az kolejnosc bedzie 1-5
4. `u` wielokrotnie -- cofnij

## Cwiczenie 2: Przesuwanie blokow w Visual mode

Przesuniemy cala metode w odpowiednie miejsce:

```python
class TaskManager:
    def complete(self, task_id):
        task = self.get(task_id)
        task.status = "done"
        self.save(task)

    def delete(self, task_id):
        task = self.get(task_id)
        self.tasks.remove(task)

    def create(self, title, priority="medium"):
        task = Task(title=title, priority=priority)
        self.tasks.append(task)
        return task

    def get(self, task_id):
        for task in self.tasks:
            if task.id == task_id:
                return task
        return None

    def update(self, task_id, **kwargs):
        task = self.get(task_id)
        for key, value in kwargs.items():
            setattr(task, key, value)
        self.save(task)
```

Cel: posortuj metody logicznie -- `create`, `get`, `update`, `complete`, `delete`.
1. Kursor na `def create` -- `V` -- zaznacz cala metode (4 linie) -- `Alt+k` wielokrotnie az bedzie pierwsza
2. Kursor na `def get` -- `V` -- zaznacz -- `Alt+k` az bedzie za `create`
3. Kontynuuj z `update`, `complete`, `delete`
4. `u` wielokrotnie -- cofnij

## Cwiczenie 3: Laczenie linii -- `J` i `gJ`

Polacz wieloliniowe deklaracje w jednoliniowe:

```typescript
const userQuery = db
    .select("*")
    .from("users")
    .where("active", true)
    .orderBy("name")
    .limit(10);

const headers = {
    "Content-Type":
        "application/json",
    "Authorization":
        "Bearer " + token,
};

const message =
    "Hello, " +
    firstName +
    " " +
    lastName +
    "!";
```

1. Kursor na `const userQuery` -- `6J` -- polacz 6 linii w jedna
2. `u` -- cofnij
3. Kursor na `const message` -- `6J` -- polacz
4. `u` -- cofnij
5. Kursor na `"Content-Type":` -- `gJ` -- polacz bez spacji (porownaj z `J`)
6. `u` -- cofnij

## Cwiczenie 4: Dot repeat z `ciw`

Zmien nazwe zmiennej `data` na `payload` uzywajac `ciw` + `n.`:

```typescript
function processRequest(data: RequestData): Response {
    const validated = validate(data);
    if (!validated) {
        throw new Error("Invalid data");
    }

    const transformed = transform(data);
    const result = save(data);
    logger.info("Processed data:", data.id);

    return {
        data: result,
        timestamp: Date.now(),
    };
}
```

1. `/data<CR>` -- znajdz pierwsze wystapienie
2. `ciw` -- zmien inner word
3. `payload` -- wpisz nowy tekst
4. `Esc`
5. `n` -- nastepne wystapienie
6. `.` -- powtorz zmiane
7. `n` -- nastepne -- zdecyduj: `.` (zamien) lub `n` (pomin) -- np. `data: result` w return moze zostac
8. Kontynuuj `n.` lub `nn` az do konca

## Cwiczenie 5: Dot repeat z `A` -- dodawanie na koncu

Dodaj srednik na koncu kazdej linii:

```go
name := "Alice"
age := 30
city := "Warsaw"
active := true
score := 95.5
level := "senior"
```

1. `A;<Esc>` -- dodaj `;` na koncu pierwszej linii
2. `j.` -- nastepna linia + powtorz
3. `j.j.j.j.` -- kontynuuj na wszystkich liniach

## Cwiczenie 6: Dot repeat z surround

Otocz slowa cudzyslowami uzywajac `ysiw"` + `.`:

```yaml
name: Jan
surname: Kowalski
city: Warsaw
country: Poland
language: Polish
timezone: CET
currency: PLN
```

1. Kursor na `Jan` -- `ysiw"` -- otocz cudzyslowami
2. `j$` -- nastepna linia, koniec linii (kursor na `Kowalski`)
3. `.` -- powtorz otoczenie
4. Kontynuuj `j$.` na kazdej linii

Alternatywnie: `f<Space>w` aby nawigowac do wartosci w kazdej linii.

## Cwiczenie 7: Dot repeat z `I` -- dodawanie na poczatku

Dodaj `- [ ] ` (checkbox markdown) na poczatku kazdej linii:

```
Review pull requests
Update dependencies
Write migration script
Deploy to staging
Run integration tests
Update changelog
Tag release version
```

1. `I- [ ] <Esc>` -- wstaw checkbox na poczatku
2. `j.` -- nastepna linia + powtorz
3. `j.j.j.j.j.` -- kontynuuj

## Cwiczenie 8: Wzorzec `n.` z wyszukiwaniem

Zamien `TODO` na `DONE` ale tylko w wybranych miejscach:

```python
# TODO: add error handling
def fetch_data():
    pass

# TODO: implement caching
def process_data():
    pass

# TODO: add logging
def save_results():
    pass

# TODO: write tests
def validate_input():
    pass

# TODO: optimize query
def search_records():
    pass

# TODO: add retry logic
def send_notification():
    pass
```

1. `/TODO<CR>` -- znajdz pierwsze
2. `ciwDONE<Esc>` -- zmien na DONE
3. `n` -- nastepne -- `TODO: implement caching` -- `.` (zamien)
4. `n` -- nastepne -- `TODO: add logging` -- `n` (pomin -- zostawiamy)
5. `n` -- nastepne -- `.` (zamien)
6. Kontynuuj selektywnie: `n.` lub `nn`

## Cwiczenie bonusowe

**Pelny workflow -- polaczenie lekcji 09-14**:

```typescript
interface user_profile {
    first_name: string
    last_name: string
    email_address: string
    phone_number: string
    date_of_birth: string
    account_status: string
}

function get_user(id) {
    const result = db.query(id)
    console.log(result)
    return result
}

function update_user(id, data) {
    const validated = validate(data)
    console.log(validated)
    db.save(id, validated)
    console.log("saved")
}

function delete_user(id) {
    console.log("deleting", id)
    db.remove(id)
    console.log("deleted")
}
```

1. **Surround (lekcja 09)**: Otocz kazdy typ `string` cudzyslowami -- `ysiw"` + `j.` na kazdej linii
2. **Komentarze (lekcja 10)**: Zakomentuj cala funkcje `delete_user` -- `V` + zaznacz + `gc`
3. **Flash (lekcja 11)**: Uzyj `s` + `get_u` aby przeskoczyc do `get_user`
4. **Substitution (lekcja 13)**: Zamien `console.log` na `logger.debug` -- `:%s/console\.log/logger.debug/g`
5. **Przesuwanie (lekcja 14)**: Przesunimy `update_user` nad `get_user` -- `V` + zaznacz + `Alt+k`
6. **Dot repeat (lekcja 14)**: Dodaj `;` na koncu kazdej linii w interface -- `A;<Esc>` + `j.j.j.j.j.`
7. **Laczenie (lekcja 14)**: Polacz interface w mniej linii -- `J`

**Speed challenge**: Zmierz ile czasu zajmuje Ci zrobienie kroków 1-7. Powtorz 3 razy -- za kazdym razem powinno byc szybciej.
