package main

import (
	"fmt"
	"os"
	"time"
)

const MB = 1000000

func writeData(s string, inp []byte) {
	f, _ := os.Create(s)
	defer func() {
		if err := f.Close(); err != nil {
			panic(err)
		}
	}()
	f.Write([]byte(inp))
}

func makeData(n int) []byte {
	x := make([]byte, n)
	for i := 0; i < n; i++ {
		x[i] = 1
	}
	return x
}

func readData(s string, n int) (int, []byte) {
	d := make([]byte, n)
	f, _ := os.Open(s)
	nn, _ := f.Read(d)
	return nn, d
}

func main() {
	mx := 1000000000
	st := time.Now()
	x, _ := readData("output.txt", mx)
	d := time.Since(st)
	fmt.Println("time taken ", d, x)
	tp := float64(mx) / d.Seconds()
	fmt.Printf("through put is %2f MB/s", tp/(MB))
}
