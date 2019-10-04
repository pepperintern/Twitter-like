package main

import (
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
}
