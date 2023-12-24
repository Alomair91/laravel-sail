<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    \Illuminate\Support\Facades\Redis::set('name', 'Mohammed ');
    \Illuminate\Support\Facades\Redis::set('name2', 'Mohammed 2');
    \Illuminate\Support\Facades\Redis::set('names', 'mohammed', "hassan");
    error_log(\Illuminate\Support\Facades\Redis::get('name'));
    error_log(\Illuminate\Support\Facades\Redis::get('name2'));
    return view('welcome');
});
