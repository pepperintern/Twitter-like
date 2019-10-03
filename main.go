// package main

// import (
// 	"os"
// 	"fmt"
// 	"github.com/joho/godotenv"
//     "net/http"
// 	"github.com/labstack/echo"
// 	"github.com/jinzhu/gorm"
//     _ "github.com/jinzhu/gorm/dialects/mysql"
// )

// type Tweet struct{
// 	Id int `json:"id"`
// 	Content string `json:"content"`
// 	User_id int `json:"user_id"`
// }

// func main() {
// 	err := godotenv.Load()
// 	db, err := gorm.Open("mysql", "root:"+os.Getenv("DB_PASSWORD")+"@/user")
// 	if err != nil {
//         panic(err.Error())
//     }
// 	fmt.Println("db connected: ", &db)
// 	defer db.Close() 
// 	db.SingularTable(true)
// 	db.LogMode(true) 

// 	e := echo.New()
// 	e.GET("/tweets", func(c echo.Context) error {
// 		tweets := []Tweet{}
// 		db.Find(&tweets)
// 		return c.JSON(http.StatusOK, tweets)
// 	})
// 	e.Logger.Fatal(e.Start(":8080"))
// }

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
   // fmt.Printf("%v\n", jsonBody)
   id := jsonBody["id"]
   fmt.Println(id)
   message := jsonBody["message"]
   fmt.Println(message)
   db, err := sql.Open("mysql", "root:chikuro@/user")
   if err != nil {
       panic(err.Error())
   }
   defer db.Close() // 関数がリターンする直前に呼び出される
   ins, err := db.Prepare("INSERT INTO post(id,message) VALUES(?,?)")
   if err != nil {
       panic(err.Error())
   }
   ins.Exec(id, message)
   w.WriteHeader(http.StatusOK)
}

func main() {
   http.HandleFunc("/json", dumpJsonRequestHandlerFunc)
   http.ListenAndServe(":8080", nil)
}