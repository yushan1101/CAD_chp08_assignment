// src/api/employeeApi.js
import axios from 'axios'

// 1. Single pre-configured Axios instance
const apiClient = axios.create({
  baseURL : 'http://localhost:3001',
  timeout : 5000,
  headers : {
    'Content-Type': 'application/json',
    Accept        : 'application/json'
  }
})

// 2. Request interceptor — logs every outgoing request
apiClient.interceptors.request.use(
  (config) => {
    console.log(`[API REQUEST] ${config.method?.toUpperCase()} ${config.url}`)
    return config
  },
  (error) => Promise.reject(error)
)

// 3. Response interceptor — maps errors to human-readable messages
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      // Server responded with a non-2xx status
      const status  = error.response.status
      const message = error.response.data?.error || error.response.statusText

      if (status === 404) {
        error.userMessage = 'Employee not found.'
      } else if (status === 409) {
        error.userMessage = 'Employee ID or email already exists.'
      } else if (status === 400) {
        error.userMessage = `Validation error: ${message}`
      } else {
        error.userMessage = `Server error (${status}): ${message}`
      }

      console.error(`[API ERROR] ${status} — ${message}`)

    } else if (error.request) {
      // Request was made but no response received
      error.userMessage = 'Cannot reach the server. Is the API running on port 3001?'
      console.error('[API ERROR] No response from server')
    } else {
      // Something else went wrong
      error.userMessage = `Unexpected error: ${error.message}`
      console.error('[API ERROR]', error.message)
    }

    return Promise.reject(error)
  }
)

// 4. CRUD helper functions
export const getEmployees  = (params = {}) =>
  apiClient.get('/employees', { params })

export const getEmployee   = (id) =>
  apiClient.get(`/employees/${id}`)

export const createEmployee = (data) =>
  apiClient.post('/employees', data)

export const updateEmployee = (id, data) =>
  apiClient.put(`/employees/${id}`, data)

export const deleteEmployee = (id) =>
  apiClient.delete(`/employees/${id}`)

export default apiClient