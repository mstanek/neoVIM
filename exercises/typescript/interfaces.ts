/**
 * TypeScript interfaces and types for practicing navigation and text objects.
 *
 * Good for:
 *   - LSP go-to-definition, find references
 *   - Text objects for generics: ci<, ca<
 *   - Aerial/Namu symbol navigation
 */

// ---- Base types ----

export type UUID = string;
export type ISODateString = string;
export type Email = `${string}@${string}.${string}`;

export type Role = "admin" | "editor" | "viewer" | "guest";
export type OrderStatus = "pending" | "confirmed" | "shipped" | "delivered" | "cancelled";

// ---- Entity interfaces ----

export interface User {
  id: UUID;
  username: string;
  email: Email;
  firstName: string;
  lastName: string;
  role: Role;
  isActive: boolean;
  avatarUrl?: string;
  createdAt: ISODateString;
  updatedAt: ISODateString;
}

export interface Product {
  id: UUID;
  name: string;
  description: string;
  price: number;
  sku: string;
  category: string;
  tags: string[];
  stockQuantity: number;
  isAvailable: boolean;
  images: ProductImage[];
  createdAt: ISODateString;
}

export interface ProductImage {
  url: string;
  alt: string;
  width: number;
  height: number;
  isPrimary: boolean;
}

export interface Order {
  id: UUID;
  userId: UUID;
  items: OrderItem[];
  status: OrderStatus;
  shippingAddress: Address;
  billingAddress: Address;
  total: number;
  notes?: string;
  createdAt: ISODateString;
  updatedAt: ISODateString;
}

export interface OrderItem {
  productId: UUID;
  productName: string;
  quantity: number;
  unitPrice: number;
  totalPrice: number;
}

export interface Address {
  street: string;
  city: string;
  state: string;
  postalCode: string;
  country: string;
}

// ---- Generic API types ----

export interface ApiResponse<T> {
  data: T;
  message: string;
  statusCode: number;
  timestamp: ISODateString;
}

export interface ApiError {
  message: string;
  code: string;
  details?: Record<string, string[]>;
  statusCode: number;
}

export interface PaginatedResponse<T> {
  items: T[];
  page: number;
  perPage: number;
  total: number;
  totalPages: number;
  hasNext: boolean;
  hasPrev: boolean;
}

// ---- Filter and sort types ----

export interface FilterOptions<T> {
  field: keyof T;
  operator: "eq" | "neq" | "gt" | "gte" | "lt" | "lte" | "contains" | "in";
  value: T[keyof T] | T[keyof T][];
}

export interface SortConfig<T> {
  field: keyof T;
  direction: "asc" | "desc";
}

export interface QueryParams<T> {
  filters?: FilterOptions<T>[];
  sort?: SortConfig<T>[];
  page?: number;
  perPage?: number;
  search?: string;
}

// ---- Utility types ----

export type Nullable<T> = T | null;
export type Optional<T> = T | undefined;
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};
export type ReadonlyDeep<T> = {
  readonly [P in keyof T]: T[P] extends object ? ReadonlyDeep<T[P]> : T[P];
};
export type PickRequired<T, K extends keyof T> = T & Required<Pick<T, K>>;

// ---- Theme configuration ----

export interface ThemeColors {
  primary: string;
  secondary: string;
  accent: string;
  background: string;
  surface: string;
  text: string;
  error: string;
  warning: string;
  success: string;
}

export interface Theme {
  name: string;
  isDark: boolean;
  colors: ThemeColors;
  fontFamily: string;
  borderRadius: number;
  spacing: {
    xs: number;
    sm: number;
    md: number;
    lg: number;
    xl: number;
  };
}

// ---- Type guards ----

export function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "username" in value &&
    "email" in value &&
    "role" in value
  );
}

export function isApiError(value: unknown): value is ApiError {
  return (
    typeof value === "object" &&
    value !== null &&
    "code" in value &&
    "statusCode" in value
  );
}
