/**
 * Shared DTO types for the application.
 *
 * Practice scenario: Rename UserDTO -> UserEntity using Spectre (nvim-spectre)
 * across all files in this directory.
 */

export interface UserDTO {
  id: string;
  username: string;
  email: string;
  role: "admin" | "editor" | "viewer";
  isActive: boolean;
  createdAt: string;
}

export interface ProductDTO {
  id: string;
  name: string;
  description: string;
  price: number;
  sku: string;
  category: string;
  inStock: boolean;
}

export interface OrderDTO {
  id: string;
  userId: string;
  items: Array<{ productId: string; quantity: number; unitPrice: number }>;
  status: "pending" | "confirmed" | "shipped" | "delivered" | "cancelled";
  total: number;
  createdAt: string;
}

export type CreateUserDTO = Omit<UserDTO, "id" | "createdAt">;
export type UpdateUserDTO = Partial<Omit<UserDTO, "id" | "createdAt">>;
export type UserListDTO = Pick<UserDTO, "id" | "username" | "email" | "role">;
