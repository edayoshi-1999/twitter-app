export interface Tweet {
  id: string;
  body: string;
  user: User;
  likes_count: number;
  created_at: string;
  updated_at: string;
}

export interface User {
  id: number;
  name: string;
  username: string;
  email?: string;
}

export interface CreateTweetData {
  body: string;
}
