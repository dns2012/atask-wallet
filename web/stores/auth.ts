export const useAuthStore = defineStore('authStore', {
  state: () => ({
    token: '',
  }),
  persist: true,
  actions: {
    setAuthToken(token: string) {
      this.token = token
    },
  },
  getters: {
    isAuthenticated: (state) => {
      return state.token
    }
  }
})
