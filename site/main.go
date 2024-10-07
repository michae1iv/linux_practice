package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "flag{y0u_found_m3_yahoo}")
	})

	http.ListenAndServe(":7913", nil)
}
