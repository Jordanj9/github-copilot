package main

import (
	"encoding/json"
	"net/http"

	"github.com/gorilla/mux"
)

type Response struct {
	Message string `json:"message"`
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		response := Response{Message: "Hello, World!"}
		w.Header().Set("Content-Type", "application/json")
		err := json.NewEncoder(w).Encode(response)
		if err != nil {
			return
		}
	}).Methods("GET")

	r.HandleFunc("/hello/{name}", func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		name := vars["name"]
		response := Response{Message: "Hola: " + name}
		w.Header().Set("Content-Type", "application/json")
		if err := json.NewEncoder(w).Encode(response); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}).Methods("GET")

	if err := http.ListenAndServe(":8080", r); err != nil {
		return
	}
}
