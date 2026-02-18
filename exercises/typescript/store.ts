/**
 * State management stores (Pinia-like pattern) in TypeScript.
 *
 * Good for practicing:
 *   - Interface/type navigation
 *   - Computed property patterns
 *   - Complex object text objects
 */

import { ref, computed, reactive, type Ref, type ComputedRef } from "vue";

// ---- Types ----

interface UserState {
  currentUser: User | null;
  users: User[];
  isLoading: boolean;
  error: string | null;
}

interface User {
  id: string;
  username: string;
  email: string;
  role: "admin" | "editor" | "viewer";
  preferences: UserPreferences;
}

interface UserPreferences {
  theme: "light" | "dark" | "system";
  language: string;
  notifications: boolean;
  itemsPerPage: number;
}

interface CartItem {
  productId: string;
  name: string;
  price: number;
  quantity: number;
  imageUrl: string;
}

// ---- User Store ----

export function useUserStore() {
  const state = reactive<UserState>({
    currentUser: null,
    users: [],
    isLoading: false,
    error: null,
  });

  // Getters
  const isAuthenticated = computed((): boolean => state.currentUser !== null);

  const isAdmin = computed((): boolean => state.currentUser?.role === "admin");

  const activeUsers = computed((): User[] =>
    state.users.filter((user) => user.role !== "viewer"),
  );

  const userCount = computed((): number => state.users.length);

  // Actions
  async function fetchCurrentUser(): Promise<void> {
    state.isLoading = true;
    state.error = null;
    try {
      const response = await fetch("/api/me");
      if (!response.ok) throw new Error("Failed to fetch user");
      state.currentUser = await response.json();
    } catch (err) {
      state.error = err instanceof Error ? err.message : "Unknown error";
    } finally {
      state.isLoading = false;
    }
  }

  async function login(email: string, password: string): Promise<boolean> {
    state.isLoading = true;
    state.error = null;
    try {
      const response = await fetch("/api/auth/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      });
      if (!response.ok) throw new Error("Invalid credentials");
      state.currentUser = await response.json();
      return true;
    } catch (err) {
      state.error = err instanceof Error ? err.message : "Login failed";
      return false;
    } finally {
      state.isLoading = false;
    }
  }

  function logout(): void {
    state.currentUser = null;
  }

  function updatePreferences(prefs: Partial<UserPreferences>): void {
    if (state.currentUser) {
      state.currentUser.preferences = { ...state.currentUser.preferences, ...prefs };
    }
  }

  return {
    state,
    isAuthenticated,
    isAdmin,
    activeUsers,
    userCount,
    fetchCurrentUser,
    login,
    logout,
    updatePreferences,
  };
}

// ---- Cart Store ----

export function useCartStore() {
  const items: Ref<CartItem[]> = ref([]);
  const isCheckingOut: Ref<boolean> = ref(false);
  const lastError: Ref<string | null> = ref(null);

  // Getters
  const totalItems: ComputedRef<number> = computed(() =>
    items.value.reduce((sum, item) => sum + item.quantity, 0),
  );

  const totalPrice: ComputedRef<number> = computed(() =>
    items.value.reduce((sum, item) => sum + item.price * item.quantity, 0),
  );

  const formattedTotal: ComputedRef<string> = computed(
    () => `$${totalPrice.value.toFixed(2)}`,
  );

  const isEmpty: ComputedRef<boolean> = computed(() => items.value.length === 0);

  // Actions
  function addItem(product: Omit<CartItem, "quantity">, quantity: number = 1): void {
    const existing = items.value.find((item) => item.productId === product.productId);
    if (existing) {
      existing.quantity += quantity;
    } else {
      items.value.push({ ...product, quantity });
    }
  }

  function removeItem(productId: string): void {
    const index = items.value.findIndex((item) => item.productId === productId);
    if (index !== -1) {
      items.value.splice(index, 1);
    }
  }

  function updateQuantity(productId: string, quantity: number): void {
    const item = items.value.find((item) => item.productId === productId);
    if (item) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        item.quantity = quantity;
      }
    }
  }

  function clearCart(): void {
    items.value = [];
  }

  async function checkout(): Promise<boolean> {
    if (isEmpty.value) return false;

    isCheckingOut.value = true;
    lastError.value = null;
    try {
      const response = await fetch("/api/orders", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          items: items.value.map((item) => ({
            productId: item.productId,
            quantity: item.quantity,
          })),
        }),
      });
      if (!response.ok) throw new Error("Checkout failed");
      clearCart();
      return true;
    } catch (err) {
      lastError.value = err instanceof Error ? err.message : "Checkout error";
      return false;
    } finally {
      isCheckingOut.value = false;
    }
  }

  return {
    items,
    isCheckingOut,
    lastError,
    totalItems,
    totalPrice,
    formattedTotal,
    isEmpty,
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
    checkout,
  };
}
