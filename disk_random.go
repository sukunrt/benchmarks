package main

import (
	crand "crypto/rand"
	"encoding/binary"
	"fmt"
	"math/rand"
	"os"
	"syscall"
	"time"
)

var s = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

func fillRandomBytes(buf []byte) {
	for i := 0; i < len(buf); i++ {
		buf[i] = byte('A')
	}
}

func randString(n int) string {
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

func formatSpeed(bytesWritten int, timeNanos time.Duration) string {
	bps := (bytesWritten * 1000 * 1000 * 1000) / int(timeNanos)
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

func getNewOutputFile(len int) (*os.File, string) {
	fName := randString(len) + ".out"
	f, err := os.Create((fName))
	if err != nil {
		panic(err)
	}
	return f, fName
}

func measureTime(blockSize, count int, f *os.File) time.Duration {
	f.Seek(0, 0)
	f.Sync()
	buf := make([]byte, blockSize)
	t := time.Duration(0)
	for i := 0; i < count; i++ {
		st := time.Now()
		n, err := f.Write(buf)
		if n != len(buf) || err != nil {
			fmt.Println("error:", err)
		}
		syscall.Fdatasync(int(f.Fd()))
		//f.Sync()
		el := time.Since(st)
		t = t + el
	}
	return t
}

func writeTest(blockSize, count int, f *os.File, fileName string, testName string, res chan string) {
	el := measureTime(blockSize, count, f)
	res <- fmt.Sprintf(`Test %s:
Took %0.3f per write
Write Speed: %s

`, testName, float64(el)/float64(count*1e6), formatSpeed(count*blockSize, el))
	f.Close()
	//os.Remove(fileName)
}

func writeBM(blockSize int) {
	fmt.Printf("Starting write test for blockSize: %s\n\n", formatDataSize(blockSize))

	count := 1000
	N := int64(400 * 1000 * 1000)
	// f1, fn1 := getNewOutputFile(10)
	//buf := make([]byte, int(N))
	// f1.Write(buf[:])
	// f1.Sync()	

	f2, fn2 := getNewOutputFile(10)
	err := syscall.Fallocate(int(f2.Fd()), 0, 0, N)
	if err != nil {
		panic(err)
	}
	
	fn1 := "dd.out"
	f1, _ := os.OpenFile(fn1, os.O_WRONLY, 0644)
	
	f3, fn3 := getNewOutputFile(10)
	

	ch := make(chan string, 3)
	writeTest(blockSize, count, f1, fn1, "zeroed_out", ch)
	writeTest(blockSize, count, f2, fn2, "fallocate_0", ch)
	writeTest(blockSize, count, f3, fn3, "unallocated", ch)
	for i := 0; i < 3; i++ {
		fmt.Printf("%s", <- ch)
	}
}

func main() {
	b := make([]byte, 8)
	crand.Read(b)
	rand.Seed(int64(binary.LittleEndian.Uint64(b)))
	var blockSize int
	fmt.Scanf("%d", &blockSize)
	writeBM(blockSize)
}


