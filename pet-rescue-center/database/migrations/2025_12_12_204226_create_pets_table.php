<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
       Schema::create('pets', function (Blueprint $table) {
            $table->id(); // This creates an auto-increment ID
            $table->string('name'); // Pet name
            $table->string('type'); // Dog, Cat, etc
            $table->string('breed')->nullable(); // Can be empty
            $table->integer('age'); // Age in months
            $table->string('image')->nullable(); // Image filename
            $table->text('description')->nullable(); // Description
            $table->string('status')->default('Available'); // Available, Adopted, etc
            $table->string('location'); // Where the pet is
            $table->timestamps(); // Adds created_at and updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pets');
    }
};
