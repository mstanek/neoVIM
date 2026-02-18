/**
 * API service with async methods and proper error handling.
 *
 * Good for practicing:
 *   - Class method navigation with Aerial
 *   - Text objects inside function arguments
 *   - LSP go-to-definition on types
 */

import type {
  ApiResponse,
  PaginatedResponse,
  QueryParams,
  User,
  Product,
  Order,
} from "./interfaces";

// ---- Types ----

interface RequestConfig {
  headers?: Record<string, string>;
  timeout?: number;
  signal?: AbortSignal;
}

type HttpMethod = "GET" | "POST" | "PUT" | "PATCH" | "DELETE";

type Interceptor = (config: RequestConfig) => RequestConfig | Promise<RequestConfig>;

class ApiError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public details?: Record<string, string[]>,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

// ---- Service ----

export class ApiService {
  private baseUrl: string;
  private defaultHeaders: Record<string, string>;
  private interceptors: Interceptor[] = [];
  private timeout: number;

  constructor(baseUrl: string, options?: { timeout?: number; token?: string }) {
    this.baseUrl = baseUrl.replace(/\/+$/, "");
    this.timeout = options?.timeout ?? 30_000;
    this.defaultHeaders = {
      "Content-Type": "application/json",
      Accept: "application/json",
    };
    if (options?.token) {
      this.defaultHeaders["Authorization"] = `Bearer ${options.token}`;
    }
  }

  addInterceptor(interceptor: Interceptor): void {
    this.interceptors.push(interceptor);
  }

  private async request<T>(
    method: HttpMethod,
    path: string,
    body?: unknown,
    config?: RequestConfig,
  ): Promise<ApiResponse<T>> {
    let mergedConfig: RequestConfig = {
      headers: { ...this.defaultHeaders, ...config?.headers },
      timeout: config?.timeout ?? this.timeout,
      signal: config?.signal,
    };

    for (const interceptor of this.interceptors) {
      mergedConfig = await interceptor(mergedConfig);
    }

    const url = `${this.baseUrl}${path}`;
    const response = await fetch(url, {
      method,
      headers: mergedConfig.headers,
      body: body ? JSON.stringify(body) : undefined,
      signal: mergedConfig.signal,
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new ApiError(
        error.message ?? `HTTP ${response.status}`,
        response.status,
        error.details,
      );
    }

    return response.json() as Promise<ApiResponse<T>>;
  }

  // ---- User endpoints ----

  async getUsers(params?: QueryParams<User>): Promise<PaginatedResponse<User>> {
    const query = params ? `?${this.buildQuery(params)}` : "";
    const response = await this.request<PaginatedResponse<User>>("GET", `/users${query}`);
    return response.data;
  }

  async getUser(id: string): Promise<User> {
    const response = await this.request<User>("GET", `/users/${id}`);
    return response.data;
  }

  async createUser(data: Omit<User, "id" | "createdAt" | "updatedAt">): Promise<User> {
    const response = await this.request<User>("POST", "/users", data);
    return response.data;
  }

  async updateUser(id: string, data: Partial<User>): Promise<User> {
    const response = await this.request<User>("PATCH", `/users/${id}`, data);
    return response.data;
  }

  async deleteUser(id: string): Promise<void> {
    await this.request<void>("DELETE", `/users/${id}`);
  }

  // ---- Product endpoints ----

  async getProducts(params?: QueryParams<Product>): Promise<PaginatedResponse<Product>> {
    const query = params ? `?${this.buildQuery(params)}` : "";
    const response = await this.request<PaginatedResponse<Product>>("GET", `/products${query}`);
    return response.data;
  }

  async searchProducts(term: string, category?: string): Promise<Product[]> {
    const params = new URLSearchParams({ q: term });
    if (category) params.set("category", category);
    const response = await this.request<Product[]>("GET", `/products/search?${params}`);
    return response.data;
  }

  // ---- Order endpoints ----

  async getOrders(userId: string): Promise<Order[]> {
    const response = await this.request<Order[]>("GET", `/users/${userId}/orders`);
    return response.data;
  }

  async createOrder(order: Omit<Order, "id" | "createdAt" | "updatedAt">): Promise<Order> {
    const response = await this.request<Order>("POST", "/orders", order);
    return response.data;
  }

  // ---- File operations ----

  async uploadFile(file: File, path: string): Promise<{ url: string; size: number }> {
    const formData = new FormData();
    formData.append("file", file);
    formData.append("path", path);

    const url = `${this.baseUrl}/files/upload`;
    const response = await fetch(url, {
      method: "POST",
      headers: { Authorization: this.defaultHeaders["Authorization"] ?? "" },
      body: formData,
    });

    if (!response.ok) {
      throw new ApiError("Upload failed", response.status);
    }

    return response.json();
  }

  async downloadFile(fileId: string): Promise<Blob> {
    const url = `${this.baseUrl}/files/${fileId}/download`;
    const response = await fetch(url, {
      headers: this.defaultHeaders,
    });

    if (!response.ok) {
      throw new ApiError("Download failed", response.status);
    }

    return response.blob();
  }

  // ---- Helpers ----

  private buildQuery(params: QueryParams<unknown>): string {
    const search = new URLSearchParams();
    if (params.page) search.set("page", String(params.page));
    if (params.perPage) search.set("per_page", String(params.perPage));
    if (params.search) search.set("q", params.search);
    if (params.sort?.length) {
      const sortStr = params.sort
        .map((s) => `${String(s.field)}:${s.direction}`)
        .join(",");
      search.set("sort", sortStr);
    }
    return search.toString();
  }
}
