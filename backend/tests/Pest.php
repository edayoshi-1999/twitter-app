<?php

declare(strict_types=1);

use Illuminate\Foundation\Testing\RefreshDatabase;

/*
|--------------------------------------------------------------------------
| Pest Test Configuration
|--------------------------------------------------------------------------
|
| This file configures Pest for Laravel testing.
| We use the Laravel plugin to integrate with Laravel's testing features.
|
*/

uses(
    Tests\TestCase::class,
    RefreshDatabase::class,
)->in('Feature');

uses(
    Tests\TestCase::class,
)->in('Unit');

/*
|--------------------------------------------------------------------------
| Helper Functions
|--------------------------------------------------------------------------
*/

// You can add custom helper functions here
// Example: function createUser(array $attributes = []) { ... }
