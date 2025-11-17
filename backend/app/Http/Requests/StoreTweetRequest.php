<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreTweetRequest extends FormRequest
{
    /**
     * ツイート本文の最大文字数
     */
    private const MAX_TWEET_LENGTH = 280;

    /**
     * このリクエストを実行する権限があるか判定
     */
    public function authorize(): bool
    {
        // ログインしているユーザーのみ許可
        return $this->user() !== null;
    }

    /**
     * バリデーションルール
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'body' => ['required', 'string', 'max:'.self::MAX_TWEET_LENGTH],
        ];
    }

    /**
     * バリデーションエラーメッセージ（オプション）
     *
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'body.required' => 'ツイート本文は必須です。',
            'body.max' => sprintf('ツイート本文は%d文字以内で入力してください。', self::MAX_TWEET_LENGTH),
        ];
    }
}
