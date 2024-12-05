<script setup lang="ts">

  const email = ref('')
  const password = ref('')
  const load = ref(false)

  const auth = useAuthStore()
  const exception = useExceptionStore()

  if (auth.isAuthenticated) {
    navigateTo("dashboard")
  }

  async function submit() {
    load.value = true
    const res = await postRequest('api/v1/auth/login', {email: email.value, password: password.value})
    if (res) {
      auth.setAuthToken(res.access_token)
      navigateTo('dashboard')
    }
    load.value = false
  }
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="bg-white shadow-lg rounded-lg p-8 max-w-sm w-full">
      <h2 class="text-2xl font-semibold text-gray-800 text-center mb-4">Login</h2>

      <div class="mb-4">
        <div v-if="exception.isError" class="flex items-center gap-2 px-4 py-2 bg-red-100 text-red-600 rounded-lg">
          <span>{{ exception.exception }}</span>
        </div>
      </div>

      <form @submit.prevent="submit" autocomplete="off">
        <!-- Email Field -->
        <div class="mb-4">
          <label for="email" class="block text-sm font-medium text-gray-600">Email</label>
          <input
            v-model="email"
            type="email"
            id="email"
            placeholder="Enter your email"
            class="w-full px-4 py-2 mt-1 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
            required
          />
        </div>

        <!-- Password Field -->
        <div class="mb-6">
          <label for="password" class="block text-sm font-medium text-gray-600">Password</label>
          <input
            v-model="password"
            type="password"
            id="password"
            placeholder="Enter your password"
            class="w-full px-4 py-2 mt-1 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:outline-none"
            autocomplete="off"
            required
          />
        </div>

        <!-- Submit Button -->
        <p v-if="load" class="text-center">
          Loading...
        </p>
        <button
          v-else
          type="submit"
          class="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 focus:ring-2 focus:ring-blue-400"
        >
          Login
        </button>
      </form>
    </div>
  </div>
</template>

<style scoped>
/* Optional scoped styles (if any) */
</style>
