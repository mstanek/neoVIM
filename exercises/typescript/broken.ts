/**
 * Intentionally broken TypeScript code for LSP diagnostics practice.
 *
 * Keybindings to practice:
 *   [d / ]d    - navigate between diagnostics
 *   <leader>ld - list diagnostics (Trouble)
 *   <leader>ca - code actions
 *   K          - hover for type info
 */

// ERROR: unused imports
import { readFileSync, writeFileSync, existsSync } from "fs";
import { join, resolve, basename } from "path";

// ERROR: duplicate identifier
interface User {
  id: number;
  name: string;
  email: string;
}

// ERROR: missing required properties
const admin: User = {
  id: 1,
  name: "Admin",
  // missing 'email' property
};

// ERROR: wrong generic type argument
function getFirst<T>(items: T[]): T {
  return items[0];
}

const numbers: string = getFirst<number>([1, 2, 3]); // Type 'number' is not assignable to 'string'

// ERROR: property does not exist on type
interface Product {
  id: number;
  name: string;
  price: number;
}

function formatProduct(product: Product): string {
  return `${product.name} - ${product.description}`; // 'description' does not exist
}

// ERROR: argument type mismatch
function calculateTotal(prices: number[]): number {
  return prices.reduce((sum, price) => sum + price, 0);
}

const total = calculateTotal("not an array"); // string is not number[]

// ERROR: unreachable code
function processStatus(status: "active" | "inactive"): string {
  switch (status) {
    case "active":
      return "User is active";
    case "inactive":
      return "User is inactive";
  }
  console.log("This is unreachable"); // unreachable code
  return "unknown";
}

// ERROR: async/await mismatch
function fetchData(): string {
  const response = await fetch("https://api.example.com/data"); // await in non-async
  return response.json();
}

// ERROR: wrong return type
function divide(a: number, b: number): number {
  if (b === 0) {
    return "Cannot divide by zero"; // string is not number
  }
  return a / b;
}

// ERROR: using private member
class BankAccount {
  private balance: number;

  constructor(initial: number) {
    this.balance = initial;
  }

  getBalance(): number {
    return this.balance;
  }
}

const account = new BankAccount(1000);
console.log(account.balance); // 'balance' is private

// ERROR: type narrowing issue
function processValue(value: string | number | null): string {
  // forgot to handle null case
  return value.toString(); // Object is possibly 'null'
}

// ERROR: readonly assignment
interface Config {
  readonly apiUrl: string;
  readonly timeout: number;
}

const config: Config = { apiUrl: "https://api.example.com", timeout: 5000 };
config.apiUrl = "https://other.api.com"; // Cannot assign to readonly property
