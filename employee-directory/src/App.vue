<script setup>
import { ref, onMounted } from 'vue'
import EmployeeForm from './components/EmployeeForm.vue'
import EmployeeList from './components/EmployeeList.vue'
import SearchSort   from './components/SearchSort.vue'
import {
  getEmployees,
  createEmployee,
  updateEmployee,
  deleteEmployee
} from './api/employeeApi.js'

const employees       = ref([])
const editingEmployee = ref(null)
const loading         = ref(false)
const errorMsg        = ref('')

// Track active headcount
const activeCount = ref(0)

// --- Load employees (with optional search/sort params) ---
async function load(params = {}) {
  loading.value  = true
  errorMsg.value = ''
  try {
    const { data }    = await getEmployees(params)
    employees.value   = data
    activeCount.value = data.filter(e => e.active).length
  } catch (e) {
    errorMsg.value = e.userMessage || 'Failed to load employees.'
  } finally {
    loading.value = false
  }
}

// --- Handle search/sort from SearchSort component ---
function handleSearch(params) {
  load(params)
}

// --- Handle save (create or update) ---
async function handleSave(payload) {
  errorMsg.value = ''
  try {
    if (editingEmployee.value) {
      await updateEmployee(editingEmployee.value.id, payload)
      editingEmployee.value = null
    } else {
      await createEmployee(payload)
    }
    await load()
  } catch (e) {
    errorMsg.value = e.userMessage || 'Save failed. Check the console.'
  }
}

// --- Handle edit button click ---
function handleEdit(emp) {
  editingEmployee.value = { ...emp }
  // Scroll to form smoothly
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// --- Handle cancel edit ---
function handleCancel() {
  editingEmployee.value = null
  errorMsg.value        = ''
}

// --- Handle delete ---
async function handleDelete(id) {
  if (!confirm('Delete this employee? This cannot be undone.')) return
  errorMsg.value = ''
  try {
    await deleteEmployee(id)
    await load()
  } catch (e) {
    errorMsg.value = e.userMessage || 'Delete failed.'
  }
}

// Load on page mount
onMounted(() => load())
</script>

<template>
  <!-- Header -->
  <header>
    <h1>Employee Directory</h1>
    <p class="subtitle">Vue 3 · Axios · Express · MySQL</p>
  </header>

  <main>
    <!-- Error banner -->
    <p v-if="errorMsg" class="error-banner">⚠ {{ errorMsg }}</p>

    <!-- Active headcount summary -->
    <div class="summary-bar">
      <span>Total Employees: <strong>{{ employees.length }}</strong></span>
      <span>Active: <strong class="active-count">{{ activeCount }}</strong></span>
      <span>Inactive: <strong class="inactive-count">
        {{ employees.length - activeCount }}
      </strong></span>
    </div>

    <!-- Add / Edit Form -->
    <EmployeeForm
      :editingEmployee="editingEmployee"
      @save="handleSave"
      @cancel="handleCancel"
    />

    <!-- Search & Sort -->
    <SearchSort @search="handleSearch" />

    <!-- Loading state -->
    <p v-if="loading" class="loading">Loading employees…</p>

    <!-- Employee table -->
    <EmployeeList
      v-else
      :employees="employees"
      @edit="handleEdit"
      @delete="handleDelete"
    />
  </main>
</template>