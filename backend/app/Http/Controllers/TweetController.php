<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreTweetRequest;
use App\Models\Tweet;
use Illuminate\Http\JsonResponse;

class TweetController extends Controller
{
    /**
     * ツイートを投稿する
     */
    public function store(StoreTweetRequest $request): JsonResponse
    {
        // 1. ツイートを作成
        $tweet = Tweet::create([
            'body' => $request->input('body'),
            'user_id' => $request->user()->id,
            'posted_at' => now(),
        ]);

        // 2. ツイートをリロード（リレーションを取得するため）
        $tweet->load('user');

        // 3. JSONレスポンスを返す（201 Created）
        return response()->json([
            'id' => $tweet->id,
            'body' => $tweet->body,
            'user' => [
                'id' => $tweet->user->id,
                'name' => $tweet->user->name,
            ],
            'created_at' => $tweet->created_at->toIso8601String(),
            'posted_at' => $tweet->posted_at->toIso8601String(),
        ], 201);
    }
}
