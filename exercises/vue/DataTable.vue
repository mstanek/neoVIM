<script setup lang="ts" generic="T extends Record<string, unknown>">
/**
 * DataTable - sortable/filterable data table component.
 *
 * Good for practicing:
 *   - Long template navigation with { } and [[ / ]]
 *   - Complex v-for/v-if structures
 *   - Slot and emit patterns
 *   - Folding sections (zc on script/template/style)
 */

import { computed, ref, watch } from "vue";

interface Column<T> {
  key: keyof T & string;
  label: string;
  sortable?: boolean;
  filterable?: boolean;
  width?: string;
  align?: "left" | "center" | "right";
  formatter?: (value: T[keyof T], row: T) => string;
}

type SortDirection = "asc" | "desc" | null;

interface SortState {
  key: string;
  direction: SortDirection;
}

const props = withDefaults(
  defineProps<{
    columns: Column<T>[];
    data: T[];
    selectable?: boolean;
    striped?: boolean;
    hoverable?: boolean;
    loading?: boolean;
    emptyMessage?: string;
    rowKey?: keyof T & string;
  }>(),
  {
    selectable: false,
    striped: true,
    hoverable: true,
    loading: false,
    emptyMessage: "Brak danych do wyświetlenia",
    rowKey: "id" as keyof T & string,
  },
);

const emit = defineEmits<{
  sort: [key: string, direction: SortDirection];
  filter: [key: string, value: string];
  select: [selectedRows: T[]];
  rowClick: [row: T, index: number];
}>();

const currentSort = ref<SortState>({ key: "", direction: null });
const filterValues = ref<Record<string, string>>({});
const selectedKeys = ref<Set<string>>(new Set());

// ---- Computed ----

const filteredData = computed((): T[] => {
  let result = [...props.data];

  for (const [key, value] of Object.entries(filterValues.value)) {
    if (!value) continue;
    const lowerValue = value.toLowerCase();
    result = result.filter((row) => {
      const cellValue = String(row[key as keyof T] ?? "").toLowerCase();
      return cellValue.includes(lowerValue);
    });
  }

  return result;
});

const sortedData = computed((): T[] => {
  const { key, direction } = currentSort.value;
  if (!key || !direction) return filteredData.value;

  return [...filteredData.value].sort((a, b) => {
    const aVal = a[key as keyof T];
    const bVal = b[key as keyof T];

    if (aVal === bVal) return 0;
    if (aVal === null || aVal === undefined) return 1;
    if (bVal === null || bVal === undefined) return -1;

    const comparison = aVal < bVal ? -1 : 1;
    return direction === "asc" ? comparison : -comparison;
  });
});

const allSelected = computed((): boolean => {
  if (sortedData.value.length === 0) return false;
  return sortedData.value.every((row) =>
    selectedKeys.value.has(String(row[props.rowKey])),
  );
});

const someSelected = computed(
  (): boolean => selectedKeys.value.size > 0 && !allSelected.value,
);

const filterableColumns = computed(() =>
  props.columns.filter((col) => col.filterable),
);

// ---- Methods ----

function handleSort(column: Column<T>): void {
  if (!column.sortable) return;

  const key = column.key;
  let direction: SortDirection;

  if (currentSort.value.key !== key) {
    direction = "asc";
  } else if (currentSort.value.direction === "asc") {
    direction = "desc";
  } else {
    direction = null;
  }

  currentSort.value = { key, direction };
  emit("sort", key, direction);
}

function handleFilter(key: string, value: string): void {
  filterValues.value[key] = value;
  emit("filter", key, value);
}

function toggleSelectAll(): void {
  if (allSelected.value) {
    selectedKeys.value.clear();
  } else {
    for (const row of sortedData.value) {
      selectedKeys.value.add(String(row[props.rowKey]));
    }
  }
  emitSelection();
}

function toggleRow(row: T): void {
  const key = String(row[props.rowKey]);
  if (selectedKeys.value.has(key)) {
    selectedKeys.value.delete(key);
  } else {
    selectedKeys.value.add(key);
  }
  emitSelection();
}

function isRowSelected(row: T): boolean {
  return selectedKeys.value.has(String(row[props.rowKey]));
}

function emitSelection(): void {
  const selected = sortedData.value.filter((row) =>
    selectedKeys.value.has(String(row[props.rowKey])),
  );
  emit("select", selected);
}

function getCellValue(row: T, column: Column<T>): string {
  const value = row[column.key];
  if (column.formatter) {
    return column.formatter(value, row);
  }
  return String(value ?? "");
}

function getSortIcon(column: Column<T>): string {
  if (currentSort.value.key !== column.key) return "?";
  return currentSort.value.direction === "asc" ? "^" : "v";
}

