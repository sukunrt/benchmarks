package main

import (
	crand "crypto/rand"
	"encoding/binary"
	"fmt"
	"math/rand"
	"os"
	"time"
	"syscall"
)

var s = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func fill_random_bytes(buf []byte) {
	for i := 0; i < len(buf); i++ {
		buf[i] = byte('A')
	}
}

func rand_string(n int) string {
	buf := make([]rune, n)
	for i := 0; i < n; i++ {
		buf[i] = s[rand.Intn(len(s))]
	}
	return string(buf)
}

func formatDataSize(blockSize int) string {
	kb := 1000
	mb := 1000 * kb
	gb := 1000 * mb

	if blockSize > gb {
		return fmt.Sprintf("%.2f GB", float64(blockSize)/float64(gb))
	} else if blockSize > mb {
		return fmt.Sprintf("%.2f MB", float64(blockSize)/float64(mb))
	} else if blockSize > kb {
		return fmt.Sprintf("%.2f KB", float64(blockSize)/float64(kb))
	} else {
		return fmt.Sprintf("%.2f B", float64(blockSize))
	}
}

func formatSpeed(bytesWritten int, timeNanos int) string {
	bps := (bytesWritten * 1000 * 1000 * 1000) / timeNanos
	kb := 1000
	mb := 1000 * kb
	gb := 1000 * mb

	if bps > gb {
		return fmt.Sprintf("%.2f GB/s", float64(bps)/float64(gb))
	} else if bps > mb {
		return fmt.Sprintf("%.2f MB/s", float64(bps)/float64(mb))
	} else if bps > kb {
		return fmt.Sprintf("%.2f KB/s", float64(bps)/float64(kb))
	} else {
		return fmt.Sprintf("%.2f B/s", float64(bps))
	}
}

func getMillis(nanosecs int) float64 {
	return float64(nanosecs) / float64(1000000)
}

func writeBM(blockSize int) {
	fmt.Printf("Starting write test for blockSize: %s\n\n", formatDataSize(blockSize))

	iters := 1000
	N := blockSize * iters

	fName := rand_string(10) + ".out"
	f, _ := os.Create(fName)
	buf := make([]byte, N)
	f.Write(buf[:])
	buf = buf[:blockSize]
	f.Sync()
	f.Seek(0, 0)
	timeSequential := 0
	for i := 0; i < iters; i++ {
		fill_random_bytes(buf)
		st := time.Now()
		n, err := f.Write(buf)
		if n != len(buf) {
			fmt.Println("error:", err)
		}
		if err != nil {
			fmt.Println("write error: ", err)
		}
		syscall.Fdatasync(int(f.Fd()))
		el := time.Since(st)
		timeSequential += int(el.Nanoseconds())
	}
	fmt.Printf("Took %0.3f msecs per write\n", getMillis(timeSequential/iters))
	fmt.Printf("Write Speed: %s\n\n", formatSpeed(iters*blockSize, timeSequential))
	f.Close()
	os.Remove(fName)

	fName = rand_string(10) + ".out"
	f, _ = os.OpenFile(fName, os.O_WRONLY|os.O_CREATE, 0644)
	st := time.Now()
	syscall.Fallocate(int(f.Fd()), 0, 0, int64(10*N))
	f.Sync()
	f.Close()
	f, _ = os.OpenFile(fName, os.O_WRONLY|os.O_CREATE, 0644)
	ed := time.Since(st)
	fmt.Println("took ", ed.Milliseconds())
	timeSequentialAppend := 0
	buf = buf[:blockSize]
	for i := 0; i < iters; i++ {
		fill_random_bytes(buf)
		st := time.Now()
		n, err := f.Write(buf)
		if n != len(buf) {
			fmt.Println("error:", err)
		}
		if err != nil {
			fmt.Println("write error: ", err)
		}
		syscall.Fdatasync(int(f.Fd()))
		el := time.Since(st)
		timeSequentialAppend += int(el.Nanoseconds())
	}
	fmt.Printf("Took %0.3f msecs per write\n", getMillis(timeSequentialAppend/iters))
	fmt.Printf("Write Speed: %s\n\n", formatSpeed(iters*blockSize, timeSequentialAppend))
	f.Close()
}

func main() {
	b := make([]byte, 8)
	crand.Read(b)
	rand.Seed(int64(binary.LittleEndian.Uint64(b)))
	var blockSize int
	fmt.Scanf("%d", &blockSize)
	writeBM(blockSize)
}

