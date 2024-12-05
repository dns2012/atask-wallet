export const useExceptionStore = defineStore('exceptionStore', {
  state: () => ({
    status: 0,
    error: '',
    exception: ''
  }),
  getters: {
    getStatus: (state) => state.status,
    getError: (state) => state.error,
    getException: (state) => state.exception,
    isError: (state) => {
      return state.status != 0
    }
  },

  actions: {
    setStatus(value: number) {
      this.status = value;
    },
    setError(value: string) {
      this.error = value;
    },
    setException(value: string) {
      this.exception = value;
    },
    raise(status: number, error: string, exception: string) {
      this.status = status
      this.error = error
      this.exception = exception
      setTimeout(() => {
        this.status = 0
        this.error = ''
        this.exception = ''
      }, 5000);
    }
  },
})
