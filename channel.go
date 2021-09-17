package main

import (
	"fmt"
	"time"
)

const N = 1000000

func A(c chan int, fin chan int) int {
	var x int
	for i := 0; i < N; i++ {
		c <- 1
		x = <-c
	}
	fin <- 1
	return x
}

func B(c chan int, fin chan int) int {
	var y int
	for i := 0; i < N; i++ {
		y = <-c
		c <- 1
	}
	fin <- 1
	return y
}

func main() {
	c := make(chan int)
	fin := make(chan int, 2)
	st := time.Now()
	go A(c, fin)
	go B(c, fin)
	<-fin
	<-fin
	ed := time.Since(st)
	fmt.Printf("Took %.2f seconds for %d nanoseconds per switch", ed.Seconds(), ed.Nanoseconds()/(2*N))
}
