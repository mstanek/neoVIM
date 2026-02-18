<script setup lang="ts">
/**
 * Intentionally broken Vue SFC for LSP diagnostics practice.
 *
 * Keybindings to practice:
 *   [d / ]d    - navigate between diagnostics
 *   <leader>ld - list diagnostics (Trouble)
 *   <leader>ca - code actions (auto-import, fix type)
 *   K          - hover for type info
 */

import { computed, ref } from "vue";
// ERROR: unused import
import { watch, onMounted, onUnmounted } from "vue";

// ERROR: missing import for 'useRouter'
const router = useRouter();

interface Todo {
  id: number;
  title: string;
  completed: boolean;
}

// ERROR: wrong type annotation (string instead of number)
const count: string = ref(0);

// ERROR: ref used without .value in script
const todos = ref<Todo[]>([]);
const totalCount = todos.length; // should be todos.value.length

// ERROR: computed with wrong return type
const activeTodos = computed((): string => {
  // should return Todo[], not string
  return todos.value.filter((todo) => !todo.completed);
});

// ERROR: function references undefined ref
function addTodo(): void {
  const newTodo: Todo = {
    id: nextId.value, // 'nextId' is not defined
    title: newTitle.value, // 'newTitle' is not defined
    completed: false,
  };
  todos.value.push(newTodo);
}

// ERROR: wrong argument for emit (emit not defined)
function handleClick(id: number): void {
  emit("select", id); // 'emit' is not declared
}

// ERROR: property does not exist on Todo
function formatTodo(todo: Todo): string {
  return `${todo.title} - ${todo.priority}`; // 'priority' does not exist on Todo
}

// ERROR: wrong number of generic arguments
const items = ref<string, number>([]); // ref takes 1 type argument
</script>

<template>
  <div class="todo-app">
    <h1>{{ title }}</h1>
    <!-- ERROR: 'title' is not defined in setup -->

    <!-- ERROR: v-for without :key -->
    <ul>
      <li v-for="todo in todos">
        {{ todo.title }}
      </li>
    </ul>

    <!-- ERROR: wrong event name (should be @click) -->
    <button v-on:clik="addTodo">Dodaj</button>

    <!-- ERROR: v-model on non-existent ref -->
    <input v-model="searchQuery" placeholder="Szukaj..." />

    <!-- ERROR: calling method with wrong args in template -->
    <span>{{ formatTodo("not a todo object") }}</span>

    <!-- ERROR: v-if and v-for on same element -->
    <div v-for="item in items" v-if="item.active" :key="item.id">
      {{ item.name }}
    </div>

    <!-- ERROR: wrong prop binding syntax -->
    <div :class="{ active: isActive }">
      <!-- isActive is not defined -->
      Aktywny element
    </div>
  </div>
</template>

<style scoped>
.todo-app {
  padding: 20px;
}

/* ERROR: referencing class not used in template */
.sidebar {
  width: 200px;
}

/* valid styles */
h1 {
  font-size: 24px;
  margin-bottom: 16px;
}

ul {
  list-style: none;
  padding: 0;
}

li {
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}
</style>
