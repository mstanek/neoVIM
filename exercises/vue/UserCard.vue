<script setup lang="ts">
/**
 * UserCard - profile card component.
 *
 * Good for practicing:
 *   - Vue SFC section navigation
 *   - Template text objects (it/at for tags)
 *   - Attribute text objects inside tags
 */

import { computed, ref } from "vue";

interface User {
  id: string;
  name: string;
  email: string;
  role: "admin" | "editor" | "viewer";
  avatarUrl?: string;
  bio?: string;
  joinedAt: string;
}

const props = defineProps<{
  user: User;
  showActions?: boolean;
  compact?: boolean;
}>();

const emit = defineEmits<{
  edit: [userId: string];
  delete: [userId: string];
  message: [userId: string];
}>();

const isExpanded = ref(false);

const initials = computed(() => {
  const parts = props.user.name.split(" ");
  return parts
    .map((p) => p[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);
});

const roleLabel = computed(() => {
  const labels: Record<string, string> = {
    admin: "Administrator",
    editor: "Redaktor",
    viewer: "Czytelnik",
  };
  return labels[props.user.role] ?? props.user.role;
});

const joinedDate = computed(() => {
  return new Date(props.user.joinedAt).toLocaleDateString("pl-PL", {
    year: "numeric",
    month: "long",
    day: "numeric",
  });
});

function handleEdit() {
  emit("edit", props.user.id);
}

function handleDelete() {
  emit("delete", props.user.id);
}

function toggleExpand() {
  isExpanded.value = !isExpanded.value;
}
</script>

<template>
  <div
    class="user-card"
    :class="{ 'user-card--compact': compact, 'user-card--expanded': isExpanded }"
  >
    <div class="user-card__header" @click="toggleExpand">
      <div class="user-card__avatar">
        <img
          v-if="user.avatarUrl"
          :src="user.avatarUrl"
          :alt="`Avatar ${user.name}`"
          class="user-card__avatar-img"
        />
        <span v-else class="user-card__initials">{{ initials }}</span>
      </div>

      <div class="user-card__info">
        <h3 class="user-card__name">{{ user.name }}</h3>
        <p class="user-card__email">{{ user.email }}</p>
        <span class="user-card__role" :class="`role--${user.role}`">
          {{ roleLabel }}
        </span>
      </div>
    </div>

    <div v-if="isExpanded && !compact" class="user-card__details">
      <p v-if="user.bio" class="user-card__bio">{{ user.bio }}</p>
      <p class="user-card__joined">Joined: {{ joinedDate }}</p>
    </div>

    <div v-if="showActions" class="user-card__actions">
      <button class="btn btn--primary" @click="emit('message', user.id)">
        Wiadomość
      </button>
      <button class="btn btn--secondary" @click="handleEdit">
        Edytuj
      </button>
      <button class="btn btn--danger" @click="handleDelete">
        Usuń
      </button>
    </div>
  </div>
</template>

<style scoped>
.user-card {
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: 8px;
  padding: 16px;
  background: var(--color-surface, #ffffff);
  transition: box-shadow 0.2s ease;
}

.user-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.user-card--compact {
  padding: 8px 12px;
}

.user-card__header {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.user-card__avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: var(--color-primary, #6366f1);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.user-card__avatar-img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
}

.user-card__initials {
  color: white;
  font-weight: 600;
  font-size: 14px;
}

.user-card__name {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
}

.user-card__email {
  margin: 2px 0 0;
  font-size: 13px;
  color: var(--color-text-muted, #64748b);
}

.user-card__role {
  display: inline-block;
  margin-top: 4px;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.role--admin {
  background: #fee2e2;
  color: #dc2626;
}
.role--editor {
  background: #dbeafe;
  color: #2563eb;
}
.role--viewer {
  background: #f1f5f9;
  color: #64748b;
}

.user-card__details {
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid var(--color-border, #e2e8f0);
}

.user-card__actions {
  display: flex;
  gap: 8px;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid var(--color-border, #e2e8f0);
}

.btn {
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  font-weight: 500;
}

.btn--primary {
  background: var(--color-primary, #6366f1);
  color: white;
}
.btn--secondary {
  background: #f1f5f9;
  color: #334155;
}
.btn--danger {
  background: #fee2e2;
  color: #dc2626;
}
</style>
