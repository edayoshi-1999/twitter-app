import axios from 'axios';

// Axiosインスタンスを作成
export const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Cookie を送信（Sanctum認証で必要）
});

// リクエストインターセプター（将来的に認証トークンを追加）
api.interceptors.request.use(
  (config) => {
    // 将来的にトークンをヘッダーに追加
    // const token = localStorage.getItem('token');
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`;
    // }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

// レスポンスインターセプター（エラーハンドリング）
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response) {
      // サーバーがエラーレスポンスを返した
      console.error('API Error:', error.response.status, error.response.data);
    } else if (error.request) {
      // リクエストは送信されたがレスポンスがない
      console.error('Network Error:', error.request);
    } else {
      // リクエスト設定中にエラー
      console.error('Error:', error.message);
    }
    return Promise.reject(error);
  },
);
