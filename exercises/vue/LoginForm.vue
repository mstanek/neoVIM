<script setup lang="ts">
/**
 * LoginForm - form with validation, loading state, error handling.
 *
 * Good for practicing:
 *   - v-model binding navigation
 *   - Template conditional blocks (v-if/v-else)
 *   - Form-related text objects
 */

import { computed, reactive, ref } from "vue";

interface LoginFormData {
  email: string;
  password: string;
  rememberMe: boolean;
}

interface FormErrors {
  email?: string;
  password?: string;
  general?: string;
}

const emit = defineEmits<{
  submit: [data: LoginFormData];
  forgotPassword: [];
  register: [];
}>();

const form = reactive<LoginFormData>({
  email: "",
  password: "",
  rememberMe: false,
});

const errors = reactive<FormErrors>({});
const isLoading = ref(false);
const showPassword = ref(false);
const attemptCount = ref(0);

const isEmailValid = computed((): boolean => {
  const pattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  return pattern.test(form.email);
});

const isPasswordValid = computed((): boolean => {
  return form.password.length >= 8;
});

const isFormValid = computed((): boolean => {
  return isEmailValid.value && isPasswordValid.value;
});

const passwordStrength = computed((): "weak" | "medium" | "strong" => {
  const pwd = form.password;
  if (pwd.length < 8) return "weak";
  const hasUpper = /[A-Z]/.test(pwd);
  const hasLower = /[a-z]/.test(pwd);
  const hasNumber = /[0-9]/.test(pwd);
  const hasSpecial = /[^a-zA-Z0-9]/.test(pwd);
  const score = [hasUpper, hasLower, hasNumber, hasSpecial].filter(Boolean).length;
  if (score >= 3 && pwd.length >= 12) return "strong";
  if (score >= 2) return "medium";
  return "weak";
});

function validateEmail(): void {
  if (!form.email) {
    errors.email = "Adres email jest wymagany";
  } else if (!isEmailValid.value) {
    errors.email = "Podaj poprawny adres email";
  } else {
    errors.email = undefined;
  }
}

function validatePassword(): void {
  if (!form.password) {
    errors.password = "Haslo jest wymagane";
  } else if (form.password.length < 8) {
    errors.password = "Haslo musi miec co najmniej 8 znakow";
  } else {
    errors.password = undefined;
  }
}

async function handleSubmit(): Promise<void> {
  validateEmail();
  validatePassword();

  if (!isFormValid.value) return;

  isLoading.value = true;
  errors.general = undefined;

  try {
    const response = await fetch("/api/auth/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email: form.email,
        password: form.password,
        rememberMe: form.rememberMe,
      }),
    });

    if (!response.ok) {
      const data = await response.json();
      throw new Error(data.message ?? "Logowanie nie powiodlo sie");
    }

    emit("submit", { ...form });
  } catch (err) {
    attemptCount.value++;
    errors.general = err instanceof Error ? err.message : "Nieznany blad";
  } finally {
    isLoading.value = false;
  }
}
</script>

