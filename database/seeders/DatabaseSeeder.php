<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();

        // \App\Models\User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);

        // $this->call(SuperAdminSeeder::class);
        $this->call(AsistSeeder::class);
        $this->call(CoordinadorSeeder::class);
        $this->call(AlvaroValeroSeeder::class);
        //$this->call(EstadisticaSeeder::class);
        //$this->call(JoseFernandoSeeder::class);
        // $this->call(SeederTablaPermisos::class);
    }
}
