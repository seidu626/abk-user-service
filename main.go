package main

import (
	"log"

	"github.com/micro/go-micro/v2"
	k8s "github.com/micro/go-plugins/registry/kubernetes/v2"
	pb "github.com/seidu626/abk-user-service/proto/auth"
)

func main() {

	// Creates a database connection and handles
	// closing it again before exit.
	db, err := CreateConnection()
	defer db.Close()

	if err != nil {
		log.Fatalf("Could not connect to DB: %v", err)
	}

	// Automatically migrates the user struct
	// into database columns/types etc. This will
	// check for changes and migrate them each time
	// this service is restarted.
	db.AutoMigrate(&pb.User{})

	repo := &UserRepository{db}

	registry := k8s.NewRegistry() //a default to using env vars for master API

	tokenService := &TokenService{repo}

	// Create a new service. Optionally include some options here.
	srv := micro.NewService(

		// This name must match the package name given in your protobuf definition
		micro.Name("abk.auth"),

		// Set service registry
		micro.Registry(registry),
	)

	// Init will parse the command line flags.
	// srv.Init()

	// Will comment this out now to save having to run this locally
	// publisher := micro.NewPublisher("user.created", srv.Client())

	// Register handler
	pb.RegisterAuthHandler(srv.Server(), &service{repo, tokenService})

	// Run the server
	if err := srv.Run(); err != nil {
		log.Fatal(err)
	}
}