<template>
  <form class="login-form" @submit.prevent="handleSubmit" novalidate>
    <h2 class="login-form__title">Zaloguj sie</h2>

    <!-- General error -->
    <div v-if="errors.general" class="login-form__error-banner" role="alert">
      {{ errors.general }}
      <span v-if="attemptCount >= 3" class="login-form__hint">
        Zapomnialesz hasla?
        <a href="#" @click.prevent="emit('forgotPassword')">Zresetuj je</a>
      </span>
    </div>

    <!-- Email field -->
    <div class="login-form__field" :class="{ 'field--error': errors.email }">
      <label for="login-email">Email</label>
      <input
        id="login-email"
        v-model="form.email"
        type="email"
        placeholder="jan@example.com"
        autocomplete="email"
        :disabled="isLoading"
        @blur="validateEmail"
      />
      <span v-if="errors.email" class="field__error-msg">{{ errors.email }}</span>
    </div>

    <!-- Password field -->
    <div class="login-form__field" :class="{ 'field--error': errors.password }">
      <label for="login-password">Haslo</label>
      <div class="field__input-group">
        <input
          id="login-password"
          v-model="form.password"
          :type="showPassword ? 'text' : 'password'"
          placeholder="Minimum 8 znakow"
          autocomplete="current-password"
          :disabled="isLoading"
          @blur="validatePassword"
        />
        <button
          type="button"
          class="field__toggle-password"
          @click="showPassword = !showPassword"
          :aria-label="showPassword ? 'Ukryj haslo' : 'Pokaz haslo'"
        >
          {{ showPassword ? "Ukryj" : "Pokaz" }}
        </button>
      </div>
      <span v-if="errors.password" class="field__error-msg">{{ errors.password }}</span>
      <div
        v-if="form.password.length > 0"
        class="field__strength"
        :class="`strength--${passwordStrength}`"
      >
        Sila hasla: {{ passwordStrength }}
      </div>
    </div>

    <!-- Remember me -->
    <div class="login-form__checkbox">
      <input
        id="remember-me"
        v-model="form.rememberMe"
        type="checkbox"
        :disabled="isLoading"
      />
      <label for="remember-me">Zapamietaj mnie</label>
    </div>

    <!-- Submit -->
    <button
      type="submit"
      class="login-form__submit"
      :disabled="isLoading || !isFormValid"
    >
      <span v-if="isLoading" class="login-form__spinner" />
      {{ isLoading ? "Logowanie..." : "Zaloguj" }}
    </button>

    <!-- Footer links -->
    <div class="login-form__footer">
      <a href="#" @click.prevent="emit('forgotPassword')">Nie pamietam hasla</a>
      <span class="login-form__separator">|</span>
      <a href="#" @click.prevent="emit('register')">Utworz konto</a>
    </div>
  </form>
</template>

<style scoped>
.login-form {
  max-width: 400px;
  margin: 0 auto;
  padding: 32px;
  background: var(--color-surface, #ffffff);
  border-radius: 12px;
  border: 1px solid var(--color-border, #e2e8f0);
}

.login-form__title {
  margin: 0 0 24px;
  font-size: 24px;
  font-weight: 700;
  text-align: center;
}

.login-form__error-banner {
  padding: 12px;
  margin-bottom: 16px;
  background: #fee2e2;
  color: #dc2626;
  border-radius: 8px;
  font-size: 14px;
}

.login-form__field {
  margin-bottom: 16px;
}

.login-form__field label {
  display: block;
  margin-bottom: 6px;
  font-size: 14px;
  font-weight: 600;
}

.login-form__field input[type="email"],
.login-form__field input[type="password"],
.login-form__field input[type="text"] {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.2s;
}

.field--error input {
  border-color: #dc2626 !important;
}

.field__error-msg {
  display: block;
  margin-top: 4px;
  color: #dc2626;
  font-size: 12px;
}

.field__input-group {
  display: flex;
  gap: 8px;
}

.field__input-group input {
  flex: 1;
}

.field__toggle-password {
  padding: 8px 12px;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: 8px;
  background: #f8fafc;
  cursor: pointer;
  font-size: 12px;
  white-space: nowrap;
}

.field__strength {
  margin-top: 4px;
  font-size: 12px;
}

.strength--weak {
  color: #dc2626;
}
.strength--medium {
  color: #f59e0b;
}
.strength--strong {
  color: #16a34a;
}

.login-form__checkbox {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 20px;
  font-size: 14px;
}

.login-form__submit {
  width: 100%;
  padding: 12px;
  background: var(--color-primary, #6366f1);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.login-form__submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.login-form__spinner {
  width: 16px;
  height: 16px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-top-color: white;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.login-form__footer {
  margin-top: 16px;
  text-align: center;
  font-size: 13px;
}

.login-form__footer a {
  color: var(--color-primary, #6366f1);
  text-decoration: none;
}

.login-form__separator {
  margin: 0 8px;
  color: var(--color-text-muted, #94a3b8);
}
</style>
