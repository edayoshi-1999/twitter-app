<?php

use App\Http\Controllers\TweetController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// ツイート投稿エンドポイント
Route::post('/tweets', [TweetController::class, 'store'])
    ->middleware('auth:sanctum');
