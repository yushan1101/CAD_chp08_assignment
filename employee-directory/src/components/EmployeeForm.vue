<script setup>
import { ref, watch, computed } from 'vue'

const props = defineProps({
  editingEmployee: { type: Object, default: null }
})

const emit = defineEmits(['save', 'cancel'])

const emptyForm = () => ({
  empId      : '',
  name       : '',
  email      : '',
  department : '',
  position   : '',
  hireDate   : '',
  salary     : '',
  active     : true
})

const form   = ref(emptyForm())
const errors = ref({})

// When parent passes an employee to edit, fill the form
watch(() => props.editingEmployee, (val) => {
  form.value   = val ? { ...val } : emptyForm()
  errors.value = {}
}, { immediate: true })

const isEditing = computed(() => Boolean(props.editingEmployee))

// --- Validation rules ---
const empIdRegex = /^EMP[0-9]{3,5}$/
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function validate() {
  const e = {}

  // Employee ID
  if (!form.value.empId.trim())
    e.empId = 'Employee ID is required.'
  else if (!empIdRegex.test(form.value.empId.trim().toUpperCase()))
    e.empId = 'Format: EMP followed by 3–5 digits (e.g. EMP001).'

  // Name
  if (!form.value.name.trim() || form.value.name.trim().length < 3)
    e.name = 'Name must be at least 3 characters.'

  // Email
  if (!emailRegex.test(form.value.email.trim()))
    e.email = 'Please enter a valid email address.'

  // Department
  if (!form.value.department)
    e.department = 'Please select a department.'

  // Position
  if (!form.value.position.trim())
    e.position = 'Position is required.'

  // Hire Date — required and cannot be in the future
  if (!form.value.hireDate) {
    e.hireDate = 'Hire date is required.'
  } else {
    const today    = new Date()
    today.setHours(0, 0, 0, 0)
    const selected = new Date(form.value.hireDate)
    if (selected > today)
      e.hireDate = 'Hire date cannot be in the future.'
  }

  // Salary
  const salary = Number(form.value.salary)
  if (!form.value.salary || isNaN(salary))
    e.salary = 'Salary is required and must be a number.'
  else if (salary < 1500 || salary > 50000)
    e.salary = 'Salary must be between RM 1,500 and RM 50,000.'

  errors.value = e
  return Object.keys(e).length === 0
}

function onSubmit() {
  if (!validate()) return

  emit('save', {
    ...form.value,
    empId   : form.value.empId.trim().toUpperCase(),
    name    : form.value.name.trim(),
    email   : form.value.email.trim(),
    position: form.value.position.trim(),
    salary  : Number(form.value.salary)
  })

  if (!isEditing.value) form.value = emptyForm()
}

function onCancel() {
  emit('cancel')
  form.value   = emptyForm()
  errors.value = {}
}
</script>

<template>
  <form @submit.prevent="onSubmit" class="employee-form">
    <h3>{{ isEditing ? 'Edit Employee' : 'Add New Employee' }}</h3>

    <!-- Employee ID -->
    <label>Employee ID
      <input v-model.trim="form.empId" placeholder="EMP001" />
      <span v-if="errors.empId" class="err">{{ errors.empId }}</span>
    </label>

    <!-- Full Name -->
    <label>Full Name
      <input v-model.trim="form.name" placeholder="Full name" />
      <span v-if="errors.name" class="err">{{ errors.name }}</span>
    </label>

    <!-- Email -->
    <label>Email
      <input v-model.trim="form.email" type="email" placeholder="email@company.com" />
      <span v-if="errors.email" class="err">{{ errors.email }}</span>
    </label>

    <!-- Department -->
    <label>Department
      <select v-model="form.department">
        <option value="">-- Select Department --</option>
        <option>IT</option>
        <option>HR</option>
        <option>Finance</option>
        <option>Marketing</option>
        <option>Operations</option>
      </select>
      <span v-if="errors.department" class="err">{{ errors.department }}</span>
    </label>

    <!-- Position -->
    <label>Position
      <input v-model.trim="form.position" placeholder="Job title" />
      <span v-if="errors.position" class="err">{{ errors.position }}</span>
    </label>

    <!-- Hire Date -->
    <label>Hire Date
      <input v-model="form.hireDate" type="date" />
      <span v-if="errors.hireDate" class="err">{{ errors.hireDate }}</span>
    </label>

    <!-- Salary -->
    <label>Salary (RM)
      <input v-model.number="form.salary" type="number"
             step="100" min="1500" max="50000"
             placeholder="e.g. 4500" />
      <span v-if="errors.salary" class="err">{{ errors.salary }}</span>
    </label>

    <!-- Active -->
    <label class="check">
      <input type="checkbox" v-model="form.active" /> Active employee
    </label>

    <!-- Buttons -->
    <div class="actions">
      <button type="submit">{{ isEditing ? 'Update' : 'Add Employee' }}</button>
      <button v-if="isEditing" type="button" @click="onCancel">Cancel</button>
    </div>
  </form>
</template>