package main

import (
	"os"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
)

func CreateConnection() (*gorm.DB, error) {
	// Get database details from environment variables
	// host := os.Getenv("DB_HOST")
	// user := os.Getenv("DB_USER")
	// DBName := os.Getenv("DB_NAME")
	// password := os.Getenv("DB_PASSWORD")
	host := os.Getenv("DB_HOST")

	return gorm.Open("postgres", host+"?sslmode=disable")
}
