package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
	// Inisialisasi Gin dengan mode default (Logger & Recovery)
	r := gin.Default()

	// Endpoint sederhana untuk verifikasi
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Hello JBR Minpo! Backend Go sudah aktif ðŸš€",
			"status":  "success",
		})
	})

	// Jalankan server di port 8080 (default)
	r.Run(":8080")
}

