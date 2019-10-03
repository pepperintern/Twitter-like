package main

import (
    "database/sql"
    "encoding/json"
    "fmt"
    "io"
    "net/http"
    "strconv"

    _ "github.com/go-sql-driver/mysql"
)

func dumpJsonRequestHandlerFunc(w http.ResponseWriter, req *http.Request) {
    //Validate request
    if req.Method != "POST" {
        w.WriteHeader(http.StatusBadRequest)
        return
    }

    if req.Header.Get("Content-Type") != "application/json" {
        w.WriteHeader(http.StatusBadRequest)
        return
    }

    //To allocate slice for request body
    length, err := strconv.Atoi(req.Header.Get("Content-Length"))
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        return
    }

    //Read body data to parse json
    body := make([]byte, length)
    length, err = req.Body.Read(body)
    if err != nil && err != io.EOF {
        w.WriteHeader(http.StatusInternalServerError)
        return
    }

    //parse json
    var jsonBody map[string]interface{}
    err = json.Unmarshal(body[:length], &jsonBody)
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        return
    }
    fmt.Printf("%v\n", jsonBody)

    

    db, err := sql.Open("mysql", "yuta:sakuya@/twitter_like")
    if err != nil {
        panic(err.Error())
    }
    defer db.Close() // 関数がリターンする直前に呼び出される

    ins, err := db.Prepare("INSERT INTO tweet(id,content,name_id) VALUES(?,?,?)")
    if err != nil {
        panic(err.Error())
    }
    ins.Exec(,, 123456)

    w.WriteHeader(http.StatusOK)
}

func main() {
    http.HandleFunc("/json", dumpJsonRequestHandlerFunc)
    http.ListenAndServe(":8080", nil)

    

}