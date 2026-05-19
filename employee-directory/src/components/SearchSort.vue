<script setup>
import { ref, watch } from 'vue'

const emit = defineEmits(['search'])

const q       = ref('')
const sortBy  = ref('')
const order   = ref('asc')

// Emit whenever any filter changes
watch([q, sortBy, order], () => {
  emit('search', {
    q      : q.value.trim(),
    sortBy : sortBy.value,
    order  : order.value
  })
})

function clearFilters() {
  q.value      = ''
  sortBy.value = ''
  order.value  = 'asc'
}
</script>

<template>
  <div class="search-sort">

    <!-- Search box -->
    <div class="search-box">
      <input
        v-model="q"
        placeholder="Search by name, ID, email, department or position…"
      />
      <button v-if="q" @click="q = ''" class="clear-btn">✕</button>
    </div>

    <!-- Sort controls -->
    <div class="sort-box">
      <select v-model="sortBy">
        <option value="">-- Sort by --</option>
        <option value="name">Name</option>
        <option value="hireDate">Hire Date</option>
        <option value="salary">Salary</option>
        <option value="department">Department</option>
      </select>

      <select v-model="order" :disabled="!sortBy">
        <option value="asc">Ascending</option>
        <option value="desc">Descending</option>
      </select>

      <button @click="clearFilters" class="clear-btn">Clear</button>
    </div>

    </div>
</template>