watch(
  () => props.data,
  () => {
    selectedKeys.value.clear();
  },
);
</script>

<template>
  <div class="data-table-wrapper">
    <!-- Filters -->
    <div v-if="filterableColumns.length > 0" class="data-table__filters">
      <div
        v-for="col in filterableColumns"
        :key="col.key"
        class="data-table__filter-item"
      >
        <label :for="`filter-${col.key}`">{{ col.label }}</label>
        <input
          :id="`filter-${col.key}`"
          type="text"
          :placeholder="`Filtruj ${col.label.toLowerCase()}...`"
          :value="filterValues[col.key] ?? ''"
          @input="handleFilter(col.key, ($event.target as HTMLInputElement).value)"
        />
      </div>
    </div>

    <!-- Loading overlay -->
    <div v-if="loading" class="data-table__loading">
      <span class="data-table__spinner" />
      <span>Ladowanie danych...</span>
    </div>

    <!-- Table -->
    <table class="data-table" :class="{ 'data-table--striped': striped }">
      <thead>
        <tr>
          <th v-if="selectable" class="data-table__checkbox-col">
            <input
              type="checkbox"
              :checked="allSelected"
              :indeterminate="someSelected"
              @change="toggleSelectAll"
            />
          </th>
          <th
            v-for="col in columns"
            :key="col.key"
            :style="{ width: col.width, textAlign: col.align ?? 'left' }"
            :class="{ 'data-table__sortable': col.sortable }"
            @click="handleSort(col)"
          >
            {{ col.label }}
            <span v-if="col.sortable" class="data-table__sort-icon">
              {{ getSortIcon(col) }}
            </span>
          </th>
        </tr>
      </thead>

      <tbody>
        <tr v-if="sortedData.length === 0">
          <td :colspan="columns.length + (selectable ? 1 : 0)" class="data-table__empty">
            <slot name="empty">{{ emptyMessage }}</slot>
          </td>
        </tr>

        <tr
          v-for="(row, index) in sortedData"
          :key="String(row[rowKey])"
          :class="{
            'data-table__row--selected': selectable && isRowSelected(row),
            'data-table__row--hoverable': hoverable,
          }"
          @click="emit('rowClick', row, index)"
        >
          <td v-if="selectable" class="data-table__checkbox-col">
            <input
              type="checkbox"
              :checked="isRowSelected(row)"
              @click.stop
              @change="toggleRow(row)"
            />
          </td>
          <td
            v-for="col in columns"
            :key="col.key"
            :style="{ textAlign: col.align ?? 'left' }"
          >
            <slot :name="`cell-${col.key}`" :value="row[col.key]" :row="row">
              {{ getCellValue(row, col) }}
            </slot>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Footer slot -->
    <div v-if="$slots.footer" class="data-table__footer">
      <slot name="footer" :total="sortedData.length" :selected="selectedKeys.size" />
    </div>
  </div>
</template>

<style scoped>
.data-table-wrapper {
  position: relative;
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.data-table th,
.data-table td {
  padding: 10px 12px;
  border-bottom: 1px solid var(--color-border, #e2e8f0);
}

.data-table th {
  background: var(--color-surface-alt, #f8fafc);
  font-weight: 600;
  text-align: left;
  user-select: none;
}

.data-table--striped tbody tr:nth-child(even) {
  background: var(--color-surface-alt, #f8fafc);
}

.data-table__row--hoverable:hover {
  background: var(--color-hover, #f1f5f9);
}

.data-table__row--selected {
  background: var(--color-selected, #eff6ff) !important;
}

.data-table__sortable {
  cursor: pointer;
}

.data-table__sort-icon {
  margin-left: 4px;
  opacity: 0.5;
}

.data-table__empty {
  text-align: center;
  padding: 32px;
  color: var(--color-text-muted, #94a3b8);
}

.data-table__filters {
  display: flex;
  gap: 12px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.data-table__filter-item label {
  display: block;
  font-size: 12px;
  font-weight: 600;
  margin-bottom: 4px;
}

.data-table__filter-item input {
  padding: 6px 10px;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: 6px;
  font-size: 13px;
}

.data-table__checkbox-col {
  width: 40px;
  text-align: center;
}

.data-table__loading {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: rgba(255, 255, 255, 0.8);
  z-index: 10;
}

.data-table__spinner {
  width: 20px;
  height: 20px;
  border: 2px solid #e2e8f0;
  border-top-color: #6366f1;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.data-table__footer {
  padding: 12px;
  font-size: 13px;
  color: var(--color-text-muted, #64748b);
  border-top: 1px solid var(--color-border, #e2e8f0);
}
</style>
