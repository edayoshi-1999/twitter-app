import type { CreateTweetData, Tweet } from '../types/tweet';
import { api } from './api';

export const tweetService = {
  // ツイート一覧取得
  async getTweets(): Promise<Tweet[]> {
    const response = await api.get<{ data: Tweet[] }>('/tweets');
    return response.data.data;
  },

  // ツイート投稿
  async createTweet(data: CreateTweetData): Promise<Tweet> {
    const response = await api.post<{ data: Tweet }>('/tweets', data);
    return response.data.data;
  },

  // ツイート削除
  async deleteTweet(id: string): Promise<void> {
    await api.delete(`/tweets/${id}`);
  },
};
