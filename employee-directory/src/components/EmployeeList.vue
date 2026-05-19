<script setup>
defineProps({ employees: { type: Array, required: true } })

const emit = defineEmits(['edit', 'delete'])

// Format salary as Malaysian Ringgit
const formatSalary = (amount) =>
  new Intl.NumberFormat('ms-MY', {
    style   : 'currency',
    currency: 'MYR'
  }).format(amount)

// Format date from MySQL (2021-03-15 → 15 Mar 2021)
const formatDate = (date) =>
  new Date(date).toLocaleDateString('en-MY', {
    day  : 'numeric',
    month: 'short',
    year : 'numeric'
  })
</script>

<template>
  <!-- Empty state -->
  <div v-if="!employees.length" class="empty">
    No employees found. Add one above or clear the search filter.
  </div>

  <!-- Table -->
  <div v-else class="table-wrapper">
    <table class="employee-table">
      <thead>
        <tr>
          <th>Emp ID</th>
          <th>Name</th>
          <th>Department</th>
          <th>Position</th>
          <th>Hire Date</th>
          <th>Salary</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="emp in employees" :key="emp.id">

          <td><code>{{ emp.empId }}</code></td>

          <td>
            <strong>{{ emp.name }}</strong>
            <div class="muted">{{ emp.email }}</div>
          </td>

          <td>{{ emp.department }}</td>
          <td>{{ emp.position }}</td>
          <td>{{ formatDate(emp.hireDate) }}</td>
          <td>{{ formatSalary(emp.salary) }}</td>

          <td>
            <span :class="emp.active ? 'badge ok' : 'badge no'">
              {{ emp.active ? 'Active' : 'Inactive' }}
            </span>
          </td>

          <td class="action-btns">
            <button @click="emit('edit', emp)">Edit</button>
            <button class="danger" @click="emit('delete', emp.id)">Delete</button>
          </td>

        </tr>
      </tbody>
    </table>
  </div>
</template>