/**
 * User service layer - business logic for user operations.
 *
 * References UserDTO from types.ts - will be affected by rename refactoring.
 */

import type { UserDTO, CreateUserDTO, UpdateUserDTO, UserListDTO } from "./types";

const API_BASE = "/api/v1";

export class UserService {
  private cache: Map<string, UserDTO> = new Map();

  async getAll(): Promise<UserListDTO[]> {
    const response = await fetch(`${API_BASE}/users`);
    const data: UserDTO[] = await response.json();
    data.forEach((user: UserDTO) => this.cache.set(user.id, user));
    return data.map((user: UserDTO) => ({
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
    }));
  }

  async getById(id: string): Promise<UserDTO | null> {
    if (this.cache.has(id)) {
      return this.cache.get(id) as UserDTO;
    }
    const response = await fetch(`${API_BASE}/users/${id}`);
    if (!response.ok) return null;
    const user: UserDTO = await response.json();
    this.cache.set(user.id, user);
    return user;
  }

  async create(data: CreateUserDTO): Promise<UserDTO> {
    const response = await fetch(`${API_BASE}/users`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    const user: UserDTO = await response.json();
    this.cache.set(user.id, user);
    return user;
  }

  async update(id: string, data: UpdateUserDTO): Promise<UserDTO> {
    const response = await fetch(`${API_BASE}/users/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    const user: UserDTO = await response.json();
    this.cache.set(user.id, user);
    return user;
  }

  async delete(id: string): Promise<void> {
    await fetch(`${API_BASE}/users/${id}`, { method: "DELETE" });
    this.cache.delete(id);
  }

  clearCache(): void {
    this.cache.clear();
  }
}
