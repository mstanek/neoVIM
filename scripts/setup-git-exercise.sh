#!/bin/bash
set -e

# =============================================================================
# setup-git-exercise.sh
#
# Skrypt tworzący repozytorium git do ćwiczeń operacji gitowych w Neovimie.
# Generuje realistyczną historię commitów z branchami, staged/unstaged changes,
# idealną do nauki:
#   - <leader>gd  (DiffviewOpen)        — podgląd staged/unstaged zmian
#   - <leader>gD  (diff z HEAD)          — porównanie pliku z HEAD
#   - <leader>gb  (git blame)            — kto napisał daną linię
#   - <leader>gg  (lazygit)              — interaktywny UI gita
#   - <leader>gl  (git graph)            — wizualizacja historii branchy
#   - <leader>gh  (file history)         — historia zmian w pliku
#   - <leader>gs  (git status panel)     — panel Staged Changes / Changes
#
# Użycie:
#   ./setup-git-exercise.sh              — pyta przed usunięciem istniejącego repo
#   ./setup-git-exercise.sh --force      — nadpisuje bez pytania
# =============================================================================

REPO_DIR="$HOME/GIT/vim-tutor/exercises/git-exercise/repo"
FORCE=false

# --- Parsowanie argumentów ---
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        -h|--help)
            echo "Użycie: $0 [--force]"
            echo "  --force  Nadpisz istniejące repo bez pytania"
            exit 0
            ;;
        *)
            echo "Nieznany argument: $arg"
            echo "Użycie: $0 [--force]"
            exit 1
            ;;
    esac
done

# --- Kolorowe logi ---
info()  { echo -e "\033[1;34m[INFO]\033[0m  $1"; }
ok()    { echo -e "\033[1;32m[OK]\033[0m    $1"; }
warn()  { echo -e "\033[1;33m[WARN]\033[0m  $1"; }

# --- Czyszczenie istniejącego repo ---
if [ -d "$REPO_DIR" ]; then
    if [ "$FORCE" = true ]; then
        warn "Usuwam istniejące repo: $REPO_DIR"
        rm -rf "$REPO_DIR"
    else
        echo -n "Repo już istnieje w $REPO_DIR. Usunąć i utworzyć od nowa? [t/N] "
        read -r answer
        case "$answer" in
            [tTyY]*)
                warn "Usuwam istniejące repo..."
                rm -rf "$REPO_DIR"
                ;;
            *)
                echo "Przerwano."
                exit 0
                ;;
        esac
    fi
fi

# --- Tworzenie katalogu i inicjalizacja repo ---
info "Tworzę repozytorium w $REPO_DIR"
mkdir -p "$REPO_DIR"
cd "$REPO_DIR"
git init
git branch -M main

# --- Pomocnicza funkcja do commitów z datą ---
# Ustawiamy daty commitów, żeby historia wyglądała realistycznie
COMMIT_DATE="2026-02-10 09:00:00"
commit_with_date() {
    local message="$1"
    local date="$2"
    GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" git commit -m "$message"
}

# =============================================================================
# COMMIT 1: Initial project setup
# =============================================================================
info "Commit 1: Initial project setup"

cat > package.json << 'PJSON'
{
  "name": "user-management-api",
  "version": "1.0.0",
  "description": "REST API for user and product management",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node-dev --respawn src/index.ts",
    "lint": "eslint src/**/*.ts",
    "test": "jest --coverage"
  },
  "dependencies": {
    "express": "^4.18.2",
    "jsonwebtoken": "^9.0.2",
    "bcrypt": "^5.1.1",
    "zod": "^3.22.4",
    "uuid": "^9.0.0"
  },
  "devDependencies": {
    "typescript": "^5.3.3",
    "ts-node-dev": "^2.0.0",
    "@types/express": "^4.17.21",
    "@types/node": "^20.11.5",
    "@types/jsonwebtoken": "^9.0.5",
    "@types/bcrypt": "^5.0.2",
    "jest": "^29.7.0",
    "ts-jest": "^29.1.1",
    "eslint": "^8.56.0"
  }
}
PJSON

