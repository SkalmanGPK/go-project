package main

import (
	"fmt"
	"net/http"
	"time"
)

func main() {
	// Ändra "probe-service" till IP om du inte kör DNS i K8s än
	target := "10.1.82.149" 

	for {
		start := time.Now()
		resp, err := http.Get(target)
		
		if err != nil {
			fmt.Printf("Error probing %s: %v\n", target, err)
		} else {
			latency := time.Since(start)
			fmt.Printf("Status: %d | Latency: %v | Timestamp: %s\n", 
				resp.StatusCode, latency, time.Now().Format(time.RFC3339))
			resp.Body.Close()
		}

		time.Sleep(5 * time.Second)
	}
}

