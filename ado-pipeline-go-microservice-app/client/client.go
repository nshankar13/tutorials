package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

var (
	serverPort      = 8080
	serverEndpoint  = "hello"
	serverName      = "server"
	serverNamespace = "server"
)

func sendReq(w http.ResponseWriter, req *http.Request) {
	requestURL := fmt.Sprintf("http://%s.%s.svc.cluster.local:%d/%s", serverName, serverNamespace, serverPort, serverEndpoint)

	reqResp, err := http.Get(requestURL)

	if err != nil {
		fmt.Printf("error sending request to server: %s\n", err)
	}

	// To-Do: what if request to server fails?

	respCode := reqResp.StatusCode

	if respCode == 200 {
		fmt.Printf("Response Successful\n")
	} else {
		fmt.Printf("Error sending request - response code %d\n", respCode)
	}

	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")
	resp := make(map[string]string)
	resp["message"] = "Status OK"
	jsonResp, err := json.Marshal(resp)
	if err != nil {
		log.Fatalf("Error happened in JSON marshal. Err: %s", err)
	}
	w.Write(jsonResp)
	return
}

func main() {
	http.HandleFunc("/send-req", sendReq)
	http.ListenAndServe(":8080", nil)
}
