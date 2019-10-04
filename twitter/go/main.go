package main

import (
<<<<<<< HEAD
	// "database/sql"
	// "encoding/json"
	// "strconv"
	// "io"
	// "log"
	"fmt"
	"net/http"

	// "net/http"

	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

// func dumpJsonRequestHandlerFunc(c echo.Context) error{
// 	//Validate request

// 	if req.Method != "post" {
// 		w.WriteHeader(http.StatusBadRequest)
// 		return
// 	}

// 	if req.Header.Get("Content-Type") != "application/json" {
// 		w.WriteHeader(http.StatusBadRequest)
// 		return
// 	}

// 	//To allocate slice for request body
// 	length, err := strconv.Atoi(req.Header.Get("Content-Length"))
// 	if err != nil {
// 		w.WriteHeader(http.StatusInternalServerError)
// 		return
// 	}

// 	fmt.Println(length);

// 	//Read body data to parse json
// 	body := make([]byte, length)
// 	length, err = req.Body.Read(body)
// 	if err != nil && err != io.EOF {
// 		w.WriteHeader(http.StatusInternalServerError)
// 		return
// 	}

// 	//parse json
// 	var jsonBody map[string]interface{}
// 	err = json.Unmarshal(body[:length], &jsonBody)
// 	if err != nil {
// 		w.WriteHeader(http.StatusInternalServerError)
// 		return
// 	}

// 	// fmt.Printf("%v\n", jsonBody)
// 	email := jsonBody["email"]
// 	fmt.Println(email)
// 	name := jsonBody["name"]
// 	fmt.Println(name)








// 	db, err := sql.Open("mysql", "masatoinoue:masato@tcp(127.0.0.1)/twitter")
// 	if err != nil {
// 		panic(err.Error())
// 	}
// 	defer db.Close() // 関数がリターンする直前に呼び出される
// 	ins, err := db.Prepare("INSERT INTO user(name,email) VALUES(?,?)")
// 	if err != nil {
// 		panic(err.Error())
// 	}
// 	ins.Exec(name, email)
// 	w.WriteHeader(http.StatusOK)

// }
// }

// func bind(c echo.Context) (err error) {
// 	u := new(User)
// 	if err = c.Bind(u); err != nil {
// 		return
// 	}
// 	return c.JSON(http.StatusOK, u)
// }

// func name(c echo.Context) error {
// 	fmt.Println("hudhiasg");
// 	name := c.QueryParam("name")
// 	fmt.Println(name);
// 	return c.String(http.StatusOK, name)
// }

// func email(c echo.Context) (err error) {
// 	email := c.FormValue("email")
// 	return c.String(http.StatusOK, email)
// }

// // echo用テストコード
// func hello(c echo.Context) error {
// 	return c.String(http.StatusOK, "こんにちは世界")
// }

type User struct {
	Name  string `json:"name" form:"name" query:"name"`
	Email string `json:"email" form:"email" query:"email"`
}

type CustomBinder struct{}

// func db(c echo.Context) (err error) {

// 	u := new(User)
// 	if err = c.Bind(u); err != nil {
// 		return
// 	}

// 	name := c.QueryParam("name")
// 	fmt.Println(name);

// 	return c.String(http.StatusOK,"データベースOK")
// }

// func (cb *CustomBinder) Bind(i interface{}, c echo.Context) (err error) {
// 	// You may use default binder
// 	db := new(echo.DefaultBinder)
// 	if err = db.Bind(i, c); err != echo.ErrUnsupportedMediaType {
// 		return
// 	}
// 	return c.String(http.StatusOK,"データベースOK");
// }

func name (c echo.Context) error {
	name := c.FormValue("name")
	fmt.Println(name)
	return c.String(http.StatusOK, name)
}


// １、postデータを受け取る
// ２、jsonを配列に変換
// ３、配列をdbに挿入

func main() {

	e := echo.New()
	e.Use(middleware.Logger())

	// e.POST("/user", func(c echo.Context) (err error) {
	// 	e.Use(middleware.Logger())
	// 	u := new(User)
	// 	fmt.Println(u)
	// 	if err = c.Bind(u); err != nil {
	// 	}
	// 	return c.String(http.StatusOK, name)
	// })

	// e.GET("/",dumpJsonRequestHandlerFunc)
	e.POST("/user",name)

	// e.POST("/user", func(c echo.Context) error {
	// 	m := echo.Map{}
	// 	fmt.Println(m)
	// 	if err := c.Bind(&m); err != nil {
	// 		return err
	// 	}
	// 	return c.JSON(200, m)
	// })

	e.Logger.Fatal(e.Start(":8080"))

	// echo使わなかったときの処理
	// http.HandleFunc("/", dumpJsonRequestHandlerFunc)
	// http.HandleFunc("/user", dumpJsonRequestHandlerFunc)
	// http.HandleFunc("/post",dumpJsonRequestHandlerFunc)
	// http.ListenAndServe(":8080", nil)

=======
    "net/http"
    "github.com/labstack/echo"
    //"io"
    //"text/template"
	"github.com/labstack/echo/middleware"
	"os"
	"fmt"
	"github.com/joho/godotenv"
	"github.com/jinzhu/gorm"
    _ "github.com/jinzhu/gorm/dialects/mysql"
)

func DBConnect() *gorm.DB {
	err := godotenv.Load()
	db, err := gorm.Open("mysql", "root:"+os.Getenv("DB_PASSWORD")+"@/user")
	if err != nil {
        panic(err.Error())
    }
	fmt.Println("db connected: ", &db)
	return db
}

func main() {
    e := echo.New()
    e.Use(middleware.Logger())
    e.Use(middleware.Recover())
    // t := &Template{
    //     templates: template.Must(template.ParseGlob("template/*.html")),
    // }
    // e.Renderer = t
	//e.GET("/", rootHandler)
	e.GET("/posts", GetHandler)
	e.POST("/post", PostHandler)
    e.POST("/user", UserPostHandler)
    e.Logger.Fatal(e.Start(":8080"))
}

type Post struct{
	Id int `json:"id"`
	Message string `json:"message"`
}

type User struct {
	Id int `json:id`
    Name string `json:"name"`
    Email string `json:"email"`
}

func GetHandler(c echo.Context) error {
	db := DBConnect()
	defer db.Close() 
	db.SingularTable(true)
	db.LogMode(true) 

	posts := []Post{}
	db.Find(&posts)
	return c.JSON(http.StatusOK, posts)
}

func PostHandler(c echo.Context) error {
	db := DBConnect()
	defer db.Close() 
	db.SingularTable(true)
	db.LogMode(true) 

    post := new(Post)
    if err := c.Bind(post); err != nil {
        return err
    }
	db.Create(&post);
	return c.JSON(http.StatusOK, post)
}

func UserPostHandler(c echo.Context) error {
	db := DBConnect()
	defer db.Close() 
	db.SingularTable(true)
	db.LogMode(true) 

    user := new(User)
    if err := c.Bind(user); err != nil {
        return err
    }
    //db.NewRecord(&user);
	db.Create(&user);
	return c.JSON(http.StatusOK, user)
>>>>>>> 8a7fdf2b7908d4319b46e8efe8db02673532a384
}
