/**
 * HTTP request utility function for common API methods
 * @param method - HTTP method (GET, POST, PUT, DELETE)
 * @param url - API endpoint (relative to the base API URL)
 * @param data - Request body for POST/PUT (optional)
 * @param useToken - Whether to include Bearer token in the header
 * @returns Promise with the response data
 */
export const makeRequest = async <T>(
  method: 'GET' | 'POST' | 'PUT' | 'DELETE',
  url: string,
  data: Record<string, unknown> = {},
  useToken: boolean = false
): Promise<T> => {
  const config = useRuntimeConfig(); // Access runtime config for base API URL
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
  };
  const auth = useAuthStore()
  const exception = useExceptionStore()

  if (useToken) {
    const token = auth.token; // Or use another secure method to retrieve the token
    if (!token) throw new Error('No access token found');
    headers.Authorization = `Bearer ${token}`;
  }

  try {
    const response = await $fetch<T>(url, {
      baseURL: config.public.baseApiUrl, // Use the runtime base URL
      method,
      headers,
      body: method === 'POST' || method === 'PUT' ? data : undefined,
    });


    return (response.data) ? response.data : response;
  } catch (error: any) {
    // console.error(`HTTP Request Error (${method} ${url}):`, error);
    // throw error?.data || new Error('An unexpected error occurred');
    exception.raise(error.data.status, error.data.error, error.data.exception)
  }
};

/**
 * Helper functions for each HTTP method
 */
export const getRequest = async <T>(url: string, useToken = false): Promise<T> =>
  makeRequest<T>('GET', url, {}, useToken);

export const postRequest = async <T>(
  url: string,
  data: Record<string, unknown>,
  useToken = false
): Promise<T> => makeRequest<T>('POST', url, data, useToken);

export const putRequest = async <T>(
  url: string,
  data: Record<string, unknown>,
  useToken = false
): Promise<T> => makeRequest<T>('PUT', url, data, useToken);

export const deleteRequest = async <T>(url: string, useToken = false): Promise<T> =>
  makeRequest<T>('DELETE', url, {}, useToken);