cat > tsconfig.json << 'TSCONF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "baseUrl": "./src",
    "paths": {
      "@models/*": ["models/*"],
      "@services/*": ["services/*"],
      "@controllers/*": ["controllers/*"],
      "@utils/*": ["utils/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
TSCONF

mkdir -p src

cat > src/index.ts << 'INDEX'
import express from "express";

const app = express();
const PORT = process.env.PORT ?? 3000;

app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
INDEX

cat > .gitignore << 'GITIGNORE'
node_modules/
dist/
.env
*.log
coverage/
.DS_Store
GITIGNORE

git add -A
commit_with_date "Initial project setup with Express and TypeScript" "2026-02-10 09:00:00"
ok "Commit 1 gotowy"

# =============================================================================
# COMMIT 2: Add user model
# =============================================================================
info "Commit 2: Add user model"

mkdir -p src/models

cat > src/models/user.ts << 'USERMODEL'
import { z } from "zod";

export interface User {
  id: string;
  email: string;
  username: string;
  passwordHash: string;
  role: UserRole;
  createdAt: Date;
  updatedAt: Date;
}

export type UserRole = "admin" | "editor" | "viewer";

export const CreateUserSchema = z.object({
  email: z.string().email("Invalid email adress"),
  username: z
    .string()
    .min(3, "Username must be at least 3 characters")
    .max(30, "Username must be at most 30 characters")
    .regex(/^[a-zA-Z0-9_]+$/, "Username can only contain letters, numbers and underscores"),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .regex(/[A-Z]/, "Password must contain at least one uppercase letter")
    .regex(/[0-9]/, "Password must contain at least one number"),
  role: z.enum(["admin", "editor", "viewer"]).default("viewer"),
});

export const UpdateUserSchema = CreateUserSchema.partial().omit({ password: true });

export type CreateUserDto = z.infer<typeof CreateUserSchema>;
export type UpdateUserDto = z.infer<typeof UpdateUserSchema>;

export function toUserResponse(user: User): Omit<User, "passwordHash"> {
  const { passwordHash: _, ...userResponse } = user;
  return userResponse;
}
USERMODEL

git add -A
commit_with_date "Add user model with Zod validation schemas" "2026-02-10 10:30:00"
ok "Commit 2 gotowy"

# =============================================================================
# COMMIT 3: Add user service
# =============================================================================
info "Commit 3: Add user service"

mkdir -p src/services

cat > src/services/user-service.ts << 'USERSERVICE'
import { v4 as uuidv4 } from "uuid";
import bcrypt from "bcrypt";
import { User, CreateUserDto, UpdateUserDto, UserRole } from "../models/user";

const SALT_ROUNDS = 12;

// Prosty in-memory store (w produkcji byłaby baza danych)
const users: Map<string, User> = new Map();

export class UserService {
  async createUser(dto: CreateUserDto): Promise<User> {
    const existingUser = this.findByEmail(dto.email);
    if (existingUser) {
      throw new Error(`User with email ${dto.email} already exists`);
    }

    const passwordHash = await bcrypt.hash(dto.password, SALT_ROUNDS);
    const now = new Date();

    const user: User = {
      id: uuidv4(),
      email: dto.email,
      username: dto.username,
      passwordHash,
      role: dto.role ?? "viewer",
      createdAt: now,
      updatedAt: now,
    };

    users.set(user.id, user);
    return user;
  }

  async updateUser(id: string, dto: UpdateUserDto): Promise<User> {
    const user = this.findById(id);
    if (!user) {
      throw new Error(`User with id ${id} not found`);
    }

    const updatedUser: User = {
      ...user,
      ...dto,
      updatedAt: new Date(),
    };

    users.set(id, updatedUser);
    return updatedUser;
  }

  async deleteUser(id: string): Promise<boolean> {
    return users.delete(id);
  }

  findById(id: string): User | undefined {
    return users.get(id);
  }

  findByEmail(email: string): User | undefined {
    return Array.from(users.values()).find((u) => u.email === email);
  }

  findAll(role?: UserRole): User[] {
    const allUsers = Array.from(users.values());
    if (role) {
      return allUsers.filter((u) => u.role === role);
    }
    return allUsers;
  }

  async verifyPassword(user: User, password: string): Promise<boolean> {
    return bcrypt.compare(password, user.passwordHash);
  }
}

export const userService = new UserService();
USERSERVICE

git add -A
commit_with_date "Add user service with CRUD operations" "2026-02-10 14:15:00"
ok "Commit 3 gotowy"

# =============================================================================
# COMMIT 4: Add user controller
# =============================================================================
info "Commit 4: Add user controller"

mkdir -p src/controllers

cat > src/controllers/user-controller.ts << 'USERCTRL'
import { Router, Request, Response } from "express";
import { userService } from "../services/user-service";
import { CreateUserSchema, UpdateUserSchema, toUserResponse } from "../models/user";
import { ZodError } from "zod";

const router = Router();

router.get("/", async (_req: Request, res: Response) => {
  try {
    const role = _req.query.role as string | undefined;
    const users = userService.findAll(role as any);
    res.json(users.map(toUserResponse));
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

router.get("/:id", async (req: Request, res: Response) => {
  try {
    const user = userService.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(toUserResponse(user));
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

router.post("/", async (req: Request, res: Response) => {
  try {
    const dto = CreateUserSchema.parse(req.body);
    const user = await userService.createUser(dto);
    res.status(201).json(toUserResponse(user));
  } catch (error) {
    if (error instanceof ZodError) {
      return res.status(400).json({
        error: "Validation failed",
        details: error.errors.map((e) => ({
          field: e.path.join("."),
          message: e.message,
        })),
      });
    }
    if (error instanceof Error && error.message.includes("already exists")) {
      return res.status(409).json({ error: error.message });
    }
    res.status(500).json({ error: "Internal server error" });
  }
});

router.patch("/:id", async (req: Request, res: Response) => {
  try {
    const dto = UpdateUserSchema.parse(req.body);
    const user = await userService.updateUser(req.params.id, dto);
    res.json(toUserResponse(user));
  } catch (error) {
    if (error instanceof ZodError) {
      return res.status(400).json({
        error: "Validation failed",
        details: error.errors.map((e) => ({
          field: e.path.join("."),
          message: e.message,
        })),
      });
    }
    if (error instanceof Error && error.message.includes("not found")) {
      return res.status(404).json({ error: error.message });
    }
    res.status(500).json({ error: "Internal server error" });
  }
});

router.delete("/:id", async (req: Request, res: Response) => {
  try {
    const deleted = await userService.deleteUser(req.params.id);
    if (!deleted) {
      return res.status(404).json({ error: "User not found" });
    }
    res.status(204).send();
  } catch (error) {
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
USERCTRL

# Zaktualizuj index.ts żeby podłączyć router
cat > src/index.ts << 'INDEX2'
import express from "express";
import userRouter from "./controllers/user-controller";

const app = express();
const PORT = process.env.PORT ?? 3000;

app.use(express.json());

app.get("/health", (_req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

app.use("/api/users", userRouter);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
INDEX2

git add -A
commit_with_date "Add user controller with REST endpoints" "2026-02-11 09:45:00"
ok "Commit 4 gotowy"

# =============================================================================
# COMMIT 5: Add validation utils
# =============================================================================
info "Commit 5: Add validation utils"

mkdir -p src/utils

cat > src/utils/validation.ts << 'VALIDATION'
/**
 * Utility functions for input validation and sanitization.
 * Used across controllers for request preprocessing.
 */

export function sanitizeEmail(email: string): string {
  return email.trim().toLowerCase();
}

export function isStrongPassword(password: string): boolean {
  const minLength = 8;
  const hasUpperCase = /[A-Z]/.test(password);
  const hasLowerCase = /[a-z]/.test(password);
  const hasNumbers = /\d/.test(password);
  const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(password);

  return (
    password.length >= minLength &&
    hasUpperCase &&
    hasLowerCase &&
    hasNumbers &&
    hasSpecialChar
  );
}

export function sanitizeUsername(username: string): string {
  return username.trim().replace(/[^a-zA-Z0-9_]/g, "");
}

export function isValidUUID(id: string): boolean {
  const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
  return uuidRegex.test(id);
}

export function paginationDefaults(query: {
  page?: string;
  limit?: string;
}): { page: number; limit: number; offset: number } {
  const page = Math.max(1, parseInt(query.page ?? "1", 10) || 1);
  const limit = Math.min(100, Math.max(1, parseInt(query.limit ?? "20", 10) || 20));
  const offset = (page - 1) * limit;
  return { page, limit, offset };
}
VALIDATION

git add -A
commit_with_date "Add validation and sanitization utilities" "2026-02-11 11:20:00"
ok "Commit 5 gotowy"

# =============================================================================
# BRANCH: feature/add-auth (odgałęzienie od commit 5)
# =============================================================================
info "Tworzę branch feature/add-auth z 3 commitami"

git checkout -b feature/add-auth

# --- Auth commit 1: Token utils ---
mkdir -p src/utils

cat > src/utils/token.ts << 'TOKEN'
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET ?? "dev-secret-change-in-production";
const ACCESS_TOKEN_TTL = "15m";
const REFRESH_TOKEN_TTL = "7d";

export interface TokenPayload {
  userId: string;
  email: string;
  role: string;
}

export function generateAccessToken(payload: TokenPayload): string {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: ACCESS_TOKEN_TTL });
}

export function generateRefreshToken(payload: TokenPayload): string {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: REFRESH_TOKEN_TTL });
}

export function verifyToken(token: string): TokenPayload {
  return jwt.verify(token, JWT_SECRET) as TokenPayload;
}

export function generateTokenPair(payload: TokenPayload): {
  accessToken: string;
  refreshToken: string;
} {
  return {
    accessToken: generateAccessToken(payload),
    refreshToken: generateRefreshToken(payload),
  };
}
TOKEN

git add -A
commit_with_date "Add JWT token generation and verification utils" "2026-02-12 10:00:00"

# --- Auth commit 2: Auth middleware ---
mkdir -p src/middleware

cat > src/middleware/auth.ts << 'AUTHMW'
import { Request, Response, NextFunction } from "express";
import { verifyToken, TokenPayload } from "../utils/token";

declare global {
  namespace Express {
    interface Request {
      user?: TokenPayload;
    }
  }
}

export function authenticate(req: Request, res: Response, next: NextFunction): void {
  const authHeader = req.headers.authorization;

  if (!authHeader?.startsWith("Bearer ")) {
    res.status(401).json({ error: "Missing or invalid authorization header" });
    return;
  }

  const token = authHeader.slice(7);

  try {
    const payload = verifyToken(token);
    req.user = payload;
    next();
  } catch {
    res.status(401).json({ error: "Invalid or expired token" });
  }
}

export function authorize(...allowedRoles: string[]) {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({ error: "Not authenticated" });
      return;
    }

    if (!allowedRoles.includes(req.user.role)) {
      res.status(403).json({ error: "Insufficient permissions" });
      return;
    }

    next();
  };
}
AUTHMW

git add -A
commit_with_date "Add authentication and authorization middleware" "2026-02-12 11:30:00"

# --- Auth commit 3: Login endpoint ---
cat > src/controllers/auth-controller.ts << 'AUTHCTRL'
import { Router, Request, Response } from "express";
import { z } from "zod";
import { userService } from "../services/user-service";
import { generateTokenPair } from "../utils/token";

const router = Router();

const LoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1, "Password is required"),
});

const RefreshSchema = z.object({
  refreshToken: z.string().min(1, "Refresh token is required"),
});

router.post("/login", async (req: Request, res: Response) => {
  try {
    const { email, password } = LoginSchema.parse(req.body);

    const user = userService.findByEmail(email);
    if (!user) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const isValid = await userService.verifyPassword(user, password);
    if (!isValid) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const tokens = generateTokenPair({
      userId: user.id,
      email: user.email,
      role: user.role,
    });

    res.json({
      user: { id: user.id, email: user.email, role: user.role },
      ...tokens,
    });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ error: "Invalid request body" });
    }
    res.status(500).json({ error: "Internal server error" });
  }
});

router.post("/refresh", async (req: Request, res: Response) => {
  try {
    const { refreshToken } = RefreshSchema.parse(req.body);
    // W produkcji: weryfikacja refresh tokena, rotacja tokenów, blacklista
    void refreshToken;
    res.status(501).json({ error: "Token refresh not yet implemented" });
  } catch {
    res.status(400).json({ error: "Invalid request body" });
  }
});

export default router;
AUTHCTRL

git add -A
commit_with_date "Add login and token refresh endpoints" "2026-02-12 14:00:00"

ok "Branch feature/add-auth gotowy (3 commity)"

# =============================================================================
# Powrót na main i kontynuacja commitów
# =============================================================================
git checkout main

# =============================================================================
# COMMIT 6: Fix typo in user model
# =============================================================================
info "Commit 6: Fix typo in user model"

# Poprawiamy "adress" -> "address" w walidacji emaila
sed -i '' 's/Invalid email adress/Invalid email address/' src/models/user.ts

git add -A
commit_with_date "Fix typo in email validation error message" "2026-02-12 16:00:00"
ok "Commit 6 gotowy"

# =============================================================================
# COMMIT 7: Add product model
# =============================================================================
info "Commit 7: Add product model"

cat > src/models/product.ts << 'PRODUCT'
import { z } from "zod";

export interface Product {
  id: string;
  name: string;
  description: string;
  price: number;
  currency: Currency;
  category: ProductCategory;
  stock: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export type Currency = "USD" | "EUR" | "GBP" | "PLN";

export type ProductCategory =
  | "electronics"
  | "clothing"
  | "books"
  | "food"
  | "other";

export const CreateProductSchema = z.object({
  name: z
    .string()
    .min(2, "Product name must be at least 2 characters")
    .max(200, "Product name must be at most 200 characters"),
  description: z
    .string()
    .max(2000, "Description must be at most 2000 characters")
    .default(""),
  price: z
    .number()
    .positive("Price must be positive")
    .multipleOf(0.01, "Price must have at most 2 decimal places"),
  currency: z.enum(["USD", "EUR", "GBP", "PLN"]).default("USD"),
  category: z
    .enum(["electronics", "clothing", "books", "food", "other"])
    .default("other"),
  stock: z.number().int().nonnegative("Stock cannot be negative").default(0),
  isActive: z.boolean().default(true),
});

export const UpdateProductSchema = CreateProductSchema.partial();

export type CreateProductDto = z.infer<typeof CreateProductSchema>;
export type UpdateProductDto = z.infer<typeof UpdateProductSchema>;

export function formatPrice(price: number, currency: Currency): string {
  const symbols: Record<Currency, string> = {
    USD: "$",
    EUR: "\u20ac",
    GBP: "\u00a3",
    PLN: "z\u0142",
  };
  return `${symbols[currency]}${price.toFixed(2)}`;
}
PRODUCT

git add -A
commit_with_date "Add product model with pricing and category support" "2026-02-13 10:00:00"
ok "Commit 7 gotowy"

# =============================================================================
# COMMIT 8: Refactor user service (zmiana sygnatur metod)
# =============================================================================
info "Commit 8: Refactor user service"

cat > src/services/user-service.ts << 'USERSERVICE2'
import { v4 as uuidv4 } from "uuid";
import bcrypt from "bcrypt";
import { User, CreateUserDto, UpdateUserDto, UserRole } from "../models/user";

const SALT_ROUNDS = 12;

// Prosty in-memory store (w produkcji byłaby baza danych)
const users: Map<string, User> = new Map();

export interface PaginatedResult<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  hasNext: boolean;
}

export interface FindUsersOptions {
  role?: UserRole;
  page?: number;
  limit?: number;
  sortBy?: keyof User;
  sortOrder?: "asc" | "desc";
}

export class UserService {
  async createUser(dto: CreateUserDto): Promise<User> {
    const existingUser = await this.findByEmail(dto.email);
    if (existingUser) {
      throw new Error(`User with email ${dto.email} already exists`);
    }

    const passwordHash = await bcrypt.hash(dto.password, SALT_ROUNDS);
    const now = new Date();

    const user: User = {
      id: uuidv4(),
      email: dto.email,
      username: dto.username,
      passwordHash,
      role: dto.role ?? "viewer",
      createdAt: now,
      updatedAt: now,
    };

    users.set(user.id, user);
    return user;
  }

  async updateUser(id: string, dto: UpdateUserDto): Promise<User> {
    const user = await this.findById(id);
    if (!user) {
      throw new Error(`User with id ${id} not found`);
    }

    const updatedUser: User = {
      ...user,
      ...dto,
      updatedAt: new Date(),
    };

    users.set(id, updatedUser);
    return updatedUser;
  }

  async deleteUser(id: string): Promise<boolean> {
    return users.delete(id);
  }

  async findById(id: string): Promise<User | undefined> {
    return users.get(id);
  }

  async findByEmail(email: string): Promise<User | undefined> {
    return Array.from(users.values()).find((u) => u.email === email);
  }

  async findAll(options: FindUsersOptions = {}): Promise<PaginatedResult<User>> {
    const { role, page = 1, limit = 20, sortBy = "createdAt", sortOrder = "desc" } = options;

    let allUsers = Array.from(users.values());

    if (role) {
      allUsers = allUsers.filter((u) => u.role === role);
    }

    allUsers.sort((a, b) => {
      const aVal = a[sortBy];
      const bVal = b[sortBy];
      const compare = aVal < bVal ? -1 : aVal > bVal ? 1 : 0;
      return sortOrder === "asc" ? compare : -compare;
    });

    const total = allUsers.length;
    const offset = (page - 1) * limit;
    const data = allUsers.slice(offset, offset + limit);

    return {
      data,
      total,
      page,
      limit,
      hasNext: offset + limit < total,
    };
  }

  async verifyPassword(user: User, password: string): Promise<boolean> {
    return bcrypt.compare(password, user.passwordHash);
  }

  async countByRole(): Promise<Record<UserRole, number>> {
    const counts: Record<UserRole, number> = { admin: 0, editor: 0, viewer: 0 };
    for (const user of users.values()) {
      counts[user.role]++;
    }
    return counts;
  }
}

export const userService = new UserService();
USERSERVICE2

git add -A
commit_with_date "Refactor user service to async methods with pagination" "2026-02-13 15:30:00"
ok "Commit 8 gotowy"

# =============================================================================
# UNSTAGED CHANGES — zmodyfikowany user-service.ts
# Dodajemy nową metodę i komentarz, żeby było widać w git diff
# =============================================================================
info "Dodaję unstaged changes do user-service.ts"

cat >> src/services/user-service.ts << 'UNSTAGED'

// TODO: Add caching layer for frequently accessed users
export class UserCache {
  private cache: Map<string, { user: User; expiresAt: number }> = new Map();
  private readonly ttlMs: number;

  constructor(ttlMs: number = 5 * 60 * 1000) {
    this.ttlMs = ttlMs;
  }

  get(id: string): User | undefined {
    const entry = this.cache.get(id);
    if (!entry) return undefined;
    if (Date.now() > entry.expiresAt) {
      this.cache.delete(id);
      return undefined;
    }
    return entry.user;
  }

  set(user: User): void {
    this.cache.set(user.id, {
      user,
      expiresAt: Date.now() + this.ttlMs,
    });
  }

  invalidate(id: string): void {
    this.cache.delete(id);
  }

  clear(): void {
    this.cache.clear();
  }
}
UNSTAGED

# =============================================================================
# STAGED CHANGES — zmodyfikowany validation.ts
# Dodajemy nowe funkcje walidacyjne do staged area
# =============================================================================
info "Dodaję staged changes do validation.ts"

cat >> src/utils/validation.ts << 'STAGED'

/**
 * Validate and parse a date string in ISO 8601 format.
 * Returns null if the date is invalid.
 */
export function parseISODate(dateStr: string): Date | null {
  const date = new Date(dateStr);
  if (isNaN(date.getTime())) {
    return null;
  }
  return date;
}

/**
 * Check if a string is a valid slug (URL-friendly identifier).
 */
export function isValidSlug(slug: string): boolean {
  return /^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(slug);
}

/**
 * Truncate a string to a maximum length, adding ellipsis if needed.
 */
export function truncate(str: string, maxLength: number): string {
  if (str.length <= maxLength) return str;
  return str.slice(0, maxLength - 3) + "...";
}
STAGED

git add src/utils/validation.ts

# =============================================================================
# Podsumowanie
# =============================================================================
echo ""
echo "============================================="
ok "Repozytorium git-exercise gotowe!"
echo "============================================="
echo ""
info "Lokalizacja: $REPO_DIR"
echo ""
info "Struktura:"
echo "  main (8 commitow):"
echo "    1. Initial project setup"
echo "    2. Add user model"
echo "    3. Add user service"
echo "    4. Add user controller"
echo "    5. Add validation utils"
echo "    6. Fix typo in user model"
echo "    7. Add product model"
echo "    8. Refactor user service"
echo ""
echo "  feature/add-auth (3 commity, odgaleziony od commit 5):"
echo "    1. JWT token utils"
echo "    2. Auth middleware"
echo "    3. Login endpoint"
echo ""
info "Stan working directory:"
echo "  - Unstaged: src/services/user-service.ts (nowa klasa UserCache)"
echo "  - Staged:   src/utils/validation.ts (nowe funkcje walidacyjne)"
echo ""
info "Cwiczenia do wykonania w Neovimie:"
echo "  cd $REPO_DIR && nvim ."
echo ""
echo "  <leader>gd  - DiffviewOpen (podglad staged/unstaged zmian)"
echo "  <leader>gD  - Diff biezacego pliku z HEAD"
echo "  <leader>gb  - Git blame (kto napisal dana linie)"
echo "  <leader>gg  - Lazygit (interaktywny UI gita)"
echo "  <leader>gl  - Git graph (wizualizacja branchy)"
echo "  <leader>gh  - Historia zmian pliku"
echo "  <leader>gs  - Git status panel (Staged / Changes)"
echo ""
