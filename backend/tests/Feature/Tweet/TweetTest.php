<?php

declare(strict_types=1);

use App\Models\User;

it('認証されていないユーザーはツイートを投稿できない', function () {
    // ログインせずにツイート投稿をリクエスト
    $response = $this->postJson('/api/tweets', [
        'body' => 'これはテストツイートです',
    ]);

    // 401エラーが返ることを確認
    $response->assertStatus(401);
});

it('認証済みユーザーはツイートを投稿できる', function () {
    // テスト用ユーザーを作成してログイン
    $user = User::factory()->create();

    // ログイン状態でツイート投稿をリクエスト
    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => 'これはテストツイートです',
    ]);

    // 201（Created）が返ることを確認
    $response->assertStatus(201)
        ->assertJsonStructure(['id', 'body', 'user', 'created_at', 'posted_at']);

    // データベースに保存されたことを確認
    $this->assertDatabaseHas('tweets', [
        'body' => 'これはテストツイートです',
        'user_id' => $user->id,
    ]);
});

it('ツイート本文が空の場合バリデーションエラーが返る', function () {
    $user = User::factory()->create();

    // 空の本文でリクエスト
    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => '',
    ]);

    // 422（バリデーションエラー）が返ることを確認
    $response->assertStatus(422)
        ->assertJsonValidationErrors(['body']);
});

it('ツイート本文が280文字を超える場合バリデーションエラーが返る', function () {
    $user = User::factory()->create();

    // 281文字の本文でリクエスト
    $response = $this->actingAs($user)->postJson('/api/tweets', [
        'body' => str_repeat('あ', 281),
    ]);

    // 422（バリデーションエラー）が返ることを確認
    $response->assertStatus(422)
        ->assertJsonValidationErrors(['body']);
});
